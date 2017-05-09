import QtQuick 2.7
import QtQuick.Controls 2.1



ImageManagerForm {

    function getCheckedImages() {
        var sourceArray = []
        for (var k = 0; k < swipe.count; k++) {
            for (var i = 0; i < swipe.itemAt(k).images.count; i++) {
                if (swipe.itemAt(k).images.itemAt(i).checkbox.checked) {
                    sourceArray.push(swipe.itemAt(k).images.itemAt(i).source)
                }
            }
        }
        return sourceArray
    }

    function confirm() {

        // close opened dialogs
        for (var k = 0; k < swipe.count; k++) {
            for (var i = 0; i < swipe.itemAt(k).images.count; i++) {
                if(swipe.itemAt(k).images.itemAt(i).loader.sourceComponent !== undefined)
                    swipe.itemAt(k).images.itemAt(i).loader.sourceComponent = undefined
            }
        }


        var checkedImages = getCheckedImages()
        console.log("User chose " + checkedImages.length + " image(s): " + checkedImages.toString())
        window.images = checkedImages
        window.changePage(qsTr("Electrode Manager"), "qrc:/pages/ElectrodeManager.qml", 2)
    }

    function reset() {
        for (var k = 0; k < swipe.count; k++) {
            for (var i = 0; i < swipe.itemAt(k).images.count; i++) {
                swipe.itemAt(k).images.itemAt(i).checkbox.checked = false
            }
        }
    }
}
