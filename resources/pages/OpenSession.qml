import QtQuick 2.7
import QtQuick.XmlListModel 2.0

Item {
    property alias imageModel: imageModel
    property alias electrodesModel: electrodesModel
    property string sourcePath: "qrc:/xmls/session.xml"

    XmlListModel {
        id: imageModel
        source: sourcePath
        query: "/document/electrodePlacement/images/image"

        XmlRole { name: "source"; query: "@source/string()" }
    }

    XmlListModel {
        id: electrodesModel
        source: sourcePath
        query: "/document/electrodePlacement/electrodes/electrode"

        XmlRole { name: "rows"; query: "@rows/string()" }
        XmlRole { name: "columns"; query: "@columns/string()" }
        XmlRole { name: "links"; query: "links" }
    }
}
