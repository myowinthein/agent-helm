(() => {
  const storageKey = 'agent-helm-theme';
  const modes = ['system', 'light', 'dark'];
  const systemTheme = window.matchMedia('(prefers-color-scheme: dark)');
  let stylesheet = document.getElementById('helm-theme-stylesheet') || document.querySelector('link[rel="stylesheet"]');
  let pendingStylesheet;
  let mode = 'system';
  let feedback = '';
  let fallbackTheme = '';
  let pendingFeedbackTimer;
  let errorTimer;

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
  const showFallback = current => {
    fallbackTheme = current;
    const fallback = document.getElementById('theme-fallback');
    if (fallback) {
      fallback.hidden = !current;
      fallback.textContent = current ? `Using ${current}` : '';
    }
    const selector = document.getElementById('theme-mode');
    if (selector) {
      if (current) selector.title = `Theme unavailable. Using ${current}. Choose another theme to retry.`;
      else selector.removeAttribute('title');
    }
  };
  const reportFailure = () => {
    clearFeedback();
    const current = stylesheet.href.endsWith('just-the-docs-dark.css') ? 'Dark' : 'Light';
    document.documentElement.style.colorScheme = current.toLowerCase();
    showFallback(current);
    showFeedback(`Theme unavailable. Using ${current}.`);
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

  const applyTheme = () => {
    delete stylesheet.dataset.themeLoadFailed;
    clearFeedback();
    showFallback('');
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
        clearFeedback();
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

    if (!pendingStylesheet) document.documentElement.style.colorScheme = theme;
    const selector = document.getElementById('theme-mode');
    if (selector) selector.value = mode;
  };

  if (stylesheet.dataset.themeLoadFailed) reportFailure();
  else applyTheme();
  systemTheme.addEventListener('change', () => {
    if (mode === 'system') applyTheme();
  });

  window.addEventListener('storage', event => {
    if (event.key !== storageKey && event.key !== null) return;
    mode = modes.includes(event.newValue) ? event.newValue : 'system';
    applyTheme();
  });

  document.addEventListener('DOMContentLoaded', () => {
    const selector = document.getElementById('theme-mode');
    if (!selector) return;
    selector.value = mode;
    showFeedback(feedback);
    showFallback(fallbackTheme);
    selector.closest('.theme-switcher').hidden = false;
    selector.addEventListener('change', () => {
      mode = selector.value;
      applyTheme();
      try {
        localStorage.setItem(storageKey, mode);
      } catch {
        // Switching still works when the preference cannot be saved.
      }
    });
  });
})();
