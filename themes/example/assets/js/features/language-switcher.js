export function enableLanguageSwitcher() {
  document.querySelectorAll("[data-language-switcher]").forEach((switcher) => {
    const toggle = switcher.querySelector("summary");

    document.addEventListener("click", (event) => {
      if (!switcher.contains(event.target)) switcher.open = false;
    });

    switcher.addEventListener("keydown", (event) => {
      if (event.key !== "Escape") return;

      switcher.open = false;
      toggle.focus();
    });
  });
}
