#ifndef CARTMODEL_H
#define CARTMODEL_H
#include <QAbstractListModel>
#include "defs.h"

class CartModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(double cartTotal READ cartTotal NOTIFY cartTotalChanged)
    Q_PROPERTY(double cartCount READ cartCount NOTIFY cartTotalChanged)

public:
    // Constructor:
    CartModel(QObject *parent=0);

    // Row count:
    virtual int rowCount(const QModelIndex &parent=QModelIndex()) const;

    // Data:
    virtual QVariant data(const QModelIndex &index, int role) const;

    // Return role names:
    virtual QHash<int, QByteArray> roleNames() const;

    // Increment item count:
    void incrementItemCount(const QString &vendItemName);

    // Decrement item count:
    void decrementItemCount(const QString &vendItemName);

    // Add item:
    void addItem(const QString &vendItemName, const QString &icon,
        const QString &nutrition, const QString &category, const QString &price);

    // Remove item:
    void removeItem(const QString &vendItemName);

    // Clear:
    void clear();

private:
    // Get item:
    bool getItem(const QString &vendItemName, Item &item, int &itemIndex) const;

    // Return cart total:
    double cartTotal() const;

    // Return cart count:
    int cartCount() const;

    // Return index of specific item:
    int indexOf(const QString &vendItemName) const;

private:
    // Items:
    QList<Item> mItems;

    // Max item count:
    int mMaxItemCount;

signals:
    // Cart changed:
    void cartTotalChanged();
};

#endif // CARTMODEL_H
