import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.1



ElectrodePlacementForm {

    resetButton.onClicked: {
        stackView.replace("qrc:/pages/ElectrodePlacement.qml", {"electrodes": electrodes, "images": window.images,"name": "Electrode Placement",
                              "maxSpikes": maxSpikes, "minSpikes": minSpikes} );
    }

    resetZoomButton.onClicked:   {
        imageArea.scale = 1;
        imageArea.x = 0;
        imageArea.y = 0;
    }

    statisticsButton.onClicked: {
        var i   = 0.1 * maxSpikes;
        var ii  = 0.3 * maxSpikes;
        var iii = 0.5 * maxSpikes;
        var iv  = 0.7 * maxSpikes;
        var v   = 0.9 * maxSpikes;
        var gradientColor;
        var currElec;
        for (var m = 0; m < electrodeRep.count; m++) {
            for (var j = 0; j < electrodeRep.itemAt(m).elec.children.length; j++) {
                currElec = electrodeRep.itemAt(m).elec.children[j].basicE;
                for (var k = 0; k < currElec.rowCount; k++) {
                    for (var l = 0; l < currElec.columnCount; l++) {
                        if(currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes !== 0) {
                            console.log("show spikes " + currElec.rowRep.itemAt(k).colRep.itemAt(l).trackName
                                        + " " + currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes);

                            if (currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes < i) {
                                gradientColor = "indigo";
                            } else if (currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes < ii) {
                                gradientColor = "blue";
                            } else if (currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes < iii) {
                                gradientColor = "green";
                            } else if (currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes < iv) {
                                gradientColor = "yellow";
                            } else if (currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes < v) {
                                gradientColor = "orange";
                            } else if (currElec.rowRep.itemAt(k).colRep.itemAt(l).spikes > v) {
                                gradientColor = "red";
                            }
                            currElec.rowRep.itemAt(k).colRep.itemAt(l).colorFill = gradientColor;
                        }
                    }
                }
            }
        }
    }

    gradientMouse.onPressAndHold: {
        colorGradientPopup.open();
    }

    comboBox.onCurrentIndexChanged: {
        changeNames(comboBox.currentIndex);
    }

    zoomSwitch.onCheckedChanged: {
        zoomEnabled = zoomSwitch.checked;
    }

    fixButton.onCheckedChanged: {
        var electrodeI;
        for (var i = 0; i < electrodeRep.count; i++) {
            for (var j = 0; j < electrodeRep.itemAt(i).elec.children.length; j++) {
                electrodeI = electrodeRep.itemAt(i).elec.children[j];
                electrodeI.draggable = !fixButton.checked;
                electrodeI.mouseArea.drag.target = (fixButton.checked) ? null : electrodeI.basicE;
            }
        }
    }

    function changeNames(comboBoxValue) {
        var currElec
        for (var i = 0; i < electrodeRep.count; i++) {
            for (var j = 0; j < electrodeRep.itemAt(i).elec.children.length; j++) {
                currElec = electrodeRep.itemAt(i).elec.children[j].basicE;
                for (var k = 0; k < currElec.rowCount; k++) {
                    for (var l = 0; l < currElec.columnCount; l++) {
                        switch (comboBoxValue) {
                        case 0: // only default name
                            currElec.rowRep.itemAt(k).colRep.itemAt(l).name = currElec.rowRep.itemAt(k).colRep.itemAt(l).defaultName;
                            break;
                        case 1: // only wave names (non-linked are empty)
                            currElec.rowRep.itemAt(k).colRep.itemAt(l).name = currElec.rowRep.itemAt(k).colRep.itemAt(l).trackName;
                            break;
                        default: // wave names, non-linked default name
                            currElec.rowRep.itemAt(k).colRep.itemAt(l).name =
                                    (currElec.rowRep.itemAt(k).colRep.itemAt(l).trackName === "") ?
                                        currElec.rowRep.itemAt(k).colRep.itemAt(l).defaultName : currElec.rowRep.itemAt(k).colRep.itemAt(l).trackName;
                            break;
                        }
                    }
                }
            }
        }
    }

    function confirm() {
        loader.sourceComponent = fileComp;
        window.showMaximized();
    }

    Component {
        id: fileComp

        FileDialog {
            id: fileDialog
            folder: shortcuts.desktop
            selectExisting: false
            nameFilters: [ "JPEG Image (*.jpg)", "PNG Image (*.png)", "Bitmap Image (*.bmp)", "All files (*)" ]
            onAccepted: {
                takeScreenshot((fileDialog.fileUrl + "").replace('file:///', ''));
                loader.sourceComponent = undefined
            }
            onRejected: {
                loader.sourceComponent = undefined;
                console.log("Saving file canceled.");
            }

            function takeScreenshot(filePath) {
                electrodePlacement.grabToImage(function(result) {
                    if (result.saveToFile(filePath)){
                        console.log("Screenshot has been saved to " + filePath);
                        dialog.open();
                    } else {
                        console.error('Unknown error saving to ',filePath);
                    }
                });
            }

            Component.onCompleted: open();
        }
    }

    Loader {
        id: loader
    }

    //    Component.onCompleted: {
    // musi se to prejmenovat potom vsude zpet
    //        window.confirmButton.text = "Save image"
    //    }
}
