const jsStatus = document.querySelector("[data-js-status]");

if (jsStatus) {
  const label = jsStatus.querySelector("[data-js-status-label]");
  const enabledIcon = jsStatus.querySelector("[data-js-status-enabled-icon]");
  const disabledIcon = jsStatus.querySelector("[data-js-status-disabled-icon]");

  if (label && enabledIcon && disabledIcon) {
    document.documentElement.classList.add("js-enabled");
    jsStatus.dataset.state = "enabled";
    label.textContent = "JavaScript enabled";
    enabledIcon.hidden = false;
    disabledIcon.hidden = true;
  }
}
