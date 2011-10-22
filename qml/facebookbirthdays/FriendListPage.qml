import QtQuick 1.0
import com.nokia.symbian 1.0
import FBLibrary 1.0
import QtWebKit 1.0
import "js/storage.js" as Storage

Page {
    id: friendListPage

    property string accessToken

    function activate() {
        accessToken = Storage.getSetting("access_token")
        loader.running = true
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://graph.facebook.com/me/friends?access_token=" + accessToken);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                var r = JSON.parse(xhr.responseText);
                for (var i in r.data) {
                    var o = r.data[i]
                    listModel.append({"name": o.name, "id": o.id});
                }
                loader.running = false
                loader.visible = false
                loadingText.visible = false
            }
        }
        xhr.send();
    }

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
        text: "Loading friends list..."
        color: platformStyle.colorNormalLight
        font.pixelSize: 20
    }

    ListModel {
        id: listModel
    }

    Component {
        id: listDelegate

        Text {
            text: name + ", " + id
            color: platformStyle.colorNormalLight
            font.pixelSize: 20
        }
    }

    ListView {
        anchors.fill: parent
        model: listModel
        delegate: listDelegate
        clip: true
    }
}
