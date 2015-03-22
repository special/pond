import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    id: pageview
    Layout.fillWidth: true
    Layout.fillHeight: true

    property var currentPage
    property Item item

    onCurrentPageChanged: {
        if (currentPage !== null && currentPage.pageInstance == null) {
            var component = Qt.createComponent(currentPage.source)
            if (component.status !== Component.Ready) {
                console.log("component error:", component.errorString())
                return
            }

            currentPage.pageInstance = component.createObject(container, { pageData: currentPage })
        }

        if (item !== null) {
            item.focus = false
            item.visible = false
        }
        item = (currentPage === null ? null : currentPage.pageInstance)
        if (item !== null) {
            item.visible = true
            item.focus = true
        }
    }

    FocusScope {
        id: container
        anchors.fill: parent
    }
}
