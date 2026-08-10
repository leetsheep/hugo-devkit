const jsStatus = document.querySelector("[data-js-status]");

if (jsStatus) {
  const label = jsStatus.querySelector("[data-js-status-label]");
  const enabledIcon = jsStatus.querySelector("[data-js-status-enabled-icon]");
  const disabledIcon = jsStatus.querySelector("[data-js-status-disabled-icon]");

  if (label && enabledIcon && disabledIcon) {
    document.documentElement.classList.add("js-enabled");
    jsStatus.dataset.state = "enabled";
    label.textContent = document.documentElement.lang === "de-DE" ? "JavaScript aktiv" : "JavaScript enabled";
    enabledIcon.hidden = false;
    disabledIcon.hidden = true;
  }
}

if (navigator.clipboard) {
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
      await navigator.clipboard.writeText(code.textContent);
      button.textContent = copiedLabel;
      window.setTimeout(() => {
        button.textContent = defaultLabel;
      }, 1600);
    });
    highlight.append(button);
  });
}
