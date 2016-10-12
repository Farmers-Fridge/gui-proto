#ifndef LAYOUTMANAGER_H
#define LAYOUTMANAGER_H
#include <QObject>
#include <QMap>
#include <QPointF>
#define MAX_IMAGES 9

class LayoutManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int nLayouts READ nLayouts NOTIFY nLayoutsChanged)
    Q_PROPERTY(int maxImages READ maxImages NOTIFY maxImagesChanged)
    Q_PROPERTY(int currentLayout READ currentLayout WRITE setCurrentLayout NOTIFY layoutIndexChanged)

public:
    // Constructor:
    explicit LayoutManager(QObject *parent = 0);

    // Cell selected?
    Q_INVOKABLE bool cellSelected(int index) const;

    // Update layout:
    Q_INVOKABLE void updateLayout(int startIndex, int endIndex);

    // Get specific layout:
    Q_INVOKABLE QList<int> getLayout(int iLayoutIndex) const;

    // Return layouts:
    const QMap<int, QList<bool> > &layouts() const;

    // Define default layouts:
    void defineDefaultLayouts();

    // Initialize:
    void initialize();

private:
    // Return # layouts:
    int nLayouts() const;

    // Return max images:
    int maxImages() const;

    // Return current layout:
    int currentLayout() const;

    // Set current layout:
    void setCurrentLayout(int iCurrentLayout);

private:
    // Layouts:
    QMap<int, QList<bool> > mLayouts;

    // Current layout:
    int mCurrentLayout;

signals:
    // # layouts changed:
    void nLayoutsChanged();

    // Max images changed:
    void maxImagesChanged();

    // Layout index changed:
    void layoutIndexChanged();

    // Current layout changed:
    void currentLayoutChanged();
};

#endif // LAYOUTMANAGER_H
