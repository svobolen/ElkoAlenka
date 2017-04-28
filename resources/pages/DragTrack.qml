import QtQuick 2.7

DragTrackForm {

    mouseArea.onReleased: {
        mouseArea.parent = (tile.Drag.target === null || tile.Drag.target.alreadyContainsDrag) ?  root : tile.Drag.target
        if (mouseArea.parent !== root) {
            mouseArea.parent.alreadyContainsDrag = true
            mouseArea.parent.name = trackName
            mouseArea.parent.trackName = trackName
            mouseArea.parent.trackId = trackId

            console.log("Track " + trackName + " has been linked to position " + mouseArea.parent.defaultName
                        + " on electrode " + mouseArea.parent.rowCount + "x" + mouseArea.parent.columnCount + ".")
        }
    }

    mouseArea.onPressed: {
        if (mouseArea.parent !== root) {
            mouseArea.parent.alreadyContainsDrag = false
            mouseArea.parent.name = mouseArea.parent.defaultName
            mouseArea.parent.trackName = ""
            mouseArea.parent.trackId = -1
            mouseArea.parent.spikes = 0
        }
    }
    tile.states: State {
        when: mouseArea.drag.active
        ParentChange {
            target: tile
            parent: root
        }
        //aby se to pohybovalo s mysi
        AnchorChanges {
            target: tile
            anchors.verticalCenter: undefined
            anchors.horizontalCenter: undefined
        }
    }
}
