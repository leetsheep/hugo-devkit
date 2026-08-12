export function enableCodeCopy() {
  const template = document.querySelector("#copy-button-template");

  if (!navigator.clipboard || !template) return;

  document.querySelectorAll(".highlight").forEach((highlight) => {
    const code = highlight.querySelector("code");

    if (!code) return;

    const button = template.content.firstElementChild.cloneNode(true);
    const copyIcon = button.querySelector(".copy-button__copy-icon");
    const checkIcon = button.querySelector(".copy-button__check-icon");
    const label = button.querySelector(".copy-button__label");
    const defaultLabel = document.body.dataset.copyLabel || "Copy";
    const copiedLabel = document.body.dataset.copiedLabel || "Copied";
    let resetTimer;

    label.textContent = defaultLabel;
    button.addEventListener("click", async () => {
      try {
        await navigator.clipboard.writeText(code.textContent);
      } catch {
        return;
      }

      copyIcon.hidden = true;
      checkIcon.hidden = false;
      label.textContent = copiedLabel;
      window.clearTimeout(resetTimer);
      resetTimer = window.setTimeout(() => {
        copyIcon.hidden = false;
        checkIcon.hidden = true;
        label.textContent = defaultLabel;
      }, 1600);
    });
    highlight.append(button);
  });
}
