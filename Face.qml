import QtQuick 2.0

Item {
    property var matrix: []
    property bool numbersVisible: true
    readonly property alias view: gridView
    readonly property alias size: gridView.width

    antialiasing: true
    layer.mipmap: true

    GridView {
        id: gridView

        property int matrixIndex: 0

        width: Math.min(parent.height, parent.width)
        height: width

        model: matrix != undefined && matrix.length > 0 ? matrix.length * matrix[0].length : 0

        cellWidth: Math.floor(width / 3)
        cellHeight: cellWidth

        interactive: false

        delegate: Item {
            property var parentMatrixIndex: parent.parent.matrixIndex

            width: Math.floor(parent.width / 3)
            height: width

            Rectangle {
                anchors {
                    fill: parent
                    margins: parent.height * 0.05
                }

                border {
                    color: "#000000"
                    width: 1
                }

                color: colors[matrix[Math.floor(index / 3)][index % 3]]

                Text {
                    anchors.centerIn: parent

                    visible: numbersVisible

                    text: (1 + Math.floor(index / 3)) + " x " + (1 + (index % 3))
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log((1 + Math.floor(index / 3)) + " x " + (1 + (index % 3)))
                }
            }
        }
    }
}
