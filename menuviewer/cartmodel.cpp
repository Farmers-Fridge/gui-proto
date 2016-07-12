#include "cartmodel.h"
#include <QDebug>

double CartModel::sCartTaxPercent = .09;

// Constructor:
CartModel::CartModel(QObject *parent) : QAbstractListModel(parent),
    mMaxItemCount(15)
{

}

// Return row count:
int CartModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mItems.size();
}

// Return data:
QVariant CartModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if ((index.row() < 0) || (index.row() > (mItems.size()-1)))
        return QVariant();
    return mItems[index.row()].data(role);
}

// Return role names:
QHash<int, QByteArray> CartModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[VendItemNameRole] = "vendItemName";
    roles[IconRole] = "icon";
    roles[NutritionRole] = "nutrition";
    roles[CategoryRole] = "category";
    roles[PriceRole] = "price";
    roles[CountRole] = "count";
    return roles;
}

// Increment item count:
void CartModel::setItemCount(int count, const QString &vendItemName)
{
    Item item;
    int itemIndex = -1;

    // Get item:
    if (!getItem(vendItemName, item, itemIndex))
        return;

    // Set item count:
    item._count = count;

    // Item count is null, remove item:
    if (item._count < 1)
    {
        beginRemoveRows(QModelIndex(), itemIndex, itemIndex);
        mItems.removeAt(itemIndex);
        endRemoveRows();
    }
    else
    {
        // Replace:
        mItems.replace(itemIndex, item);

        // Notify:
        emit dataChanged(index(itemIndex, 0), index(itemIndex, 0));
    }

    qDebug() << vendItemName << " COUNT: " << item._count;

    // Subtotal changed:
    emit cartSubTotalChanged();
}

// Get item:
bool CartModel::getItem(const QString &vendItemName, Item &item, int &itemIndex) const
{
    for (int i=0; i<mItems.size(); i++)
    {
        if (mItems[i]._vendItemName.compare(vendItemName, Qt::CaseInsensitive) == 0)
        {
            item = mItems[i];
            itemIndex = i;
            return true;
        }
    }
    return false;
}

// Add item:
void CartModel::addItem(const QString &vendItemName, const QString &icon,
    const QString &nutrition, const QString &category, const QString &price)
{
    // Already added?
    Item item;
    int itemIndex = -1;
    if (getItem(vendItemName, item, itemIndex))
    {
        setItemCount(++item._count, vendItemName);
        return;
    }

    // Did we reach max?
    if (mItems.size() == mMaxItemCount)
        return;

    // Insert:
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mItems << Item(vendItemName, icon, nutrition, category, price);
    endInsertRows();

    // Update cart total:
    emit cartSubTotalChanged();
}

// Remove item:
void CartModel::removeItem(const QString &vendItemName)
{
    int itemIndex = indexOf(vendItemName);
    if (itemIndex < 0)
        return;
    beginRemoveRows(QModelIndex(), itemIndex, itemIndex);
    mItems.removeAt(itemIndex);
    endRemoveRows();

    // Update cart total:
    emit cartSubTotalChanged();
}

// Return cart subtotal:
double CartModel::cartSubTotal() const
{
    double total = 0.;
    for (int i=0; i<mItems.size(); i++)
        total += mItems[i]._count*mItems[i]._price;
    return total;
}

// Return cart taxt:
double CartModel::cartTax() const
{
    return sCartTaxPercent*cartSubTotal();
}

// Return cart count:
int CartModel::cartCount() const
{
    int count = 0;
    for (int i=0; i<mItems.size(); i++)
        count += mItems[i]._count;
    return count;
}

// Return index of specific item:
int CartModel::indexOf(const QString &vendItemName) const
{
    for (int i=0; i<mItems.size(); i++)
    {
        QString currentItemName = mItems[i]._vendItemName;
        if (currentItemName.compare(vendItemName, Qt::CaseInsensitive) == 0)
            return i;
    }
    return -1;
}

// Clear:
void CartModel::clear()
{
    beginResetModel();
    mItems.clear();
    endResetModel();
    emit cartSubTotalChanged();
}
