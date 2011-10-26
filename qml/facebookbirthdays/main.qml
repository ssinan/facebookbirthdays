import QtQuick 1.0
import com.nokia.symbian 1.0

Window {
    id: window

    StatusBar {
        id: statusBar
        anchors.top: window.top
    }

    PageStack {
        id: pageStack
        anchors { left: parent.left; right: parent.right; top: statusBar.top; bottom: toolBar.bottom }
    }

    ToolBar {
        id: toolBar
        anchors.bottom: window.bottom
        visible: false
    }

    ToolBarLayout {
        id: toolBarLayout1
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
        }
    }

    ToolBarLayout {
        id: toolBarLayout2
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: pageStack.depth <= 1 ? Qt.quit() : pageStack.pop()
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-add"
        }
    }

    AuthPage {
        id: authPage

        onLoginPageLoaded: {
            pageStack.replace(authPage)
            toolBar.visible = true
            toolBar.tools = toolBarLayout1
            pageStack.anchors.top = statusBar.bottom
            pageStack.anchors.bottom = toolBar.top
        }

        onHasAccessToken: {
            pageStack.replace(friendListPage)
            friendListPage.activate()
            toolBar.visible = true
            toolBar.tools = toolBarLayout2
            pageStack.anchors.top = statusBar.bottom
            pageStack.anchors.bottom = toolBar.top
        }
    }

    SplashScreen {
        id: splashScreen
    }

    FriendListPage {
        id: friendListPage
    }

    Component.onCompleted: {
        pageStack.push(splashScreen)
    }
}
