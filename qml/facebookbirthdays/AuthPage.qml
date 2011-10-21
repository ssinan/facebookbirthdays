import QtQuick 1.0
import com.nokia.symbian 1.0
import FBLibrary 1.0
import QtWebKit 1.0
import "js/storage.js" as Storage

//https://www.facebook.com/dialog/oauth?client_id=375162172308&redirect_uri=https://www.facebook.com/connect/login_success.html&display=popup&scope=friends_birthday,friends_groups,offline_access&response_type=token

Page {
    id: mainPage

    Constants {
        id: constants
    }

    Flickable {
        id: flickable
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        boundsBehavior: Flickable.DragAndOvershootBounds
        anchors.fill: parent

        BusyIndicator {
            id: loader
            width: 60
            height: 60
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: loadingText
            anchors.top: loader.bottom
            anchors.horizontalCenter: loader.horizontalCenter
            text: "Loading Facebook login screen..."
            color: platformStyle.colorNormalLight
            font.pixelSize: 20
        }

        WebView {
            id: webView
            anchors.fill: parent
            url: qsTr("https://www.facebook.com/dialog/oauth?client_id=%1&redirect_uri=https://www.facebook.com/connect/login_success.html&display=popup&scope=%2&response_type=token").arg(constants.FACEBOOK_API_KEY).arg(constants.FACEBOOK_PERMISSIONS)

            onLoadStarted: {
                webView.visible = false
                loader.running = true
                loader.visible = true
            }

            onLoadFinished: {
                loadingText.visible = false
                webView.visible = true
                loader.running = false
                loader.visible = false
                if (webView.url.toString().indexOf("https://www.facebook.com/connect/login_success.html", 0) == 0) {
                    var i1 = webView.url.toString().indexOf("access_token=") + 13
                    var i2 = webView.url.toString().indexOf("&expires_in")
                    var access_token = webView.url.toString().slice(i1, i2)
                    console.log("access_token: " + access_token)
                }
            }
        }
    }

    Component.onCompleted: {
        // Initialize the database
        //Storage.initialize();
        // Sets a value in the database
        //Storage.setSetting("mySetting","myValue");
        // Sets the textDisplay element's text to the value we just set
        //textDisplay.text = "The value of mySetting is:\n" + Storage.getSetting("mySetting");
    }
}