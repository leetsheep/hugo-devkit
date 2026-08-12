function normalize(value) {
  return value.toLocaleLowerCase();
}

function findPages(pages, query) {
  const terms = normalize(query).split(/\s+/).filter(Boolean);

  return pages
    .map((page) => {
      const title = normalize(page.title);
      const description = normalize(page.description || "");
      const content = normalize(page.content || "");
      const matches = terms.every((term) =>
        `${title} ${description} ${content}`.includes(term),
      );
      const score = terms.reduce((total, term) => {
        if (title.includes(term)) return total + 3;
        if (description.includes(term)) return total + 2;
        return total + 1;
      }, 0);

      return { matches, page, score };
    })
    .filter((result) => result.matches)
    .sort((a, b) => b.score - a.score || a.page.title.localeCompare(b.page.title))
    .slice(0, 20);
}

function renderResults(results, list) {
  list.replaceChildren();

  results.forEach(({ page }) => {
    const item = document.createElement("li");
    const article = document.createElement("article");
    const heading = document.createElement("h2");
    const link = document.createElement("a");

    link.href = page.permalink;
    link.textContent = page.title;
    heading.append(link);
    article.append(heading);

    if (page.description) {
      const description = document.createElement("p");
      description.textContent = page.description;
      article.append(description);
    }

    item.append(article);
    list.append(item);
  });
}

export function enableSearch() {
  const form = document.querySelector("[data-search-form]");

  if (!form) return;

  const input = form.querySelector("input[type='search']");
  const list = document.querySelector("[data-search-results]");
  const status = document.querySelector("[data-search-status]");
  const indexURL = form.dataset.searchIndex;
  let pages;

  async function search(query) {
    status.textContent = form.dataset.loadingLabel;

    try {
      pages ||= await fetch(indexURL).then((response) => {
        if (!response.ok) throw new Error("Search index unavailable");
        return response.json();
      });
    } catch {
      status.textContent = form.dataset.errorLabel;
      return;
    }

    const results = findPages(pages, query);
    renderResults(results, list);
    status.textContent = results.length
      ? (results.length === 1
          ? form.dataset.resultOneLabel
          : form.dataset.resultOtherLabel
        ).replace("{count}", results.length)
      : form.dataset.emptyLabel;
  }

  form.addEventListener("submit", (event) => {
    event.preventDefault();
    const query = input.value.trim();

    if (!query) return;

    const url = new URL(window.location);
    url.searchParams.set("q", query);
    window.history.replaceState({}, "", url);
    search(query);
  });

  const initialQuery = new URLSearchParams(window.location.search).get("q");
  if (initialQuery) {
    input.value = initialQuery;
    search(initialQuery);
  }
}
