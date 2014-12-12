// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1
import com.stars.widgets 1.0
import "../utility"
import "../utility/metro"
import "../utility/newsListPage"
import "../js/api.js" as Api

MyPage{
    id: root

    property bool isQuit: false
    //判断此次点击后退键是否应该退出
    signal refreshNewsList
    //发射信号刷新当前新闻列表

    function getNewsCategorysFinished(error, data){
        //当获取新闻种类结束后调用此函数
        if(error)//如果网络请求出错
            return

        data = JSON.parse(data)
        if(data.error==0){
            for(var i in data.categorys){
                metroView.addItem(data.titles[i], data.categorys[i])
            }
        }
    }

    tools: ToolBarSwitch{
        id: toolBarSwitch
        toolBarComponent: compoentToolBarLayout
    }

    Component{
        id: compoentToolBarLayout

        CustomToolBarLayout{
            invertedTheme: command.invertedTheme

            ToolButton{
                iconSource: "toolbar-back"
                platformInverted: command.invertedTheme
                onClicked: {
                    if(isQuit){
                        Qt.quit()
                    }else{
                        isQuit = true
                        main.showBanner(qsTr("Press again to exit"))
                        timerQuit.start()
                    }
                }
            }
            ToolButton{
                iconSource: command.getIconSource("skin", command.invertedTheme)
                onClicked: {
                    command.invertedTheme=!command.invertedTheme
                }
            }
            ToolButton{
                iconSource: "toolbar-search"
                platformInverted: command.invertedTheme
                onClicked: {
                    toolBarSwitch.toolBarComponent = compoentCommentToolBar
                    //搜索新闻
                }
            }

            ToolButton{
                iconSource: "toolbar-menu"
                platformInverted: command.invertedTheme
                onClicked: {
                    mainMenu.open()
                }
            }
        }
    }

    Component{
        id: compoentCommentToolBar

        CommentToolBar{
            invertedTheme: command.invertedTheme

            onLeftButtonClick: {
                textArea.closeSoftwareInputPanel()
                metroView.pageInteractive = true
                toolBarSwitch.toolBarComponent = compoentToolBarLayout
                if(metroView.getTitle(metroView.pageCount-1)==qsTr("Searched result")){
                    metroView.removePage(metroView.pageCount-1)
                    metroView.activation(0)
                }
            }
            onRightButtonClick: {
                if(metroView.getTitle(metroView.pageCount-1)==qsTr("Searched result")){
                    metroView.removePage(metroView.pageCount-1)
                }
                if(textAreaContent!=""){
                    metroView.addItem(qsTr("Searched result"), "", textAreaContent)
                    metroView.activation(metroView.pageCount-1)
                    metroView.pageInteractive = false
                    textArea.closeSoftwareInputPanel()
                }
            }
        }
    }

    HeaderView{
        id: headerView

        invertedTheme: command.invertedTheme
        height: screen.currentOrientation===Screen.Portrait?
                     privateStyle.tabBarHeightPortrait:privateStyle.tabBarHeightLandscape
    }

    Timer{
        //当第一次点击后退键时启动定时器，如果在定时器被触发时用户还未按下第二次后退键则将isQuit置为false
        id: timerQuit
        interval: 2000
        onTriggered: {
            isQuit = false
        }
    }

    MetroView{
        id: metroView
        anchors.fill: parent
        titleBarHeight: headerView.height
        titleSpacing: 25

        function addItem(title, category, keyword, order){
            var obj = {
                "articles": null,
                "covers": null,
                "listContentY": 0,
                "enableAnimation": true,
                "newsUrl": Api.getNewsUrlByCategory(category, keyword, order),
                "imagePosterUrl": keyword?"":Api.getPosterUrlByCategory(category)
            }
            addPage(title, obj)
        }

        delegate: NewsListPage{
            id: newsList

            width: metroView.width
            height: metroView.height-metroView.titleBarHeight

            Connections{
                target: root
                onRefreshNewsList:{
                    newsList.updateList()
                    //如果收到刷新列表的信号就重新获取新闻列表
                }
            }
        }

        Component.onCompleted: {
            metroView.addItem(qsTr("all news"))
            //先去获取全部新闻
            utility.httpGet(getNewsCategorysFinished, Api.newsCategorysUrl)
            //去获取新闻分类
        }
    }
    Connections{
        target: command
        onGetNews:{
            //如果某新闻标题被点击（需要阅读此新闻）
            pageStack.push(Qt.resolvedUrl("NewsContentPage.qml"),
                           {newsId: newsId, newsTitle: title})
        }
    }

    // define the menu
     Menu {
         id: mainMenu
         // define the items in the menu and corresponding actions
         platformInverted: command.invertedTheme
         content: MenuLayout {
             MenuItem {
                 text: qsTr("Personal Center")
                 platformInverted: command.invertedTheme
             }
             MenuItem {
                 text: qsTr("Settings")
                 platformInverted: command.invertedTheme
             }
             MenuItem {
                 text: qsTr("About")
                 platformInverted: command.invertedTheme
             }
         }
     }
}
