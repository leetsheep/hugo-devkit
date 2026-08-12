export function showJavaScriptStatus() {
  const status = document.querySelector("[data-js-status]");

  if (!status) return;

  const label = status.querySelector("[data-js-status-label]");
  const enabledIcon = status.querySelector("[data-js-status-enabled-icon]");
  const disabledIcon = status.querySelector("[data-js-status-disabled-icon]");

  if (!label || !enabledIcon || !disabledIcon) return;

  document.documentElement.classList.add("js-enabled");
  status.dataset.state = "enabled";
  label.textContent = status.dataset.enabledLabel || "JavaScript enabled";
  enabledIcon.hidden = false;
  disabledIcon.hidden = true;
}
