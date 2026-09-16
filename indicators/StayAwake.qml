import QtQuick
import qs.Ui

BarIndicator {
  id: root

  readonly property var idleService: bar?.shell?.firstPartyServiceFor("omarchy.idle")

  active: idleService ? idleService.stayAwake : false
  activeText: "󰅶"
  inactiveText: "󰅶"
  // Strings come from ~/.config/omarchy/locales/<language>.json.
  Translations { id: i18n }

  activeTooltipText: i18n.t("Allow Idle Lock & Screensaver")
  inactiveTooltipText: i18n.t("Stay Awake")

  function toggle() {
    if (root.idleService) root.idleService.setIdleEnabled(root.active)
  }

  onPressed: function() { root.toggle() }
}
