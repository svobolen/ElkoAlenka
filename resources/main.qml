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

    property var images
    property string file: filePath
    property alias confirmButton: confirmButton
    property alias resetButton: resetButton
    property alias xmlModels: xmlModels

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

                    MenuItem {
                        text: qsTr("Close menu")
                        font.pixelSize: 30
                        width: parent.width
                        height: 100
                    }
                    MenuItem {
                        text: qsTr("Save session...")
                        font.pixelSize: 30
                        width: parent.width
                        height: 100
                        onTriggered: saveDialog.open()
                    }
                    MenuItem {
                        text: qsTr("Open session...")
                        font.pixelSize: 30
                        width: parent.width
                        height: 100
                        onTriggered: openDialog.open()
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
                        onTriggered: window.exit()
                    }
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
                text: qsTr("X Clean")
                font.pixelSize: 40
                implicitWidth: 200
                implicitHeight: parent.height
                anchors.left: parent.left
                onClicked: {
                    stackView.currentItem.reset()
                }
            }
            PageIndicator {
                id: pageIndicator
                count: listView.count
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
                onClicked: stackView.currentItem.confirm()
            }
        }
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
                text: model.title
                font.pixelSize: 30
                highlighted: ListView.isCurrentItem
                Universal.accent: Universal.Cyan

                onClicked: {
                    if (model.switchElement === true) {
                        window.switchToAlenka()
                        drawer.close()
                    }
                    else {
                        changePage(model.title, model.source, index)
                        drawer.close()
                    }
                }
            }
            model: pageModel
            ScrollIndicator.vertical: ScrollIndicator { }

            ListModel {
                id: pageModel
                ListElement { title: qsTr("Welcome page"); source: "" }
                ListElement { title: qsTr("Image Manager"); source: "qrc:/pages/ImageManager.qml" }
                ListElement { title: qsTr("Electrode Manager"); source: "qrc:/pages/ElectrodeManager.qml" }
                ListElement { title: qsTr("Link Signal with Electrode"); source: "qrc:/pages/ElectrodeSignalLink.qml"}
                ListElement { title: qsTr("Electrode Placement"); source: "qrc:/pages/ElectrodePlacement.qml" }
                ListElement { title: qsTr("Switch to Alenka"); switchElement: true }
            }
            onCurrentIndexChanged: {
                if (currentIndex == 4) {
                    confirmButton.text = qsTr("Export image")
                    confirmButton.width = 300
                    confirmButton.highlighted = false
                } else if (confirmButton.text !== qsTr("Next >")){
                    confirmButton.text = qsTr("Next >")
                    confirmButton.width = 200
                    confirmButton.highlighted = true
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
                changePage("Image Manager", "qrc:/pages/ImageManager.qml", 1)
            }

            function reset() { // do nothing
            }
        }

        replaceEnter: Transition {
            XAnimator {
                duration: 0
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

    Dialogs.FileDialog {
        id: saveDialog
        folder: shortcuts.documents
        selectExisting: false
        nameFilters: [ qsTr("All files (*)") ]
        onAccepted: {

        }
        onRejected: console.log("Saving file canceled.")
    }

    Dialogs.FileDialog {
        id: openDialog

        property ListModel electrodeList: ListModel {}

        nameFilters: [ "", qsTr("All files (*)") ]
        folder: shortcuts.documents
        onAccepted: {
            var path = openDialog.fileUrl
            openSessionPage.sourcePath = "qrc:/xmls/session.xml"
            listView.currentIndex = 3   //index v listview
            titleLabel.text = qsTr("Electrode Placement")

            var sourceArray = []
            for (var k = 0; k < openSessionPage.imageModel.count; k++) {
                sourceArray.push(openSessionPage.imageModel.get(k).source)
            }

            for (var l = 0; l < openSessionPage.electrodesModel.count; l++) {
                electrodeList.append({rows: openSessionPage.electrodesModel.get(l).rows,
                                         columns: openSessionPage.electrodesModel.get(l).columns,
                                         links: null})
            }

            stackView.push( "qrc:/pages/ElectrodePlacement.qml", {"electrodes": electrodeList, "images": sourceArray,
                               "name": qsTr("Electrode Placement"), "minSpikes": 0, "maxSpikes": 97} )
        }
        onRejected: console.log("Choosing file canceled.")
    }

    Pages.OpenSession {
        id: openSessionPage
    }

    Pages.XmlModels {
        id: xmlModels
        sourcePath: file
    }

    function changePage(title, source, indexNum) {
        if (listView.currentIndex !== indexNum) {

            listView.currentIndex = indexNum
            titleLabel.text = title

            var stackItem = stackView.find(function(item, index) { return  item.name === title})

            if (stackItem === null) {
                stackView.push(source, {"name": title})

            } else {
                if (title === qsTr("Welcome page")) {
                    stackView.push(stackView.initialItem)
                } else {
                    stackView.push(stackItem)
                }
            }
        }
    }
}
