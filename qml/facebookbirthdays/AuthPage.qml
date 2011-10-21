import QtQuick 1.0
import com.nokia.symbian 1.0
import FBLibrary 1.0
import QtWebKit 1.0
import "js/storage.js" as Storage

Page {
    id: authPage

    property string accessToken

    signal loginPageLoaded()
    signal hasAccessToken(string accessToken)

    function isAccessTokenValid() {
        tokenChecker.url = "https://graph.facebook.com/me?access_token=" + accessToken
    }

    WebView {
        id: tokenChecker
        visible: false

        onLoadFinished: {
            if (html.toString().search("\"error\": {") < 0) {
                authPage.hasAccessToken(accessToken)
            } else {
                webView.url = qsTr("https://www.facebook.com/dialog/oauth?client_id=%1&redirect_uri=https://www.facebook.com/connect/login_success.html&display=popup&scope=%2&response_type=token").arg(constants.FACEBOOK_API_KEY).arg(constants.FACEBOOK_PERMISSIONS)
            }
        }
    }

    Constants {
        id: constants
    }

    Flickable {
        id: flickable
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.DragAndOvershootBounds
        anchors.fill: parent

        BusyIndicator {
            id: loader
            width: 60
            height: 60
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        WebView {
            id: webView
            anchors.fill: parent

            onLoadStarted: {
                webView.visible = false
                loader.running = true
                loader.visible = true
            }

            onLoadFinished: {

                // close splash screen
                if (url.toString().indexOf("https://www.facebook.com/login.php?", 0) == 0) {
                    authPage.loginPageLoaded()
                }

                // busy indicator
                webView.visible = true
                loader.running = false
                loader.visible = false

                // success scenario
                if (url.toString().indexOf("https://www.facebook.com/connect/login_success.html#access_token", 0) == 0) {

                    // parse the access token
                    var i1 = url.toString().indexOf("access_token=") + 13
                    var i2 = url.toString().indexOf("&expires_in")
                    accessToken = url.toString().slice(i1, i2)

                    // save the access token
                    Storage.setSetting("accessToken", accessToken)
                    console.log("accessToken: " + accessToken)
                    isAccessTokenValid()
                }
            }
        }
    }

    Component.onCompleted: {
        // initialize the database
        Storage.initialize();
        // if there is an access token, check if it's still valid
        accessToken = Storage.getSetting("accessToken")
        console.log("accessToken(from cache): " + accessToken)
        isAccessTokenValid()
    }
}
