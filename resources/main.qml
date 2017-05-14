import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.2 as Dialogs
import QtQuick.Controls.Universal 2.1
import "./pages" as Pages
import "./+universal"

Page {
    id: window
    width: 1600
    height: 800

    visible: true
    title: "Elko"

    Universal.theme: Universal.Light
    Universal.accent: Universal.Cyan

    signal switchToAlenka()
    signal exit()
    signal saveSession(string images, var minMax, string electrodes)
    signal saving()
    signal exportDialog()

    property string file: filePath
    //    property bool fileUpdated: filePathUpdated

    property alias confirmButton: confirmButton
    property alias resetButton: resetButton
    property alias xmlModels: xmlModels
    property alias imageManagerMain: imageManagerMain
    property alias electrodeManagerMain: electrodeManagerMain
    property alias signalLinkMain: electrodeSignalLinkMain
    property alias electrodePlacementMain: electrodePlacementMain

    function changePage(pageIndex, page) {
        listView.currentIndex = pageIndex
        titleLabel.text = page.name
        stackView.replace(page)
        page.enabled = true
        page.visible = true
    }

    function loadSession(images, minMax, electrodes) {
//        console.log(electrodes.length)
        // ({ rows: 1, columns: 1, links: listmodel, eParent: "root", eX: 0, eY:0, eZ: 0, eScale: 1, eRotation: 0})

        for (var i = 0; i < electrodes.length; i++) {
            var JsonString = electrodes[i]
            var JsonObject= JSON.parse(JsonString);

            //retrieve values from JSON again
            var aString = JsonObject.rows;
            var bString = JsonObject.columns;
            var eparent = JsonObject.eParent;
            var ex = JsonObject.eX
            var ey = JsonObject.eY
            var ez = JsonObject.eZ
            var escale = JsonObject.eScale
            var eRotation = JsonObject.eRotation
            var spikes = JsonObject.links

//            console.log(aString);
//            console.log(bString);
//            console.log(eparent)
//            console.log(ex)
//            console.log(ey)
//            console.log(ez)
//            console.log(escale)
//            console.log(eRotation)
//            console.log(spikes)
//            console.log("")
        }
    }

    function setDataForSave() {
        var electrodesData = []
        for (var i = 0; i < electrodePlacementMain.electrodes.count; i++) {
            electrodesData[i] = JSON.stringify(electrodePlacementMain.electrodes.get(i))
        }
        return electrodesData
    }

    function takeScreenshot(filePath) {
        electrodePlacementMain.grabToImage(function(result) {
            if (result.saveToFile(filePath)){
                console.log("Screenshot has been saved to " + filePath);
                dialog.open();
            } else {
                console.error('Unknown error saving to ', filePath);
            }
        });
    }

    header: ToolBar {
        height: 100

        background: Rectangle {
            color: Universal.accent
            opacity: 1
        }

        RowLayout {
            anchors.fill: parent

            ToolButton {
                implicitHeight: parent.height
                implicitWidth: 100

                contentItem: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        anchors.margins: 25
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        source: "qrc:/images/drawer@4x.png"
                    }
                }
                onClicked: drawer.open()
            }

            Label {
                id: titleLabel
                text: "Elko"
                font.pixelSize: 30
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                implicitHeight: parent.height
                implicitWidth: 100

                contentItem: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Image {
                        anchors.fill: parent
                        anchors.margins: 25
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        source: "qrc:/images/menu@4x.png"
                    }
                }
                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    width: window.width / 4
                    font.pixelSize: 30
                    transformOrigin: Menu.TopRight

                    onOpened: menuTimer.start()
                    onClosed: menuTimer.stop()

                    MenuItem {
                        text: qsTr("Close menu")
                        font.pixelSize: 30
                        width: parent.width
                        height: 100
                    }
                    MenuItem {
                        text: qsTr("About")
                        font.pixelSize: 30
                        width: parent.width
                        height: 100
                        onTriggered: aboutDialog.open()
                    }
                    MenuItem {
                        text: qsTr("Exit")
                        font.pixelSize: 30
                        width: parent.width
                        height: 100
                        onTriggered: {

                            window.saveSession(electrodePlacementMain.images, [electrodePlacementMain.minSpikes, electrodePlacementMain.maxSpikes,
                                                                               electrodePlacementMain.customMinSpikes, electrodePlacementMain.customMaxSpikes], setDataForSave())

                            window.loadSession(electrodePlacementMain.images, [electrodePlacementMain.minSpikes, electrodePlacementMain.maxSpikes,
                                                                               electrodePlacementMain.customMinSpikes, electrodePlacementMain.customMaxSpikes], setDataForSave())
//                            window.exit()
                        }
                    }
                }
                Timer {
                    id: menuTimer
                    interval: 5000
                    onTriggered: optionsMenu.close()
                }
            }
        }
    }

    footer: ToolBar {
        height: 80
        background: Rectangle {
            implicitHeight: 100
            color: "white"
        }

        RowLayout {
            anchors.fill: parent
            spacing: 100
            ToolButton {
                id: resetButton
                text: qsTr("Reset")
                font.pixelSize: 40
                implicitWidth: 200
                implicitHeight: parent.height
                anchors.left: parent.left
                onClicked: {
                    reallyDialog.open()
                }
            }

            PageIndicator {
                id: pageIndicator
                count: listView.count - 1
                currentIndex: listView.currentIndex
                anchors {horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter}
                spacing: 15
                delegate: Rectangle {
                    implicitWidth: 30
                    implicitHeight: 10

                    radius: width / 2
                    color: index === pageIndicator.currentIndex ? Universal.color(Universal.Cyan)  : pageIndicator.Universal.baseLowColor
                }

            }

            ToolButton {
                id: confirmButton
                text: qsTr("Next >")
                font.pixelSize: 40
                implicitWidth: 200
                implicitHeight: parent.height
                anchors.right: parent.right
                highlighted: true
                onClicked: {
                    enabled = false
                    stackView.currentItem.confirm()
                    enabled = true
                }
            }
        }
    }

    BusyIndicator {
        running: confirmButton.enabled === false
    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 1.5
        height: window.height

        ListView {
            id: listView
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate {
                id: control
                width: parent.width
                height: 120
                text: modelData.name
                font.pixelSize: 30
                highlighted: ListView.isCurrentItem
                Universal.accent: Universal.Cyan

                onClicked: {
                    if (modelData.switchElement === true) {
                        window.switchToAlenka()

                    } else if (listView.currentIndex != index){
                        changePage(index, modelData)
                    }

                    drawer.close()
                }
            }
            model: [ imageManagerMain, electrodeManagerMain, electrodeSignalLinkMain, electrodePlacementMain, alenka ]
            ScrollIndicator.vertical: ScrollIndicator { }

            onCurrentIndexChanged: {
                if (currentIndex == 3) {
                    confirmButton.text = qsTr("Export image")
                    confirmButton.width = 300
                } else if (confirmButton.text !== qsTr("Next >")){
                    confirmButton.text = qsTr("Next >")
                    confirmButton.width = 200
                }
            }
        }
    }

    StackView {     //inicializace stacku, uvodni stranka
        id: stackView
        anchors.fill: parent

        initialItem: Pane {
            id: pane
            property string name: qsTr("Welcome page")
            Image {
                source: "qrc:/images/Doctor_Hibbert.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.centerIn: parent;
            }

            PinchArea {
                anchors.fill: parent
                pinch.target: pane
                pinch.minimumScale: 1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                onSmartZoom: pane.scale = pinch.scale
                onPinchFinished: {
                    pane.scale = 1
                    pane.x = 0
                    pane.y = 0
                }
            }

            function confirm() {
                changePage(0, imageManagerMain)
            }

            function reset() { // do nothing
            }
        }
    }

    Dialog {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        standardButtons: Dialog.Ok

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                text: qsTr("About")
                font.bold: true
            }
            Label {
                text: qsTr("Author:   Lenka Svobodová ")
            }
            Label {
                text: qsTr("E-mail:   svobole5@fel.cvut.cz ")
            }
            Label {
                text: qsTr("Year:     2017")
            }
        }
    }

    Dialog {
        id: reallyDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        title: "<b>Are you sure?</b>"
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: stackView.currentItem.reset()

        Label {
            text: qsTr("Page will be reset to default state.")
        }
    }

    Dialogs.FileDialog {
        id: saveDialog
        folder: shortcuts.documents
        selectExisting: false
        nameFilters: [ qsTr("All files (*)") ]
        onAccepted: {

        }
        onRejected: console.log("Saving file canceled.")
    }

    Pages.XmlModels {
        id: xmlModels
        sourcePath: file
    }
    //    onFileUpdatedChanged: {
    //        console.log(fileUpdated)
    //        if (fileUpdated) {
    //            xmlModels.sourcePath = file
    //        }
    //        fileUpdated = false
    //    }

    Pages.ImageManager { id: imageManagerMain; enabled: false; visible: false }

    Pages.ElectrodeManager {id: electrodeManagerMain; enabled: false; visible: false }

    Pages.ElectrodeSignalLink {id: electrodeSignalLinkMain; enabled: false; visible: false }

    Pages.ElectrodePlacement {id: electrodePlacementMain; enabled: false; visible: false }

    Item { id: alenka; property string name: qsTr("Switch to Alenka"); property bool switchElement: true }
}
