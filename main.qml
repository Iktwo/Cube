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

    onCubeDataChanged: {
        printCubeData()
    }

    function printCubeData() {
        for (var face = 0; face < 6; ++face) {
            console.log("-- Face", face)
            for (var i = 0; i < 3; ++i) {
                console.log(cubeData[face][i])
            }
        }
    }

    function getDifferentColor(colors) {
        var randomColor = Math.floor(Math.random() * Math.floor(6))

        if (colors === undefined) {
            return randomColor
        }

        while (colors.indexOf(randomColor) !== -1) {
            randomColor = Math.floor(Math.random() * Math.floor(6))
        }

        return randomColor
    }

    function generateRandomCubeData() {
        for (var face = 0; face < 6; ++face) {
            for (var i = 0; i < 3; ++i) {
                for (var j = 0; j < 3; ++j) {
                    if (face == 0) {
                        cubeData[face][i][j] = getDifferentColor()
                    } else {
                        var colors = []

                        for (var index = face - 1; index > 0; --index) {
                            colors.push(cubeData[index][i][j])
                        }

                        cubeData[face][i][j] = getDifferentColor(colors)
                    }
                }
            }
        }

        printCubeData()
    }

    Component.onCompleted: {
        generateRandomCubeData()
        cubeData = cubeData
    }

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

        function getNewSideIndex(index, increasing) {
            var sides = 4
            var currentIndex = index

            if (currentTopIndex == 5) {
                increasing = !increasing
            }

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
            left: parent.left
            top: parent.top
            margins: 20
        }

        text: "R"

        onClicked: {
            generateRandomCubeData()
            cubeData = cubeData
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
            cube.currentLeftIndex = cube.getNewSideIndex(cube.currentLeftIndex, false)
            cube.currentRightIndex = cube.getNewSideIndex(cube.currentRightIndex, false)
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
            cube.currentLeftIndex = cube.getNewSideIndex(cube.currentLeftIndex, true)
            cube.currentRightIndex = cube.getNewSideIndex(cube.currentRightIndex, true)
        }
    }

    Button {
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: cube.horizontalCenter
        }

        text: "^"

        onClicked: {
            cube.currentLeftIndex = cube.getNewSideIndex(cube.currentLeftIndex, false)
            cube.currentRightIndex = cube.getNewSideIndex(cube.currentRightIndex, false)
            cube.currentLeftIndex = cube.getNewSideIndex(cube.currentRightIndex, false)
            cube.currentRightIndex = cube.getNewSideIndex(cube.currentLeftIndex, false)

            if (cube.currentTopIndex == 4) {
                cube.currentTopIndex = 5
            } else {
                cube.currentTopIndex = 4
            }
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

                numbersVisible: true
            }

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                width: 8
                color: "#343434"
            }
        }
    }
}
