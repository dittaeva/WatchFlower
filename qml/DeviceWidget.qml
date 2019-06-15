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

import QtQuick 2.9

import com.watchflower.theme 1.0
import "UtilsNumber.js" as UtilsNumber

Item {
    implicitWidth: 640
    implicitHeight: bigAssMode ? 140 : 100
    anchors.fill: parent.width

    property var boxDevice: null

    property bool mobileMode: (Qt.platform.os === "android" || Qt.platform.os === "ios")
    property bool wideAssMode: (width >= 380)
    property bool bigAssMode: false
    property bool singleColumn: true

    Connections {
        target: boxDevice
        onStatusUpdated: updateBoxDatas()
        onSensorUpdated: updateBoxDatas()
        onDatasUpdated: updateBoxDatas()
        onLimitsUpdated: updateBoxDatas()
    }

    Component.onCompleted: initBoxDatas()

    function initBoxDatas() {

        // Device picture
        if (boxDevice.deviceName === "MJ_HT_V1") {
            imageDevice.source = "qrc:/assets/icons_material/baseline-trip_origin-24px.svg"
        } else {
            if (boxDevice.hasDatas("hygro"))
                imageDevice.source = "qrc:/assets/icons_material/outline-local_florist-24px.svg"
            else
                imageDevice.source = "qrc:/assets/icons_material/outline-settings_remote-24px.svg"
        }

        // Sensor battery level
        if (boxDevice.hasBatteryLevel()) {
            imageBattery.visible = true
            imageBattery.color = Theme.colorIcons

            if (boxDevice.deviceBattery > 95) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_full-24px.svg";
            } else if (boxDevice.deviceBattery > 85) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_90-24px.svg";
            } else if (boxDevice.deviceBattery > 75) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_80-24px.svg";
            } else if (boxDevice.deviceBattery > 55) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_60-24px.svg";
            } else if (boxDevice.deviceBattery > 45) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_50-24px.svg";
            } else if (boxDevice.deviceBattery > 25) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_30-24px.svg";
            } else if (boxDevice.deviceBattery > 15) {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_20-24px.svg";
            } else if (boxDevice.deviceBattery > 1) {
                imageBattery.color = Theme.colorRed
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_10-24px.svg";
            } else {
                imageBattery.source = "qrc:/assets/icons_material/baseline-battery_unknown-24px.svg";
            }
        } else {
            imageBattery.source = "qrc:/assets/icons_material/baseline-battery_unknown-24px.svg";
            imageBattery.visible = false
        }

        updateBoxDatas()
    }

    function updateBoxDatas() {

        rectangleSensors.visible = false
        rectangleHygroTemp.visible = false
        water.visible = false
        temp.visible = false

        // Texts
        if (boxDevice.deviceName === "MJ_HT_V1") {
            textPlant.text = qsTr("Thermometer")
        } else if (boxDevice.devicePlantName !== "") {
            textPlant.text = boxDevice.devicePlantName
        } else {
            textPlant.text = boxDevice.deviceName
        }

        if (boxDevice.deviceLocationName !== "") {
            textLocation.text = boxDevice.deviceLocationName
        } else {
            textLocation.text = boxDevice.deviceAddress
        }

        // Status
        if (boxDevice.updating) {
            textStatus.color = Theme.colorYellow
            textStatus.text = qsTr("Connecting...")
            opa.start()
        } else if (boxDevice.available) {
            textStatus.color = Theme.colorGreen
            textStatus.text = qsTr("Synced")
            opa.stop()
        } else if (boxDevice.lastUpdateMin >= 0 && boxDevice.lastUpdateMin <= 12*60) {
            textStatus.color = Theme.colorYellow
            textStatus.text = qsTr("Synced")
            //textStatus.text = qsTr("Synced %1 min. ago").arg(boxDevice.lastUpdateMin)
            opa.stop()
        } else {
            textStatus.color = Theme.colorRed
            textStatus.text = qsTr("Offline")
            opa.stop()
        }

        // Water me notif
        if (boxDevice.deviceHygro > 0) {
            if (boxDevice.deviceName !== "MJ_HT_V1") {
                if (boxDevice.deviceHygro < boxDevice.limitHygroMin) {
                    water.visible = true
                }
            }
        }
        // Extreme temperature notif
        if (boxDevice.deviceTempC > 40) {
            temp.visible = true
            temp.color = Theme.colorYellow
        } else if (boxDevice.deviceTempC > -80 && boxDevice.deviceTempC  <= 0) {
            temp.visible = true
            temp.color = Theme.colorBlue
        }

        // Update notif
        if (boxDevice.isUpdating()) {
            if (boxDevice.lastUpdateMin >= 0 && boxDevice.lastUpdateMin <= 720) {
                // if we have data cached, no indicator
            } else {
                imageStatus.visible = true;
                imageStatus.source = "qrc:/assets/icons_material/baseline-bluetooth_searching-24px.svg";
                refreshAnimation.running = true;
            }
        } else {
            refreshAnimation.running = false;

            if (boxDevice.isAvailable()) {
                imageStatus.visible = false;
            } else {
                if (boxDevice.lastUpdateMin >= 0 && boxDevice.lastUpdateMin <= 720) {
                    // if we have data cached, no indicator
                    imageStatus.visible = false;
                } else {
                    imageStatus.visible = true;
                    imageStatus.source = "qrc:/assets/icons_material/baseline-bluetooth_disabled-24px.svg";
                }
            }
        }

        // Has datas? always display them
        if (boxDevice.lastUpdateMin >= 0 && boxDevice.lastUpdateMin <= 720) {
            if (boxDevice.deviceName === "MJ_HT_V1") {
                rectangleHygroTemp.visible = true
                textTemp.text = boxDevice.getTemp().toFixed(1) + "°"
                textHygro.text = boxDevice.deviceHygro + "%"
            } else {
                rectangleSensors.visible = true
                hygro_data.height = UtilsNumber.normalize(boxDevice.deviceHygro, boxDevice.limitHygroMin - 1, boxDevice.limitHygroMax) * rowRight.height
                temp_data.height = UtilsNumber.normalize(boxDevice.deviceTempC, boxDevice.limitTempMin - 1, boxDevice.limitTempMax) * rowRight.height
                lumi_data.height = UtilsNumber.normalize(boxDevice.deviceLuminosity, boxDevice.limitLumiMin, boxDevice.limitLumiMax) * rowRight.height
                cond_data.height = UtilsNumber.normalize(boxDevice.deviceConductivity, boxDevice.limitConduMin, boxDevice.limitConduMax) * rowRight.height

                hygro_bg.visible = (boxDevice.deviceHygro > 0 || boxDevice.deviceConductivity > 0)
                lumi_bg.visible = boxDevice.hasLuminositySensor()
                cond_bg.visible = (boxDevice.deviceHygro > 0 || boxDevice.deviceConductivity > 0)
            }
        }
    }

    Rectangle {
        id: deviceWidget
        radius: 2
        anchors.rightMargin: 6
        anchors.leftMargin: 6
        anchors.bottomMargin: 6
        anchors.topMargin: 6
        anchors.fill: parent

        color: "transparent"
        border.width: 2
        border.color: (singleColumn) ? "transparent" : Theme.colorMaterialDarkGrey

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if (boxDevice.hasDatas()) {
                    if (currentlySelectedDevice != boxDevice) {
                        currentlySelectedDevice = boxDevice

                        if (currentlySelectedDevice.deviceName === "MJ_HT_V1")
                            screenDeviceThermometer.loadDevice()
                        else
                            screenDeviceSensor.loadDevice()
                    }

                    if (currentlySelectedDevice.deviceName === "MJ_HT_V1")
                        content.state = "DeviceThermo"
                    else
                        content.state = "DeviceSensor"
                }
            }
        }

        ////////////////////////////////////////////////////////////////////////////

        Row {
            id: rowLeft
            clip: true
            anchors.right: rowRight.left
            anchors.rightMargin: 0
            spacing: bigAssMode ? 20 : 24
            anchors.top: parent.top
            anchors.topMargin: bigAssMode ? 16 : 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bigAssMode ? 16 : 8
            anchors.left: parent.left
            anchors.leftMargin: bigAssMode ? (singleColumn ? 4 : 16) : (singleColumn ? 8 : 12)

            ImageSvg {
                id: imageDevice
                width: bigAssMode ? 32 : 24
                height: bigAssMode ? 32 : 24
                anchors.verticalCenter: parent.verticalCenter

                color: "black"
                visible: wideAssMode || bigAssMode
                fillMode: Image.PreserveAspectFit
            }

            Column {
                id: column
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: textPlant
                    anchors.right: parent.right
                    anchors.rightMargin: bigAssMode ? 0 : 8

                    color: Theme.colorText
                    text: boxDevice.deviceLocationName
                    font.capitalization: Font.Capitalize
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    font.pixelSize: bigAssMode ? 22 : 20
                }

                Text {
                    id: textLocation
                    anchors.right: parent.right
                    anchors.rightMargin: bigAssMode ? 0 : 8

                    color: Theme.colorSubText
                    text: boxDevice.deviceAddress
                    font.capitalization: Font.Capitalize
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    font.pixelSize: bigAssMode ? 20 : 18
                }

                Row {
                    id: row
                    height: bigAssMode ? 26 : 22
                    spacing: 8
                    anchors.left: parent.left

                    ImageSvg {
                        id: imageBattery
                        width: bigAssMode ? 30 : 28
                        height: bigAssMode ? 32 : 30

                        color: Theme.colorIcons
                        anchors.verticalCenter: parent.verticalCenter
                        rotation: 90
                        source: "qrc:/assets/icons_material/baseline-battery_unknown-24px.svg"
                        fillMode: Image.PreserveAspectCrop
                    }

                    Text {
                        id: textStatus
                        anchors.verticalCenterOffset: 0
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: bigAssMode ? 16 : 15

                        SequentialAnimation on opacity {
                            id: opa
                            loops: Animation.Infinite
                            onStopped: textStatus.opacity = 1;

                            PropertyAnimation { to: 0.5; duration: 750; }
                            PropertyAnimation { to: 1; duration: 750; }
                        }
                    }
                }
            }
        }

        ////////////////////////////////////////////////////////////////////////////

        Row {
            id: rowRight
            spacing: 8
            anchors.top: parent.top
            anchors.topMargin: bigAssMode ? 16 : 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: bigAssMode ? 16 : 8
            anchors.right: parent.right
            anchors.rightMargin: singleColumn ? 0 : (bigAssMode ? 16 : 10)

            Row {
                id: lilIcons
                height: 24
                anchors.verticalCenter: parent.verticalCenter
                layoutDirection: Qt.RightToLeft
                spacing: 8

                ImageSvg {
                    id: water
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-opacity-24px.svg"
                    color: Theme.colorBlue
                }
                ImageSvg {
                    id: temp
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-ac_unit-24px.svg"
                    color: Theme.colorYellow
                }
            }

            Row {
                id: rectangleSensors
                anchors.bottom: parent.bottom
                anchors.top: parent.top

                visible: true
                spacing: 8
                property int sensorWidth: mobileMode ? 8 : (bigAssMode ? 12 : 10)
                property int sensorRadius: 2

                Item {
                    id: hygro_bg
                    width: rectangleSensors.sensorWidth
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0

                    Rectangle {
                        id: bg1
                        anchors.fill: parent
                        color: Theme.colorBlue
                        opacity: 0.33
                        radius: rectangleSensors.sensorRadius
                    }
                    Rectangle {
                        id: hygro_data
                        height: 12
                        color: Theme.colorBlue
                        radius: rectangleSensors.sensorRadius
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                    }
                }

                Item {
                    id: temp_bg
                    width: rectangleSensors.sensorWidth
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Rectangle {
                        id: bg2
                        anchors.fill: parent
                        color: Theme.colorGreen
                        opacity: 0.33
                        radius: rectangleSensors.sensorRadius
                    }
                    Rectangle {
                        id: temp_data
                        height: 6
                        color: Theme.colorGreen
                        radius: rectangleSensors.sensorRadius
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        visible: true
                        anchors.bottomMargin: 0
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                    }
                }

                Item {
                    id: lumi_bg
                    width: rectangleSensors.sensorWidth
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0

                    Rectangle {
                        id: bg3
                        anchors.fill: parent
                        color: Theme.colorYellow
                        opacity: 0.33
                        radius: rectangleSensors.sensorRadius
                    }
                    Rectangle {
                        id: lumi_data
                        height: 8
                        color: Theme.colorYellow
                        radius: rectangleSensors.sensorRadius
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                    }
                }

                Item {
                    id: cond_bg
                    width: rectangleSensors.sensorWidth
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0

                    Rectangle {
                        id: bg4
                        anchors.fill: parent
                        color: Theme.colorRed
                        opacity: 0.33
                        radius: rectangleSensors.sensorRadius
                    }
                    Rectangle {
                        id: cond_data
                        height: 10
                        color: Theme.colorRed
                        radius: rectangleSensors.sensorRadius
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                    }
                }
            }

            Column {
                id: rectangleHygroTemp
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: textTemp
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    text: "25.0°"
                    color: "#333333"
                    font.wordSpacing: -1.2
                    font.letterSpacing: -1.4
                    font.pixelSize: bigAssMode ? 32 : 30
                    font.family: "Tahoma"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft

                    Connections {
                        target: settingsManager
                        onTempUnitChanged: textTemp.text = boxDevice.getTemp().toFixed(1) + "°"
                    }
                }

                Text {
                    id: textHygro
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    text: "55%"
                    color: "#666666"
                    font.pixelSize: bigAssMode ? 26 : 24
                    font.family: "Tahoma"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }
            }

            Image {
                id: imageForward
                width: 32
                height: 32
                anchors.verticalCenterOffset: 0
                visible: singleColumn
                z: 1
                sourceSize: Qt.size(width, height)
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/icons_material/baseline-chevron_right-24px.svg"
            }
        }

        ImageSvg {
            id: imageStatus
            width: 32
            height: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: singleColumn ? 56 : 36

            source: "qrc:/assets/icons_material/baseline-bluetooth_disabled-24px.svg"
            visible: false
            color: Theme.colorIcons

            SequentialAnimation on opacity {
                id: refreshAnimation
                loops: Animation.Infinite
                running: false
                onStopped: imageStatus.opacity = 1
                OpacityAnimator { from: 0; to: 1; duration: 750 }
                OpacityAnimator { from: 1; to: 0;  duration: 750 }
            }
        }
    }

    Rectangle {
        id: bottomSeparator
        color: Theme.colorMaterialDarkGrey
        visible: singleColumn
        height: 1

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.leftMargin: -6
        anchors.rightMargin: -6
        anchors.left: parent.left
    }
}
