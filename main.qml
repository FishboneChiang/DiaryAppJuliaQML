import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

import org.julialang

Window {

    visible: true
    width: 640
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
    component CustomTextArea: ScrollView {
        property alias content_text: text_area_id.text
        property alias read_only: text_area_id.readOnly
        TextArea {
            id: text_area_id
            readOnly: false
            placeholderText: "How was your day?"
            text: ""
            background: Rectangle {
                radius: 3
                color: "#444444"
                border.color: "#555555"
                border.width: 1
            }
            wrapMode: TextEdit.Wrap
        }
    }

    function displayEntry() {
        stack_layout.currentIndex = 2;
        var index = list.currentIndex;
        var entry = Julia.getEntry(index);
        console.log(index, "\t", entry);
        title_display.text = entry[0];
        date_time_display.text = entry[1];
        content_display.content_text = entry[2];
    }

    function clear_input() {
        title_input.text = "";
        date_time_input.text = current_time_checkbox.checked ? Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss") : "";
        content_input.content_text = "";
    }

    function displayEntryEdit() {
        stack_layout.currentIndex = 3;
        var index = list.currentIndex;
        var entry = Julia.getEntry(index);
        console.log(index, "\t", entry);
        title_edit.text = entry[0];
        date_time_edit.text = entry[1];
        content_edit.content_text = entry[2];
    }

    function entryInputSave() {
        Julia.newEntry(title_input.text, date_time_input.text, content_input.content_text);
        Julia.save_to_json();
        stack_layout.currentIndex = 0;
        clear_input();
    }

    function entryEditSave() {
        var index = list.currentIndex;
        Julia.editEntry(index, title_edit.text, date_time_edit.text, content_edit.content_text);
        Julia.save_to_json();
        stack_layout.currentIndex = 0;
        list.currentIndex = -1;
    }
    
    function deleteEntry(){
        var index = list.currentIndex;
        Julia.deleteEntry(index);
        Julia.save_to_json();
        stack_layout.currentIndex = 0;
        list.currentIndex = -1;
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

        // LEFT AREA
        Rectangle {

            SplitView.preferredWidth: (2 / 5) * parent.width
            SplitView.fillHeight: true
            radius: 6
            color: "#333333"

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                spacing: 10

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
                        list.currentIndex = -1;
                        date_time_input.text = current_time_checkbox.checked ? Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss") : "";
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#444444"
                    radius: 4
                    ListView {
                        id: list
                        anchors.fill: parent
                        model: diaryEntries
                        clip: true
                        highlightMoveVelocity: -1
                        ScrollBar.vertical: ScrollBar {}
                        currentIndex: -1
                        delegate: Component {
                            Item {
                                width: parent.width
                                height: 60
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    anchors.topMargin: 10
                                    anchors.bottomMargin: 10
                                    Text {
                                        font.bold: true
                                        font.pixelSize: 14
                                        Layout.fillHeight: true
                                        text: "Title: " + entryTitle
                                    }
                                    Text {
                                        // font.pixelSize: 14
                                        Layout.fillHeight: true
                                        text: "Date: " + entryDate
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        list.currentIndex = index;
                                        displayEntry();
                                    }
                                }
                            }
                        }
                        highlight: Rectangle {
                            y: list.currentItem.y
                            color: "grey"
                            Text {
                                anchors.centerIn: parent
                                text: 'index: ' + list.currentIndex
                                color: "#ffffff"
                            }
                            radius: 4
                        }
                        focus: true
                    }
                }
            }
        }

        // RIGHT AREA
        Rectangle {

            SplitView.preferredWidth: (3 / 5) * parent.width
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
                currentIndex: 0

                // page 0: blank page
                Rectangle {
                    color: "#333333"
                }

                // page 1: new entry page
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10
                    GridLayout {
                        columns: 4
                        rowSpacing: 10
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
                                regularExpression: /\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):([0-5]\d):([0-5]\d)/
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
                        // placeholderText: "How was your day? "
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Save"
                            onClicked: {
                                entryInputSave();
                            }
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Clear"
                            onClicked: {
                                clear_input();
                            }
                        }
                    }
                }

                // page 2: view past entries
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10
                    GridLayout {
                        columns: 2
                        rowSpacing: 10
                        Text {
                            text: "Title: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            id: title_display
                            Layout.fillWidth: true
                            readOnly: true
                            text: "Display title here..."
                        }
                        Text {
                            text: "Date: "
                            color: "#ffffff"
                        }
                        CustomTextField {
                            id: date_time_display
                            Layout.fillWidth: true
                            readOnly: true
                            text: "Display date here..."
                        }
                    }
                    CustomTextArea {
                        id: content_display
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        read_only: true
                        // text: "Display content here..."
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Edit"
                            onClicked: {
                                displayEntryEdit();
                            }
                        }
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Delete"
                            onClicked:{
                                deleteEntry();
                                // console.log
                            }
                        }
                    }
                }

                // page 3: edit entries
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10
                    GridLayout {
                        columns: 4
                        rowSpacing: 10
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
                                regularExpression: /\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):([0-5]\d):([0-5]\d)/
                            }
                        }
                        Text {
                            text: "Use current time: "
                            color: "#ffffff"
                        }
                        CheckBox {
                            id: current_time_checkbox_2
                            checked: false
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
                        // placeholderText: "How was your day? "
                    }

                    RowLayout {
                        CustomButton {
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Save"
                            onClicked: {
                                entryEditSave();
                            }
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
                    spacing: 10
                    GridLayout {
                        columns: 2
                        rowSpacing: 10
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
