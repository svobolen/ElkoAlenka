import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
//import "../controls" as MyControls

Page {
    id: item
    property var name
    property alias resetButton: resetButton
    property alias addButton: addButton
    property alias stripRepeater: stripRep
    property alias gridRepeater: gridRep
    property alias stripModel: stripModel
    property alias gridModel: gridModel
    property alias tabBar: bar
    property alias infoPopup: infoPopup
    property alias addDialog: addDialog
    property ListModel chosenElectrodesList: ListModel {} //ListElement { columns: 0; rows: 0}

    header: TabBar {
        id: bar
        width: parent.width
        TabButton { text: qsTr("Strips") }
        TabButton { text: qsTr("Grids") }
    }

    StackLayout {
        id: stack
        width: parent.width
        height: parent.height
        y: header.height
        currentIndex: bar.currentIndex
        Flickable {
            contentHeight: stripColumn.height + 150
            contentWidth: stripColumn.width + 150
            boundsBehavior: Flickable.OvershootBounds

            Column {
                id: stripColumn
                spacing: 30
                padding: 20

                ListModel {
                    id: stripModel
                    ListElement { columns: 4 }
                    ListElement { columns: 5 }
                    ListElement { columns: 6 }
                    ListElement { columns: 7 }
                    ListElement { columns: 8 }
                    ListElement { columns: 9 }
                    ListElement { columns: 10 }
                }

                Repeater {
                    id: stripRep
                    model: stripModel
                    delegate: Row {
                        spacing: 20
                        property alias count: stripSpin.value
                        property alias stripColumns: strip.columnCount
                        SpinBox {
                            id: stripSpin
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Label {
                            text: strip.rowCount + "x" + strip.columnCount
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        BasicElectrode {
                            id: strip
                            columnCount: model.columns
                            rowCount: 1
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
            ScrollIndicator.horizontal: ScrollIndicator { }
        }

        Flickable {
            contentHeight: gridColumn.height + 150
            contentWidth: gridColumn.width + 150
            boundsBehavior: Flickable.OvershootBounds

            Column {
                id: gridColumn
                spacing: 30
                padding: 20

                ListModel {
                    id: gridModel
                    ListElement { columns: 4; rows: 4 }
                    ListElement { columns: 5; rows: 5 }
                    ListElement { columns: 6; rows: 5 }
                    ListElement { columns: 7; rows: 3 }
                    ListElement { columns: 8; rows: 5 }
                    ListElement { columns: 9; rows: 2 }
                    ListElement { columns: 10; rows: 3 }
                }

                Repeater {
                    id: gridRep
                    model: gridModel
                    delegate: Row {
                        spacing: 20
                        property alias count: gridSpin.value
                        property alias gridRows: grid.rowCount
                        property alias gridColumns: grid.columnCount
                        SpinBox {
                            id: gridSpin
                            value: 0
                            anchors.verticalCenter: parent.verticalCenter
                            editable: true
                        }
                        Label {
                            text: grid.rowCount + "x" + grid.columnCount
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        BasicElectrode {
                            id: grid
                            columnCount: model.columns
                            rowCount: model.rows
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
            ScrollIndicator.horizontal: ScrollIndicator { }
        }
    }

    Button {
        id: addButton
        text: qsTr("Add new electrode")
        font.pixelSize: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 15
    }

    Button {
        id: resetButton
        text: qsTr("Reset choice")
        anchors.top: addButton.bottom
        anchors.right: parent.right
        anchors.margins: 15
    }

    Popup {
        id: infoPopup
        modal: true
        focus: true
        x: (window.width - width) / 2
        y: (window.height - height) / 6
        Column{
            spacing: 10
            Label {
                text: qsTr("<b>Information</b>")
            }
            Label {
                text: qsTr("You didn't choose any electrode.")
            }
            Button {
                text: qsTr("OK")
                onClicked: { infoPopup.close() }
            }
        }
    }

    ElectrodeAddingDialog {
        id: addDialog
    }
}
