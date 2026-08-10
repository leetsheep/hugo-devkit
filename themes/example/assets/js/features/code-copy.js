export function enableCodeCopy() {
  if (!navigator.clipboard) return;

  document.querySelectorAll(".highlight").forEach((highlight) => {
    const code = highlight.querySelector("code");

    if (!code) return;

    const button = document.createElement("button");
    const defaultLabel = document.body.dataset.copyLabel || "Copy code";
    const copiedLabel = document.body.dataset.copiedLabel || "Copied";

    button.className = "copy-button";
    button.type = "button";
    button.textContent = defaultLabel;
    button.addEventListener("click", async () => {
      try {
        await navigator.clipboard.writeText(code.textContent);
      } catch {
        return;
      }

      button.textContent = copiedLabel;
      window.setTimeout(() => {
        button.textContent = defaultLabel;
      }, 1600);
    });
    highlight.append(button);
  });
}
