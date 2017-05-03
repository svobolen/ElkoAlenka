import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls 2.1
import QtQuick.Controls.Universal 2.1
import "../+universal"

Controls.SplitView {
    id: electrodePlacement

    property alias zoomSwitch: zoomSwitch
    property alias fixButton: fixButton
    property alias resetZoomButton: resetZoomButton
//    property alias resetButton: resetButton
    property alias comboBox: comboBox
    property alias electrodeRep: electrodeRep
    property alias electrodePlacement: electrodePlacement
    property alias statisticsButton: statisticsButton
    property alias scrollIndicator: scrollIndicator
    property alias column: column
    property alias imageArea: imageArea
    property alias gradientMouse: gradientMouse
    property alias gradient: gradient
    property alias colorDialog: colorDialog

    property var name
    property int zHighest: 2
    property int currIndex: 1
    property bool zoomEnabled: false
    property var images: []
    property int minSpikes: 0
    property int maxSpikes: 0
    property int customMinSpikes: 0
    property int customMaxSpikes: 0
    property ListModel electrodes: ListModel {}

    orientation: Qt.Horizontal
    onCurrIndexChanged: {
        if (currIndex > 0) {
            imageArea.children[currIndex].z = ++zHighest    //clicked electrode on the top
        }
    }


    DropArea {
        id: imageArea
        Layout.minimumWidth: 3/4 * window.width

        Rectangle {
            anchors.fill: parent
            color: "white"
            height: window.height

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
        Layout.minimumWidth: 1/4 * window.width
        Layout.maximumWidth: 1/4 * window.width
        contentHeight: column.height
        contentWidth: 1/4 * window.width
        boundsBehavior: Flickable.OvershootBounds

        Rectangle {
            id: rect
            width: 1/4 * window.width
            height: Math.max(column.height, electrodePlacement.height)
            color: "white"

            Column {
                id: column
                spacing: 15
                padding: 20

                Button {
                    id: statisticsButton
                    text: qsTr("Show spikes statistics")
                }

                Item {
                    id: gradientItem
                    height: 20
                    width: 250
                    Rectangle {
                        width: 20
                        height: 250
                        x: 115
                        y: -110
                        clip: true
                        rotation: -90
                        gradient: Gradient {
                            id: gradient
                            GradientStop { position: 0.1 }
                            GradientStop { position: 0.3 }
                            GradientStop { position: 0.5 }
                            GradientStop { position: 0.7 }
                            GradientStop { position: 0.9 }
                        }

                        MouseArea  {
                            id: gradientMouse
                            anchors.fill: parent

                            ColorGradientSettingDialog {
                                id: colorDialog
                                visible: false
                            }
                        }
                    }
                }

                Row{
                    id: gradientLabels
                    width: 260
                    spacing: 10

                    Repeater {
                        model: [customMinSpikes,
                            0.25*(customMaxSpikes - customMinSpikes) + customMinSpikes,
                            0.5 * (customMaxSpikes - customMinSpikes) + customMinSpikes,
                            0.75 * (customMaxSpikes - customMinSpikes) + customMinSpikes,
                            customMaxSpikes]
                        Label {
                            text: Math.round(modelData)
                            width: 44
                            fontSizeMode: Text.Fit
                            horizontalAlignment:Text.AlignHCenter
                            minimumPixelSize: 10
                            font.pixelSize: 20
                        }
                    }


                }

                Switch {
                    id: zoomSwitch
                    text: qsTr("Enable zoom")
                    checked: false
                }

                Switch {
                    id: fixButton
                    text: qsTr("Fix electrodes")
                    checked: false
                }

//                Button {
//                    id: resetButton
//                    text: qsTr("Reset positions")
//                }

                Button {
                    id: resetZoomButton
                    text: qsTr("Reset zoom")
                }

                ComboBox {
                    id: comboBox
                    model: [qsTr("indexes"), qsTr("track names"), qsTr("indexes + tracks")]
                    currentIndex: 2
                    displayText: qsTr("Display: ") + currentText
                }

                Repeater {
                    id: electrodeRep

                    model: electrodes
                    delegate: Row {
                        id: elRow
                        property alias elec: elecItem
                        padding: 5
                        spacing: 5

                        Label {
                            text: rows + "x" + columns
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        RoundButton {
                            id: plusButton
                            text: "+"
                            height: 40
                            font.pixelSize: 40
                            highlighted: true
                            anchors.verticalCenter: parent.verticalCenter
                            onClicked: addNewElectrode()
                            function addNewElectrode() {
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
                                var temp = comboBox.y + comboBox.height + column.spacing + column.padding
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
        }

        ScrollIndicator.vertical: ScrollIndicator { id: scrollIndicator }
    }
}
