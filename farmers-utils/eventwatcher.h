#ifndef EVENTWATCHER_H
#define EVENTWATCHER_H
#include <QObject>
#include <QTime>
#include <QTimer>
#include "farmers-utils_global.h"

class FARMERSUTILSSHARED_EXPORT EventWatcher : public QObject
{
    Q_OBJECT

public:
    // Constructor:
    EventWatcher(QObject *parent=0);

    // Event filter:
    virtual bool eventFilter(QObject *obj, QEvent *ev);

private:
    // Watched events:
    QList<int> mWatchedEvents;

signals:
    // User active?
    void userActive();
};

#endif // EVENTWATCHER_H
