// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import "../../js/api.js" as Api
import "../"
import "../customwidget"
import "../../utility"

MyPage{
    id: root

    property int newsId: -1

    tools: ToolBarSwitch{
        id: toolBarSwitch

        toolBarComponent: compoentToolBarLayout
    }

    HeaderView{
        id: header

        textColor: command.style.newsContentFontColor
        font.pixelSize: command.style.metroTitleFontPixelSize
        title: qsTr("Comment")
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    Component{
        id: compoentToolBarLayout

        MyToolBarLayout{
            invertedTheme: command.style.toolBarInverted

            ToolButton{
                iconSource: "toolbar-back"
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    pageStack.pop()
                }
            }

            ToolButton{
                iconSource: command.getIconSource(platformInverted, "edit")
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    toolBarSwitch.toolBarComponent = compoentCommentToolBar
                }
            }

            ToolButton{
                iconSource: "toolbar-refresh"
                platformInverted: command.style.toolBarInverted

                onClicked: {
                    commentList.refreshComment()
                }
            }

            ToolButton{
                iconSource: "toolbar-menu"
                platformInverted: command.style.toolBarInverted
                onClicked: {
                    //mainMenu.open()
                }
            }
        }
    }

    Component{
        id: compoentCommentToolBar

        TextAreaToolBar{
            property string oldText: ""
            //记录上次输入的内容

            invertedTheme: command.style.toolBarInverted

            onLeftButtonClick: {
                textArea.closeSoftwareInputPanel()
                toolBarSwitch.toolBarComponent = compoentToolBarLayout
            }
            onRightButtonClick: {
                if(textAreaContent=="")
                    return//如果内容没有变化或者为空则不进行下一步
            }
        }
    }


    CommentList{
        id: commentList

        width: parent.width-20
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: header.bottom
            topMargin: 10
            bottom: parent.bottom
        }
        newsId: root.newsId
    }

    ScrollBar {
        platformInverted: command.style.scrollBarInverted
        flickableItem: commentList.listView
        anchors {
            right: parent.right
            top: header.bottom
            bottom: parent.bottom
        }
    }

    BusyIndicator {
        id: busyIndicator

        running: visible
        visible: commentList.isBusy
        anchors.centerIn: parent
        width: 50
        height: 50
    }
}
