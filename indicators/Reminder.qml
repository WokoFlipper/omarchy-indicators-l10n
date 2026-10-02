import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarIndicator {
  id: root

  property int reminderCount: 0
  property string tooltip: ""

  active: reminderCount > 0
  activeText: "󰢌"
  inactiveText: "󰢌"
  // Strings come from ~/.config/omarchy/locales/<language>.json.
  Translations { id: i18n }

  // omarchy-reminder formats the tooltip itself -- "Set Reminder", "1 reminder",
  // "5 reminders" -- so the English arrives already built, and translating the
  // finished sentence would need a catalog key per count. The count comes in the
  // same payload, so the tooltip is built here from it instead. That is also
  // what lets a language decline the noun: Slovenian needs four forms where
  // English has two. `tooltip` stays as upstream sets it, unread.
  activeTooltipText: i18n.plural(reminderCount, "%1 reminder", "%1 reminders")
  inactiveTooltipText: i18n.t("Set Reminder")

  Translations { id: i18n }

  function refresh() {
    if (!jsonProc.running) jsonProc.running = true
  }

  function openReminderFlow() {
    Quickshell.execDetached(["omarchy-reminder", "-i"])
  }

  function update(raw) {
    var data = extractData(raw)
    reminderCount = Number(data.count || 0)
    tooltip = reminderCount > 0
      ? i18n.plural(reminderCount, "%1 reminder", "%1 reminders")
      : i18n.t("Set Reminder")
  }

  Component.onCompleted: refresh()

  Connections {
    target: root.indicatorHost
    ignoreUnknownSignals: true
    function onRefreshRequested() { root.refresh() }
  }

  Process {
    id: jsonProc
    command: ["omarchy-reminder", "show", "--json"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.update(text)
    }
    onExited: function(exitCode) {
      if (exitCode !== 0) {
        root.reminderCount = 0
        root.tooltip = ""
      }
    }
  }

  onPressed: function() {
    if (root.reminderCount > 0) Quickshell.execDetached(["omarchy-reminder", "show"])
    else root.openReminderFlow()
  }
}
