import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results

    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }

    SilicaListView
    {
        opacity: hint.running ? disabledOpacity : 1.0
        Behavior on opacity { FadeAnimation {} }
        header: Item
        {
            width: parent.width
            height: pageHeader.height + dit.height
            PageHeader
            {
                id: pageHeader
                title: "Pomiary"
            }

            Rectangle
            {
                id: dit
                width: parent.width
                anchors
                {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                    top: pageHeader.bottom
                }
                height: sweetValue.paintedHeight + Theme.paddingMedium
                color: "transparent"

                Label
                {
                    id: sweetValue
                    font.pixelSize: Theme.fontSizeMedium
                    text: "Cukier"
                    anchors
                    {
                        left: parent.left
                        top: parent.top
                    }
                    color: Theme.primaryColor
                }

                Label
                {
                    id: dateAndTime
                    font.pixelSize: Theme.fontSizeMedium
                    horizontalAlignment: Text.AlignRight
                    text: "Data i Czas"
                    anchors
                    {
                        right: parent.right
                        top: parent.top
                    }
                    color: Theme.primaryColor
                    clip: true
                }
            }
        }
        PullDownMenu
        {
            id: pullDownMenu
            MenuItem
            {
                text: "Ustawienia"
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/Settings.qml")
            }

            MenuItem
            {
                text: "Bluetooth"
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/DeviceList.qml")
            }

            MenuItem
            {
                text: "Dodaj pomiar"
                onClicked: openAddMeasurementDialog()
            }
        }
        VerticalScrollDecorator {}


        id: book
        anchors.fill: parent
        model: measurements.model
        delegate: ListItem
        {
            enabled: !isTutorialEnabled
            id: measurement
            RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/MeasurementDetails.qml"), {
                                          "measurement_id": measurement_id,
                                          "value": value,
                                          "meal": meal,
                                          "timestamp": timestamp
                                      })
            menu: ContextMenu
            {
                MenuItem
                {
                    text: "Zmień pore posiłku"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/ChangeMeal.qml"),
                                                                         {"meal": meal})
                        dialog.accepted.connect(function()
                        {
                            measurements.update({
                                "measurement_id": measurement_id
                            }, {"meal": dialog.meal}, true);
                        })
                    }
                }
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(measurement, "Usunięcie pomiaru", function() {
                        measurements.remove(measurement_id)
                    })
                }
            }

            GlassItem
            {
                x: 0
                id: dot
                width: Theme.itemSizeExtraSmall
                height: width
                anchors.verticalCenter: sugar.verticalCenter
                color: thresholds.evaluateMeasurement(value, meal)
            }

            Label
            {
                id: sugar
                font.pixelSize: Theme.fontSizeSmall
                text: value
                anchors
                {
                    left: dot.right
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: Theme.primaryColor
            }

            Label
            {
                function changeToString(meal)
                {
                    switch(meal)
                    {
                        case 0: return "Na czczo"
                        case 1: return "Przed posiłkiem"
                        case 2: return "Po posiłku"
                        case 3: return "Nocna"
                        default: return "Nie określono"
                    }
                }
                id: whenMeasurement
                font.pixelSize: Theme.fontSizeSmall
                text: changeToString(meal)
                color: Theme.secondaryColor
                anchors
                {
                    top: sugar.bottom
                    topMargin: Theme.paddingSmall
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
            }

            Label
            {
                id: dateLabel
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: new Date(timestamp*1000).toLocaleString(Qt.locale("pl_PL"),"dd.MM.yy    HH:mm")
                anchors
                {
                    left: whenMeasurement.right
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: Theme.highlightColor
            }
        }
    }

    InteractionHintLabel
    {
        text: "Aby przejść dalej przesuń palcem w dół"
        color: Theme.secondaryColor
        anchors.top: parent.top
        opacity: hint.running ? (pullDownMenu.active ? 0.0 : 1.0) : 0.0
        Behavior on opacity { FadeAnimation {} }
        invert: true
    }

    InteractionHintLabel
    {
        text: "Wybierz 'Dodaj pomiar'"
        color: Theme.secondaryColor
        anchors.bottom: parent.bottom
        opacity: hint.running ? (pullDownMenu.active ? 1.0 : 0.0) : 0.0
        Behavior on opacity { FadeAnimation {} }
        invert: false
    }

    TouchInteractionHint
    {
        id: hint
        loops: Animation.Infinite
        interactionMode: TouchInteraction.Pull
        direction: TouchInteraction.Down
        Connections {
            target: application
            onIsTutorialEnabledChanged:
            {
                if (application.isTutorialEnabled)
                    hint.start()
                else hint.stop();
            }
        }
    }
}