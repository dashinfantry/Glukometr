import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    Component.onCompleted: {
        reminders.clearExpiredReminders();
        reminders.get();
    }

    function makeReminder(text, reminder_type, when, repeating)
    {
        reminders.remind(text, reminder_type, when, repeating)
    }

    function reminderTypeToString(type)
    {
        switch (type)
        {
        case 0: return qsTr("REMINDERS_MEASUREMENT")
        case 1: return qsTr("REMINDERS_DRUG");
        case 2: return qsTr("REMINDERS_FOOD");
        default: return qsTr("REMINDERS_REMINDER")
        }
    }

    SilicaListView
    {
        anchors.fill: parent
        PullDownMenu
        {         
            MenuItem
            {
                text: qsTr("REMINDERS_ADD_LABEL")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddReminder.qml"))
                    dialog.accepted.connect(function()
                    {
                        var date = new Date();
                        if (date.getHours() > dialog.selectedHour) {
                            date.setDate(date.getDate() + 1); // hcemy jurto
                        }
                        date.setHours(dialog.selectedHour)
                        date.setMinutes(dialog.selectedMinute)
                        date.setSeconds(0);
                        date.setMilliseconds(0);
                        reminders.remind(
                                    reminderTypeToString(dialog.reminderType),
                                    dialog.reminderType, date, dialog.repeating)
                    })
                }
            }
        }

        model: reminders.model
        header: PageHeader { title: qsTr("REMINDERS_ADD_LABEL") }
        delegate: ListItem
        {
            id:list
            RemorseItem { id: remorse }
            menu: ContextMenu
            {
                MenuItem
                {
                    text: qsTr("REMOVE_LABEL")
                    onClicked: remorse.execute(list, qsTr("REMINDERS_REMOVE_REMORSE"), function()
                    {
                        reminders.cancel(cookie_id);
                        reminders.remove(reminder_id);
                    })
                }
            }
            Label
            {
                id:remind
                text: reminderTypeToString(reminder_type)
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
            }
            Label
            {
                id:whenCall
                text: new Date(reminder_datetime*1000).toLocaleString(Qt.locale(),"HH:mm")
                anchors
                {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Theme.horizontalPageMargin
                }
                color: Theme.secondaryColor
            }
        }
    }
}
