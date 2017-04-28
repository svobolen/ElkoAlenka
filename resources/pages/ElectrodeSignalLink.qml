import QtQuick 2.7


ElectrodeSignalLinkForm {

    ListModel { id: linkedElectrodesList } //ListElement { rows: rowCount, columns: columnCount, links: links}

    function confirm() {
        readXml()
        fillLinkedElectrodesList()
        titleLabel.text = "Electrode Placement"
        listView.currentIndex = 4
        stackView.push( "qrc:/pages/ElectrodePlacement.qml", {"electrodes": linkedElectrodesList, "images": window.images,"name": "Electrode Placement",
                           "minSpikes": minSpikes, "maxSpikes": maxSpikes} )
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

        for (var i = 0; i < xmlModels.trackModel.count; i++) {
            spikes = 0
            dragRep.itemAt(i).spikes = 0    //////////////
            for (var j = 0; j < xmlModels.eventModel.count; j++) {
                if (i == xmlModels.eventModel.get(j).channel) {
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

