// SPDX-License-Identifier: GPL-3.0-only
pragma Singleton
import QtQuick

QtObject {
    property bool colorDisplay: false
    property var calendarColors: ({})
    readonly property color accent: colorDisplay?"#0082c9":"black"
    // Dracula accents: bright enough to read as color on the color e-ink panels, light enough for black text on top
    readonly property var choices: [
        {value:"#ff79c6",label:"Pink"},{value:"#bd93f9",label:"Purple"},
        {value:"#8be9fd",label:"Cyan"},{value:"#50fa7b",label:"Green"},
        {value:"#f1fa8c",label:"Yellow"},{value:"#ffb86c",label:"Orange"},
        {value:"#ff5555",label:"Red"}
    ]
    // colors saved with the earlier (muted) palette move to their closest Dracula accent
    readonly property var legacy: ({"#0082c9":"#8be9fd","#3a9d5d":"#50fa7b","#e7a52b":"#f1fa8c","#7952b3":"#bd93f9",
                                    "#167d8d":"#8be9fd","#c94758":"#ff5555","#bf6a22":"#ffb86c","#667085":"#bd93f9"})
    function calendarColor(id) {
        var chosen=calendarColors[id]
        if(chosen&&/^#[0-9a-fA-F]{6}$/.test(chosen))return legacy[chosen.toLowerCase()]||chosen
        var hash=0
        for(var i=0;i<id.length;i++)hash=(hash*31+id.charCodeAt(i))>>>0
        return choices[hash%choices.length].value
    }
    function colorLabel(id) {
        var value=calendarColor(id),found=choices.find(function(c){return c.value===value})
        return found?found.label:value
    }
    // Solid fills: pale tints of a color all but vanish on color e-ink. Edges are a darker shade for a crisp outline.
    function tint(color) {return Qt.color(color)}
    function shade(color) {return Qt.darker(Qt.color(color),1.6)}
    function calendarFill(id,gray) {return colorDisplay?tint(calendarColor(id)):gray}
    function calendarEdge(id,gray) {return colorDisplay?shade(calendarColor(id)):gray}
}
