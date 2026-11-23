(() => {
  const storageKey = 'agent-helm-theme';
  const modes = ['system', 'light', 'dark'];
  const systemTheme = window.matchMedia('(prefers-color-scheme: dark)');
  let stylesheet = document.getElementById('helm-theme-stylesheet') || document.querySelector('link[rel="stylesheet"]');
  let pendingStylesheet;
  let mode = 'system';
  let committedMode = mode;
  let savePendingChoice = false;
  let feedback = '';
  let pendingFeedbackTimer;
  let errorTimer;

  const updateDiagramLinks = () => {
    document.querySelectorAll('[data-diagram-full-size]').forEach(link => {
      const url = new URL(link.href);
      url.hash = committedMode === 'system' ? '' : `theme-${committedMode}`;
      link.setAttribute('href', `${url.pathname}${url.search}${url.hash}`);
    });
    if (document.documentElement.hasAttribute('data-diagram-viewer')) {
      const url = new URL(location.href);
      url.hash = committedMode === 'system' ? '' : `theme-${committedMode}`;
      history.replaceState(history.state, '', `${url.pathname}${url.search}${url.hash}`);
    }
  };

  const showFeedback = message => {
    feedback = message;
    const status = document.getElementById('theme-status');
    if (status) status.textContent = message;
  };
  const clearFeedback = () => {
    clearTimeout(pendingFeedbackTimer);
    clearTimeout(errorTimer);
    showFeedback('');
  };
  const finishChange = () => {
    committedMode = mode;
    updateDiagramLinks();
    const selector = document.getElementById('theme-mode');
    if (selector) {
      selector.value = committedMode;
      selector.removeAttribute('aria-busy');
    }
    if (savePendingChoice) {
      try {
        localStorage.setItem(storageKey, committedMode);
      } catch {
        // Keep the working choice in memory when storage is unavailable.
      }
    }
    savePendingChoice = false;
    clearFeedback();
  };
  const reportFailure = () => {
    clearFeedback();
    pendingStylesheet?.remove();
    pendingStylesheet = null;
    const current = stylesheet.href.endsWith('just-the-docs-dark.css') ? 'dark' : 'light';
    const previousTheme = committedMode === 'system' ? (systemTheme.matches ? 'dark' : 'light') : committedMode;
    mode = previousTheme === current ? committedMode : current;
    committedMode = mode;
    updateDiagramLinks();
    savePendingChoice = false;
    document.documentElement.style.colorScheme = current;
    const selector = document.getElementById('theme-mode');
    if (selector) {
      selector.value = committedMode;
      selector.removeAttribute('aria-busy');
    }
    showFeedback('Theme unavailable. Try again.');
    errorTimer = setTimeout(() => showFeedback(''), 4000);
  };
  stylesheet.addEventListener('error', () => {
    if (stylesheet.dataset.themeLoadFailed) reportFailure();
  });

  try {
    const saved = localStorage.getItem(storageKey);
    if (modes.includes(saved)) mode = saved;
  } catch {
    // Browser storage may be blocked by privacy settings.
  }
  if (document.documentElement.hasAttribute('data-diagram-viewer') && /^#theme-(light|dark)$/.test(location.hash)) {
    mode = location.hash.slice(7);
  }
  committedMode = mode;

  const applyTheme = (save = false) => {
    delete stylesheet.dataset.themeLoadFailed;
    clearFeedback();
    savePendingChoice = save;
    const theme = mode === 'system' ? (systemTheme.matches ? 'dark' : 'light') : mode;
    const href = new URL(`just-the-docs-${theme}.css`, stylesheet.href).href;
    pendingStylesheet?.remove();
    pendingStylesheet = null;

    if (stylesheet.href !== href) {
      // Keep the current styles active while the selected theme loads.
      const next = stylesheet.cloneNode();
      next.removeAttribute('id');
      next.href = href;
      next.addEventListener('load', () => {
        if (pendingStylesheet !== next) return;
        stylesheet.remove();
        stylesheet = next;
        stylesheet.id = 'helm-theme-stylesheet';
        pendingStylesheet = null;
        document.documentElement.style.colorScheme = theme;
        finishChange();
      });
      next.addEventListener('error', () => {
        if (pendingStylesheet !== next) return;
        next.remove();
        pendingStylesheet = null;
        reportFailure();
      });
      pendingStylesheet = next;
      pendingFeedbackTimer = setTimeout(() => {
        if (pendingStylesheet === next) showFeedback('Loading theme…');
      }, 200);
      stylesheet.after(next);
    }

    if (!pendingStylesheet) {
      document.documentElement.style.colorScheme = theme;
      finishChange();
    }
    const selector = document.getElementById('theme-mode');
    if (selector) {
      selector.value = committedMode;
      if (pendingStylesheet) selector.setAttribute('aria-busy', 'true');
    }
  };

  if (stylesheet.dataset.themeLoadFailed) reportFailure();
  else applyTheme();
  systemTheme.addEventListener('change', () => {
    if (mode === 'system') applyTheme(savePendingChoice);
  });

  window.addEventListener('storage', event => {
    if (event.key !== storageKey && event.key !== null) return;
    mode = modes.includes(event.newValue) ? event.newValue : 'system';
    applyTheme();
  });

  document.addEventListener('DOMContentLoaded', () => {
    updateDiagramLinks();
    const selector = document.getElementById('theme-mode');
    if (!selector) return;
    selector.value = committedMode;
    showFeedback(feedback);
    if (pendingStylesheet) selector.setAttribute('aria-busy', 'true');
    selector.closest('.theme-switcher').hidden = false;
    selector.addEventListener('change', () => {
      mode = selector.value;
      applyTheme(true);
    });
  });
})();
