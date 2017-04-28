import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Universal 2.1
import QtQuick.Window 2.2
import "./pages" as Pages

Page {
    id: window
    width: 1600
    height: 800

    visible: true
    title: "Elko"

    Universal.theme: Universal.Light
    Universal.accent: Universal.Cyan

    property var images
    property alias confirmButton: confirmButton
    property bool fullscreen: false

    header: ToolBar {
        height: 100

        background: Rectangle {
            color: "skyblue"
            opacity: 1
        }
        MouseArea {
            anchors.fill: parent
            onDoubleClicked: {
                if (fullscreen) {
                    window.showMaximized()
                } else {
                    window.showFullScreen()
                }
                fullscreen = !fullscreen
            }
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
                    font.pixelSize: 30
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: qsTr("Save session...")
                        onTriggered: saveDialog.open()
                    }
                    MenuItem {
                        text: qsTr("Open session...")
                        onTriggered: openDialog.open()
                    }
                    MenuItem {
                        text: qsTr("About")
                        onTriggered: aboutDialog.open()
                    }
                    MenuItem {
                        text: qsTr("Exit")
                        onTriggered: Qt.quit()
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

            Rectangle {
                width: parent.width
                height: 2
                anchors.bottom: parent.bottom
                color: "transparent"
                border.color: "skyblue"
            }
        }

        RowLayout {
            anchors.fill: parent
            ToolButton {
                id: backButton
                text: qsTr("< Back")
                font.pixelSize: 40
                implicitWidth: 200
                implicitHeight: parent.height
                anchors.left: parent.left
                onClicked: {
                    stackView.pop()
                    titleLabel.text = stackView.currentItem.name
                }
            }
            ToolButton {
                id: confirmButton
                text: qsTr("Next >")
                font.pixelSize: 40
                implicitWidth: 200
                implicitHeight: parent.height
                anchors.right: parent.right
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
                text: model.title
                font.pixelSize: 40
                highlighted: ListView.isCurrentItem

                onClicked: {
                    changePage(model.title, model.source, index)
                    drawer.close()
                }
            }
            model: pageModel
            ScrollIndicator.vertical: ScrollIndicator { }

            ListModel {
                id: pageModel
                ListElement { title: "Welcome page"; source: "" }
                ListElement { title: "Image Manager"; source: "qrc:/pages/ImageManager.qml" }
                ListElement { title: "Electrode Manager"; source: "qrc:/pages/ElectrodeManager.qml" }
                ListElement { title: "Link Signal with Electrode"; source: "qrc:/pages/ElectrodeSignalLink.qml"}
                ListElement { title: "Electrode Placement"; source: "qrc:/pages/ElectrodePlacement.qml" }
                ListElement { title: "Alenka"; source: "qrc:/pages/Alenka.qml" }
            }
        }
    }

    StackView {     //inicializace stacku, uvodni stranka
        id: stackView
        anchors.fill: parent

        initialItem: Pane {
            id: pane
            property string name: "Welcome page"
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
        }

        replaceEnter: Transition {
            XAnimator {
                duration: 0
            }
        }

        onDepthChanged: {
            backButton.enabled = (depth > 1)
        }
    }

    Popup {
        id: aboutDialog
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) * 3 / 7
        height: aboutColumn.implicitHeight + topPadding + bottomPadding

        Column {
            id: aboutColumn
            spacing: 20

            Label {
                text: qsTr("About")
                font.bold: true
            }
            Label {
                width: aboutDialog.availableWidth
                text: "Author:    Lenka Svobodová "
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {
                width: aboutDialog.availableWidth
                text: "E-mail:    svobole5@fel.cvut.cz "
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {
                width: aboutDialog.availableWidth
                text: "Year:      2017"
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Button {
                id: okButton
                text: "Ok"
                onClicked: aboutDialog.close()
            }
        }
    }

    FileDialog {
        id: saveDialog
        folder: shortcuts.documents
        selectExisting: false
        nameFilters: [ "All files (*)" ]
        onAccepted: {

        }
        onRejected: console.log("Saving file canceled.")
    }

    FileDialog {
        id: openDialog

        property ListModel electrodeList: ListModel {}

        nameFilters: [ "", "All files (*)" ]
        folder: shortcuts.documents
        onAccepted: {
            var path = openDialog.fileUrl
            openSessionPage.sourcePath = "qrc:/xmls/session.xml"
            listView.currentIndex = 3   //index v listview
            titleLabel.text = "Electrode Placement"

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
                               "name": "Electrode Placement", "minSpikes": 0, "maxSpikes": 97} )
        }
        onRejected: console.log("Choosing file canceled.")
    }

    Pages.OpenSession {
        id: openSessionPage
    }

    function changePage(title, source, indexNum) {
        if (listView.currentIndex !== indexNum) {

            listView.currentIndex = indexNum
            titleLabel.text = title

            var stackItem = stackView.find(function(item, index) { return  item.name === title})

            if (stackItem === null) {
                stackView.push(source, {"name": title})

            } else {
                if (title === "Welcome page") {
                    stackView.push(stackView.initialItem)
                } else {
                    stackView.push(stackItem)
                }
            }
        }
    }

//    Component.onCompleted: showMaximized()
}
