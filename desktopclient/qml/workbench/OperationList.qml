import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Dialogs 1.0
import MasterCatalogModel 1.0
import OperationCatalogModel 1.0
import OperationModel 1.0

Rectangle {

    signal makeForm(string objectid, string name)

    width : parent.width
    color : "white"
    clip : true
    ListView {
        id : operationsList
        anchors.fill: parent
        model : operations.operations
        delegate : Item{
            id : currentOperation
            height : 35;
            width : parent.width;
            Rectangle {
                anchors.fill: parent
                color: operationsList.currentIndex === index ? "#99CCFF" : index  % 2 == 0 ? "#FFFBF3" : "#DCDCDC"
                radius : 5
                Text {
                    id : operationName
                    text : displayName
                    anchors.top : parent.top
                    width : parent.width
                    height : 17
                    x : 5
                    font.pointSize: 12
                }
                Text {
                    id : operationSyntax
                    text : syntax()
                    anchors.top : operationName.bottom
                    width : parent.width
                    height : 12
                    font.pointSize: 8
                    x : 5
                    color : "grey"
                }
            }

            focus : true
            MouseArea {
                hoverEnabled: true
                anchors.fill: parent
                cursorShape: Qt.ArrowCursor
                onClicked: {
                    applicationForm.state = operationsList.currentIndex == index && applicationForm.state != "minimized" ? "minimized" : "maximized"
                    operationsList.currentIndex = index;
                    operationid = operations.operationId(index)
                    makeForm(operationid, displayName);
                }
            }

        }
    }

}
