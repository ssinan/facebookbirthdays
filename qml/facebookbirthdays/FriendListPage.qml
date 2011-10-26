import QtQuick 1.0
import com.nokia.symbian 1.0
import FBLibrary 1.0
import QtWebKit 1.0
import "js/storage.js" as Storage
import QtMobility.organizer 1.1

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
                var r = JSON.parse(xhr.responseText)
                var xhrList = new Array(r.data.length)
                var reqDone = new Array(r.data.length)
                for (var j in r.data) {
                    reqDone[j] = false
                }
                for (var i in r.data) {
                    var o = r.data[i]
                    // get each individual contact's info from facebook
                    xhrList[i] = new XMLHttpRequest
                    xhrList[i].open("GET", "https://graph.facebook.com/" + o.id + "?access_token=" + accessToken)
                    xhrList[i].onreadystatechange = function() {
                        for (var x=0; x<i; x++) {
                            if (!reqDone[x]) {
                                if (xhrList[x].readyState == XMLHttpRequest.DONE) {
                                    var d = JSON.parse(xhrList[x].responseText)
                                    if (typeof d.birthday != 'undefined') {
                                        listModel.append({"fullname": d.name, "birthday": d.birthday})
                                    }
                                    reqDone[x] = true
                                    // should dismiss busy indicator after the whole list is done?
                                    loader.running = false
                                    loader.visible = false
                                    loadingText.visible = false
                                }
                            }
                        }
                    }
                    xhrList[i].send()
                }
            }
        }
        xhr.send();
    }

    function formatBdayDatetime(bday) {
        var month = bday.slice(0,2)
        var day = bday.slice(3,5)
        return "2011-" + month + "-" + day
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

        Item {
            width: parent.parent.width
            height: checkBox.height + 15

            Rectangle {
                id: selectedRect
                visible: false
                color: "white"
                opacity: 0.5
                anchors.fill: parent
            }
            BirthdayImporter {
                id: birthdayImporter
                name: fullname
                date: formatBdayDatetime(birthday)
            }
            CheckBox {
                id: checkBox
                anchors.left: parent.left
                text: "<b>" + fullname + "</b><br/>" + birthday
                anchors.top: parent.top
                anchors.topMargin: 5
            }
            Rectangle {
                width: parent.width
                height: 1
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "white"
            }
        }
    }

    ListView {
        id: friendList
        anchors.fill: parent
        model: listModel
        delegate: listDelegate
        clip: true
    }

    ScrollBar {
        flickableItem: friendList
        orientation: Qt.Vertical
        anchors.right: parent.right
    }
}
