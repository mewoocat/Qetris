pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Item {
    id: root
    anchors.fill: parent

    property int blockSize: gameBoard.height / tetris.gridRows
    Component.onCompleted: {
        console.debug(`blockSize: ${blockSize}`)
        console.debug(`height: ${height}`)
    }

    property Tetris tetris: Tetris {
        blockSize: root.blockSize
    }

    Rectangle {
        id: controlBoard
        anchors.fill: parent
        color: "blue"//controlBoard.focus ? "deepskyblue" : "grey"
        onVisibleChanged: root.tetris.pause()
        onFocusChanged: console.log(`controlBoard focus changed to ${focus}`)
        Keys.onPressed: (event) => {
            console.log(`key event root`)
            if (root.tetris.isRunning) {
                if (event.key == Qt.Key_A) { root.tetris.moveLeft() }
                if (event.key == Qt.Key_D) { root.tetris.moveRight() }
                if (event.key == Qt.Key_S) { root.tetris.moveDown() }
                if (event.key == Qt.Key_L) { root.tetris.rotateRight() }
            }
        }
        
        Rectangle {
            id: gameBoard
            color: "black"
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                margins: 8
            }
            implicitWidth: root.tetris.blockSize * root.tetris.gridColumns
            Component.onCompleted: root.tetris.gameBoard = gameBoard
        }

        Rectangle {
            id: pauseOverlay
            visible: root.tetris.isPaused
            anchors.fill: gameBoard
            color: "transparent"
            WrapperRectangle {
                anchors.centerIn: parent
                margin: 2
                Text {
                    text: "Paused"
                }
            }
        }

        Rectangle {
            id: gameoverOverlay
            visible: root.tetris.isGameover
            anchors.fill: gameBoard
            color: "transparent"
            WrapperRectangle {
                anchors.centerIn: parent
                margin: 2
                Text {
                    text: "Gameover"
                }
            }
        }

        Rectangle {
            id: sidePanel
            anchors {
                left: gameBoard.right
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                margins: 8
            }
            topRightRadius: 2
            bottomRightRadius: 2
            color: "dimgray"
            implicitWidth: 80
            border.width: 1
            border.color: controlBoard.focus ? "deepskyblue" : "grey"

            Item {
                id: scoreBox
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                    margins: 8
                }
                height: scoreText.height + scoreValueBox.height
                Text {
                    id: scoreText
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "white"
                    text: `score`
                    padding: 4
                    font.bold: true
                } 
                Rectangle { 
                    id: scoreValueBox
                    color: "black"
                    anchors.top: scoreText.bottom
                    implicitHeight: scoreText.height + 8
                    implicitWidth: parent.width
                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 4
                        id: scoreValue
                        color: "white"
                        text: `${root.tetris.score}`
                    }
                }
            }
            ColumnLayout {
                anchors {
                    top: scoreBox.bottom
                    left: parent.left
                    right: parent.right
                    margins: 8
                }
                Button {
                    Layout.fillWidth: true
                    text: !root.tetris.isRunning || root.tetris.isPaused ? "start" : "pause" ;
                    onClicked: () => {
                        if (!root.tetris.isRunning || root.tetris.isPaused) {
                            root.tetris.start()
                            controlBoard.forceActiveFocus()
                            //root.focus = true // idk why setting this doesn't give root the active focus
                        }
                        else {
                            root.tetris.pause()
                            controlBoard.focus = false
                        }
                    }
                }
                Button {
                    text: "reset"
                    Layout.fillWidth: true
                    onClicked: () => root.tetris.reset()
                }
            }

            Rectangle {
                id: nextShapeBoard
                anchors {
                    margins: 8
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                }
                color: "black"
                implicitWidth: root.tetris.blockSize * 4
                implicitHeight: root.tetris.blockSize * 4

                Component.onCompleted: root.tetris.nextShapeBoard = nextShapeBoard
            }
        }
    }
}
