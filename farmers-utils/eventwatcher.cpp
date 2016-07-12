#include "eventwatcher.h"
#include <QEvent>
#include <QCoreApplication>
#include <QDebug>

// Constructor:
EventWatcher::EventWatcher(QObject *parent) : QObject(parent)
{
    mWatchedEvents << QEvent::MouseButtonPress <<
        QEvent::MouseButtonRelease <<
            QEvent::MouseButtonDblClick <<
                QEvent::MouseMove <<
                      QEvent::MouseTrackingChange <<
                            QEvent::KeyPress <<
                                QEvent::KeyRelease;
}

// Event filter:
bool EventWatcher::eventFilter(QObject *obj, QEvent *ev)
{
    // Check mouse clicked / mouse moved:
    if (mWatchedEvents.contains(ev->type()))
        emit userActive();

    return QObject::eventFilter(obj, ev);
}
