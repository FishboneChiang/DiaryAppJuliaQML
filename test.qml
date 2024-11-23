import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow {
    visible: true
    width: 320
    height: 240
    title: qsTr("Custom Dialog")

    Dialog {
        id: customDialog
        title: "Custom Dialog in QML/Qt 5.3"
    }
}