import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    Column
    {
        id: column
        spacing: Theme.paddingMedium
        opacity: hint.running ? 0.2 : 1.0
        Behavior on opacity { FadeAnimation {} }
        anchors
        {
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }

        Label
        {
            id: welcome
            anchors
            {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }

            text: qsTr("WELCOME_TEXT")
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.pixelSize: Theme.fontSizeHuge
            color: Theme.highlightColor
            wrapMode: Text.WordWrap
        }

        Button
        {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("WELCOME_BEGIN")
            color: Theme.highlightColor
            highlightBackgroundColor: Theme.highlightBackgroundColor
            onClicked:
            {
                application.isTutorialEnabled = true //
                hint.start()
            }
        }
    }

    InteractionHintLabel
    {
        text: qsTr("WELCOME_HINT")
        color: Theme.secondaryColor
        anchors.bottom: parent.bottom
        opacity: hint.running ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation {} }
    }

    TouchInteractionHint
    {
        id: hint
        loops: Animation.Infinite
        interactionMode: TouchInteraction.EdgeSwipe
        direction: TouchInteraction.Right
    }
}
