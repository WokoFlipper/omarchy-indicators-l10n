import QtQuick
import qs.Ui

BarIndicator {
  id: root

  readonly property var nightlightService: bar?.shell?.firstPartyServiceFor("omarchy.nightlight")

  active: nightlightService ? nightlightService.enabled : false
  activeText: "󰔎"
  inactiveText: "󰔎"
  // Strings come from ~/.config/omarchy/locales/<language>.json.
  Translations { id: i18n }

  activeTooltipText: i18n.t("Day Light")
  inactiveTooltipText: i18n.t("Night Light")

  function toggle() {
    if (root.nightlightService) root.nightlightService.setNightlight(!root.active)
  }

  onPressed: function() { root.toggle() }
}
