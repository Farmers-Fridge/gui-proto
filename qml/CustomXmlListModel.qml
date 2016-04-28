import QtQuick 2.5
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: root
    property int elpasedTime: 0

    // Network time out:
    property variant timer: Timer {
        id: timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.elpasedTime += 1000
            if (root.elpasedTime > _timeSettings.networkTimeOut)
            {
                timer.stop()
                root.source = ""
                root.elpasedTime = 0
            }
        }
    }

    // App stays busy as long as a XmlListModel is loading:
    onStatusChanged: {
        //_appIsBusy = (root.status === XmlListModel.Loading)
        timer.stop()
    }

    Component.onCompleted: timer.start()
}

