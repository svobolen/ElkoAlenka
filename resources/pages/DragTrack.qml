import QtQuick 2.7
import QtQuick.Controls.Universal 2.1

DragTrackForm {

    mouseArea.onReleased: {
        mouseArea.parent = (tile.Drag.target === null || tile.Drag.target.alreadyContainsDrag) ?  root : tile.Drag.target
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

    mouseArea.onParentChanged: {
        if (mouseArea.parent !== root && mouseArea.parent != null) {
            mouseArea.parent.alreadyContainsDrag = true
            mouseArea.parent.name = trackName
            mouseArea.parent.trackName = trackName
            mouseArea.parent.trackId = trackId
            tile.color = Universal.color(Universal.Cyan)
        }
    }

    function resetPosition() {
        mouseArea.parent = root
        tile.color = "white"
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
