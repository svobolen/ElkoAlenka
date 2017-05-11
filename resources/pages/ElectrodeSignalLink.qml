import QtQuick 2.7
import QtQuick.Controls 2.1


ElectrodeSignalLinkForm {

    ListModel { id: linkedElectrodesList } //ListElement { rows: rowCount, columns: columnCount, links: links}

    function confirm() {
        readXml()
        fillLinkedElectrodesList()

        window.electrodePlacementMain.electrodes = linkedElectrodesList
        window.electrodePlacementMain.minSpikes = minSpikes
        window.electrodePlacementMain.maxSpikes = maxSpikes
        changePage(3, window.electrodePlacementMain)
    }

    function reset() {
        for (var i = 0; i < dragRep.count; i++) {

            if(dragRep.itemAt(i).mouseArea.parent !== dragRep.itemAt(i).root) {

                dragRep.itemAt(i).mouseArea.parent.alreadyContainsDrag = false
                dragRep.itemAt(i).mouseArea.parent.name = dragRep.itemAt(i).mouseArea.parent.defaultName
                dragRep.itemAt(i).mouseArea.parent.trackName = ""
                dragRep.itemAt(i).mouseArea.parent.trackId = -1
                dragRep.itemAt(i).mouseArea.parent.spikes = 0
                dragRep.itemAt(i).tile.color = "white"
                dragRep.itemAt(i).mouseArea.parent = dragRep.itemAt(i).root
            }
        }
    }

    function setPreviousState() {
        reset()

        for (var i = 0; i < dragRep.count; i++) {

            var dragItem = dragRep.itemAt(i)

            for(var j = 0; j < elecRep.count; j++) {

                if (elecRep.itemAt(j).bElectrode.rowCount === dragItem.electrodeType[0]) {

                    if (elecRep.itemAt(j).bElectrode.columnCount === dragItem.electrodeType[1]) {

                        dragItem.mouseArea.parent = elecRep.itemAt(j).bElectrode.rowRep.itemAt(dragItem.electrodePosition[0]).colRep.itemAt(dragItem.electrodePosition[1])
                        break
                    }
                }
            }
        }
    }

    function fillLinkedElectrodesList() {
        linkedElectrodesList.clear()
        for (var i = 0; i < elecRep.count; i++) {
            linkedElectrodesList.append({ rows: elecRep.itemAt(i).bElectrode.rowCount, columns: elecRep.itemAt(i).bElectrode.columnCount,
                                            links: elecRep.itemAt(i).bElectrode.linkedTracks})
        }
        return linkedElectrodesList
    }

    function readXml() {
        var spikes = 0
        var min = 0
        var max = 0

        for (var i = 0; i < window.xmlModels.trackModel.count; i++) {
            spikes = 0
            dragRep.itemAt(i).spikes = 0    //////////////
            for (var j = 0; j < window.xmlModels.eventModel.count; j++) {
                if (i == window.xmlModels.eventModel.get(j).channel) {
                    spikes++
                }
            }
            if (spikes > max){
                max = spikes
            } else if (spikes <= min) {
                min = spikes
            }

            dragRep.itemAt(i).spikes = spikes
            //            console.log(xmlModels.trackModel.get(i).label.replace(/\s+/g, '') + " (" + i + ") has " + spikes + " spike(s).")
        }
        console.log("Minimum is " + min + " spike(s).")
        console.log("Maximum is " + max + " spikes.")
        minSpikes = min
        maxSpikes = max
    }
}

