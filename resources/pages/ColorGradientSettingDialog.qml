import QtQuick 2.7
import QtQuick.Controls.Universal 2.1

ColorGradientSettingDialogForm {

    applyButton.onClicked: {
        electrodePlacement.setColors(gradient.stops[0].color, gradient.stops[1].color,
                                     gradient.stops[2].color, gradient.stops[3].color,
                                     gradient.stops[4].color)
        electrodePlacement.customMinSpikes = Math.round(minSpinBox.value)
        electrodePlacement.customMaxSpikes = Math.round(maxSpinBox.value)
        electrodePlacement.gradientParent.colorGradientChanged()
        setFooterButtons()
        stackView.pop()
        window.confirmButton.width = 300
    }

    cancelButton.onClicked: {
        for(var i = 0; i < tileRepeater.count; i++) {
            tileRepeater.itemAt(i).mouseArea.parent = tileRepeater.itemAt(i)
        }
        setColors(electrodePlacement.gradient.stops[0].color, electrodePlacement.gradient.stops[1].color, electrodePlacement.gradient.stops[2].color,
                  electrodePlacement.gradient.stops[3].color, electrodePlacement.gradient.stops[4].color)
        setFooterButtons()
        stackView.pop()
    }

    backButton.onClicked: {
        for(var i = 0; i < tileRepeater.count; i++) {
            tileRepeater.itemAt(i).mouseArea.parent = tileRepeater.itemAt(i)
        }
        setColors(electrodePlacement.gradient.stops[0].color, electrodePlacement.gradient.stops[1].color, electrodePlacement.gradient.stops[2].color,
                  electrodePlacement.gradient.stops[3].color, electrodePlacement.gradient.stops[4].color)
        setFooterButtons()
        stackView.pop()
    }

    function setColors(color1, color3, color5, color7, color9) {
        for (var i = 0; i < arguments.length; i++) {
            setColor(i, arguments[i])
        }
    }

    function setColor(gradientNum, color) {
        gradient.stops[gradientNum].color = color
    }

    Component.onCompleted: {
        setColors(Universal.color(Universal.Cobalt), Universal.color(Universal.Green),
                  Universal.color(Universal.Yellow), Universal.color(Universal.Orange),
                  Universal.color(Universal.Red))
    }

    function setFooterButtons() {
        window.confirmButton.enabled = true
        window.confirmButton.text = "Export image"
        window.resetButton.enabled = true
        window.resetButton.text = "X Clean"
        window.confirmButton.highlighted = false
    }

}
