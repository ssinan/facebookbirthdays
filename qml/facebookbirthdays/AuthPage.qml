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
        //QTBUG-17405 - QML WebView should have access to the HTTP status code
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://graph.facebook.com/me?access_token=" + accessToken);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                console.log("isAccessTokenValid()::xhr: " + xhr.status)
                if (xhr.status != 200) {
                    // access token has expired, get a new one
                    webView.url = qsTr("https://www.facebook.com/dialog/oauth?client_id=%1&redirect_uri=https://www.facebook.com/connect/login_success.html&display=popup&scope=%2&response_type=token").arg(constants.FACEBOOK_API_KEY).arg(constants.FACEBOOK_PERMISSIONS)
                } else {
                    // we have a valid access token
                    authPage.hasAccessToken(accessToken)
                }
            }
        }
        xhr.send();
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

        Dialog {
            id: errorDialog

            buttons: [
                Button {
                    text: "Ok"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 10
                    onClicked: Qt.quit()
                }
            ]
            title: [
                Text {
                    text: "Error"
                }
            ]
            content: [
                Text {
                    text: "Internet connection error.<br/> Application will close."
                }
            ]
        }

        WebView {
            id: webView
            anchors.fill: parent

            onLoadFailed: {
                errorDialog.open()
            }

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
                    Storage.setSetting("access_token", accessToken)
                    console.log("accessToken: " + accessToken)

                    // we're done with authentication
                    authPage.hasAccessToken(accessToken)
                }
            }
        }
    }

    Component.onCompleted: {
        // initialize the database
        Storage.initialize();
        // if there is an access token, check if it's still valid
        accessToken = Storage.getSetting("access_token")
        console.log("accessToken(from cache): " + accessToken)
        isAccessTokenValid()
    }
}
