import QtQuick 2.7
import QtQuick.Controls 2.1
import "../+universal"

Popup {
    property alias addDialog: addDialog
    property alias okButton: okButton
    property alias cancelButton: closeButton
    property alias rowSpinBox: rowSpinBox
    property alias columnSpinBox: columnSpinBox

    id: addDialog
    modal: true
    focus: true
    x: (window.width - width) / 2
    y: (window.height - height)/6

    Grid {
        id: dialogGrid
        columns: 2
        spacing: 10
        verticalItemAlignment: Grid.AlignVCenter

        Label {
            text: qsTr("<b>Add new strip/grid</b>")
        }

        Label {
            text: " "
        }

        Label {
            text: qsTr("Rows")
        }

        SpinBox {
            id: rowSpinBox
            from: 1
            value: 1
        }

        Label {
            text: qsTr("Columns")
        }

        SpinBox {
            id: columnSpinBox
            from: 1
            value: 5
        }

        Button {
            id: okButton
            text: qsTr("Add")
            width: 150
        }

        Button {
            id: closeButton
            text: qsTr("Cancel")
            width: 150
        }
    }
}
