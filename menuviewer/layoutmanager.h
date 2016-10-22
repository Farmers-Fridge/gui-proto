#ifndef LAYOUTMANAGER_H
#define LAYOUTMANAGER_H

// Application:
#include "layout.h"

// Qt:
#include <QObject>
#include <QMap>

#define MAX_IMAGES 9

class LayoutManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int nLayouts READ nLayouts NOTIFY nLayoutsChanged)
    Q_PROPERTY(int currentLayout READ currentLayout WRITE setCurrentLayout NOTIFY layoutIndexChanged)

public:
    // Constructor:
    explicit LayoutManager(QObject *parent = 0);

    // Cell selected?
    Q_INVOKABLE bool cellSelected(int index) const;

    // Update layout:
    Q_INVOKABLE void updateLayout(int startIndex, int endIndex);

    // Get specific layout:
    Q_INVOKABLE QList<int> getLayoutFilledCells(int iLayoutIndex) const;

    // Return layouts:
    const QList<Layout> &layouts() const;

    // Define default layouts:
    void defineDefaultLayouts();

    // Initialize:
    void initialize();

private:
    // Return # layouts:
    int nLayouts() const;

    // Return current layout:
    int currentLayout() const;

    // Set current layout:
    void setCurrentLayout(int iCurrentLayout);

private:
    // Layouts:
    QList<Layout> mLayouts;

    // Current layout:
    int mCurrentLayout;

signals:
    // # layouts changed:
    void nLayoutsChanged();

    // Layout index changed:
    void layoutIndexChanged();

    // Current layout changed:
    void currentLayoutChanged();
};

#endif // LAYOUTMANAGER_H
