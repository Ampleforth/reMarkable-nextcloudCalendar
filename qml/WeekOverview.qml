// SPDX-License-Identifier: GPL-3.0-only
import QtQuick

Item {
    id:overview
    required property var app
    readonly property var days: {
        var result=[],first=app.startOfWeek(app.selected)
        for(var i=0;i<7;i++) {
            var day=app.add(first,i)
            result.push({day:day,events:app.eventsOn(day).slice().sort(function(a,b){
                if(a.all_day!==b.all_day)return a.all_day?-1:1
                return a.start.localeCompare(b.start)
            })})
        }
        return result
    }
    function eventTime(item) {
        if(item.all_day)return "All day"
        return app.formatTime(item.start.slice(11,16))+"\n"+app.formatTime(item.end.slice(11,16))
    }
    Row {
        id:dates;width:parent.width;height:68;spacing:6
        Repeater {model:overview.days;delegate:Action {
            required property var modelData
            width:(overview.width-36)/7;height:68;fontSize:20
            label:Qt.formatDate(modelData.day,"ddd\nd")
            selected:app.iso(modelData.day)===app.iso(app.selected)
            onTriggered:app.openDay(modelData.day)
        }}
    }
    ListView {
        id:agenda;objectName:"weekAgendaList"
        anchors.top:dates.bottom;anchors.topMargin:12;anchors.bottom:parent.bottom
        width:parent.width;clip:true;spacing:18;model:overview.days
        delegate:Column {
            id:dayGroup
            required property var modelData
            width:agenda.width;spacing:8
            Rectangle {
                width:parent.width;height:54;radius:10;color:"#eeeeee"
                Text {x:16;anchors.verticalCenter:parent.verticalCenter;text:Qt.formatDate(dayGroup.modelData.day,"dddd, d MMM");font.pixelSize:26;font.bold:true;color:"black"}
                CalendarGesture {objectName:"agendaDayGesture";anchors.fill:parent;onSwiped:function(direction){app.navigate(direction)};onTapped:app.openDay(dayGroup.modelData.day)}
            }
            Repeater {model:dayGroup.modelData.events;delegate:Rectangle {
                required property var modelData
                objectName:"agendaEventCard"
                width:dayGroup.width;height:Math.max(114,eventText.height+28);radius:12
                color:Theme.calendarFill(modelData.calendar,"#e5e5e5")
                border.color:Theme.calendarEdge(modelData.calendar,"#888888")
                Rectangle {width:5;height:parent.height;color:Theme.calendarEdge(modelData.calendar,"black")}
                Text {x:18;y:18;width:180;text:overview.eventTime(modelData);font.pixelSize:23;font.bold:true;wrapMode:Text.Wrap;color:"black"}
                Column {id:eventText;x:218;y:14;width:parent.width-238;spacing:8
                    Text {width:parent.width;text:modelData.title;font.pixelSize:28;font.bold:true;wrapMode:Text.Wrap;color:"black"}
                    Row {spacing:8
                        CalendarDot {calendarId:modelData.calendar;anchors.verticalCenter:parent.verticalCenter}
                        Text {width:eventText.width-32;text:modelData.calendar_name;font.pixelSize:21;font.weight:Font.DemiBold;elide:Text.ElideRight;color:"black"}
                    }
                }
                CalendarGesture {anchors.fill:parent;onSwiped:function(direction){app.navigate(direction)};onTapped:app.openItem(modelData)}
            }}
            Text {visible:dayGroup.modelData.events.length===0;width:parent.width;height:visible?44:0;text:"No events";leftPadding:16;verticalAlignment:Text.AlignVCenter;font.pixelSize:22;color:"black"
                CalendarGesture {anchors.fill:parent;onSwiped:function(direction){app.navigate(direction)};onTapped:app.openDay(dayGroup.modelData.day)}
            }
        }
    }
}
