import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import ".."
import "../components"

Page
{
    header: PageHeader {
        id: pageHeader
        title: "Pomiary"
    }
    background: OreoBackground {}
    id: results
    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }

    ListView
    {
        // opacity: hint.running ? disabledOpacity : 1.0
        // Behavior on opacity { FadeAnimation {} }
//        header: Item
//        {
//            width: parent.width
//            height: dit.height

//            Rectangle
//            {
//                id: dit
//                width: parent.width
//                anchors
//                {
//                    left: parent.left
//                    right: parent.right
//                    leftMargin: Theme.horizontalPageMargin
//                    rightMargin: Theme.horizontalPageMargin
//                    top: pageHeader.bottom
//                    topMargin: Theme.paddingMedium
//                }
//                height: sweetValue.paintedHeight + Theme.paddingMedium
//                color: "transparent"

//                Label
//                {
//                    id: sweetValue
//                    font.pixelSize: Theme.fontSizeMedium
//                    text: "Cukier"
//                    anchors
//                    {
//                        left: parent.left
//                        top: parent.top
//                    }
//                    color: Theme.primaryColor
//                }

//                Label
//                {
//                    id: dateAndTime
//                    font.pixelSize: Theme.fontSizeMedium
//                    horizontalAlignment: Text.AlignRight
//                    text: "Data i Czas"
//                    anchors
//                    {
//                        right: parent.right
//                        top: parent.top
//                    }
//                    color: Theme.primaryColor
//                    clip: true
//                }
//            }
//        }

        ScrollBar.vertical: ScrollBar { }


        id: book
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: toolBar.top
        }

        model: measurements.model
        section {
            property: "date_measured"
            delegate: Rectangle
            {
                height: tekst.paintedHeight + Theme.paddingMedium
                width: parent.width
                color: "#66000000"
                Label
                {
                    id: tekst
                    text: section
                    anchors
                    {
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        delegate: ListItem
        {
            enabled: !isTutorialEnabled
            id: measurement
            width: parent.width
            //RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/MeasurementDetails.qml"), {
                                          "measurement_id": model.measurement_id,
                                          "value": model.value,
                                          "meal": model.meal,
                                          "timestamp": model.timestamp
                                      })
            menu: Menu
            {
                id: contextMenu
                MenuItem
                {
                    text: "Zmień pore posiłku"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/ChangeMeal.qml"),
                                                                         {"meal": model.meal})
                        dialog.accepted.connect(function()
                        {
                            measurements.update({
                                "measurement_id": model.measurement_id
                            }, {"meal": dialog.meal}, true);
                        })
                    }
                }
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(measurement, "Usunięcie pomiaru", function() {
                        measurements.remove(model.measurement_id)
                    })
                }
            }

            Item
            {
                Rectangle {
                    width: Theme.itemSizeExtraSmall/3
                    height: Theme.itemSizeExtraSmall/3
                    anchors.centerIn: parent
                    color: thresholds.evaluateMeasurement(model.value, model.meal)

                    radius: width
                }

                x: 0
                id: dot
                width: Theme.itemSizeExtraSmall
                height: Theme.itemSizeExtraSmall
                anchors.verticalCenter: sugar.verticalCenter
            }

            Label
            {
                id: sugar
                font.pixelSize: Theme.fontSizeSmall
                text: model.value
                anchors
                {
                    left: dot.right
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: "#f7f5f0"
                //color: Theme.primaryColor
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
                text: changeToString(model.meal)
                anchors
                {
                    top: sugar.bottom
                    topMargin: Theme.paddingSmall
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
                color: "#e3decb"
            }

            Label
            {
                id: dateLabel
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: new Date(model.timestamp*1000).toLocaleString(Qt.locale("pl_PL"),"HH:mm")
                anchors
                {
                    left: whenMeasurement.right
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: "#f7f5f0"
            }
        }
    }

    ToolBar {
        id: toolBar
        width: parent.width
        anchors.bottom: parent.bottom
        Row{
            anchors.fill: parent

            ToolButton {
                font.family: "Material Icons"
                font.pixelSize: 20
                text: "\ue145"
                width: parent.width/3
                onClicked: openAddMeasurementDialog()
            }
            ToolButton {
                font.family: "Material Icons"
                font.pixelSize: 20
                text: "\ue1a7"
                width: parent.width/3
                onClicked: pageStack.push("qrc:/assets/pages/DeviceList.qml")
            }
            ToolButton {
                font.family: "Material Icons"
                font.pixelSize: 20
                text: "\ue8b8"
                width: parent.width/3
                onClicked: pageStack.push("qrc:/assets/pages/Settings.qml")
            }
        }
    }

    /*
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
    }*/
}