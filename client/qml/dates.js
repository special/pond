.pragma library

function prettyDate(unixDate) {
    var date = new Date(unixDate)
    var now = new Date()
    var delta = (now.getTime() - date.getTime()) / 1000

    if (delta < 86400 && date.getDay() == now.getDay()) {
        return Qt.formatTime(date)
    } else if (delta < 86400*2 && date.getDay() == now.getDay()-1) {
        return qsTr("Yesterday")
    } else {
        return Qt.formatDate(date, Qt.DefaultLocaleShortDate)
    }
}

function fullDate(unixDate) {
    return Qt.formatDateTime(new Date(unixDate))
}

function durationDate(unixDate) {
    var date = new Date(unixDate)
    var now = new Date()
    var delta = (now.getTime() - date.getTime()) / 1000
    var absDelta = Math.abs(delta)
    var isPast = delta > 0

    if (absDelta < 60) {
        return isPast ? qsTr("%n seconds ago", "", absDelta) : qsTr("in %n seconds", "", absDelta)
    }

    absDelta /= 60
    if (absDelta < 60) {
        return isPast ? qsTr("%n minutes ago", "", absDelta) : qsTr("in %n minutes", "", absDelta)
    }

    absDelta /= 60
    if (absDelta < 24) {
        return isPast ? qsTr("%n hours ago", "", absDelta) : qsTr("in %n hours", "", absDelta)
    }

    absDelta /= 24
    if (absDelta < 7) {
        return isPast ? qsTr("%n days ago", "", absDelta) : qsTr("in %n days", "", absDelta)
    }

    absDelta /= 7
    if (absDelta < 52) {
        return isPast ? qsTr("%n weeks ago", "", absDelta) : qsTr("in %n weeks", "", absDelta)
    }

    absDelta /= 52
    return isPast ? qsTr("%n years ago", "", absDelta) : qsTr("in %n years", "", absDelta)
}

