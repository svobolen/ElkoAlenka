import QtQuick 2.7
import QtQuick.Controls.Universal 2.1

DragTrackForm {

    mouseArea.onReleased: {
        mouseArea.parent = (tile.Drag.target === null || tile.Drag.target.alreadyContainsDrag) ?  root : tile.Drag.target

        if (mouseArea.parent !== root) {
            mouseArea.parent.alreadyContainsDrag = true
            mouseArea.parent.name = trackName
            mouseArea.parent.trackName = trackName
            mouseArea.parent.trackId = trackId
            tile.color = Universal.color(Universal.Cyan)
        }
    }

    mouseArea.onPressed: {
        if (mouseArea.parent !== root) {
            mouseArea.parent.alreadyContainsDrag = false
            mouseArea.parent.name = mouseArea.parent.defaultName
            mouseArea.parent.trackName = ""
            mouseArea.parent.trackId = -1
            mouseArea.parent.spikes = 0
            tile.color = "white"
        }
    }
    tile.states: State {
        when: mouseArea.drag.active
        ParentChange {
            target: tile
            parent: root
        }
        //for moving with mouse
        AnchorChanges {
            target: tile
            anchors.verticalCenter: undefined
            anchors.horizontalCenter: undefined
        }
    }
}
