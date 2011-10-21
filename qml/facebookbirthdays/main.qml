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
        // splash timer
        Timer {
            interval: 500; running: true; repeat: false
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("AuthPage.qml"))
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
                onClicked: pageStack.depth <= 3 ? Qt.quit() : pageStack.pop()
            }
        }
    }

    Component.onCompleted: {
        pageStack.push(Qt.resolvedUrl("SplashScreen.qml"))
    }
}
