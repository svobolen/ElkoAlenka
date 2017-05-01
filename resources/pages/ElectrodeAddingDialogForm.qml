import QtQuick 2.7
import QtQuick.Controls 2.1
import "../+universal"

Dialog {
    property alias addDialog: addDialog
    property alias rowSpinBox: rowSpinBox
    property alias columnSpinBox: columnSpinBox

    id: addDialog
    modal: true
    focus: true
    x: (window.width - width) / 2
    y: (window.height - height)/6
    title: qsTr("<b>Add new strip/grid</b>")
    standardButtons: Dialog.Ok | Dialog.Cancel

    Grid {
        id: dialogGrid
        columns: 2
        spacing: 20
        verticalItemAlignment: Grid.AlignVCenter

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
    }
}
