// SPDX-License-Identifier: GPL-3.0-only
import QtQuick

Rectangle {
    property string calendarId: ""
    objectName: "calendarColorDot"
    visible: Theme.colorDisplay && calendarId !== ""
    width: 20
    height: 20
    radius: width / 2
    color: visible ? Theme.calendarColor(calendarId) : "transparent"
    border.color: "black"
    border.width: 1
}
