import QtQuick 1.0
import com.nokia.symbian 1.0
import "js/storage.js" as Storage

Page {
    id: mainPage
    Text {
        id: textDisplay
        anchors.centerIn: parent
        text: qsTr("Hello world!")
        color: platformStyle.colorNormalLight
        font.pixelSize: 20
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
