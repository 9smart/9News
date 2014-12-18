// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item {

    property alias sliderText: sliderText.text
    property alias stepSize: sli.stepSize
    property alias minimumValue: sli.minimumValue
    property alias maximumValue: sli.maximumValue
    property alias value: sli.value
    property alias inverted: sli.inverted
    property alias textColor: sliderText.color
    property bool invertedTheme: command.style.sliderInverted

    width: parent.width
    height: sliderText.height+20

    Text{
        id:sliderText

        font.pixelSize: 22
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
    }
    Slider {
        id:sli

        anchors.left: sliderText.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.verticalCenter: sliderText.verticalCenter
        valueIndicatorVisible: true
    }
}
