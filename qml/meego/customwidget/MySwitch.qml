// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1

Item{
    property string switch_text:""
    property alias checked: off_on.checked
    property alias textColor: switchText.color
    property bool invertedTheme: command.style.switchInverted!=true

    signal trigger(bool checked)

    width: parent.width
    height: off_on.height

    Text{
        id:switchText
        text:switch_text
        font.pixelSize: 22
        anchors.left: parent.left
        height:off_on.height
        verticalAlignment: Text.AlignVCenter
        color: invertedTheme?"#000":"#ccc"
    }

    Switch {
        id:off_on

        anchors.top: switchText.top
        anchors.right: parent.right
        onCheckedChanged:{
            trigger(checked)
        }

        platformStyle: SwitchStyle{
            inverted: invertedTheme
        }
    }
}
