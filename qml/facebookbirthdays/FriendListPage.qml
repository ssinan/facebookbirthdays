import QtQuick 1.0
import com.nokia.symbian 1.0
import FBLibrary 1.0
import QtWebKit 1.0
import "js/storage.js" as Storage

Page {
    id: friendListPage

    property string accessToken

    Component.onCompleted: {
        accessToken = Storage.getSetting("access_token")
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "https://graph.facebook.com/me/friends?access_token=" + accessToken);
        xhr.onreadystatechange = function() {
            if (xhr.readyState == XMLHttpRequest.DONE) {
                var a = JSON.parse(xhr.responseText);
                console.log("a: " + a.data[0].name)
                for (var b in a) {
                    var o = a[b];
                    //listmodel.append({name: o.name, url: o.url});
                }
            }
        }
        xhr.send();
    }
}
