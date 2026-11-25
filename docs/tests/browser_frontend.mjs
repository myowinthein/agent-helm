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
const assert=Object.assign(counted(assertStrict),{equal:counted(assertStrict.equal),notEqual:counted(assertStrict.notEqual),rejects:counted(assertStrict.rejects)});
async function checkThemeFeedback(page) {
 const status=page.locator('#theme-status');
 const offscreen=await page.locator('#theme-mode').evaluate(el=>{
  const box=el.getBoundingClientRect(),v=visualViewport;
  return !el.getClientRects().length||box.bottom<=v.offsetTop||box.top>=v.offsetTop+v.height||box.right<=v.offsetLeft||box.left>=v.offsetLeft+v.width;
 });
 if(offscreen){assert(await status.isHidden(),'Theme feedback remained visible without its dropdown');return;}
 assert(await status.isVisible(),'Theme feedback is hidden');
 assert(await status.evaluate(el=>{
  const box=el.getBoundingClientRect(),viewport=window.visualViewport;
  const left=viewport?.offsetLeft||0,top=viewport?.offsetTop||0;
  return box.left>=left&&box.right<=left+(viewport?.width||innerWidth)+1&&
   box.top>=top&&box.bottom<=top+(viewport?.height||innerHeight)+1;
 }),'Theme feedback escapes the visible viewport');
}
async function openCompactMenu(page) {
 const menu=page.locator('#menu-button');
 await menu.waitFor({state:'visible'});
 if(await menu.getAttribute('aria-expanded')!=='true')await menu.click();
}
async function checkFloatingFeedback(page, status, anchor) {
 assert(await status.isVisible(),'Feedback is hidden');
 await page.waitForFunction(el=>{
  const box=el.getBoundingClientRect(),v=visualViewport;
  return box.width>0&&box.height>0&&box.left>=v.offsetLeft-1&&box.top>=v.offsetTop-1&&box.right<=v.offsetLeft+v.width+1&&box.bottom<=v.offsetTop+v.height+1;
 },await status.elementHandle());
 const box=await status.boundingBox(),field=await anchor.boundingBox();
 assert(box.x+box.width<=field.x||box.x>=field.x+field.width||box.y+box.height<=field.y||box.y>=field.y+field.height,'Feedback covers its control');
}
try {
 browser=await chromium.launch({executablePath:await chromeExecutable('run the browser checks'),headless:true});
 // Short theme feedback fits its text and sits close to the dropdown itself.
 for(const width of [390,800,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
  const page=await context.newPage();let release;
  const download=new Promise(resolve=>{release=resolve;});
  try {
   await page.goto(pageUrl(''));
   if(await page.locator('#menu-button').isVisible())await openCompactMenu(page);
   if(await page.locator('#main-header').evaluate(el=>getComputedStyle(el).position==='sticky')) {
    await page.evaluate(()=>scrollTo({top:600,behavior:'instant'}));
    const readingPosition=await page.evaluate(()=>scrollY);
    const selector=await page.locator('#theme-mode').boundingBox();
    await page.mouse.click(selector.x+selector.width/2,selector.y+selector.height/2);
    await page.keyboard.press('Escape');await page.waitForTimeout(100);
    assert.equal(await page.evaluate(()=>scrollY),readingPosition,'Opening the sticky theme dropdown moved the page');
    const field=await page.locator('#search-input').boundingBox();
    await page.mouse.click(field.x+field.width/2,field.y+field.height/2);await page.waitForTimeout(100);
    assert.equal(await page.evaluate(()=>scrollY),readingPosition,'Opening sticky search moved the page');
    await page.locator('#search-input').fill('log');
    await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);await page.waitForTimeout(100);
    assert.equal(await page.evaluate(()=>scrollY),readingPosition,'Typing in sticky search moved the page');
    await page.locator('#search-input').press('Escape');await page.waitForTimeout(100);
    assert.equal(await page.evaluate(()=>scrollY),readingPosition,'Closing sticky search moved the page');
    await page.locator('#search-input').evaluate(el=>el.blur());
    await page.evaluate(()=>scrollTo({top:0,behavior:'instant'}));
   }
   const target=scheme==='light'?'dark':'light';
   await page.route(`**/just-the-docs-${target}.css?v=*`,async route=>{await download;await route.abort();});
   await page.locator('#theme-mode').selectOption(target);
   await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Loading theme…');
   await page.evaluate(()=>new Promise(resolve=>requestAnimationFrame(resolve)));
   const layout=await page.locator('#theme-status').evaluate(el=>{
    const box=el.getBoundingClientRect(),field=document.getElementById('theme-mode').getBoundingClientRect();
    const style=getComputedStyle(el),range=document.createRange();range.selectNodeContents(el);
    const padding=parseFloat(style.paddingLeft)+parseFloat(style.paddingRight);
    const border=parseFloat(style.borderLeftWidth)+parseFloat(style.borderRightWidth);
    return {extra:box.width-range.getBoundingClientRect().width-padding-border,gap:box.top-field.bottom,expectedGap:parseFloat(getComputedStyle(document.documentElement).fontSize)/4};
   });
   assert(Math.abs(layout.extra)<1,'Theme loading box reserves unused width');
   assert(Math.abs(layout.gap-layout.expectedGap)<1,'Theme loading box is detached from the dropdown');
   await page.evaluate(()=>scrollTo(0,8));
   await page.waitForFunction(()=>scrollY===8);
   await page.evaluate(()=>new Promise(resolve=>requestAnimationFrame(resolve)));
   assert(await page.locator('#theme-status').evaluate(el=>Math.abs(el.getBoundingClientRect().top-document.getElementById('theme-mode').getBoundingClientRect().bottom-parseFloat(getComputedStyle(document.documentElement).fontSize)/4)<1),'Theme feedback detached while its dropdown scrolled');
   for(const message of ['Loading theme…','Theme unavailable. Try again.']) {
    if(message.startsWith('Theme unavailable')) {
     release();
     await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Try again.');
    }
    await page.evaluate(()=>scrollTo(0,document.getElementById('theme-mode').getBoundingClientRect().bottom+scrollY+50));
    const sticky=await page.locator('#main-header').evaluate(el=>getComputedStyle(el).position==='sticky');
    await page.waitForFunction(sticky=>{const box=document.getElementById('theme-mode').getBoundingClientRect();return sticky?box.top>=0:box.bottom<=0;},sticky);
    await page.locator('#theme-status').waitFor({state:sticky?'visible':'hidden'});
    assert.equal(await page.locator('#theme-status').textContent(),message,'Scrolling cleared the theme result');
    await page.evaluate(()=>scrollTo(0,0));
    await page.locator('#theme-status').waitFor({state:'visible'});
    assert(await page.locator('#theme-status').evaluate(el=>Math.abs(el.getBoundingClientRect().top-document.getElementById('theme-mode').getBoundingClientRect().bottom-parseFloat(getComputedStyle(document.documentElement).fontSize)/4)<1),'Theme feedback did not return beside the dropdown');
   }
   await page.unroute(`**/just-the-docs-${target}.css?v=*`);
   await page.locator('#theme-mode').selectOption(target);
   await background(target)(page);
   assert.equal(await page.locator('#theme-status').textContent(),'');
   console.log(`PASS ${width}px ${scheme}: theme feedback stays attached during scrolling and recovery`);
  } finally {release();await context.close();}
 }
 for(const width of [1280,390]) {
  for(const scheme of ['light','dark']) {
   const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
   const page=await context.newPage();
   const requests=[];const errors=[];
   context.on('request',r=>requests.push(r.url()));
   page.on('pageerror',e=>errors.push(e.message));
   await page.addInitScript(()=>{window.shifts=[];new PerformanceObserver(list=>window.shifts.push(...list.getEntries().filter(e=>!e.hadRecentInput).map(e=>e.value))).observe({type:'layout-shift',buffered:true});});
   await page.goto(pageUrl('docs/commands/ship/detailed.html'));
   await page.waitForTimeout(300);
   assert(!requests.some(url=>url.includes('search-data.json')),'Search downloaded before interaction');
   assert(!requests.some(url=>url.includes('mermaid')),'Browser downloaded Mermaid');
   assert(!requests.some(url=>/search-worker\.js|vendor\/lunr/.test(url)),'Search code loaded before interaction');
   assert.equal(requests.filter(url=>/just-the-docs-(default|light|dark)\.css/.test(url)).length,1,'Duplicate initial theme stylesheets');
   assert(requests.some(url=>new URL(url).pathname.endsWith(`just-the-docs-${scheme}.css`)),'Wrong system theme');
   for(const url of requests.filter(url=>/\/assets\/(?:css\/.*\.css|js\/just-the-docs\.js)(?:\?|$)/.test(url))) {
    assert(/^[0-9a-f]{16}$/.test(new URL(url).searchParams.get('v')||''),'Generated stylesheet or script has no content version');
   }
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
   assert(/^[0-9a-f]{16}$/.test(new URL(requests.find(url=>url.includes('search-data.json'))).searchParams.get('v')||''),'Search index has no content version');
   await query.evaluate(input => input.blur());
   assert.equal(await page.evaluate(()=>document.documentElement.classList.contains('search-active')),false);
   await query.focus();
   await page.waitForFunction(()=>document.documentElement.classList.contains('search-active'));
   await query.press('Escape');
   assert.equal(await query.inputValue(),'');
   await page.locator('#theme-mode').selectOption(scheme==='light'?'dark':'light');
   await page.waitForFunction(expected=>new URL(document.querySelector('link[rel="stylesheet"]').href).pathname.endsWith(`just-the-docs-${expected}.css`),scheme==='light'?'dark':'light');
   assert(/^[0-9a-f]{16}$/.test(new URL(await page.locator('#helm-theme-stylesheet').getAttribute('href'),page.url()).searchParams.get('v')||''),'Theme change lost its content version');
   await checkThemeColors(page, scheme==='light'?'dark':'light', assert);
   assert.equal(errors.length,0,errors.join('\n'));
   console.log(`PASS ${width}px ${scheme}: one theme stylesheet, no initial index, static diagrams, CLS ${cls.toFixed(3)}, search and theme switching`);
   await context.close();
  }
 }
 // Exercise the worker's real tokenizer, prefix/fuzzy matching and preview metadata.
 {
  const context=await createContext();const page=await context.newPage();
  const loader=await readFile(resolve(root,'assets/js/just-the-docs.js'),'utf8');
  const workerUrl=JSON.parse(loader.match(/new Worker\(("[^"]+")\)/)[1]);
  const libraryUrl=JSON.parse(loader.match(/libraryUrl: ("[^"]+")/)[1]);
  const fixture={
   a:{title:'Refactor',doc:'Refactor',content:'Preserve behavior and improve project code.',relUrl:'/refactor',url:'/fixture/refactor'},
   b:{title:'A guide',doc:'A guide',content:'Refactor project modules safely.',relUrl:'/guide',url:'/fixture/guide'},
   c:{title:'Work flow',doc:'Work flow',content:'A separate process for a release.',relUrl:'/work-flow',url:'/fixture/work-flow'}
  };
  await context.route('**/fixtures/search.json',route=>route.fulfill({contentType:'application/json',body:JSON.stringify(fixture)}));
  await page.goto(pageUrl('docs/commands/log.html'));
  assert.equal(await page.evaluate(()=>typeof window.lunr),'undefined','Lunr loaded on the page thread');
  const replies=await page.evaluate(async({workerUrl,libraryUrl,indexUrl})=>{
   const worker=new Worker(workerUrl);const pending=new Map();let ready;
   const initialized=new Promise(resolve=>{ready=resolve;});
   worker.onmessage=({data})=>{if(data.type==='ready')ready();else if(data.type==='results'){pending.get(data.id)(data);pending.delete(data.id);}};
   worker.postMessage({type:'init',libraryUrl,indexUrl});await initialized;
   const replies=[];for(const input of ['refac','refctor','work/flow','zzzzzzzzzzzzzzzzzzzzzzzz']){
    const id=replies.length+1;const reply=new Promise(resolve=>pending.set(id,resolve));worker.postMessage({type:'query',id,input});replies.push(await reply);
   }
   worker.terminate();return replies;
  },{workerUrl,libraryUrl,indexUrl:pageUrl('fixtures/search.json')});
  for(const reply of replies.slice(0,2))assert.equal(reply.results.map(r=>r.ref).sort().join(','),'a,b','Prefix or fuzzy search changed');
  assert.equal(replies[0].results[0].ref,'a','Exact title boost changed');
  assert(Object.values(replies[0].results[0].matchData.metadata).some(m=>m.title?.position?.some(p=>p[0]===0&&p[1]===8)),'Worker lost title highlight positions');
  assert.equal(replies[2].results.map(r=>r.ref).join(','),'c','Slash-separated search changed');
  assert.equal(replies[3].results.length,0);
  for(const reply of replies)assert.equal(Object.keys(reply.docs).sort().join(','),reply.results.map(r=>r.ref).sort().join(','),'Worker returned unrelated documents');
  console.log('PASS search worker: prefix/fuzzy matching, title boost, separators, highlight metadata and matched documents');await context.close();
 }
 // A late response must not replace newer results or reopen cleared search.
 {
  const context=await createContext();const page=await context.newPage();
  await page.addInitScript(()=>{const Native=Worker;window.workerReplies=[];window.Worker=class extends Native{constructor(...args){super(...args);this.addEventListener('message',({data})=>{if(data.type==='results')workerReplies.push(data.id);});}};});
  await context.route('**/search-worker.js?v=*',async route=>{const response=await route.fetch();await route.fulfill({response,body:(await response.text())+"\nconst send=self.postMessage.bind(self);self.postMessage=data=>{if(data.type==='results'&&data.id===1)setTimeout(()=>send(data),250);else send(data);};"});});
  await page.goto(pageUrl('docs/commands/log.html'));const query=page.locator('#search-input');
  await query.fill('archive');await page.waitForFunction(()=>!document.getElementById('search-input').hasAttribute('aria-busy'));
  await query.fill('normalize');await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  const latest=await page.locator('#search-results a').evaluateAll(links=>links.map(a=>a.href));
  await page.waitForFunction(()=>workerReplies.includes(1)&&workerReplies.includes(2));
  assert.equal(await page.locator('#search-results > ul').count(),1,'Late worker results appended an obsolete list');
  assert.equal((await page.locator('#search-results a').evaluateAll((links,length)=>links.slice(0,length).map(a=>a.href),latest.length)).join('|'),latest.join('|'),'Late worker results replaced the latest query');
  await query.press('Escape');assert.equal(await page.locator('#search-results a').count(),0);assert.equal(await query.inputValue(),'');
  console.log('PASS search worker: out-of-order replies keep the latest results and Escape clears them');await context.close();
 }
 // Startup failure and a later crash retain an explicit retry with one UI binding.
 for(const failure of ['startup','query']) {
  const context=await createContext();const page=await context.newPage();let workers=0;
  await context.route('**/search-worker.js?v=*',async route=>{
   workers++;if(workers===1&&failure==='startup')return route.abort();
   const response=await route.fetch();let body=await response.text();
   if(workers===1&&failure==='query')body+="\nconst handle=self.onmessage;self.onmessage=event=>{if(event.data.type==='query'&&event.data.input==='crash-fixture')throw new Error('Fixture worker failure');return handle(event);};";
   await route.fulfill({response,body});
  });
  await page.goto(pageUrl('docs/commands/log.html'));const query=page.locator('#search-input');await query.fill('archive');
  if(failure==='query'){await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);await query.fill('crash-fixture');}
  await page.waitForFunction(()=>document.getElementById('search-status').textContent.includes('Search unavailable'));
  await query.fill('normalize');assert.equal(workers,1,'Typing restarted a failed worker');
  await page.locator('#search-retry').click();await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  assert.equal(workers,2);assert.equal(await query.inputValue(),'normalize');assert.equal(await page.locator('#search-retry').isVisible(),false);
  await query.press('ArrowDown');assert(await page.locator('#search-results a').first().evaluate(a=>a===document.activeElement),'Retry installed duplicate keyboard handlers');
  console.log(`PASS worker ${failure} failure: preserved input, deliberate retry and one keyboard binding`);await context.close();
 }
 // The closing fade must not swallow the next navigation click.
 for(const scheme of ['light','dark']) for(const reducedMotion of ['no-preference','reduce']) {
  const context=await createContext({viewport:{width:1280,height:900},colorScheme:scheme,reducedMotion});
  const page=await context.newPage();const guide=pageUrl('docs/commands/log.html');await page.goto(guide);
  const query=page.locator('#search-input'),overlay=page.locator('.search-overlay'),link=page.locator('.guide-depth a').nth(1);
  const destination=new URL(await link.getAttribute('href'),page.url()).href;
  await query.fill('normalize');await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  await overlay.evaluate(el=>el.getAnimations().forEach(animation=>animation.finish()));
  let box=await page.locator('#site-nav').getByRole('link',{name:'Home',exact:true}).boundingBox();
  await page.mouse.click(box.x+box.width/2,box.y+box.height/2);
  await page.waitForFunction(()=>!document.documentElement.classList.contains('search-active'));
  assert.equal(page.url(),guide,'The active search overlay allowed navigation instead of dismissing search');
  await query.focus();await page.waitForFunction(()=>document.documentElement.classList.contains('search-active'));
  await overlay.evaluate(el=>el.getAnimations().forEach(animation=>animation.finish()));
  await query.press('Escape');
  // Hold the fade in progress so this check cannot pass by waiting it out.
  if(reducedMotion==='no-preference') {
   await overlay.evaluate(el=>el.getAnimations().forEach(animation=>animation.pause()));
   assert(await overlay.evaluate(el=>parseFloat(getComputedStyle(el).opacity)>0),'The closing fade was removed');
  }
  box=await link.boundingBox();await page.mouse.click(box.x+box.width/2,box.y+box.height/2);
  await page.waitForURL(destination);
  console.log(`PASS ${scheme} ${reducedMotion}: active overlay dismisses search, closing overlay releases navigation immediately`);
  await context.close();
 }
 // Arrow navigation uses real link focus and keeps the selected result visible.
 for(const width of [390,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:390},colorScheme:scheme,reducedMotion:'reduce'});
  const page=await context.newPage();await page.goto(pageUrl('docs/commands/log.html'));
  if(width<800)await page.locator('#menu-button').click();
  const query=page.locator('#search-input');await query.pressSequentially('test');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>12);
  for(let i=0;i<12;i++)await page.keyboard.press('ArrowDown');
  const selected=page.locator('.search-result.active');
  assert(await selected.evaluate(el=>el===document.activeElement&&el.matches(':focus-visible')),'Search selection has no real keyboard focus');
  assert(await selected.evaluate(el=>{const a=el.getBoundingClientRect(),r=document.getElementById('search-results').getBoundingClientRect();return a.top>=r.top-1&&a.bottom<=r.bottom+1;}),'Keyboard selection is outside the visible result list');
  assert(await page.locator('#search-results').evaluate(el=>el.scrollTop>0));
  await page.keyboard.press('Escape');
  assert(await query.evaluate(el=>el===document.activeElement));assert.equal(await query.inputValue(),'');
  assert.equal(await page.locator('#search-results').isVisible(),false);
  await query.fill('normalize');await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  await page.keyboard.press('Tab');
  assert(await page.locator('.search-result.active').evaluate(el=>el===document.activeElement),'Tab focus and selected result diverged');
  const destination=new URL(await page.locator('.search-result.active').getAttribute('href'),page.url()).href;
  await page.keyboard.press('Enter');await page.waitForURL(destination);
  console.log(`PASS ${width}px ${scheme}: typed search, result scrolling, real link focus, Escape, Tab and Enter`);
  await context.close();
 }
 // Expanded search must fit even when the header has wrapped with larger text.
 for(const width of [800,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:390},colorScheme:scheme,reducedMotion:'reduce'});
  const page=await context.newPage();await page.goto(pageUrl('docs/commands/log.html'));
  await page.addStyleTag({content:'html {font-size:32px!important;}'});
  await openCompactMenu(page);
  await page.locator('#search-input').fill('normalize');await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  for(const selector of ['#search-input','#search-results']) {
   const box=await page.locator(selector).boundingBox();
   assert(box.x>=0&&box.x+box.width<=width+1,`${selector} overflows with enlarged text`);
   assert(box.height>0&&box.y+box.height<=390+1,`${selector} is clipped in a short viewport`);
  }
  const title=await page.locator('.search-result-title').first().boundingBox();
  const preview=await page.locator('.search-result-previews').first().boundingBox();
  const stacked=await page.locator('#search-results').evaluate(el=>el.clientWidth<=28*parseFloat(getComputedStyle(document.documentElement).fontSize));
  if(stacked)assert(preview.y>=title.y+title.height-1,'Enlarged result columns did not stack in the narrow panel');
  else assert(preview.x>=title.x+title.width-1,'Wide result columns overlap');
  console.log(`PASS ${width}px ${scheme}: enlarged search field and results stay in the visible viewport`);
  await context.close();
 }
 // CSS masks retain the system link color in forced-colors palettes.
 for(const scheme of ['light','dark']) {
  const context=await createContext({colorScheme:scheme,forcedColors:'active'});const page=await context.newPage();
  await page.goto(pageUrl('docs/commands/log.html'));
  const link=page.locator('.footer-links a[href^="https://github.com"]').first();
  const colors=await link.evaluate(el=>({text:getComputedStyle(el).color,icon:getComputedStyle(el,'::after').backgroundColor,body:getComputedStyle(document.body).backgroundColor}));
  assert.equal(colors.icon,colors.text);assert.notEqual(colors.icon,colors.body);
  console.log(`PASS forced colors ${scheme}: external icons retain the system link color`);await context.close();
 }
 // Manual appearance travels with full-size links, including blocked storage.
 for(const system of ['light','dark']) for(const blocked of [false,true]) {
  const context=await createContext({viewport:{width:390,height:900},colorScheme:system});
  if(blocked)await context.addInitScript(()=>Object.defineProperty(window,'localStorage',{get(){throw new DOMException('Blocked','SecurityError');}}));
  const page=await context.newPage();await page.goto(pageUrl('docs/commands/log/detailed.html'));
  await page.locator('#menu-button').click();const manual=system==='light'?'dark':'light';
  await page.locator('#theme-mode').selectOption(manual);await background(manual)(page);
  const link=page.locator('[data-diagram-full-size]').first();
  assert((await link.getAttribute('href')).endsWith(`#theme-${manual}`));
  await link.click();await background(manual)(page);
  assert(await page.locator('.diagram-viewer__image').evaluate(el=>el.complete&&el.naturalWidth>0&&getComputedStyle(el).colorScheme===getComputedStyle(document.documentElement).colorScheme));
  await page.goBack();
  if(!await page.locator('#theme-mode').isVisible())await page.locator('#menu-button').click();
  await page.locator('#theme-mode').selectOption('system');
  await page.waitForFunction(()=>document.getElementById('theme-mode').value==='system');
  assert(!(await page.locator('[data-diagram-full-size]').first().getAttribute('href')).includes('#'),'System choice retained a manual diagram override');
  console.log(`PASS full-size ${manual} on ${system} system${blocked?', storage blocked':''}: manual theme retained and System clears it`);
  await context.close();
 }
 // Enlarged text keeps header controls and setup tabs within the page.
 for(const width of [320,800,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
  const page=await context.newPage();
  await page.goto(pageUrl('docs/setup/codex.html'));
  if(width<800)await page.locator('#menu-button').click();
  const fontSize=await page.evaluate(()=>parseFloat(getComputedStyle(document.documentElement).fontSize));
  await page.addStyleTag({content:`html { font-size: ${fontSize*2}px !important; }`});
  await openCompactMenu(page);
  assert.equal(await page.evaluate(()=>parseFloat(getComputedStyle(document.documentElement).fontSize)),fontSize*2);
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'Enlarged text causes horizontal page scrolling');
  const header=await page.locator('#main-header').boundingBox();
  for(const selector of ['#search-input','#theme-mode','.site-version']) {
   const control=page.locator(selector);
   assert(await control.isVisible(),`${selector} disappeared with enlarged text`);
   const box=await control.boundingBox();
   assert(box.x>=0&&box.x+box.width<=width+1,`${selector} overflows with enlarged text`);
   assert(box.y>=header.y&&box.y+box.height<=header.y+header.height+1,`${selector} escapes the header`);
  }
  const chooser=await page.locator('#theme-mode').boundingBox();
  const version=await page.locator('.site-version').boundingBox();
  assert(version.x>=chooser.x+chooser.width||version.y>=chooser.y+chooser.height,'Enlarged header controls overlap');
  const query=page.locator('#search-input');
  await query.fill('normalize');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  await query.press('Escape');
  await page.addStyleTag({content:'* { line-height: 1.5 !important; letter-spacing: 0.12em !important; word-spacing: 0.16em !important; } p { margin-bottom: 2em !important; }'});
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'Enlarged, spaced text causes horizontal page scrolling');
  console.log(`PASS ${width}px ${scheme}: doubled text, spacing overrides, header controls, search and wrapping setup tabs`);
  await context.close();
 }
 // Enlarged text changes the navigation layout while preserving reading space and focus.
 for(const width of [800,1024,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme,reducedMotion:'reduce'});
  const page=await context.newPage();await page.goto(pageUrl('docs/setup/codex.html'));
  const original=await page.locator('.main-content').boundingBox();
  const setup=page.locator('#site-nav').getByRole('link',{name:'Setup',exact:true});
  await setup.focus();
  const enlarged=await page.addStyleTag({content:'html {font-size:32px!important;} * {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;} p {margin-bottom:2em!important;}'});
  const menu=page.locator('#menu-button');await menu.waitFor({state:'visible'});
  assert.equal(await page.locator('.side-bar').evaluate(el=>getComputedStyle(el).position),'static');
  assert(await setup.evaluate(el=>el===document.activeElement&&el.checkVisibility({checkVisibilityCSS:true})),'Layout collapse hid or moved navigation focus');
  assert.equal(await menu.getAttribute('aria-expanded'),'true','Focused navigation was collapsed out of view');
  const article=await page.locator('.main-content').boundingBox();
  assert(article.width>width*.75,`Enlarged article is cramped: ${article.width}px at ${width}px`);
  assert(await page.locator('h1').evaluate(el=>el.getBoundingClientRect().height<=parseFloat(getComputedStyle(el).lineHeight)+1),'Codex title still breaks across lines');
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1));
  assert(await page.locator('footer .d-md-none a').isVisible(),'Compact layout lost the footer theme credit');
  await menu.focus();await page.keyboard.press('Enter');
  assert.equal(await menu.getAttribute('aria-expanded'),'false');
  assert.equal(await page.locator('#site-nav').isVisible(),false);
  await page.keyboard.press('Enter');assert.equal(await menu.getAttribute('aria-expanded'),'true');
  const query=page.locator('#search-input');await query.fill('normalize');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  const results=await page.locator('#search-results').boundingBox();
  assert(results.x>=0&&results.x+results.width<=width+1&&results.y>=0&&results.y+results.height<=901,'Compact search escapes the viewport');
  await page.keyboard.press('ArrowDown');assert(await page.locator('.search-result.active').evaluate(el=>el===document.activeElement));
  await page.keyboard.press('Escape');assert.equal(await query.inputValue(),'');
  const terminal=page.getByRole('tab',{name:'Terminal',exact:true});await terminal.click();
  assert.equal(await terminal.getAttribute('aria-selected'),'true');
  assert(await page.locator('.main-content').evaluate(el=>el.getBoundingClientRect().width>innerWidth*.75));
  await menu.focus();await enlarged.evaluate(el=>el.remove());
  await menu.waitFor({state:'hidden'});
  assert(await page.locator('.site-title').evaluate(el=>el===document.activeElement),'Returning to desktop left focus on a hidden menu button');
  assert.equal(await page.locator('.side-bar').evaluate(el=>getComputedStyle(el).position),'fixed');
  const restored=await page.locator('.main-content').boundingBox();assert(Math.abs(restored.width-original.width)<1);
  console.log(`PASS ${width}px ${scheme}: enlarged text uses a full-width article, reachable menu/search/setup panels and preserved focus through layout changes`);
  await context.close();
 }
 // A label color regression must fail even while diagram lines/surfaces remain.
 for(const scheme of ['light','dark']) {
  const context=await createContext({colorScheme:scheme});const page=await context.newPage();
  await page.route('**/assets/diagrams/*.svg',async route=>{
   const response=await route.fetch();
   const body=(await response.text()).replace(/--diagram-text:\s*#[0-9a-f]+;/gi,'--diagram-text: var(--diagram-surface);');
   await route.fulfill({response,body});
  });
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));await background(scheme)(page);
  await assert.rejects(()=>checkThemeColors(page,scheme,assertStrict),/diagram labels have insufficient contrast/);
  console.log(`PASS ${scheme}: unreadable diagram labels are rejected with unchanged lines and surfaces`);
  await context.close();
 }
 // Breakpoint changes preserve an active search, including selected-result focus.
 {
  const context=await createContext({viewport:{width:1600,height:900},reducedMotion:'reduce'});
  const page=await context.newPage();await page.goto(pageUrl('docs/commands/log.html'));
  await page.addStyleTag({content:'html {font-size:32px!important;}'});
  const query=page.locator('#search-input');await query.fill('normalize');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  for(const width of [1599,799,800,1600]) {
   await page.setViewportSize({width,height:900});
   await page.waitForFunction(compact=>document.documentElement.classList.contains('helm-compact')===compact,width<1600);
   assert.equal(await query.inputValue(),'normalize','Layout transition cleared the query');
   assert(await query.evaluate(el=>el===document.activeElement),'Layout transition moved search focus');
   assert(await page.locator('#search-results').isVisible(),'Layout transition dismissed search');
   const box=await page.locator('#search-results').boundingBox();
   assert(box.x>=0&&box.x+box.width<=width+1&&box.y>=0&&box.y+box.height<=901,'Search overflows across the adaptive breakpoint');
  }
  await page.keyboard.press('ArrowDown');
  const selected=page.locator('.search-result.active');const href=await selected.getAttribute('href');
  await page.setViewportSize({width:1599,height:900});
  await page.waitForFunction(()=>document.documentElement.classList.contains('helm-compact'));
  assert(await selected.evaluate(el=>el===document.activeElement&&el.checkVisibility({checkVisibilityCSS:true})));
  assert.equal(await selected.getAttribute('href'),href);
  await page.keyboard.press('Escape');assert.equal(await query.inputValue(),'');
  console.log('PASS adaptive breakpoint: active search and selected-result focus survive text-relative and standard-width transitions');
  await context.close();
 }
 // Full-size viewers center fitting diagrams and return to the exact guide link.
 for(const width of [320,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme,reducedMotion:'reduce'});
  const page=await context.newPage();
  const guide=pageUrl('docs/commands/log/detailed.html');await page.goto(guide);
  const figures=page.locator('figure.mermaid');
  assert.equal(await figures.locator('figcaption a').count(),await figures.count());
  const figure=figures.nth(1);const image=figure.locator('img');const fullSize=figure.getByRole('link',{name:'View full-size diagram',exact:true});
  const authoredWidth=Number(await image.getAttribute('width'));
  const source=await image.getAttribute('src');const anchor=await fullSize.getAttribute('id');
  assert((await image.boundingBox()).width<authoredWidth,'Diagram preview no longer fits the article');
  assert.equal(await fullSize.getAttribute('target'),null,'Viewer unexpectedly opens another tab');
  await fullSize.focus();
  await page.keyboard.press('Shift+Tab');await page.keyboard.press('Tab');
  assert(await fullSize.evaluate(el=>el===document.activeElement&&el.matches(':focus-visible')&&getComputedStyle(el).outlineStyle==='solid'&&parseFloat(getComputedStyle(el).outlineWidth)>=2),'Full-size link has no keyboard focus outline');
  await fullSize.evaluate(el=>el.scrollIntoView({block:'center',behavior:'instant'}));
  const scroll=await page.evaluate(()=>scrollY);
  const destination=new URL(await fullSize.getAttribute('href'),page.url()).href;
  await page.keyboard.press('Enter');await page.waitForURL(destination);
  const full=page.locator('.diagram-viewer__image');const canvas=page.locator('.diagram-viewer__canvas');const back=page.getByRole('link',{name:'Back to guide',exact:true});
  assert.equal(await full.getAttribute('src'),source);assert((await full.boundingBox()).width>=authoredWidth-1,'Viewer shrinks labels to fit the phone');
  await background(scheme)(page);
  assert.equal(await back.getAttribute('href'),`/agent-helm/docs/commands/log/detailed.html#${anchor}`);
  const placement=await full.evaluate(el=>{const box=el.getBoundingClientRect(),canvas=el.parentElement,padding=parseFloat(getComputedStyle(canvas).paddingLeft);return {left:box.left,right:box.right,available:canvas.clientWidth,width:box.width,padding};});
  if(width===1280)assert(Math.abs(placement.left-(placement.available-placement.width)/2)<1,'Fitting diagram is not horizontally centered');
  else assert(Math.abs(placement.left-placement.padding)<1,'Wide diagram clips its left edge');
  await page.keyboard.press('Tab');assert(await back.evaluate(el=>el===document.activeElement&&el.matches(':focus-visible')));
  await page.keyboard.press('Tab');assert(await canvas.evaluate(el=>el===document.activeElement&&el.matches(':focus-visible')));
  await page.keyboard.press('ArrowDown');await page.waitForFunction(()=>document.querySelector('.diagram-viewer__canvas').scrollTop>0);
  if(width===320){await page.keyboard.press('ArrowRight');await page.waitForFunction(()=>document.querySelector('.diagram-viewer__canvas').scrollLeft>0);}
  assert((await back.boundingBox()).y>=0,'Return control scrolled out of reach');
  if(width===320)await page.keyboard.press('Escape');else{await back.focus();await page.keyboard.press('Enter');}
  await page.waitForURL(guide);await page.waitForFunction(id=>document.activeElement.id===id,anchor);
  assert(Math.abs(await page.evaluate(()=>scrollY)-scroll)<2,'Return changed the guide scroll position');
  await page.keyboard.press('Enter');await page.waitForURL(destination);await page.goBack();
  await page.waitForFunction(id=>document.activeElement.id===id,anchor);
  assert(Math.abs(await page.evaluate(()=>scrollY)-scroll)<2,'Browser Back changed the guide scroll position');
  await page.goto(destination);await page.getByRole('link',{name:'Back to guide',exact:true}).click();
  await page.waitForURL(`${guide}#${anchor}`);await page.waitForFunction(id=>document.activeElement.id===id,anchor);
  assert.equal(context.pages().length,1);
  assert.equal(await page.evaluate(()=>Object.keys(localStorage).length),0,'Diagram navigation added stored state');
  console.log(`PASS ${width}px ${scheme}: native-size viewer, alignment, keyboard panning, Back/Escape, restored scroll/focus and direct-entry fallback`);
  await context.close();
 }
 // Static return links work without JavaScript; larger text keeps them reachable.
 for(const mode of ['no-js','large-text','legacy-navigation']) {
  const scripts=mode!=='no-js';
  const context=await createContext({viewport:{width:320,height:900},javaScriptEnabled:scripts});const page=await context.newPage();
  if(mode==='legacy-navigation')await context.addInitScript(()=>Object.defineProperty(window,'navigation',{value:undefined}));
  await page.goto(pageUrl('docs/commands/log/detailed.html'));
  const link=page.locator('[data-diagram-full-size]').first();const anchor=await link.getAttribute('id');await link.click();
  await page.waitForURL(/\/diagrams\//);
  if(mode==='large-text')await page.addStyleTag({content:'html {font-size:32px!important;} * {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;}'});
  const back=page.getByRole('link',{name:'Back to guide',exact:true});const box=await back.boundingBox();
  assert(box.x>=0&&box.x+box.width<=320&&box.y>=0&&box.y+box.height<=900,'Return link escapes the enlarged viewport');
  assert(await page.locator('.diagram-viewer__header').evaluate(el=>el.scrollWidth<=el.clientWidth),'Viewer header clips its contents');
  assert(await page.locator('.diagram-viewer__image').evaluate(el=>el.complete&&el.naturalWidth>0));
  await back.click();
  if(mode==='large-text')await page.waitForURL(pageUrl('docs/commands/log/detailed.html'));else await page.waitForURL(`${pageUrl('docs/commands/log/detailed.html')}#${anchor}`);
  if(scripts)await page.waitForFunction(id=>document.activeElement.id===id,anchor);
  console.log(`PASS viewer ${mode}: readable image and reachable guide return`);
  await context.close();
 }
 // The floating arrow appears after scrolling and leaves the article unobscured.
 for(const width of [320,390,800,1280]) for(const scheme of ['light','dark']) {
  const reducedMotion=width===320||width===800?'reduce':'no-preference';
  const context=await createContext({viewport:{width,height:800},colorScheme:scheme,reducedMotion});
  const page=await context.newPage();
  await page.addInitScript(()=>{
   const scroll=window.scrollTo.bind(window);
   window.scrollRequests=[];
   window.scrollTo=(...args)=>{window.scrollRequests.push(args);scroll(...args);};
  });
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  const button=page.getByRole('button',{name:'Back to top',exact:true,includeHidden:true});
  assert.equal(await button.count(),1);
  assert.equal(await page.locator('a#back-to-top').count(),0,'Old footer link remains');
  assert.equal(await button.isVisible(),false,'Arrow appears before scrolling');
  await page.evaluate(()=>scrollTo({top:400,behavior:'instant'}));
  assert.equal(await button.isVisible(),false,'Arrow appears before the scroll threshold');
  await page.evaluate(()=>scrollTo({top:600,behavior:'instant'}));
  await button.waitFor({state:'visible'});
  const box=await button.boundingBox();
  const content=await page.locator('#main-content').boundingBox();
  assert(box.width>=44 && box.height>=44,'Arrow has an undersized touch target');
  assert(box.x>=content.x+content.width+8,'Arrow overlaps the article');
  assert(box.x+box.width<=width && box.y+box.height<=800,'Arrow is outside the viewport');
  assert.equal(await button.locator('svg').getAttribute('aria-hidden'),'true');
  await page.evaluate(()=>scrollTo({top:900,behavior:'instant'}));
  const scrolledBox=await button.boundingBox();
  assert.equal(scrolledBox.y,box.y,'Arrow moves with the article');
  await button.click();
  await page.waitForFunction(()=>scrollY===0);
  assert.equal(await button.isVisible(),false,'Arrow remains visible at the top');
  assert(await page.locator('#main-content h1').evaluate(el=>el===document.activeElement),'Focus did not return to the page heading');
  assert.equal(await page.evaluate(()=>window.scrollRequests.at(-1)[0].behavior),reducedMotion==='reduce'?'instant':'smooth');
  await page.evaluate(()=>scrollTo({top:900,behavior:'instant'}));
  await button.waitFor({state:'visible'});
  await page.locator('.footer-links a').last().focus();
  await page.keyboard.press('Tab');
  assert(await button.evaluate(el=>el===document.activeElement && el.matches(':focus-visible') && getComputedStyle(el).outlineStyle!=='none'),'Arrow has no keyboard focus indicator');
  await button.press(width===320||width===800?'Enter':'Space');
  await page.waitForFunction(()=>scrollY===0);
  assert.equal(await button.isVisible(),false);
  await page.evaluate(()=>scrollTo({top:900,behavior:'instant'}));
  await button.waitFor({state:'visible'});
  await page.evaluate(()=>scrollTo({top:0,behavior:'instant'}));
  await button.waitFor({state:'hidden'});
  await page.evaluate(()=>scrollTo({top:900,behavior:'instant'}));
  await button.waitFor({state:'visible'});
  await page.reload();
  await button.waitFor({state:'visible'});
  await page.emulateMedia({media:'print'});
  assert.equal(await button.isVisible(),false,'Arrow appears in print');
  console.log(`PASS ${width}px ${scheme}: floating arrow, clear article gutter, scroll visibility, pointer/keyboard return, ${reducedMotion} motion, restored scroll and print`);
  await context.close();
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
  await context.route('**/search-data.json?v=*',async route=>{count++;await new Promise(resolve=>setTimeout(resolve,500));await route.continue();});
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
  await context.route('**/search-data.json?v=*',async route=>{
   count++;
   if(count!==1){await new Promise(resolve=>setTimeout(resolve,500));return route.continue();}
   if(failure==='network')return route.abort();
   await route.fulfill({status:failure==='http'?503:200,body:failure==='http'?'Unavailable':'{invalid'});
  });
  await page.goto(pageUrl('docs/commands/log.html'));
  if(failure==='network')await page.locator('#menu-button').click();
  await page.locator('#search-input').focus();
  await page.waitForFunction(()=>document.getElementById('search-status').textContent.includes('Search unavailable'));
  assert.equal(await page.locator('#search-status').getAttribute('role'),'status');
  assert(await page.locator('#search-status').isVisible());
  assert.equal(await page.locator('#search-input').getAttribute('aria-busy'),null);
  await page.locator('#search-input').fill('archive');
  assert.equal(count,1,'Typing retried a failed index request');
  assert.equal(await page.locator('#search-status').textContent(),'Search unavailable. Press Enter or select Retry search.');
  await page.clock.runFor(4000);
  assert.equal(await page.locator('#search-status').textContent(),'');
  assert(await page.locator('#search-retry').isVisible(),'Timed popup removed the recovery action');
  assert(await page.locator('#search-retry').evaluate(button=>{
   const input=document.getElementById('search-input');const bounds=input.getBoundingClientRect();
   const retry=button.getBoundingClientRect();
   return retry.left>bounds.left+parseFloat(getComputedStyle(input).paddingLeft) && retry.right<=bounds.right;
  }),'Retry control overlaps the search text or escapes the field');
  assert.equal(await page.locator('#search-input').inputValue(),'archive');
  await page.locator('#search-input').dispatchEvent('keydown',{key:'Enter',isComposing:true});
  await page.locator('#search-input').dispatchEvent('keydown',{key:'Enter',repeat:true});
  assert.equal(count,1,'Composition or a held Enter key retried the search');
  if(failure==='invalid-json') {
   await page.locator('#search-retry').focus();await page.keyboard.press('Enter');
  } else {
   await page.locator('#search-input').press('Enter');
  }
  await page.locator('#search-input').press('Enter');
  await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  assert.equal(count,2,'Pending search retry started duplicate requests');
  assert.equal(await page.locator('#search-status').textContent(),'');
  assert.equal(await page.locator('#search-retry').isVisible(),false);
  assert.equal(await page.locator('#search-input').inputValue(),'archive');
  assert.equal(await page.locator('#search-input').evaluate(el=>el===document.activeElement),true);
  await page.clock.runFor(250);
  assert.equal(await page.locator('#search-status').textContent(),'','Stale loading timer appeared after recovery');
  assert.equal(count,2);console.log(`PASS failed search (${failure}): stable typing, timed popup and persistent keyboard retry`);await context.close();
 }
 // Archive breadcrumbs keep their labels and separators inside narrow enlarged layouts.
 for(const width of [320,390]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:700},colorScheme:scheme});const page=await context.newPage();
  for(const step of ['1-explore','2-restore-and-freeze','3-postman','4-documentation','5-finalize']) for(const detail of [false,true]) {
   await page.goto(pageUrl(`docs/commands/archive/${step}${detail?'/detailed':''}.html`));
   const font=await page.evaluate(()=>parseFloat(getComputedStyle(document.documentElement).fontSize));
   await page.addStyleTag({content:`html {font-size:${font*2}px!important;} * {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;} p {margin-bottom:2em!important;}`});
   assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'Archive breadcrumb causes page overflow');
   assert(await page.locator('.breadcrumb-nav').evaluate(nav=>{
    const walker=document.createTreeWalker(nav,NodeFilter.SHOW_TEXT);let node;
    while(node=walker.nextNode()){
     const range=document.createRange();range.selectNodeContents(node);
     if([...range.getClientRects()].some(b=>b.width>0&&(b.left<0||b.right>innerWidth+1)))return false;
    }
    return true;
   }),'Archive breadcrumb text is clipped');
  }
  console.log(`PASS ${width}px ${scheme}: all five Archive steps and both guide views reflow with doubled text and spacing`);await context.close();
 }
 // Touch copy controls and their pending/error messages remain usable at screen edges.
 for(const [width,height] of [[320,240],[390,390],[800,320]]) for(const scheme of ['light','dark']) for(const enlarged of [false,true]) {
  const context=await createContext({viewport:{width,height},colorScheme:scheme,hasTouch:true,isMobile:true,reducedMotion:'reduce'});
  const page=await context.newPage();await page.clock.install();
  await page.addInitScript(()=>Object.defineProperty(navigator,'clipboard',{value:{writeText:()=>new Promise((resolve,reject)=>{window.finishCopy=resolve;window.failCopy=()=>reject(new Error('Denied fixture'));})}}));
  await page.goto(pageUrl('docs/commands/normalize.html'));
  if(enlarged){const font=await page.evaluate(()=>parseFloat(getComputedStyle(document.documentElement).fontSize));await page.addStyleTag({content:`html {font-size:${font*2}px!important;} * {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;}`});}
  const block=page.locator('div.highlighter-rouge').first(),button=block.locator('button'),status=block.locator('.copy-status');
  assert.equal(await button.evaluate(el=>getComputedStyle(el).opacity),'1','Touch copy control requires hover');
  await block.evaluate(el=>scrollTo(0,el.getBoundingClientRect().top+scrollY-8));
  const before=await block.evaluate(el=>({top:el.getBoundingClientRect().top+scrollY,height:document.documentElement.scrollHeight}));
  await button.tap();await page.clock.runFor(200);
  assert.equal(await status.textContent(),'Copying…');await checkFloatingFeedback(page,status,button);
  const after=await block.evaluate(el=>({top:el.getBoundingClientRect().top+scrollY,height:document.documentElement.scrollHeight}));
  assert.equal(after.top,before.top);assert.equal(after.height,before.height,'Copy popup moved nearby content');
  await block.evaluate(el=>{const button=el.querySelector('button');scrollTo(0,el.getBoundingClientRect().top+scrollY-(innerHeight-button.getBoundingClientRect().height-8));});
  await page.clock.runFor(50);await checkFloatingFeedback(page,status,button);
  await page.evaluate(()=>window.failCopy());await page.waitForFunction(()=>document.querySelector('.copy-status').textContent.startsWith('Could not copy.'));
  await checkFloatingFeedback(page,status,button);
  if(await status.evaluate(el=>el.scrollHeight>el.clientHeight+1)) {
   await button.focus();await page.keyboard.press('Tab');assert(await status.evaluate(el=>el===document.activeElement),'Long copy error is not keyboard reachable');
   await page.keyboard.press('ArrowDown');await page.waitForFunction(el=>el.scrollTop>0,await status.elementHandle());
   await page.clock.runFor(4500);assert((await status.textContent()).startsWith('Could not copy.'),'Focused copy error expired while being read');
   await button.focus();await page.clock.runFor(500);
  } else await page.clock.runFor(4000);
  assert.equal(await status.textContent(),'');
  await button.tap();await page.evaluate(()=>window.finishCopy());await page.waitForFunction(()=>document.querySelector('.copy-status').textContent==='Copied');
  await checkFloatingFeedback(page,status,button);await page.clock.runFor(2000);assert.equal(await status.textContent(),'');
  console.log(`PASS touch copy ${width}x${height} ${scheme}, enlarged ${enlarged}: visible control, top/bottom feedback, stable layout, scrollable focused error and retry`);await context.close();
 }
 // Failed search setup keeps its field, recovery and explanation in short viewports.
 for(const width of [320,390,800]) for(const scheme of ['light','dark']) for(const enlarged of [false,true]) {
  const context=await createContext({viewport:{width,height:390},colorScheme:scheme,hasTouch:true,isMobile:true,reducedMotion:'reduce'});
  const page=await context.newPage();await page.clock.install();let attempts=0,failDownload;
  const download=new Promise(resolve=>{failDownload=resolve;});
  await context.route('**/search-data.json?v=*',async route=>{if(++attempts===1){await download;await route.abort();}else await route.continue();});
  await page.goto(pageUrl('docs/commands/log.html'));
  if(enlarged){const font=await page.evaluate(()=>parseFloat(getComputedStyle(document.documentElement).fontSize));await page.addStyleTag({content:`html {font-size:${font*2}px!important;} * {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;}`});}
  if(width<800||enlarged)await openCompactMenu(page);
  const query=page.locator('#search-input'),status=page.locator('#search-status'),retry=page.locator('#search-retry'),field=page.locator('.search-input-wrap');
  await query.fill('archive');await page.clock.runFor(200);
  assert.equal(await status.textContent(),'Loading search…');await checkFloatingFeedback(page,status,field);
  failDownload();await page.waitForFunction(()=>document.getElementById('search-status').textContent.startsWith('Search unavailable.'));
  for(const height of [390,240]) {
   await page.setViewportSize({width,height});await page.clock.runFor(50);
   await checkFloatingFeedback(page,status,field);
   for(const control of [query,retry]){const box=await control.boundingBox();assert(box.x>=0&&box.y>=0&&box.x+box.width<=width+1&&box.y+box.height<=height+1,'Search or Retry is clipped');}
   assert(await retry.evaluate(el=>{
    const input=document.getElementById('search-input'),box=input.getBoundingClientRect(),button=el.getBoundingClientRect(),style=getComputedStyle(input);
    return button.left>=box.left+parseFloat(style.paddingLeft)&&button.left>=box.right-parseFloat(style.paddingRight);
   }),'Retry covers the editable search text');
  }
  if(await status.evaluate(el=>el.scrollHeight>el.clientHeight+1)) {
   await status.focus();await page.keyboard.press('ArrowDown');await page.waitForFunction(el=>el.scrollTop>0,await status.elementHandle());
   await page.clock.runFor(4500);assert((await status.textContent()).startsWith('Search unavailable.'),'Focused search error expired while being read');
   await query.focus();
  }
  await query.press('Escape');assert.equal(await query.inputValue(),'');assert(await query.evaluate(el=>el===document.activeElement));
  assert.equal(await page.evaluate(()=>document.documentElement.classList.contains('search-active')),false);
  await query.fill('archive');assert.equal(attempts,1,'Editing retried failed setup');
  await retry.tap();await page.waitForFunction(()=>document.querySelectorAll('#search-results a').length>0);
  assert.equal(attempts,2);assert.equal(await query.inputValue(),'archive');assert.equal(await status.textContent(),'');assert.equal(await retry.isVisible(),false);
  console.log(`PASS failed search ${width}px ${scheme}, enlarged ${enlarged}: pending/error visibility, short viewport, readable recovery, Escape and deliberate retry`);await context.close();
 }
 for(const fault of ['no-js','storage-blocked','saved-light','saved-dark','dark-css-failed']) {
  const context=await createContext({javaScriptEnabled:fault!=='no-js',colorScheme:'dark'});const page=await context.newPage();
  if(fault==='storage-blocked')await page.addInitScript(()=>Object.defineProperty(window,'localStorage',{get(){throw new DOMException('Blocked','SecurityError');}}));
  if(fault.startsWith('saved-'))await page.addInitScript(mode=>localStorage.setItem('agent-helm-theme',mode),fault.slice(6));
  if(fault==='dark-css-failed')await page.route('**/just-the-docs-dark.css?v=*',route=>route.abort());
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  if(fault==='no-js')assert.equal(await page.locator('#back-to-top').isVisible(),false,'Nonfunctional arrow appears without JavaScript');
  const expected=['no-js','saved-light','dark-css-failed'].includes(fault)?'light':'dark';
  await background(expected)(page);
  if(fault==='dark-css-failed') {
   await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Try again.');
   assert.equal(await page.locator('#theme-mode').inputValue(),'system');
   assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),null);
  }
  assert(await page.locator('figure.mermaid img').evaluateAll(imgs=>imgs.every(img=>img.complete&&img.naturalWidth>0)));
  console.log(`PASS ${fault}: readable ${expected} theme and diagrams`);await context.close();
 }
 // An automatic download failure preserves System and later OS changes recover.
 for(const initial of ['light','dark']) for(const saved of [null,'system']) {
  const target=initial==='light'?'dark':'light';
  const context=await createContext({colorScheme:initial});const page=await context.newPage();
  if(saved)await page.addInitScript(mode=>localStorage.setItem('agent-helm-theme',mode),saved);
  await page.goto(pageUrl('docs/commands/log.html'));await background(initial)(page);
  const stylesheet=`**/just-the-docs-${target}.css?v=*`;
  await page.route(stylesheet,route=>route.abort());
  await page.emulateMedia({colorScheme:target});
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Try again.');
  await background(initial)(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),'system');
  assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),saved);
  assert.equal(await page.evaluate(()=>document.documentElement.style.colorScheme),initial);
  await page.unroute(stylesheet);
  await page.emulateMedia({colorScheme:initial});
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='');
  await page.emulateMedia({colorScheme:target});await background(target)(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),'system');
  assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),saved);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  console.log(`PASS System ${initial} to ${target}, saved ${saved}: failed download retains preference and later OS changes recover`);
  await context.close();
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
 // Failed changes retain the working theme, selector and saved preference together.
 for(const width of [320,390,800,1280]) {
 for(const currentTheme of ['light','dark']) {
  const targetTheme=currentTheme==='light'?'dark':'light';
  const context=await createContext({colorScheme:currentTheme,viewport:{width,height:900}});const page=await context.newPage();
  await page.clock.install();
  await page.goto(pageUrl('docs/commands/log.html'));
  if(width<800)await page.locator('#menu-button').click();
  await background(currentTheme)(page);
  await page.locator('#theme-mode').selectOption(currentTheme);
  let attempts=0;
  const stylesheet=`**/just-the-docs-${targetTheme}.css?v=*`;
  await page.route(stylesheet,async route=>{
   attempts++;
   if(attempts===2)await new Promise(resolve=>setTimeout(resolve,500));
   await route.abort();
  });
  await page.locator('#theme-mode').selectOption(targetTheme);
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Try again.');
  await checkThemeFeedback(page);
  assert(await page.locator('#theme-status').evaluate(status=>{
   const style=getComputedStyle(status);
   return status.clientHeight-parseFloat(style.paddingTop)-parseFloat(style.paddingBottom)<=2*parseFloat(style.lineHeight)+1;
  }),'Theme error needs more than two lines');
  await background(currentTheme)(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),currentTheme);
  assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),currentTheme);
  await page.clock.runFor(250);
  assert.equal(await page.locator('#theme-status').textContent(),'Theme unavailable. Try again.','Stale loading text replaced the failure');
  await page.clock.runFor(3750);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  assert.equal(await page.locator('#theme-fallback').count(),0);
  assert.equal(await page.locator('#theme-mode').inputValue(),currentTheme);
  await page.locator('#theme-mode').selectOption(targetTheme);
  assert.equal(await page.locator('#theme-mode').inputValue(),currentTheme);
  assert.equal(await page.locator('#theme-mode').getAttribute('aria-busy'),'true');
  assert.equal(await page.locator('#theme-status').textContent(),'','Theme loading feedback appeared without a delay');
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Loading theme…');
  await checkThemeFeedback(page);
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Try again.');
  assert.equal(await page.locator('#theme-mode').inputValue(),currentTheme);
  assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),currentTheme);
  await page.unroute(stylesheet);
  await page.locator('#theme-mode').selectOption(targetTheme);
  await background(targetTheme)(page);
  assert.equal(await page.locator('#theme-mode').inputValue(),targetTheme);
  assert.equal(await page.evaluate(()=>localStorage.getItem('agent-helm-theme')),targetTheme);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  await page.clock.runFor(4000);
  assert.equal(await page.locator('#theme-status').textContent(),'');
  assert.equal(await page.locator('#theme-fallback').count(),0);
  assert.equal(await page.locator('#theme-mode').getAttribute('aria-busy'),null);
  assert.equal(await page.locator('#theme-mode').getAttribute('title'),null);
  console.log(`PASS failed ${currentTheme} to ${targetTheme} ${width}px: working selection restored, saved choice preserved, concise timed error and direct retry`);await context.close();
 }
 }
 // Feedback repositions when text, viewport, scroll or keyboard focus changes.
 for(const width of [320,800]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:390},colorScheme:scheme});
  const page=await context.newPage();await page.goto(pageUrl('docs/commands/log.html'));
  if(width<800)await page.locator('#menu-button').click();
  await page.addStyleTag({content:'html {font-size:32px!important;} body {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;}'});
  await openCompactMenu(page);
  await page.locator('#theme-mode').focus();
  await background(scheme)(page);
  let failDownload;
  const download=new Promise(resolve=>{failDownload=resolve;});
  const target=scheme==='light'?'dark':'light';
  await page.route(`**/just-the-docs-${target}.css?v=*`,async route=>{await download;await route.abort();});
  const before=await page.locator('#theme-mode').evaluate(el=>({top:el.getBoundingClientRect().top+scrollY,height:document.documentElement.scrollHeight}));
  await page.locator('#theme-mode').selectOption(target);
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Loading theme…');
  await checkThemeFeedback(page);
  const after=await page.locator('#theme-mode').evaluate(el=>({top:el.getBoundingClientRect().top+scrollY,height:document.documentElement.scrollHeight}));
  assert.equal(after.top,before.top,'Feedback moved the theme control');
  assert.equal(after.height,before.height,'Feedback changed the document height');
  await page.locator('.breadcrumb-nav a').first().focus();
  await checkThemeFeedback(page);
  assert(await page.locator('#theme-status').evaluate(el=>{
   if(getComputedStyle(el).visibility==='hidden')return true;
   const a=el.getBoundingClientRect(),b=document.activeElement.getBoundingClientRect();
   return a.right<=b.left||a.left>=b.right||a.bottom<=b.top||a.top>=b.bottom;
  }),'Theme feedback obscures the focused breadcrumb');
  await page.setViewportSize({width:width===320?390:1280,height:500});
  await page.waitForTimeout(50);await checkThemeFeedback(page);
  failDownload();
  await page.waitForFunction(()=>document.getElementById('theme-status').textContent==='Theme unavailable. Try again.');
  await checkThemeFeedback(page);
  console.log(`PASS ${width}px ${scheme}: enlarged and spaced feedback fits a short viewport, follows resize/scroll and avoids focused content without layout shifts`);
  await context.close();
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
 // Compact text links and focus indicators must leave surrounding words readable.
 for(const width of [320,800,1280]) for(const scheme of ['light','dark']) for(const forcedColors of ['none','active']) for(const enlarged of [false,true]) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme,forcedColors,reducedMotion:'reduce'});
  const page=await context.newPage();
  for(const [path,selectors] of [
   ['docs/commands/log.html',['main p a[href$="#run-a-command"]','figcaption a','.footer-links a:first-child','.site-footer a:visible,footer .d-md-none a:visible']],
   ['', ['main a[href*="/docs/commands/adopt.html"]','div.highlight[tabindex]']],
   ['docs/commands.html',['td a']],
   ['docs/known-issues.html',['details p a','summary']],
  ]) {
   await page.goto(pageUrl(path));
   if(enlarged)await page.addStyleTag({content:'html {font-size:200%!important;} * {line-height:1.5!important;letter-spacing:.12em!important;word-spacing:.16em!important;} p {margin-bottom:2em!important;}'});
   await page.locator('details').evaluateAll(details=>details.forEach(el=>el.open=true));
   for(const selector of selectors) {
    const target=page.locator(selector).first();
    const before=await target.evaluate(el=>({top:el.getBoundingClientRect().top+scrollY,height:document.documentElement.scrollHeight,background:getComputedStyle(el).backgroundColor}));
    await target.focus();
    // Let scroll-driven controls settle before checking the adjacent Tab stops.
    await page.evaluate(()=>new Promise(resolve=>requestAnimationFrame(()=>requestAnimationFrame(resolve))));
    await page.keyboard.press('Shift+Tab');await page.keyboard.press('Tab');
    const result=await target.evaluate(el=>{
     const style=getComputedStyle(el);
     const textLink=el.matches('a:not([class]):not(.guide-depth a)');
     const width=parseFloat(style.outlineWidth),offset=parseFloat(style.outlineOffset);
     const luminance=color=>color.match(/[\d.]+/g).slice(0,3).map(Number).map(v=>v/255).map(v=>v<=.04045?v/12.92:((v+.055)/1.055)**2.4).reduce((sum,v,i)=>sum+v*[.2126,.7152,.0722][i],0);
     let surface=el;while(getComputedStyle(surface).backgroundColor==='rgba(0, 0, 0, 0)')surface=surface.parentElement;
     const [low,high]=[style.outlineColor,getComputedStyle(surface).backgroundColor].map(luminance).sort((a,b)=>a-b);
     const contrast=(high+.05)/(low+.05);
     const frames=Array.from(el.getClientRects(),r=>({left:r.left-offset-width,right:r.right+offset+width,top:r.top-offset-width,bottom:r.bottom+offset+width,innerLeft:r.left-offset,innerRight:r.right+offset,innerTop:r.top-offset,innerBottom:r.bottom+offset}));
     const scope=el.closest('p,td,figcaption,.site-footer,.d-md-none');const collisions=[];
     if(scope) {
      const walker=document.createTreeWalker(scope,NodeFilter.SHOW_TEXT);
      for(let node;node=walker.nextNode();) {
       if(el.contains(node)||node.parentElement.closest('.sr-only,[hidden]'))continue;
       const range=document.createRange();
       for(const word of node.textContent.matchAll(/\S+/g)) {
        range.setStart(node,word.index);range.setEnd(node,word.index+word[0].length);
        for(const r of range.getClientRects())for(const f of frames) {
         const intersects=r.right>f.left+.5&&r.left<f.right-.5&&r.bottom>f.top+.5&&r.top<f.bottom-.5;
         const inside=r.left>=f.innerLeft&&r.right<=f.innerRight&&r.top>=f.innerTop&&r.bottom<=f.innerBottom;
         if(intersects&&!inside)collisions.push(word[0]);
        }
       }
      }
     }
     return {focused:el===document.activeElement&&el.matches(':focus-visible'),visible:style.outlineStyle==='solid'&&width>=2&&contrast>=3,textLink,background:style.backgroundColor,compact:!textLink||(['paddingRight','paddingLeft'].every(p=>parseFloat(style[p])<=2)&&style.lineHeight===getComputedStyle(el.parentElement).lineHeight),collisions,inViewport:frames.every(f=>f.left>=-.6&&f.top>=-.6&&f.right<=innerWidth+.6&&f.bottom<=innerHeight+.6),top:el.getBoundingClientRect().top+scrollY,height:document.documentElement.scrollHeight};
    });
    assert(result.focused&&result.visible,`${selector} lost its keyboard focus indicator`);
    assert(result.compact,`${selector} adds space around inline text`);
    if(result.textLink)assert.equal(result.background,before.background,`${selector} fills the link instead of outlining it`);
    assert.equal(result.collisions.length,0,`${selector} covers neighboring words: ${result.collisions.join(', ')}`);
    assert(result.inViewport,`${selector} focus frame is clipped by the viewport`);
    assert(Math.abs(result.top-before.top)<1&&result.height===before.height,`${selector} moves content when focus appears`);
   }
  }
  console.log(`PASS ${width}px ${scheme}, forced colors ${forcedColors}, enlarged ${enlarged}: compact links and contrasting outlines avoid adjacent text, clipping and layout shifts`);
  await context.close();
 }
 // Each sidebar row has one Tab stop, with keyboard and pointer submenu access.
 for(const width of [390,1280]) for(const scheme of ['light','dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
  const page=await context.newPage();await page.goto(pageUrl('docs/commands/log.html'));
  if(width<800)await page.locator('#menu-button').click();
  const navigation=page.locator('#site-nav');
  const setup=navigation.getByRole('link',{name:'Setup',exact:true});
  const commands=navigation.getByRole('link',{name:'Commands',exact:true});
  const setupButton=navigation.getByRole('button',{name:'Setup submenu',exact:true});
  assert(await navigation.locator('.nav-list-expander').evaluateAll(buttons=>buttons.every(button=>button.tabIndex===-1)));
  assert(await navigation.locator('.nav-list-link').evaluateAll(links=>links.every(link=>link.hasAttribute('href'))),'A current-page row lost its Tab stop');
  await navigation.getByRole('link',{name:'Home',exact:true}).focus();
  await page.keyboard.press('Tab');assert(await setup.evaluate(el=>el===document.activeElement),'Tab stopped on the arrow before the row');
  assert(await setup.evaluate(el=>el.matches(':focus-visible')&&getComputedStyle(el).outlineStyle==='solid'));
  const initial=page.url();await page.keyboard.press('ArrowRight');
  assert.equal(page.url(),initial);assert.equal(await setup.getAttribute('aria-expanded'),'true');
  assert.equal(await setupButton.getAttribute('aria-expanded'),'true');
  assert.equal(await setup.getAttribute('aria-controls'),await setupButton.getAttribute('aria-controls'));
  await page.keyboard.press('ArrowRight');assert.equal(await setup.getAttribute('aria-expanded'),'true');
  await page.keyboard.press('Tab');assert(await navigation.getByRole('link',{name:'Claude',exact:true}).evaluate(el=>el===document.activeElement));
  await page.keyboard.press('Shift+Tab');assert(await setup.evaluate(el=>el===document.activeElement));
  await page.keyboard.press('ArrowLeft');assert.equal(await setup.getAttribute('aria-expanded'),'false');
  assert.equal(await setupButton.getAttribute('aria-expanded'),'false');
  await page.keyboard.press('Tab');assert(await commands.evaluate(el=>el===document.activeElement),'Tab visited the collapsed submenu or a second row control');
  await page.keyboard.press('Shift+Tab');assert(await setup.evaluate(el=>el===document.activeElement));
  await setupButton.click();assert.equal(await setup.getAttribute('aria-expanded'),'true');
  await setupButton.click();assert.equal(await setup.getAttribute('aria-expanded'),'false');
  const archive=navigation.getByRole('link',{name:'Archive',exact:true});
  await archive.focus();await page.keyboard.press('ArrowRight');
  assert.equal(await archive.getAttribute('aria-expanded'),'true');
  await page.keyboard.press('Tab');assert(await navigation.getByRole('link',{name:'Step 1: Explore',exact:true}).evaluate(el=>el===document.activeElement));
  await page.keyboard.press('Shift+Tab');await page.keyboard.press('ArrowLeft');
  assert.equal(await archive.getAttribute('aria-expanded'),'false');
  await setup.focus();await page.keyboard.press('Enter');await page.waitForURL(pageUrl('docs/setup/'));
  if(width<800)await page.locator('#menu-button').click();
  const current=page.locator('#site-nav').getByRole('link',{name:'Setup',exact:true});
  assert.equal(await current.getAttribute('href'),'/agent-helm/docs/setup/');
  assert.equal(await current.getAttribute('aria-expanded'),'true');
  await current.focus();await page.keyboard.press('ArrowLeft');assert.equal(await current.getAttribute('aria-expanded'),'false');
  await page.goto(pageUrl('docs/commands/ship/detailed.html'));
  if(width<800)await page.locator('#menu-button').click();
  assert.equal(await page.locator('#site-nav').getByRole('link',{name:'Commands',exact:true}).getAttribute('aria-expanded'),'true');
  console.log(`PASS ${width}px ${scheme}: one sidebar Tab stop per row, arrows, nested menus, pointer toggles, Enter and current-page access`);
  await context.close();
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
 // The release follows the theme chooser while home remains a native sidebar link.
 for (const width of [320, 390, 800, 1024, 1280]) for (const scheme of ['light', 'dark']) {
  const context=await createContext({viewport:{width,height:900},colorScheme:scheme});
  await context.route('https://github.com/myowinthein/agent-helm/releases/tag/*', route=>route.fulfill({contentType:'text/html',body:'<!doctype html><title>Release fixture</title>'}));
  const page=await context.newPage();
  await page.goto(pageUrl('docs/commands/log.html'));
  const title=page.locator('.site-title');
  const version=page.locator('.header-controls .site-version');
  assert(await title.evaluate(el=>el.scrollWidth<=el.clientWidth+1),'Project title is truncated');
  await title.evaluate(el=>el.style.fontFamily='Verdana, sans-serif');
  assert(await title.evaluate(el=>el.scrollWidth<=el.clientWidth+1),`Project title is truncated with a wider fallback font at ${width}px ${scheme}`);
  await title.evaluate(el=>el.style.removeProperty('font-family'));
  const label=(await version.textContent()).trim();
  const release=`https://github.com/myowinthein/agent-helm/releases/tag/${label}`;
  assert.equal(await title.getAttribute('href'),'/agent-helm/');
  assert.equal(await version.getAttribute('href'),release);
  assert.equal(await version.getAttribute('target'),null);
  assert(await version.evaluate(a=>getComputedStyle(a,'::after').maskImage.includes('external-link.svg')));
  const box=await title.boundingBox();
  await page.mouse.click(box.x+box.width-3,box.y+box.height-3);
  await page.waitForURL(pageUrl(''));
  await page.goto(pageUrl('docs/commands/log.html'));
  if(width<800)await page.locator('#menu-button').click();
  const chooserBox=await page.locator('#theme-mode').boundingBox();
  const versionBox=await version.boundingBox();
  assert(versionBox.height>=24 && versionBox.width>=24);
  assert(versionBox.x>=chooserBox.x+chooserBox.width,'Version must sit to the right of the theme chooser');
  assert(Math.abs(versionBox.y+versionBox.height/2-chooserBox.y-chooserBox.height/2)<1,'Version and theme chooser must align vertically');
  assert(versionBox.x+versionBox.width<=width,'Version overflows the viewport');
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth),'Header causes horizontal scrolling');
  await page.locator('#theme-mode').focus();
  await page.keyboard.press('Tab');
  const focused=page.locator('.header-controls .site-version');
  assert(await focused.evaluate(a=>a===document.activeElement && a.matches(':focus-visible') && getComputedStyle(a).outlineStyle!=='none'));
  await page.keyboard.press('Enter');
  await page.waitForURL(release);
  assert.equal(context.pages().length,1);
  console.log(`PASS ${width}px ${scheme}: home area, version beside theme chooser, separate release link and keyboard activation`);
  await context.close();
 }
 console.log(`Passed ${assertions} browser assertions.`);
} finally {await browser?.close();await new Promise(resolve=>server.close(resolve));}
