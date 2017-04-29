import QtQuick 2.7
import QtQuick.XmlListModel 2.0

Item {
    id: xmlModels

    property alias trackModel: trackModel
    property alias eventModel: eventModel
    property string sourcePath
    XmlListModel {
        id: trackModel
        source: sourcePath
        query: "/document/montageTable/montage/trackTable/track"

        XmlRole { name: "label"; query: "@label/string()" }
    }

    XmlListModel {
        id: eventModel
        source: sourcePath
        query: "/document/montageTable/montage/eventTable/event"

        XmlRole { name: "channel"; query: "@channel/string()" }
        XmlRole { name: "label"; query: "@label/string()" }
    }
}
