import QtQuick 2.7
import QtQuick.Controls 2.1


ElectrodeSignalLinkForm {

    ListModel { id: linkedElectrodesList } //ListElement { rows: rowCount, columns: columnCount, links: links}

    function confirm() {

        readXml()
        fillLinkedElectrodesList()

        electrodePlacementMain.minSpikes = minSpikes
        electrodePlacementMain.maxSpikes = maxSpikes
        changePage(3, window.electrodePlacementMain)
    }

    function reset() {

        //reset link between electrodes and drag items
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

    function disconnectSignal(signalId) {
        dragRep.itemAt(signalId).resetPosition()
    }

    function fillLinkedElectrodesList() {

        //electrodes with link tracks to list
        linkedElectrodesList.clear()
        for (var i = 0; i < elecRep.count; i++) {
            linkedElectrodesList.append({ rows: elecRep.itemAt(i).bElectrode.rowCount, columns: elecRep.itemAt(i).bElectrode.columnCount,
                                            links: elecRep.itemAt(i).bElectrode.linkedTracks, eParent: "root", eX: 0, eY:0, eZ: 0, eScale: 1, eRotation: 0})
        }

        //check if electrode is not already placed in page Electrode Placement
        for (var j = 0; j < electrodePlacementMain.electrodes.count; j++) {
            checkInElectrodePlacement(j, electrodePlacementMain.electrodes.get(j))
        }
        electrodePlacementMain.electrodes.clear()

        //append electrodes that are not in the el. placement yet
        for (var l = 0; l < linkedElectrodesList.count; l++) {
            electrodePlacementMain.electrodes.append(linkedElectrodesList.get(l))
        }
    }

    function checkInElectrodePlacement(elementIndex, placedElectrode) {
        for (var k = 0; k < linkedElectrodesList.count; k++) {

            if (placedElectrode.rows === linkedElectrodesList.get(k).rows && placedElectrode.columns === linkedElectrodesList.get(k).columns) {

                if (linkedElectrodesList.get(k).links.count === placedElectrode.links.count) {

                    if (linkedTracksAreEqual(k, linkedElectrodesList.get(k).links, placedElectrode.links) === true) {
//                        electrodePlacementMain.electrodeRep.itemAt(elementIndex).elec.children[0].linkList = placedElectrode.links
                        linkedElectrodesList.setProperty(k, "eParent", placedElectrode.eParent)
                        linkedElectrodesList.setProperty(k, "eX", placedElectrode.eX)
                        linkedElectrodesList.setProperty(k, "eY", placedElectrode.eY)
                        linkedElectrodesList.setProperty(k, "eZ", placedElectrode.eZ)
                        linkedElectrodesList.setProperty(k, "eScale", placedElectrode.eScale)
                        linkedElectrodesList.setProperty(k, "eRotation", placedElectrode.eRotation)
                        return
                    }
                }
            }
        }
    }

//    function appendElectrodes() {
//        for ( var m = 0; m < elecRep.count; m++) {
//            if (electrodePlacementMain.electrodes.length <= m) return

////            if (elecRep.itemAt(m))
//        }
//    }

//    function compareListElement(listElementA, listElementB) {
//        if (listElementA.attributes.length !== listElementB.attributes.length) return false

////        for (var i = 0;listElementA.attributes.length)
//    }

    function linkedTracksAreEqual(linkListA, linkListB) {

        for (var l = 0; l < linkListA.count; l++) {

            if (linkListA.get(l).electrodeNumber !== linkListB.get(l).electrodeNumber ||
                    linkListA.get(l).wave !== linkListB.get(l).wave ) {
                return false
            }
        }
        return true
    }

    function readXml() {

        // set min, max to electrode placement
        // set spikes to linked tracks
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
//        console.log("Minimum is " + min + " spike(s).")
//        console.log("Maximum is " + max + " spikes.")
        minSpikes = min
        maxSpikes = max
    }
}
