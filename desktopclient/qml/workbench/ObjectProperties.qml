import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0
import IlwisObjectModel 1.0
import CatalogModel 1.0
import "propertyform" as PropertyForm

Rectangle {
    id : propertyFormContainer

    signal unloadcontent(string content)

    color : background4
    clip : true
    state : "invisible"
    height : 500
    opacity : 1

    FunctionBarHeader{
        id : functionBar
        headerImage: "../images/properties40.png"
        headerText:"Object properties"
        z : 1
    }
    Image {
        anchors.fill: parent
        source : "../images/back2.png"
        opacity : 0.5
        smooth : true
    }

    ListView {
        id : props
        anchors.top: functionBar.bottom
        width : parent.width
        height : 500
        model : mastercatalog.selectedCatalog().selectedData
        delegate : PropertyForm.DPropertyForm{}
    }




    states: [
        State { name: "visible"

            PropertyChanges {
                target: propertyFormContainer
                opacity : 1
            }
        },
        State {
            name : "invisible"
            PropertyChanges {
                target: propertyFormContainer
                opacity : 0
            }
        }

    ]
    transitions: [
        Transition {
            NumberAnimation {
                properties: "opacity"; duration : 500 ; easing.type: Easing.Linear
            }
            onRunningChanged :
            {
                if ( opacity == 0) {
                    unloadcontent("ObjectProperties.qml")
                }
            }

        }
    ]

    Component.onCompleted: {
    }
}
