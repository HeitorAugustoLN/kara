import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PC3
import "../highlights/" as Highlights
import "../Common/" as Common
import "../Utils.js" as Utils
import org.kde.taskmanager as TaskManager

Rectangle {
    id: cont
    z: 5
    property int pos
    property bool hasActiveWindow: tasksModel.count>0
    property real prevLen: 0

    clip: false
    onWidthChanged: {
        if(!is_vertical) {
            len += width - prevLen
            prevLen = width
        }
    }
    onHeightChanged: {
        if(is_vertical) {
            len += height - prevLen
            prevLen = height
        }
    }
    Component.onDestruction: len -= is_vertical?height:width
    Layout.fillWidth: is_vertical
    Layout.fillHeight: !is_vertical
    color: "transparent"

    x: is_vertical ? 0 : pos * width
    y: is_vertical ? pos * height: 0
    width: Math.min(root.width,cfg.fixedLen)
    height: is_vertical ? label.height : root.height

    Behavior on width   { NumberAnimation { duration: 300 }}
    Behavior on height  { NumberAnimation { duration: 300 }}
    Behavior on opacity { NumberAnimation { duration: 300 }}

    TapHandler {
        onTapped: pagerModel.changePage(pos)
    }

    TaskManager.TasksModel {
        id: tasksModel
        activity: activityInfo.currentActivity
        virtualDesktop: virtualDesktopInfo.desktopIds[pos]
        filterByVirtualDesktop: true
        filterByActivity: true
    }
    Kirigami.Icon {
        z: 5
        source: (root.customIcons[pos] ?? cfg.iconExtra).trim()
        fallback: cfg.iconExtra.trim()
        anchors.centerIn: parent
        height: Math.min(parent.width, parent.height)
        width: height
        color: root.txtColor
    }
    Common.HighlightLoader{}
}
