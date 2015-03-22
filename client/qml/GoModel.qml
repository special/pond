import QtQuick 2.0

// Workaround for issues with using ListModel API from Go code
ListModel {
    function appendObject(obj) {
        append(obj)
    }
    function insertObject(index, obj) {
        insert(index, obj)
    }
}
