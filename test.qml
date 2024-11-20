import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// import org.julialang

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    x: 1000
    title: qsTr("Hello World")

    Column {
        anchors.fill: parent
        spacing: 2
        Repeater {
            model: 10
            Rectangle {
                width: parent.width
                height: 40
                radius: 4
                color: "white"
            }
        }
    }
}
