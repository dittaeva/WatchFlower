/*!
 * This file is part of WatchFlower.
 * COPYRIGHT (C) 2019 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2019
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

import QtQuick 2.7
import QtQuick.Controls 2.0

import QtGraphicalEffects 1.0
import com.watchflower.theme 1.0

Item {
    id: rectangleAbout
    width: 480
    height: 640
    anchors.fill: parent

    Rectangle {
        id: rectangleAboutTitle
        height: 80
        color: Theme.colorMaterialDarkGrey
        border.width: 0

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: textTitle
            color: Theme.colorTitles
            text: qsTr("About")
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.top: parent.top
            anchors.topMargin: 12
            font.bold: true
            font.pixelSize: 26
        }

        Text {
            id: textSubtitle
            text: qsTr("What do you want to know?")
            font.pixelSize: 16
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14
        }
    }

    Rectangle {
        id: rectangleContent
        color: "#00000000"
        anchors.top: rectangleAboutTitle.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.topMargin: 0

        TextArea {
            id: element
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8

            text: qsTr("WatchFlower is a plant monitoring application that reads and plots datas from these Xiaomi bluetooth devices:")
            wrapMode: Text.WordWrap
            readOnly: true
            font.pixelSize: 18
        }

        Rectangle {
            id: rectangleIcons
            height: 96
            color: "#00000000"
            anchors.top: element.bottom
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Image {
                id: image3
                width: 96
                height: 96
                anchors.left: image2.right
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/devices/hygrotemp.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(width, height)
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: Theme.colorIcons
                }
            }

            Image {
                id: image2
                width: 96
                height: 96
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/devices/ropot.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(width, height)
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: Theme.colorIcons
                }
            }

            Image {
                id: image1
                width: 96
                height: 96
                anchors.right: image2.left
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/devices/flowercare.svg"
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(width, height)
                ColorOverlay {
                    anchors.fill: parent
                    source: parent
                    color: Theme.colorIcons
                }
            }
        }

        Rectangle {
            id: rectangleInfos
            width: 290
            height: 88
            color: "#00000000"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 32
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: imageLogo
                width: 88
                height: 88
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left

                source: "qrc:/assets/desktop/watchflower.svg"
                sourceSize: Qt.size(width, height)
            }

            Text {
                id: textVersion
                width: 184
                anchors.verticalCenterOffset: -12
                anchors.left: imageLogo.right
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter

                color: "#343434"
                text: qsTr("WatchFlower") + " / " + settingsManager.getAppVersion()
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 17
            }
            Text {
                id: textUrl
                width: 184
                anchors.verticalCenterOffset: 12
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: imageLogo.right
                anchors.leftMargin: 8

                color: "#343434"
                text: "Visit the <html><style type=\"text/css\"></style><a href=\"https://github.com/emericg/WatchFlower\" style=\"text-decoration: none\">GitHub</a></html> page!"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 17
                onLinkActivated: Qt.openUrlExternally("https://github.com/emericg/WatchFlower")
            }
        }
    }
}