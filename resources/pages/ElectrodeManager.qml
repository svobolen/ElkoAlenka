import QtQuick 2.7
import QtQuick.Controls 2.1

ElectrodeManagerForm {

    addButton.onClicked: {
        addDialog.open()
    }

    function confirm() {
        var chosenElecs = getChosenElectrodes()
        if (chosenElecs.count === 0) {
            infoPopup.open()
            console.log("User did not choose any electrode.")
        } else {
            window.signalLinkMain.electrodes = chosenElecs
            window.signalLinkMain.setPreviousState()
            window.changePage(2, window.signalLinkMain)
        }
    }

    function reset() {
        // reset strips choice
        for (var i = 0; i < stripRepeater.count; i++) {
            stripRepeater.itemAt(i).count = 0
        }
        //reset grids choice
        for (var j = 0; j < gridRepeater.count; j++) {
            gridRepeater.itemAt(j).count = 0
        }
        console.log("Choice of electrodes has been reset.")
    }

    function getChosenElectrodes() {
        console.log("User chose following electrodes: ")
        chosenElectrodesList.clear()

        for (var i = 0; i < stripRepeater.count; i++) {
            if (stripRepeater.itemAt(i).count !== 0) {
                for (var k = 0; k < stripRepeater.itemAt(i).count; k++) {
                    chosenElectrodesList.append({ columns: stripRepeater.itemAt(i).stripColumns, rows: 1 })
                }
                console.log(stripRepeater.itemAt(i).count + "x strip 1x" + stripRepeater.itemAt(i).stripColumns)
            }
        }
        for (var j = 0; j < gridRepeater.count; j++) {
            if (gridRepeater.itemAt(j).count !== 0) {
                for (var l = 0; l < gridRepeater.itemAt(j).count; l++) {
                    chosenElectrodesList.append({ columns: gridRepeater.itemAt(j).gridColumns, rows: gridRepeater.itemAt(j).gridRows })
                }
                console.log(gridRepeater.itemAt(j).count + "x grid " + gridRepeater.itemAt(j).gridRows + "x" + gridRepeater.itemAt(j).gridColumns)
            }
        }

        return chosenElectrodesList
    }
}


