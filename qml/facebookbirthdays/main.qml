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
        anchors { left: parent.left; right: parent.right; top: statusBar.bottom; bottom: toolBar.top }
        Timer {
            interval: 2000; running: true; repeat: false
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("MainPage.qml"))
                toolBar.visible = true
            }
        }
    }

    ToolBar {
        id: toolBar
        anchors.bottom: window.bottom
        visible: false
        tools: ToolBarLayout {
            id: toolBarLayout
            ToolButton {
                flat: true
                iconSource: "toolbar-back"
                onClicked: pageStack.depth <= 2 ? Qt.quit() : pageStack.pop()
            }
        }
    }

    Component.onCompleted: {
        pageStack.push(Qt.resolvedUrl("SplashScreen.qml"))
    }
}
