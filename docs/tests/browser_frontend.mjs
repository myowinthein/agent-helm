import assertStrict from 'node:assert/strict';
import { checkThemeColors } from './check-theme-colors.mjs';
import { chromium } from 'playwright-core';
import { readFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { allowOnlyOrigin, chromeExecutable, listenOnLoopback, staticFiles } from '../scripts/browser.mjs';

const root = resolve(process.env.HELM_DOCS_SITE || resolve(dirname(fileURLToPath(import.meta.url)), '../_site'));
const mime = { html:'text/html',css:'text/css',js:'text/javascript',json:'application/json',svg:'image/svg+xml',jpg:'image/jpeg' };
const { server, origin } = await listenOnLoopback(staticFiles(root, {
 rewrite: pathname => {
  const site = pathname.replace(/^\/agent-helm\//, '/');
  return site.endsWith('/') ? `${site}index.html` : site;
 },
 contentType: path => mime[path.split('.').at(-1)] || 'application/octet-stream'
}));
const pageUrl=path=>`${origin}/agent-helm/${path}`;
const background=expected=>page=>page.waitForFunction(expected=>{
  const color=getComputedStyle(document.body).backgroundColor;
  return expected==='dark'?color==='rgb(39, 38, 43)':color==='rgb(255, 255, 255)';
 },expected);
let browser;
async function createContext(options = {}) {
 const context = await browser.newContext(options);
 await allowOnlyOrigin(context, origin);
 return context;
}
let assertions=0;
const counted=check=>(...args)=>{assertions++;return check(...args);};
const assert=Object.assign(counted(assertStrict),{equal:counted(assertStrict.equal),notEqual:counted(assertStrict.notEqual)});
try {
 browser=await chromium.launch({executablePath:await chromeExecutable('run the browser checks'),headless:true});
 for(const width of [1280,390]) {
  for(const scheme of ['light','dark']) {
   const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
   const page=await context.newPage();
   const requests=[];const errors=[];
   page.on('request',r=>requests.push(r.url()));
   page.on('pageerror',e=>errors.push(e.message));
   await page.addInitScript(()=>{window.shifts=[];new PerformanceObserver(list=>window.shifts.push(...list.getEntries().filter(e=>!e.hadRecentInput).map(e=>e.value))).observe({type:'layout-shift',buffered:true});});
   await page.goto(pageUrl('docs/commands/ship/detailed.html'));
   await page.waitForTimeout(300);
   assert(!requests.some(url=>url.includes('search-data.json')),'Search downloaded before interaction');
   assert(!requests.some(url=>url.includes('mermaid')),'Browser downloaded Mermaid');
   assert.equal(requests.filter(url=>/just-the-docs-(default|light|dark)\.css/.test(url)).length,1,'Duplicate initial theme stylesheets');
   assert(requests.some(url=>url.endsWith(`just-the-docs-${scheme}.css`)),'Wrong system theme');
   assert(requests.every(url=>new URL(url).origin===origin),'Initial load requested another origin');
   assert.equal(await page.locator('figure.mermaid img').evaluateAll(imgs=>imgs.every(img=>img.complete&&img.naturalWidth>0)),true,'Diagram not visible');
   const cls=await page.evaluate(()=>window.shifts.reduce((sum,n)=>sum+n,0));
   assert(cls<0.01,`Initial layout shifted: ${cls}`);
   await checkThemeColors(page, scheme, assert);
   const query=page.locator('#search-input');
   if(width===390)await page.locator('#menu-button').click();
   await query.fill('normalize');
   await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
   assert.equal(requests.filter(url=>url.includes('search-data.json')).length,1,'Search initialized multiple times');
   await query.evaluate(input => input.blur());
   assert.equal(await page.evaluate(()=>document.documentElement.classList.contains('search-active')),false);
   await query.focus();
   await page.waitForFunction(()=>document.documentElement.classList.contains('search-active'));
   await query.press('Escape');
   assert.equal(await query.inputValue(),'');
   await page.locator('#theme-mode').selectOption(scheme==='light'?'dark':'light');
   await page.waitForFunction(expected=>document.querySelector('link[rel="stylesheet"]').href.endsWith(`just-the-docs-${expected}.css`),scheme==='light'?'dark':'light');
   await checkThemeColors(page, scheme==='light'?'dark':'light', assert);
   assert.equal(errors.length,0,errors.join('\n'));
   console.log(`PASS ${width}px ${scheme}: one theme stylesheet, no initial index, static diagrams, CLS ${cls.toFixed(3)}, search and theme switching`);
   await context.close();
  }
 }
 // Late image bytes must not move text below the diagram.
 {
  const context=await createContext();const page=await context.newPage();
  await page.addInitScript(()=>{window.diagramShift=0;new PerformanceObserver(list=>{for(const e of list.getEntries())if(!e.hadRecentInput)window.diagramShift+=e.value;}).observe({type:'layout-shift',buffered:true});});
  await page.route('**/assets/diagrams/*.svg',async route=>{await new Promise(resolve=>setTimeout(resolve,500));await route.continue();});
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  assert(await page.evaluate(()=>window.diagramShift<0.01));
  console.log('PASS delayed diagram download: reserved space remains stable');await context.close();
 }
 // A slow first search must retain text typed before the index becomes ready.
 {
  const context=await createContext();const page=await context.newPage();let count=0;
  await page.route('**/search-data.json',async route=>{count++;await new Promise(resolve=>setTimeout(resolve,500));await route.continue();});
  await page.goto(pageUrl('docs/commands/log.html'));
  await page.locator('#search-input').fill('archive');
  assert.equal(await page.locator('#search-status').textContent(),'','Quick search initialization should not flash loading text');
  await page.waitForFunction(()=>document.getElementById('search-status').textContent==='Loading search…');
  assert.equal(await page.locator('#search-status').textContent(),'Loading search…');
  assert(await page.locator('#search-status').isVisible());
  assert.equal(await page.locator('#search-input').getAttribute('aria-busy'),'true');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  assert.equal(await page.locator('#search-input').inputValue(),'archive');assert.equal(count,1);
  assert.equal(await page.locator('#search-status').textContent(),'');
  assert.equal(await page.locator('#search-input').getAttribute('aria-busy'),null);
  console.log('PASS slow search: first query preserved, one request');await context.close();
 }
 // Typing after a failure preserves the query without repeatedly downloading the index.
 for (const failure of ['http', 'network', 'invalid-json']) {
  const context=await createContext(failure==='network'?{viewport:{width:390,height:900},colorScheme:'dark'}:{});
  const page=await context.newPage();let count=0;
  await page.clock.install();
  await page.route('**/search-data.json',async route=>{
   count++;
   if(count!==1)return route.continue();
   if(failure==='network')return route.abort();
   await route.fulfill({status:failure==='http'?503:200,body:failure==='http'?'Unavailable':'{invalid'});
  });
  await page.goto(pageUrl('docs/commands/log.html'));
  if(failure==='network')await page.locator('#menu-button').click();
  await page.locator('#search-input').focus();
  await page.waitForFunction(()=>document.getElementById('search-status').textContent.includes('Could not load search'));
  assert.equal(await page.locator('#search-status').getAttribute('role'),'status');
  assert(await page.locator('#search-status').isVisible());
  assert.equal(await page.locator('#search-input').getAttribute('aria-busy'),null);
  await page.locator('#search-input').fill('archive');
  assert.equal(count,1,'Typing retried a failed index request');
  assert.equal(await page.locator('#search-status').textContent(),'Could not load search. Use Retry search to try again.');
  await page.clock.runFor(4000);
  assert.equal(await page.locator('#search-status').textContent(),'');
  assert(await page.locator('#search-retry').isVisible(),'Timed popup removed the recovery action');
  assert(await page.locator('#search-retry').evaluate(button=>{
   const input=document.getElementById('search-input');const bounds=input.getBoundingClientRect();
   const retry=button.getBoundingClientRect();
   return retry.left>bounds.left+parseFloat(getComputedStyle(input).paddingLeft) && retry.right<=bounds.right;
  }),'Retry control overlaps the search text or escapes the field');
  assert.equal(await page.locator('#search-input').inputValue(),'archive');
  await page.locator('#search-retry').focus();await page.keyboard.press('Enter');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  assert.equal(await page.locator('#search-status').textContent(),'');
  assert.equal(await page.locator('#search-retry').isVisible(),false);
  assert.equal(await page.locator('#search-input').inputValue(),'archive');
  assert.equal(await page.locator('#search-input').evaluate(el=>el===document.activeElement),true);
  await page.clock.runFor(250);
  assert.equal(await page.locator('#search-status').textContent(),'','Stale loading timer appeared after recovery');
  assert.equal(count,2);console.log(`PASS failed search (${failure}): stable typing, timed popup and persistent keyboard retry`);await context.close();
 }
 for(const fault of ['no-js','storage-blocked','saved-light','saved-dark','dark-css-failed']) {
  const context=await createContext({javaScriptEnabled:fault!=='no-js',colorScheme:'dark'});const page=await context.newPage();
  if(fault==='storage-blocked')await page.addInitScript(()=>Object.defineProperty(window,'localStorage',{get(){throw new DOMException('Blocked','SecurityError');}}));
  if(fault.startsWith('saved-'))await page.addInitScript(mode=>localStorage.setItem('agent-helm-theme',mode),fault.slice(6));
  if(fault==='dark-css-failed')await page.route('**/just-the-docs-dark.css',route=>route.abort());
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  const expected=['no-js','saved-light','dark-css-failed'].includes(fault)?'light':'dark';
  await background(expected)(page);
  if(fault==='dark-css-failed') {
   await page.waitForFunction(()=>document.getElementById('theme-status').textContent.includes('Using Light'));
   assert.equal(await page.locator('#theme-mode').inputValue(),'system');
   assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),null);
  }
  assert(await page.locator('figure.mermaid img').evaluateAll(imgs=>imgs.every(img=>img.complete&&img.naturalWidth>0)));
  console.log(`PASS ${fault}: readable ${expected} theme and diagrams`);await context.close();
 }
 // An unrecognized saved value falls back to the system theme.
 {
  const context=await createContext({colorScheme:'dark'});const page=await context.newPage();
  await page.addInitScript(()=>localStorage.setItem('agent-helm-theme','invalid-fixture'));
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  await background('dark')(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),'system');
  console.log('PASS invalid saved theme: system theme and System selection');await context.close();
 }
 // A chosen mode persists across reloads.
 {
  const context=await createContext({colorScheme:'dark'});const page=await context.newPage();
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  await page.locator('#theme-mode').selectOption('light');
  await background('light')(page);
  await page.reload();
  await background('light')(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),'light');
  console.log('PASS chosen theme: saved and restored after reload');await context.close();
 }
 // An explicit mode ignores system scheme changes.
 {
  const context=await createContext({colorScheme:'dark'});const page=await context.newPage();
  await page.addInitScript(()=>localStorage.setItem('agent-helm-theme','light'));
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  await background('light')(page);
  await page.emulateMedia({colorScheme:'light'});await page.emulateMedia({colorScheme:'dark'});
  await page.waitForTimeout(200);
  await background('light')(page);
  console.log('PASS explicit theme: system scheme changes ignored');await context.close();
 }
 // Another tab's choice and reset apply to open pages.
 {
  const context=await createContext({colorScheme:'dark'});const first=await context.newPage();const second=await context.newPage();
  for(const tab of [first,second])await tab.goto(pageUrl('docs/commands/ship/detailed.html'));
  await first.locator('#theme-mode').selectOption('light');
  await background('light')(second);
  assert.equal(await second.locator('#theme-mode').inputValue(),'light');
  await first.evaluate(()=>localStorage.removeItem('agent-helm-theme'));
  await background('dark')(second);
  assert.equal(await second.locator('#theme-mode').inputValue(),'system');
  console.log('PASS cross-tab theme: choice applied, reset returns to system');await context.close();
 }
 // Failed theme loads explain the retained appearance without discarding the choice.
 for(const width of [1280,390]) {
  const context=await createContext({colorScheme:'light',viewport:{width,height:900}});const page=await context.newPage();
  await page.clock.install();
  await page.goto(pageUrl('docs/commands/log.html'));
  if(width===390)await page.locator('#menu-button').click();
  let attempts=0;
  await page.route('**/just-the-docs-dark.css',async route=>{
   attempts++;
   if(attempts===2)await new Promise(resolve=>setTimeout(resolve,500));
   await route.abort();
  });
  await page.locator('#theme-mode').selectOption('dark');
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Using Light.');
  assert(await page.locator('#theme-status').isVisible());
  assert(await page.locator('#theme-status').evaluate(status=>{
   const style=getComputedStyle(status);
   return status.clientHeight-parseFloat(style.paddingTop)-parseFloat(style.paddingBottom)<=2*parseFloat(style.lineHeight)+1;
  }),'Theme error needs more than two lines');
  await background('light')(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),'dark');
  assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),'dark');
  await page.clock.runFor(250);
  assert.equal(await page.locator('#theme-status').textContent(),'Theme unavailable. Using Light.','Stale loading text replaced the failure');
  await page.clock.runFor(3750);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  assert(await page.locator('#theme-fallback').isVisible());
  assert.equal(await page.locator('#theme-fallback').textContent(),'Using Light');
  assert((await page.locator('#theme-mode').getAttribute('title')).includes('Choose another theme to retry'));
  await page.locator('#theme-mode').selectOption('system');
  assert.equal(await page.locator('#theme-fallback').isVisible(),false);
  await page.locator('#theme-mode').selectOption('dark');
  assert.equal(await page.locator('#theme-status').textContent(),'','Theme loading feedback appeared without a delay');
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Loading theme…');
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Using Light.');
  await page.unroute('**/just-the-docs-dark.css');
  await page.locator('#theme-mode').selectOption('system');
  assert.equal(await page.locator('#theme-status').textContent(),'');
  await page.locator('#theme-mode').selectOption('dark');
  await background('dark')(page);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  await page.clock.runFor(4000);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  assert.equal(await page.locator('#theme-fallback').isVisible(),false);
  assert.equal(await page.locator('#theme-mode').getAttribute('title'),null);
  console.log(`PASS failed theme ${width}px: concise timed error, delayed loading, retained choice, applied-theme label and recovery`);await context.close();
 }
 // Clipboard feedback follows the actual result and prevents duplicate pending writes.
 {
  const context=await createContext();const page=await context.newPage();
  await page.clock.install();
  await page.addInitScript(()=>{
   window.copyRequests=0;
   Object.defineProperty(navigator,'clipboard',{value:{writeText:()=>{
    window.copyRequests++;
    return new Promise((resolve,reject)=>{window.finishCopy=resolve;window.failCopy=()=>reject(new Error('Denied fixture'));});
   }}});
  });
  await page.goto(pageUrl(''));
  const block=page.locator('div.highlighter-rouge').first();
  const button=block.locator('button');const status=block.locator('.copy-status');
  await button.focus();await page.keyboard.press('Enter');
  assert.equal(await status.textContent(),'','Fast copies should not flash pending feedback');
  assert.equal(await button.evaluate(el=>getComputedStyle(el).cursor),'pointer');
  assert(await button.evaluate(el=>el.matches(':focus-visible') && getComputedStyle(el).outlineStyle!=='none'));
  await page.clock.runFor(200);
  assert.equal(await status.textContent(),'Copying…');
  assert(await status.isVisible());
  assert.equal(await button.getAttribute('aria-busy'),'true');
  assert.equal(await button.locator('use').getAttribute('xlink:href'),'#svg-copy');
  await page.keyboard.press('Enter');
  assert.equal(await page.evaluate(()=>window.copyRequests),1);
  await page.evaluate(()=>window.failCopy());
  await page.waitForFunction(()=>document.querySelector('.copy-status').textContent.includes('Could not copy'));
  assert(await status.isVisible());
  assert.equal(await button.getAttribute('aria-busy'),null);
  assert.equal(await button.getAttribute('aria-disabled'),null);
  assert.equal(await button.locator('use').getAttribute('xlink:href'),'#svg-copy');
  await page.keyboard.press('Enter');
  await page.evaluate(()=>window.finishCopy());
  await page.waitForFunction(()=>document.querySelector('.copy-status').textContent==='Copied');
  assert.equal(await page.evaluate(()=>window.copyRequests),2);
  assert.equal(await button.locator('use').getAttribute('xlink:href'),'#svg-copied');
  assert.equal(await button.evaluate(el=>el===document.activeElement),true);
  await page.keyboard.press('Enter');
  assert.equal(await status.textContent(),'Copied','Repeated quick copy should keep its confirmation steady');
  assert.equal(await button.locator('use').getAttribute('xlink:href'),'#svg-copied');
  await page.evaluate(()=>window.finishCopy());
  await page.clock.runFor(250);
  assert.equal(await status.textContent(),'Copied','Stale pending timer replaced confirmed success');
  const nextBlock=page.locator('div.highlighter-rouge').nth(1);
  const nextButton=nextBlock.locator('button');const nextStatus=nextBlock.locator('.copy-status');
  await nextButton.click();
  assert(await nextButton.evaluate(el=>el===document.activeElement && !el.matches(':focus-visible') && getComputedStyle(el).outlineStyle==='none'));
  assert.equal(await status.textContent(),'Copied','Pending copy cleared the earlier success');
  await page.evaluate(()=>window.failCopy());
  assert.equal(await nextStatus.textContent(),'Could not copy. Try again or select the code to copy it manually.');
  assert.equal(await status.textContent(),'Copied','Failed copy cleared the earlier success');
  await page.clock.runFor(1000);
  await nextButton.click();await page.evaluate(()=>window.finishCopy());
  assert.equal(await status.textContent(),'');
  assert.equal(await button.locator('use').getAttribute('xlink:href'),'#svg-copy');
  assert.equal(await nextStatus.textContent(),'Copied');
  await page.clock.runFor(1100);
  assert.equal(await nextStatus.textContent(),'Copied','Earlier timeout cleared the latest success');
  await page.clock.runFor(900);
  assert.equal(await nextStatus.textContent(),'');
  assert.equal(await nextButton.locator('use').getAttribute('xlink:href'),'#svg-copy');
  await button.click();await page.evaluate(()=>window.failCopy());
  assert.equal(await status.textContent(),'Could not copy. Try again or select the code to copy it manually.');
  await nextButton.click();
  assert.equal(await status.textContent(),'','A new attempt left an earlier copy error visible');
  await page.evaluate(()=>window.failCopy());
  assert.equal(await nextStatus.textContent(),'Could not copy. Try again or select the code to copy it manually.');
  await nextButton.click();
  assert.equal(await nextStatus.textContent(),'','Retry did not clear its previous error');
  await page.evaluate(()=>window.failCopy());
  await page.clock.runFor(3000);
  assert.equal(await nextStatus.textContent(),'Could not copy. Try again or select the code to copy it manually.');
  await page.clock.runFor(1000);
  assert.equal(await nextStatus.textContent(),'');
  assert.equal(await nextButton.locator('use').getAttribute('xlink:href'),'#svg-copy');
  console.log('PASS clipboard: confirmed results, latest success/error only, two/four-second dismissal, retry and keyboard focus');await context.close();
 }
 // A detailed guide keeps its overview entry active in the menu.
 {
  const context=await createContext();const page=await context.newPage();
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  await page.waitForSelector('#site-nav[data-guide-nav-ready]');
  const current=page.locator('#site-nav a[aria-current="location"]');
  assert.equal(await current.count(),1);
  assert((await current.getAttribute('href')).endsWith('/docs/commands/ship.html'));
  assert.equal(await current.evaluate(link=>link.classList.contains('active')),true);
  console.log('PASS detailed guide: overview menu entry active');await context.close();
 }
 const shortcut = (await readFile(resolve(root, 'assets/js/just-the-docs.js'), 'utf8')).match(/add event listener on ctrl[^]*?e\.key === '([^']+)'/);
 if (shortcut) {
  const context=await createContext();const page=await context.newPage();
  await page.goto(pageUrl('docs/commands/log.html'));
  await page.keyboard.press(`Control+${shortcut[1]}`);
  assert.equal(await page.evaluate(()=>document.activeElement.id),'search-input');
  await page.locator('#search-input').fill('archive');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  console.log('PASS configured search shortcut before index loading');await context.close();
 }
 // The header shares feedback while keeping home and release as native links.
 for (const width of [320, 390, 800, 1024, 1280]) for (const scheme of ['light', 'dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
  await context.route('https://github.com/myowinthein/agent-helm/releases/tag/*', route=>route.fulfill({contentType:'text/html',body:'<!doctype html><title>Release fixture</title>'}));
  const page=await context.newPage();
  await page.goto(pageUrl('docs/commands/log.html'));
  const brand=page.locator('.site-brand');
  const title=brand.locator('.site-title');
  const version=brand.locator('.site-version');
  assert(await brand.locator('.site-name').evaluate(el=>el.scrollWidth<=el.clientWidth+1),'Project title is truncated');
  await title.evaluate(el=>el.style.fontFamily='Verdana, sans-serif');
  assert(await brand.locator('.site-name').evaluate(el=>el.scrollWidth<=el.clientWidth+1),`Project title is truncated with a wider fallback font at ${width}px ${scheme}`);
  await title.evaluate(el=>el.style.removeProperty('font-family'));
  const label=(await version.textContent()).trim();
  const release=`https://github.com/myowinthein/agent-helm/releases/tag/${label}`;
  assert.equal(await title.getAttribute('href'),'/agent-helm/');
  assert.equal(await version.getAttribute('href'),release);
  assert.equal(await version.getAttribute('target'),null);
  assert(await version.evaluate(a=>getComputedStyle(a,'::after').maskImage.includes('external-link.svg')));
  await title.hover();
  const highlight=await brand.evaluate(el=>getComputedStyle(el).backgroundImage);
  assert.notEqual(highlight,'none');
  await version.hover();
  assert.equal(await brand.evaluate(el=>getComputedStyle(el).backgroundImage),highlight);
  const box=await brand.boundingBox();
  const versionBox=await version.boundingBox();
  assert(versionBox.height>=24 && versionBox.width>=24);
  assert(versionBox.x>=box.x && versionBox.x+versionBox.width<=box.x+box.width);
  await page.mouse.click(box.x+box.width-3,box.y+box.height-3);
  await page.waitForURL(pageUrl(''));
  await page.goto(pageUrl('docs/commands/log.html'));
  await page.locator('.site-brand .site-title').focus();
  await page.keyboard.press('Tab');
  const focused=page.locator('.site-brand .site-version');
  assert(await focused.evaluate(a=>a===document.activeElement && a.matches(':focus-visible') && getComputedStyle(a).outlineStyle!=='none'));
  await page.keyboard.press('Enter');
  await page.waitForURL(release);
  assert.equal(context.pages().length,1);
  console.log(`PASS ${width}px ${scheme}: shared header hover, home area, separate release link and keyboard activation`);
  await context.close();
 }
 console.log(`Passed ${assertions} browser assertions.`);
} finally {await browser?.close();await new Promise(resolve=>server.close(resolve));}
