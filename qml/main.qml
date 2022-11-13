import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: window
    width: 800
    height: 600
    visible: true
    title: qsTr("The Qute Masked Cat")
    property real diag: Math.sqrt(width**2 + height**2)
    
    Rectangle {
        width: diag
        height: diag
        rotation: -45
        anchors.centerIn: parent
        gradient: Gradient {
            GradientStop { position: 0.00; color: "red" }
            GradientStop { position: 0.25; color: "yellow" }
            GradientStop { position: 0.50; color: "green" }
            GradientStop { position: 0.75; color: "blue" }
            GradientStop { position: 1.00; color: "purple" }
        }
    }

    StackLayout {
        id: stack
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: bottomBar.top
        }
        currentIndex: 0
        property var text: [ 
            "First, there was no cat at home...",
            "Then, i've found this qute kitty on the net...",
            "It looks nice with the Opacity Mask...",
            "No, you don't need new glasses: Gaussian Blur effect!"
        ];

        Item {
            id: page1
        }
        
        Item {
            id: page2
            Image {
                id: kittenImage
                width: 512
                height: 512
                visible: true
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "Tabby_cat_with_blue_eyes.jpg"
            }
        }

        Item {
            id: page3
            Image {
                id: sourceImage
                width: 512
                height: 512
                visible: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                source: "Tabby_cat_with_blue_eyes.jpg"
                layer.enabled: true
                layer.smooth: true
            }
            Rectangle {
                id: rectMask
                color: "#ff0000"
                radius: 200
                border.width: 0
                anchors.fill: sourceImage
                layer.enabled: true
                layer.samplerName: "maskSource"
                layer.effect: ShaderEffect {
                    property variant source: sourceImage
                    fragmentShader: "opacitymask.frag.qsb"
                }
            }            
        }
        
        Item {
            id: page4
            Image {
                id: srcImage4
                width: 512
                height: 512
                visible: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                fillMode: Image.PreserveAspectFit
                source: "Tabby_cat_with_blue_eyes.jpg"
                layer.enabled: true
            }
            ShaderEffect {
                id: blurredImage
                anchors.fill: srcImage4
                layer.enabled: true
                property var src: srcImage4
                property int radius: 8
                property real deviation: 4
                property var pixelStep: Qt.vector2d(1/src.width, 1/src.height)
                fragmentShader: "gaussianblur.frag.qsb"
                visible: false
            }
            ShaderEffectSource {
                id: blurredSource
                sourceItem: blurredImage
                hideSource: true
                visible: false
            }
            Rectangle {
                id: rectMask4
                color: "#ff0000"
                radius: 200
                anchors.fill: srcImage4
                layer.enabled: true
                visible: false
            }
            ShaderEffect {
                anchors.fill: srcImage4
                layer.enabled: true
                property var source: blurredSource
                property var maskSource: rectMask4
                fragmentShader: "opacitymask.frag.qsb"
            }
        }
    }

    Rectangle {
        id: bottomBar
        color: "transparent"
        anchors.leftMargin: 5 
        anchors.rightMargin: 5 
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Text {
            id: bottomText
            font.pointSize: 20
            color: "white"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            text: stack.text[0]
        }
        Button {
            id: prevButton
            text: "Previous"
            font.pointSize: 14
            padding: 3
            anchors {
                right: nextButton.left
                bottom: parent.bottom
                rightMargin: 5
            }
            enabled: stack.currentIndex > 0
            visible: enabled
            onClicked: { 
                stack.currentIndex -= 1
                bottomText.text = stack.text[stack.currentIndex]
            }
        }
        Button {
            id: nextButton
            text: "Next"
            font.pointSize: 14
            padding: 3
            anchors {
                right: parent.right
                bottom: parent.bottom
                rightMargin: 5
            }
            enabled: stack.currentIndex < stack.text.length - 1
            visible: enabled
            onClicked: {
                stack.currentIndex += 1
                bottomText.text = stack.text[stack.currentIndex]
            }
        }
    }
}
