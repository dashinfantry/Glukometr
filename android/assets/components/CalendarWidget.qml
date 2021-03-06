import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import Qt.labs.calendar 1.0
import "../components"
import ".."


Item {
    property var selectedDate: new Date()
    height: calendarNav.height + calendarGrid.childrenRect.height + napiz.height + Theme.paddingMedium

    RowLayout {
        id: calendarNav
        width: parent.width

        Label {
            text: selectedDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")
            font.pixelSize: Theme.fontSizeMedium
        }
        Item {
            Layout.fillWidth: true
        }
        RoundButton {
            background: Rectangle
            {
                color: "#99ff7575"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.width
                radius: parent.width
            }
            text: "\ue5cb"
            font.family: "Material Icons"
            onClicked: {
                var d = new Date();
                d.setDate(selectedDate.getDate());
                if (selectedDate.getMonth() > 0)
                    d.setMonth(selectedDate.getMonth() - 1);
                else {
                    d.setMonth(11)
                    d.setFullYear(selectedDate.getFullYear() - 1)
                }
                selectedDate = d;
            }
        }
        RoundButton {
            background: Rectangle
            {
                color: "#99ff7575"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.width
                radius: parent.width
            }

            text: "\ue5cc"
            font.family: "Material Icons"

            onClicked: {
                var d = new Date();
                d.setDate(selectedDate.getDate());
                if (selectedDate.getMonth() < 11)
                    d.setMonth(selectedDate.getMonth() + 1);
                else {
                    d.setMonth(0)
                    d.setFullYear(selectedDate.getFullYear() + 1)
                }
                selectedDate = d;
            }
        }
    }

    Column {
        id: calendarGrid
        width: parent.width
        anchors.top: calendarNav.bottom

        DayOfWeekRow {
            locale: grid.locale
            width: parent.width
            delegate: Label {
                width: parent.width/7
                horizontalAlignment: Text.AlignHCenter
                color: "#ff7575"
                text: model.shortName
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }

        MonthGrid {
            id: grid
            width: parent.width
            month: selectedDate.getMonth()
            year: selectedDate.getFullYear()
            locale: Qt.locale()
            spacing: 0


            delegate: ToolButton {
                background: Rectangle {
                    anchors.fill: parent
                    color: "#85000000"
                    Image
                    {
                        opacity: 0.5
                        height: parent.height
                        width: parent.height
                        anchors.centerIn: parent
                        source: "qrc:/icons/cukierek.svg"
                        visible: model.day == selectedDate.getDate() && model.month == selectedDate.getMonth()
                    }
                }
                //Material.foreground: "black"

                opacity: model.month === grid.month ? 1.0 : 0.6
                text: model.day

                onClicked: {
                    var d = new Date();
                    d.setFullYear(model.year)
                    d.setMonth(model.month)
                    d.setDate(model.day)
                    selectedDate = d;
                }
            }
        }
    }
    Label {
        id: napiz
        anchors
        {
            top: calendarGrid.bottom
            topMargin: Theme.paddingSmall
            bottomMargin:Theme.paddingLarge
            horizontalCenter: parent.horizontalCenter
        }

        text: selectedDate.toLocaleDateString(Qt.locale(), "dd MMMM yyyy")
        color: "#ff7575"
    }
}
