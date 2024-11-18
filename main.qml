import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

// import org.julialang

Window {

    visible: true
    width: 800
    height: 480
    title: "Diary App"
    x: 1200
    y: 250
    color: "#222222"

    // Define custom components
    component CustomButton: Button {
        background: Rectangle {
            color: parent.down ? "#444444" : "#555555"
            radius: 4
        }
    }
    component CustomTextField: TextField {
        background: Rectangle {
            radius: 3
            color: "#444444"
            border.color: "#555555"
            border.width: 1
        }
    }
    component CustomTextArea: TextArea {
        background: Rectangle {
            radius: 3
            color: "#444444"
            border.color: "#555555"
            border.width: 1
        }
        wrapMode: TextEdit.Wrap
    }
    // component CustomEntry: Rectangle {
    //     color: "#333333"
    //     radius: 4
    //     width: parent.width
    //     height: parent.height / 8
    //     MouseArea {
    //         anchors.fill: parent
    //         onClicked: console.log("selected!")
    //     }
    //     property string title
    //     property string date_time
    //     Text {
    //         text: title + "\n" + date_time
    //         color: "#ffffff"
    //         // align to the left, vertically centered
    //         anchors.verticalCenter: parent.verticalCenter
    //         anchors.left: parent.left
    //     }
    // }

    FolderDialog {
        id: fileDialog
        title: "Please choose a file"
        currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
        onAccepted: {
            console.log("Accepted: " + fileDialog.selectedFolder);
        }
        onRejected: {
            console.log("Rejected");
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

            SplitView.preferredWidth: (1 / 2) * parent.width
            SplitView.fillHeight: true
            radius: 6
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
                        palette.buttonText: "#ffffff"
                        Layout.fillWidth: true
                        onClicked: {
                            stack_layout.currentIndex = 4;
                        }
                    }
                }

                CustomButton {
                    text: "New Entry"
                    palette.buttonText: "#ffffff"
                    Layout.fillWidth: true
                    onClicked: {
                        stack_layout.currentIndex = 1;
                    }
                }

                Column {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text{
                        text: "implement list view..."
                        color: "#ffffff"
                    }
                }
                
                
            }
        }

        // RIGHT SECTION
        Rectangle {

            SplitView.preferredWidth: (1 / 2) * parent.width
            SplitView.fillHeight: true
            radius: 6
            color: "#333333"

            StackLayout {
                id: stack_layout
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                currentIndex: 2

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
                            id: title_input
                            Layout.fillWidth: true
                            placeholderText: "Enter title..."
                            Layout.columnSpan: 3
                        }
                        Text {
                            text: "Date: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            id: date_time_input
                            Layout.fillWidth: true
                            placeholderText: "YYYY-MM-DD HH:MM:SS"
                            text: Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss")
                            validator: RegularExpressionValidator {
                                regularExpression: /\d {4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):([0-5]\d):([0-5]\d)/
                            }
                        }
                        Text {
                            text: "Use current time: "
                            color: "#ffffff"
                        }
                        CheckBox {
                            id: current_time_checkbox
                            checked: true
                            onToggled: {
                                if (this.checked) {
                                    date_time_input.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss");
                                } else {
                                    date_time_input.text = "";
                                }
                            }
                        }
                    }
                    CustomTextArea {
                        id: content_input
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "How was your day? "
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Save"
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Clear"
                            onClicked: {
                                title_input.text = "";
                                date_time_input.text = current_time_checkbox.checked ? Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss") : "";
                                content_input.text = "";
                            }
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
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Edit"
                            onClicked: {
                                stack_layout.currentIndex = 3;
                            }
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Delete"
                        }
                    }
                }

                // page 3: edit entries
                ColumnLayout {
                    anchors.fill: parent
                    GridLayout {
                        columns: 4
                        Text {
                            text: "Title: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            id: title_edit
                            Layout.fillWidth: true
                            placeholderText: "Enter title..."
                            Layout.columnSpan: 3
                        }
                        Text {
                            text: "Date: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            id: date_time_edit
                            Layout.fillWidth: true
                            placeholderText: "YYYY-MM-DD HH:MM:SS"
                            text: Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss")
                            validator: RegularExpressionValidator {
                                regularExpression: /\d {4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):([0-5]\d):([0-5]\d)/
                            }
                        }
                        Text {
                            text: "Use current time: "
                            color: "#ffffff"
                        }
                        CheckBox {
                            id: current_time_checkbox_2
                            checked: true
                            onToggled: {
                                if (this.checked) {
                                    date_time_edit.text = Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss");
                                } else {
                                    date_time_edit.text = "";
                                }
                            }
                        }
                    }
                    CustomTextArea {
                        id: content_edit
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "How was your day? "
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Save"
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Cancel"
                            onClicked: {
                                stack_layout.currentIndex = 2;
                            }
                        }
                    }
                }

                // page 4: settings
                ColumnLayout {
                    anchors.centerIn: parent
                    // spacing: 20
                    GridLayout {
                        columns: 2
                        Text {
                            text: "Diary Save Location: "
                            color: "#ffffff"
                            Layout.columnSpan: 2
                        }
                        CustomTextField {
                            Layout.fillWidth: true
                            readOnly: true
                            text: "Display save location here..."
                        }
                        CustomButton {
                            text: "File Browser"
                            onClicked: {
                                fileDialog.visible = true;
                            }
                        }
                    }
                }
            }
        }
    }
}
