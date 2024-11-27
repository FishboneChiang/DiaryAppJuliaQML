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
    color: dark_mode ? "#222222" : "#DDDDDD"

    property int current_id: -1
    property bool confirm_delete: false
    property bool dark_mode: Julia.getDarkMode()

    Popup {
        id: delete_dialog
        parent: Overlay.overlay
        modal: true
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        width: 300
        height: 80

        background: Rectangle {
            color: dark_mode ? "#333333" : "#CCCCCC"
            radius: 4
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: dark_mode ? "#ffffff" : "#000000"
                text: "Are you sure you want to delete this entry?"
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                CustomButton {
                    Layout.preferredWidth: parent.width / 2
                    Layout.fillWidth: true
                    text: "Yes"
                    onClicked: {
                        deleteEntry();
                        delete_dialog.close();
                    }
                }
                CustomButton {
                    Layout.preferredWidth: parent.width / 2
                    Layout.fillWidth: true
                    text: "No"
                    onClicked: delete_dialog.close()
                }
            }
        }
    }

    // Define custom components
    component CustomButton: Button {
        background: Rectangle {
            color: dark_mode ? (parent.down ? "#444444" : "#555555") : (parent.down ? "#DDDDDD" : "#EEEEEE")
            radius: 4
        }
        palette.buttonText: dark_mode ? "#ffffff" : "#000000"
    }
    component CustomTextField: TextField {
        background: Rectangle {
            radius: 3
            color: dark_mode ? "#444444" : "#DDDDDD"
            border.color: dark_mode ? "#555555" : "#EEEEEE"
            border.width: 1
        }
        placeholderTextColor: dark_mode ? "#bbbbbb" : "#444444"
        color: dark_mode ? "#ffffff" : "#000000"
    }
    component CustomTextArea: ScrollView {
        property alias content_text: text_area_id.text
        property alias read_only: text_area_id.readOnly
        TextArea {
            id: text_area_id
            readOnly: false
            placeholderText: "How was your day?"
            placeholderTextColor: dark_mode ? "#bbbbbb" : "#444444"
            text: ""
            color: dark_mode ? "#ffffff" : "#000000"
            background: Rectangle {
                radius: 3
                color: dark_mode ? "#444444" : "#DDDDDD"
                border.color: dark_mode ? "#555555" : "#EEEEEE"
                border.width: 1
            }
            wrapMode: TextEdit.Wrap
        }
    }

    function displayEntry() {
        stack_layout.currentIndex = 2;
        var entry = Julia.getEntry(current_id);
        title_display.text = entry[0];
        date_time_display.text = entry[1];
        content_display.content_text = entry[2];
    }

    function clear_input() {
        title_input.text = "";
        current_time_checkbox.checked = true;
        date_time_input.text = current_time_checkbox.checked ? Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss") : "";
        content_input.content_text = "";
    }

    function displayEntryEdit() {
        stack_layout.currentIndex = 3;
        var entry = Julia.getEntry(current_id);
        title_edit.text = entry[0];
        date_time_edit.text = entry[1];
        content_edit.content_text = entry[2];
        current_time_checkbox_2.checked = false;
    }

    function entryInputSave() {
        if (title_input.text == "") {
            if (content_input.content_text == "") {
                return;
            } else {
                title_input.text = "Untitled";
            }
        }
        Julia.newEntry(title_input.text, date_time_input.text, content_input.content_text);
        diaryList.model = Julia.getNumEntries();
        stack_layout.currentIndex = 0;
        clear_input();
    }

    function entryEditSave() {
        if (title_edit.text == "") {
            if (content_edit.content_text == "") {
                return;
            } else {
                title_edit.text = "Untitled";
            }
        }
        Julia.editEntry(current_id, title_edit.text, date_time_edit.text, content_edit.content_text);
        diaryList.model = 0; // to reload the diary list
        diaryList.model = Julia.getNumEntries();
        stack_layout.currentIndex = 0;
        current_id = -1;
    }

    function deleteEntry() {
        Julia.deleteEntry(current_id);
        diaryList.model = Julia.getNumEntries();
        stack_layout.currentIndex = 0;
        current_id = -1;
    }

    FolderDialog {
        id: fileDialog
        title: "Please choose a file"
        currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
        onAccepted: {
            let path = fileDialog.selectedFolder.toString().replace("file://", "");
            save_location_display.text = path;
            Julia.setDiaryFileDir(save_location_display.text);
            diaryList.model = 0; // reload diary list
            diaryList.model = Julia.getNumEntries();
        }
        onRejected: {
            // console.log("Rejected");
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
            color: dark_mode ? "#333333" : "#CCCCCC"

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
                        color: dark_mode ? "#ffffff" : "#000000"
                    }
                    CustomButton {
                        text: "Settings"
                        Layout.fillWidth: true
                        onClicked: {
                            stack_layout.currentIndex = 4;
                        }
                    }
                }

                CustomButton {
                    text: "New Entry"
                    Layout.fillWidth: true
                    onClicked: {
                        stack_layout.currentIndex = 1;
                        current_id = -1;
                        date_time_input.text = current_time_checkbox.checked ? Qt.formatDateTime(new Date(), "yyyy-MM-dd hh:mm:ss") : "";
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: dark_mode ? "#333333" : "#CCCCCC"
                    radius: 4
                    ScrollView {
                        anchors.fill: parent
                        Column {
                            spacing: 2
                            anchors.fill: parent
                            Repeater {
                                id: diaryList
                                model: Julia.getNumEntries()
                                Rectangle {
                                    required property int index
                                    width: parent.parent.parent.width
                                    height: 60
                                    color: (current_id == index) ? (dark_mode ? "#444444" : "#DDDDDD") : (dark_mode ? "#333333" : "#CCCCCC")
                                    radius: 4
                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.topMargin: 10
                                        anchors.bottomMargin: 10
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10
                                        Text {
                                            text: Julia.getEntry(index)[0]
                                            font.pixelSize: 16
                                            font.bold: true
                                            color: dark_mode ? "#ffffff" : "#000000"
                                        }
                                        Text {
                                            text: Julia.getEntry(index)[1]
                                            color: dark_mode ? "#ffffff" : "#000000"
                                        }
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            current_id = index;
                                            displayEntry();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // RIGHT AREA
        Rectangle {

            SplitView.preferredWidth: (3 / 5) * parent.width
            SplitView.fillHeight: true
            radius: 6
            color: dark_mode ? "#333333" : "#CCCCCC"

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
                    color: dark_mode ? "#333333" : "#CCCCCC"
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
                            color: dark_mode ? "#ffffff" : "#000000"
                        }
                        CustomTextField {
                            id: title_input
                            Layout.fillWidth: true
                            placeholderText: "Enter title..."
                            Layout.columnSpan: 3
                        }
                        Text {
                            text: "Date: "
                            color: dark_mode ? "#ffffff" : "#000000"
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
                            color: dark_mode ? "#ffffff" : "#000000"
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
                            color: dark_mode ? "#ffffff" : "#000000"
                        }
                        CustomTextField {
                            id: title_display
                            Layout.fillWidth: true
                            readOnly: true
                            text: "Display title here..."
                        }
                        Text {
                            text: "Date: "
                            color: dark_mode ? "#ffffff" : "#000000"
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
                            id: delete_button
                            Layout.preferredWidth: parent.width / 2
                            Layout.fillWidth: true
                            text: "Delete"
                            onClicked: {
                                delete_dialog.open();
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
                            color: dark_mode ? "#ffffff" : "#000000"
                        }
                        CustomTextField {
                            id: title_edit
                            Layout.fillWidth: true
                            placeholderText: "Enter title..."
                            Layout.columnSpan: 3
                        }
                        Text {
                            text: "Date: "
                            color: dark_mode ? "#ffffff" : "#000000"
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
                            color: dark_mode ? "#ffffff" : "#000000"
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
                    spacing: 20
                    GridLayout {
                        columns: 2
                        rowSpacing: 10
                        Text {
                            text: "Diary Save Location: "
                            color: dark_mode ? "#ffffff" : "#000000"
                            Layout.columnSpan: 2
                        }
                        CustomTextField {
                            id: save_location_display
                            Layout.fillWidth: true
                            readOnly: true
                            text: Julia.getDiaryFileDir()
                        }
                        CustomButton {
                            text: "File Browser"
                            onClicked: {
                                fileDialog.visible = true;
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text {
                            text: "Color Scheme:   "
                            color: dark_mode ? "#ffffff" : "#000000"
                        }
                        Text {
                            text: "☀️"
                        }
                        Switch {
                            checked: dark_mode
                            onToggled: {
                                dark_mode = !(dark_mode);
                                Julia.setDarkMode(dark_mode);
                            }
                        }
                        Text {
                            text: "🌙"
                        }
                    }
                }
            }
        }
    }
}
