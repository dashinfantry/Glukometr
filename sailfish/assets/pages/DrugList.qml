import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: drugsPage

    SilicaListView
    {
        header: PageHeader
        {
            id: pageHeader
            title: "Leki"
        }
        PullDownMenu
        {
            MenuItem
            {
                text: "Dodaj lek"
                onClicked:
                {
                    var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddDrug.qml"))
                    dialog.accepted.connect(function()
                    {
                        drugs.add({"name": dialog.value})
                    })
                }
            }
        }
        VerticalScrollDecorator {}


        id: drugsBook
        anchors.fill: parent
        model: drugs.model
        delegate: ListItem
        {
            id: drugItem
            RemorseItem { id: remorseDrug }
            menu: ContextMenu
            {
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorseDrug.execute(drugItem, "Usunięcie leku", function() {drugs.remove(drug_id) } )
                }

                MenuItem
                {
                    text: "Edytuj"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddDrug.qml"), {
                                                        "value": name,
                                                        "isEdited": true,
                                                    })
                        dialog.accepted.connect(function()
                        {
                            drugs.update({"drug_id": drug_id}, {"name": dialog.value})
                        })
                    }
                }
            }

            Label
            {
                id: drugLabel
                font.pixelSize: Theme.fontSizeMedium
                text: name
                anchors
                {
                    left: parent.left
                    margins: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
