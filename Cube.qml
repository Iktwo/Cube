import QtQuick 2.11

Item {
    id: root

    property Component leftFace
    property Component rightFace
    property Component topFace

    height: 100
    width: 100

    Loader {
        anchors.centerIn: parent

        sourceComponent: cube
    }

    Component {
        id: cube

        Item {
            id: itemContainer

            width: Math.min(root.height, root.width)
            height: width

            transform: [
                Matrix4x4 {
                    property real angle: 45/360 * Math.PI * 2

                    property matrix4x4 scaleMatrix:
                        Qt.matrix4x4(1,  0, 0, 0,
                                     0, 0.5, 0, 0,
                                     0,  0, 1, 0,
                                     0,  0, 0, 1)

                    property matrix4x4 rotationMatrix:
                        Qt.matrix4x4(Math.cos(angle), -Math.sin(angle), 0, 0,
                                     Math.sin(angle),  Math.cos(angle), 0, 0,
                                     0, 0, 1, 0,
                                     0, 0, 0, 1)

                    matrix: scaleMatrix.times(rotationMatrix)
                },
                Rotation {
                    axis {
                        y: 0
                        z: 1
                        x: 0
                    }

                    origin.x: itemContainer.height / 2
                    origin.y: itemContainer.height / 2

                    angle: 180
                },
                Scale {
                    xScale: 0.70
                    yScale: 0.70
                },
                Translate {
                    x: -itemContainer.height * 0.20
                    y: itemContainer.height * 0.3
                }
            ]

            Loader {
                id: loaderTop

                width: parent.width
                height: width

                transform: [
                    Matrix4x4 {
                        matrix: Qt.matrix4x4(1, 0, 0, width,
                                             0, 1, 0, width,
                                             0, 0, 1, 0,
                                             0, 0, 0, 1)
                    }
                ]

                sourceComponent: root.topFace

                rotation: 90
            }

            Loader {
                id: loaderLeft

                width: parent.width
                height: width

                layer.mipmap: true
                layer.smooth: true

                transform: [
                    Matrix4x4 {
                        matrix: Qt.matrix4x4(1, 1, 0, 0,
                                             0, 1, 0, 0,
                                             0, 0, 1, 0,
                                             0, 0, 0, 1)
                    }
                ]

                sourceComponent: root.leftFace

                rotation: 180
            }

            Loader {
                id: loaderRight

                width: parent.width
                height: width

                transform: [
                    Matrix4x4 {
                        matrix: Qt.matrix4x4(1, 0, 0, 0,
                                             1, 1, 0, 0,
                                             0, 0, 1, 0,
                                             0, 0, 0, 1)
                    }
                ]

                sourceComponent: root.rightFace

                rotation: 90
            }
        }
    }
}
