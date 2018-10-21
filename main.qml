import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.2

Window {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Cube")

    property var colors: ["#2ecc71", "#e67e22", "#3498db", "#c0392b", "#f1c40f", "#ecf0f1"]

    property var cubeData: [
        [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
        ],
        [
            [1, 1, 1],
            [1, 1, 1],
            [1, 1, 1]
        ],
        [
            [2, 2, 2],
            [2, 2, 2],
            [2, 2, 2]
        ],
        [
            [3, 3, 3],
            [3, 3, 3],
            [3, 3, 3]
        ],
        [
            [4, 4, 4],
            [4, 4, 4],
            [4, 4, 4]
        ],
        [
            [5, 5, 5],
            [5, 5, 5],
            [5, 5, 5]
        ]
    ]


    Flow {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
    }

    Cube {
        id: cube

        property int currentTopIndex: 4
        property int currentLeftIndex: 0
        property int currentRightIndex: 1

        function getNewIndex(index, increasing) {
            var sides = 4
            var currentIndex = index

            if (increasing) {
                if (currentIndex === sides - 1) {
                    currentIndex = -1
                }
            } else {
                if (currentIndex === 0) {
                    currentIndex = sides
                }
            }

            var a = currentIndex - (increasing ? -1 : 1)
            return a
        }

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: listView.top
        }

        topFace: Face {
            matrix: cubeData[cube.currentTopIndex]
        }

        leftFace: Face {
            matrix: cubeData[cube.currentLeftIndex]
        }

        rightFace: Face {
            matrix: cubeData[cube.currentRightIndex]
        }
    }

    Button {
        anchors {
            left: cube.left
            leftMargin: 20
            verticalCenter: cube.verticalCenter
        }

        text: "<"

        onClicked: {
            cube.currentLeftIndex = cube.getNewIndex(cube.currentLeftIndex, false)
            cube.currentRightIndex = cube.getNewIndex(cube.currentRightIndex, false)
        }
    }

    Button {
        anchors {
            right: cube.right
            rightMargin: 20
            verticalCenter: cube.verticalCenter
        }

        text: ">"

        onClicked: {
            cube.currentLeftIndex = cube.getNewIndex(cube.currentLeftIndex, true)
            cube.currentRightIndex = cube.getNewIndex(cube.currentRightIndex, true)
        }
    }


    ListView {
        id: listView

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: parent.width / 6

        model: cubeData

        interactive: false
        orientation: ListView.Horizontal

        delegate: Item {
            property int matrixIndex: index

            height: width
            width: Math.floor(listView.width / 6)

            Face {
                anchors {
                    fill: parent
                }

                matrix: cubeData[matrixIndex]

                width: Math.min(parent.height, parent.width)
                height: width

                numbersVisible: false
            }
        }
    }
}
