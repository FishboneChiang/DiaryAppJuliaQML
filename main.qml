import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// import org.julialang

Window {

    visible: true
    width: 800
    height: 480
    title: "Diary App"
    x: 1000
    y: 250
    color: "#222222"
    
    // Define custom components
    component CustomButton:
    Button {
        background: Rectangle {
            color: parent.down ? "#444444" : "#555555"
            radius: 4
        }
    }
    component CustomTextField:
    TextField {
        background: Rectangle {
            radius: 3
            color: "#444444"
            border.color: "#555555"
            border.width: 1
        }
    }
    component CustomTextArea:
    TextArea {
        background: Rectangle {
            radius: 3
            color: "#444444"
            border.color: "#555555"
            border.width: 1
        }
    }

    SplitView {

        anchors.fill: parent
        orientation: Qt.Horizontal
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10

        // LEFT SECTION
        Rectangle {

            SplitView.preferredWidth: parent.width / 2
            SplitView.fillHeight: true
            radius: 10
            color: "#333333"

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                RowLayout {
                    anchors.fill: parent
                    Text {
                        Layout.fillWidth: true
                        text: "My Diary 📔"
                        font.pixelSize: 24
                        color: "#ffffff"
                    }
                    CustomButton {
                        text: "Settings"
                        Layout.fillWidth: true
                    }
                }

                CustomButton {
                    text: "New Entry"
                    Layout.fillWidth: true
                    onClicked: {
                        stack_layout.currentIndex = 1
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#444444"
                    Text {
                        text: "Implement list view..."
                        color: "#ffffff"
                        anchors.centerIn: parent
                    }
                }
            }
        }

        // RIGHT SECTION
        Rectangle {

            SplitView.preferredWidth: parent.width / 2
            SplitView.fillHeight: true
            radius: 10
            color: "#333333"

            StackLayout {
                id: stack_layout
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                currentIndex: 1

                // page 0: blank page
                Rectangle {
                    color: "#333333"
                }

                // page 1: new entry page
                ColumnLayout {
                    anchors.fill: parent
                    GridLayout {
                        columns: 4
                        Text {
                            text: "Title: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Enter title..."
                            Layout.columnSpan: 3
                        }
                        Text {
                            text: "Date: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "YYYY-MM-DD HH:MM:SS"
                            validator: RegularExpressionValidator {
                                regularExpression: /\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):([0-5]\d):([0-5]\d)/
                            }
                        }
                        Text {
                            text: "Use current time: "
                            color: "#ffffff"
                        }
                        CheckBox {
                            checked: true
                        }

                    }
                    CustomTextArea {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "How was your day? "
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width/2
                            Layout.fillWidth: true
                            text: "Save"
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width/2
                            Layout.fillWidth: true
                            text: "Clear"
                        }
                    }
                }

                // page 2: view past entries
                ColumnLayout {
                    anchors.fill: parent
                    GridLayout {
                        columns: 2
                        Text {
                            text: "Title: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            Layout.fillWidth: true
                            readOnly: true
                            text: "Display title here..."
                        }
                        Text {
                            text: "Date: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            Layout.fillWidth: true
                            readOnly: true
                            text: "Display date here..."

                        }
                    }
                    CustomTextArea {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        readOnly: true
                        text: "Display content here..."
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width/2
                            Layout.fillWidth: true
                            text: "Edit"
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width/2
                            Layout.fillWidth: true
                            text: "Delete"
                        }
                    }
                }

                // page 3: edit entries


                // page 4: settings

            }
        }
    }

}