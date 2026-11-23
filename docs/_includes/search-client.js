let helmSearchStarted = false;
let helmSearchReady = false;
let helmSearchFailedState = false;
let helmSearchUIReady = false;
let helmSearchPendingTimer;
let helmSearchErrorTimer;
let helmSearchInput;
let helmSearchStatus;
let helmSearchRetry;
let helmSearchWorker;
let helmSearchQueryId = 0;
const helmSearchQueries = new Map();

function clearHelmSearchFeedback() {
  clearTimeout(helmSearchPendingTimer);
  clearTimeout(helmSearchErrorTimer);
  helmSearchStatus.textContent = '';
}

function helmSearchFailed() {
  clearHelmSearchFeedback();
  helmSearchStarted = false;
  helmSearchReady = false;
  helmSearchFailedState = true;
  helmSearchWorker?.terminate();
  helmSearchWorker = null;
  helmSearchQueries.forEach(query => query.reject(new Error('Search unavailable')));
  helmSearchQueries.clear();
  helmSearchInput.removeAttribute('aria-busy');
  helmSearchRetry.disabled = false;
  helmSearchRetry.hidden = false;
  helmSearchStatus.textContent = 'Search unavailable. Press Enter or select Retry search.';
  const dismiss = () => {
    if (document.activeElement === helmSearchStatus) helmSearchErrorTimer = setTimeout(dismiss, 500);
    else helmSearchStatus.textContent = '';
  };
  helmSearchErrorTimer = setTimeout(dismiss, 4000);
}

const helmSearchClient = {
  search(input) {
    return new Promise((resolve, reject) => {
      if (!helmSearchReady || !helmSearchWorker) return reject(new Error('Search unavailable'));
      const id = ++helmSearchQueryId;
      helmSearchQueries.set(id, { resolve, reject });
      helmSearchWorker.postMessage({ type: 'query', id, input });
    });
  }
};

function initSearch(retry = false) {
  if (helmSearchStarted || (helmSearchFailedState && retry !== true)) return;
  helmSearchStarted = true;
  helmSearchFailedState = false;
  clearHelmSearchFeedback();
  helmSearchRetry.disabled = true;
  helmSearchInput.setAttribute('aria-busy', 'true');
  helmSearchPendingTimer = setTimeout(() => { helmSearchStatus.textContent = 'Loading search…'; }, 200);
  try {
    const worker = new Worker("/* WORKER_URL */");
    helmSearchWorker = worker;
    worker.onerror = event => {
      event.preventDefault();
      if (helmSearchWorker === worker) helmSearchFailed();
    };
    worker.onmessageerror = () => {
      if (helmSearchWorker === worker) helmSearchFailed();
    };
    worker.onmessage = ({ data }) => {
      if (helmSearchWorker !== worker) return;
      if (data.type === 'ready') {
        helmSearchReady = true;
        clearHelmSearchFeedback();
        helmSearchRetry.hidden = true;
        helmSearchInput.removeAttribute('aria-busy');
        if (!helmSearchUIReady) {
          searchLoaded(helmSearchClient, {});
          helmSearchUIReady = true;
        }
        if (document.activeElement === helmSearchInput) helmSearchInput.dispatchEvent(new Event('docs-search-ready'));
      } else if (data.type === 'results') {
        const query = helmSearchQueries.get(data.id);
        if (!query) return;
        helmSearchQueries.delete(data.id);
        query.resolve(data);
      } else {
        helmSearchFailed();
      }
    };
    worker.postMessage({ type: 'init', libraryUrl: "/* LIBRARY_URL */", indexUrl: "/* INDEX_URL */" });
  } catch {
    helmSearchFailed();
  }
}
