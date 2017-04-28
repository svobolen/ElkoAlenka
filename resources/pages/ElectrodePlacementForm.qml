import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls 2.0


Controls.SplitView {
    id: electrodePlacement

    property alias zoomSwitch: zoomSwitch
    property alias fixButton: fixButton
    property alias resetButton: resetButton
    property alias resetZoomButton: resetZoomButton
    property alias comboBox: comboBox
    property alias electrodeRep: electrodeRep
    property alias electrodePlacement: electrodePlacement
    property alias statisticsButton: statisticsButton
    property alias scrollIndicator: scrollIndicator
    property alias column: column
    property alias imageArea: imageArea
    property alias gradientMouse: gradientMouse
    property alias colorGradientPopup: colorGradientPopup

    property var name
    property int zHighest: 2
    property int currIndex: 1
    property bool zoomEnabled: false
    property var images: []
    property int minSpikes: 0
    property int maxSpikes: 0
    property ListModel electrodes: ListModel {}
    orientation: Qt.Horizontal

    DropArea {
        id: imageArea
        width: 3/4*parent.width
        height: parent.height
        Layout.minimumWidth: 3/4*parent.width

        Rectangle {
            anchors.fill: parent
            color: "white"

            Grid {
                id: imagesGrid
                columns: images == null ? 0 : (images.length == 2 ? 2 : Math.round(images.length/2))
                rows: images == null ? 0 : ((images.length == 1 || images.length == 2)  ? 1 : 2)
                spacing: 5
                padding: 10
                Repeater {
                    model: images
                    Image {
                        id: brainImage
                        source: modelData
                        fillMode: Image.PreserveAspectFit
                        width: (imageArea.width-imagesGrid.spacing*(imagesGrid.columns+1))/imagesGrid.columns
                        height: (imageArea.height-imagesGrid.spacing*(imagesGrid.rows+1))/imagesGrid.rows
                        verticalAlignment: (index % 2 == 1) ? Image.AlignBottom : Image.AlignTop
                    }
                }
            }
            PinchArea {
                enabled: zoomEnabled
                anchors.fill: parent
                pinch.target: imageArea
                pinch.minimumScale: 1
                pinch.maximumScale: 10
                pinch.dragAxis: Pinch.XAndYAxis
                onSmartZoom: {
                    imageArea.scale = pinch.scale
                }
                MouseArea {
                    enabled: zoomEnabled
                    hoverEnabled: true
                    anchors.fill: parent
                    anchors.centerIn: parent
                    drag.target: imageArea
                    scrollGestureEnabled: false  // 2-finger-flick gesture should pass through to the Flickable
                    onWheel: {
                        imageArea.scale += imageArea.scale * wheel.angleDelta.y / 120 / 10;
                    }
                }
            }
        }
    }

    Flickable {
        id: flickPart
        Layout.minimumWidth: 1/4*electrodePlacement.width
        Layout.maximumWidth: 1/4*electrodePlacement.width
        contentHeight: column.height
        contentWidth: 1/4*electrodePlacement.width
        boundsBehavior: Flickable.OvershootBounds

        Rectangle {
            id: rect
            width: 1/4*electrodePlacement.width
            height: Math.max(column.height, electrodePlacement.height)
            Layout.minimumWidth: 100
            color: "white"

            Column {
                id: column
                spacing: 10
                padding: 5

                Switch {
                    id: zoomSwitch
                    text: qsTr("Image zoom")
                    checked: false
                }

                Switch {
                    id: fixButton
                    text: qsTr("Fix positions")
                    checked: false
                }

                ComboBox {
                    id: comboBox
                    model: ["indexes", "track names", "indexes + tracks"]
                    currentIndex: 2
                    displayText: "Display: " + currentText
                }

                Button {
                    id: statisticsButton
                    text: qsTr("Show spikes statistics")
                }

                Row {
                    id: resetRow
                    height: resetButton.height
                    spacing: 5
                    Button {
                        id: resetButton
                        text: qsTr("Reset")
                    }
                    Button {
                        id: resetZoomButton
                        text: qsTr("Reset zoom")
                    }
                }

                Item{
                    id: percentageGradLabels
                    height: 12
                    width: 230
                    Label {
                        x:18
                        text: "0"
                    }
                    Label {
                        x: 35
                        text: "0.1"
                    }
                    Label {
                        x:75
                        text: "0.3"
                    }
                    Label {
                        x: 115
                        text: "0.5"
                    }
                    Label {
                        x: 155
                        text: "0.7"
                    }
                    Label {
                        x: 195
                        text: "0.9"
                    }
                    Label {
                        x:218
                        text: "1"
                    }
                }

                Item {
                    id: gradient
                    height: 20
                    width: 250
                    Label {
                        x: 0
                        text: qsTr("min")
                    }
                    Rectangle {
                        width: 20
                        height: 200
                        x: 111
                        y: -90
                        clip: true
                        rotation: -90
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "indigo" }
                            GradientStop { position: 0.2; color: "blue"}
                            GradientStop { position: 0.4; color: "green"}
                            GradientStop { position: 0.6; color: "yellow"}
                            GradientStop { position: 0.8; color: "orange"}
                            GradientStop { position: 1.0; color: "red" }
                        }
                        MouseArea  {
                            id: gradientMouse
                            anchors.fill: parent
                        }

                    }

                    Label {
                        x: 223
                        text: qsTr("max")
                    }
                }

                Item{
                    id: gradientLabels
                    height: 20
                    width: 200
                    Label {
                        x:18
                        text: minSpikes
                    }
                    Label {
                        x: 35
                        text: Math.round(0.1*(maxSpikes - minSpikes))
                    }
                    Label {
                        x:75
                        text: Math.round(0.3*(maxSpikes - minSpikes))
                    }
                    Label {
                        x: 115
                        text: Math.round(0.5*(maxSpikes - minSpikes))
                    }
                    Label {
                        x: 155
                        text: Math.round(0.7*(maxSpikes - minSpikes))
                    }
                    Label {
                        x: 195
                        text: Math.round(0.9*(maxSpikes - minSpikes))
                    }
                    Label {
                        x:218
                        text: maxSpikes
                    }
                }

                Repeater {
                    id: electrodeRep

                    model: electrodes
                    delegate: Row {
                        id: elRow
                        property alias elec: elecItem
                        property int indexNum: index
                        padding: 5
                        spacing: 5

                        Label {
                            text: rows + "x" + columns
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Button {
                            id: plusButton
                            text: "+"
                            background: Rectangle {
                                implicitWidth: 20
                                implicitHeight: 20
                                color: plusButton.down ? "#d6d6d6" : "#f6f6f6"
                                border.color: "black"
                                border.width: 1
                                radius: 20
                            }
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: {
                                var component = Qt.createComponent("qrc:/pages/Electrode.qml")
                                var sameElec = component.createObject(elecItem, {"columnCount": columns, "rowCount": rows, "linkList": links,
                                                                          "color": elecItem.children[elecItem.children.length-1].basicE.color,
                                                                          "yPosition": elecItem.getYCoordinate(index)});
                                console.log("New view on electrode " + rows + "x" + columns + " added.")
                            }
                        }
                        Item {
                            id:elecItem
                            height: electrode.height
                            width: electrode.width
                            property string color: "white"
                            onColorChanged: {
                                for (var i = 0; i < children.length; i++) {
                                    children[i].color = color
                                }
                            }
                            function getYCoordinate(index) {
                                var temp = gradientLabels.y + gradientLabels.height + column.spacing + column.padding
                                if (index === 0) {
                                    return temp
                                }
                                for(var i = 1; i <= index; i++) {
                                    temp = temp + electrodeRep.itemAt(i-1).height + column.spacing
                                }
                                return temp
                            }

                            Electrode {
                                id: electrode
                                columnCount: columns
                                rowCount: rows
                                linkList: links
                                yPosition: elecItem.getYCoordinate(index)
                            }
                        }
                    }
                }
            }

            Popup {
                id: colorGradientPopup
                x: (window.width - width) / 2 - imageArea.width
                y: (window.height - height) / 6
                focus: true
                modal: true

                Column {
                    spacing: 10
                    Label {
                        text: qsTr("<b>Change colors</b>")
                    }
                    Item{
                        //  id: percentageGradLabels
                        height: 12
                        width: 230
                        Label {
                            x:18
                            text: "0"
                        }
                        Label {
                            x: 35
                            text: "0.1"
                        }
                        Label {
                            x:75
                            text: "0.3"
                        }
                        Label {
                            x: 115
                            text: "0.5"
                        }
                        Label {
                            x: 155
                            text: "0.7"
                        }
                        Label {
                            x: 195
                            text: "0.9"
                        }
                        Label {
                            x:218
                            text: "1"
                        }
                    }

                    Item {
                        //  id: gradient
                        height: 20
                        width: 300
                        Label {
                            x: 0
                            text: qsTr("min")
                        }
                        Rectangle {
                            width: 20
                            height: 240
                            x: 137
                            y: -110
                            clip: true
                            rotation: -90
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "indigo" }
                                GradientStop { position: 0.2; color: "blue"}
                                GradientStop { position: 0.4; color: "green"}
                                GradientStop { position: 0.6; color: "yellow"}
                                GradientStop { position: 0.8; color: "orange"}
                                GradientStop { position: 1.0; color: "red" }
                            }
                        }

                        Label {
                            x: 273
                            text: qsTr("max")
                        }
                    }

                    Item{
                        // id: gradientLabels
                        height: 20
                        width: 200
                        Label {
                            x:18
                            text: minSpikes
                        }
                        Label {
                            x: 35
                            text: Math.round(0.1*(maxSpikes - minSpikes))
                        }
                        Label {
                            x:75
                            text: Math.round(0.3*(maxSpikes - minSpikes))
                        }
                        Label {
                            x: 115
                            text: Math.round(0.5*(maxSpikes - minSpikes))
                        }
                        Label {
                            x: 155
                            text: Math.round(0.7*(maxSpikes - minSpikes))
                        }
                        Label {
                            x: 195
                            text: Math.round(0.9*(maxSpikes - minSpikes))
                        }
                        Label {
                            x:218
                            text: maxSpikes
                        }
                    }

                    Row {
                        spacing: 10
                        SpinBox {
                            from: 0
                            to: 9
                        }
                        ComboBox {
                            model: ["yellow", "red", "orange"]
                            currentIndex: 0
                            displayText: "Display: " + currentText
                        }
                    }
                    Row {
                        spacing: 100
                        Button {
                            text: qsTr("OK")
                        }
                        Button {
                            text: qsTr("Cancel")
                            onClicked: { colorGradientPopup.close() }
                        }
                    }
                }

            }
        }

        ScrollIndicator.vertical: ScrollIndicator { id: scrollIndicator }
    }
    onCurrIndexChanged: {
        if (currIndex > 0) {
            imageArea.children[currIndex].z = ++zHighest
        }
    }
}
