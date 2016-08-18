#ifndef COLORMODEL_H
#define COLORMODEL_H
#include <QAbstractListModel>

class ColorModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum {COLOR_NAME=0, COLOR_VALUE};

    // Constructor:
    ColorModel(QObject *parent=0);

    // Initialize:
    void initialize();

    // Return role names:
    virtual QHash<int, QByteArray> roleNames() const;

    // Return row count:
    virtual int rowCount(const QModelIndex &parent=QModelIndex()) const;

    // Return data:
    virtual QVariant data(const QModelIndex &index, int role) const;

    // Return color:
    QVariant colors();

    // Use hard coded settings:
    void useHardCodedSettings();

    // Set color value:
    Q_INVOKABLE void setColorValue(int colorIndex, const QString &colorValue);

private:
    // Colors:
    QVariantMap mColors;

signals:
    // Update colors:
    void updateColors();
};

#endif // COLORMODEL_H
