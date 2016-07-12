#ifndef CARTMODEL_H
#define CARTMODEL_H
#include <QAbstractListModel>
#include "defs.h"

class CartModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(double cartSubTotal READ cartSubTotal NOTIFY cartSubTotalChanged)
    Q_PROPERTY(double cartTax READ cartTax NOTIFY cartSubTotalChanged)
    Q_PROPERTY(double cartCount READ cartCount NOTIFY cartSubTotalChanged)

public:
    // Constructor:
    CartModel(QObject *parent=0);

    // Row count:
    virtual int rowCount(const QModelIndex &parent=QModelIndex()) const;

    // Data:
    virtual QVariant data(const QModelIndex &index, int role) const;

    // Return role names:
    virtual QHash<int, QByteArray> roleNames() const;

    // Set item count:
    void setItemCount(int count, const QString &vendItemName);

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

    // Return cart subtotal:
    double cartSubTotal() const;

    // Return cart tax:
    double cartTax() const;

    // Return cart count:
    int cartCount() const;

    // Return index of specific item:
    int indexOf(const QString &vendItemName) const;

    // Cart tax:
    static double sCartTaxPercent;

private:
    // Items:
    QList<Item> mItems;

    // Max item count:
    int mMaxItemCount;

signals:
    // Sub total changed:
    void cartSubTotalChanged();
};

#endif // CARTMODEL_H
