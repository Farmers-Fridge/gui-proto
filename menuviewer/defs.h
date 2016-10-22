#ifndef DEFS_H
#define DEFS_H

// Application:
#include <QString>
#include <QVariant>

enum ItemRole {
    VendItemNameRole = Qt::UserRole+1,
    IconRole,
    NutritionRole,
    CategoryRole,
    PriceRole,
    CountRole
};

struct Item {
    // Default constructor:
    Item() : _vendItemName(""), _icon(""), _nutrition(""),
        _category(""), _price(0.), _count(0)
    {

    }
    // Constructor:
    Item(const QString &vendItemName, const QString &icon,
         const QString &nutrition, const QString &category,
         const QString &price)
    {
        _vendItemName = vendItemName;
        _icon = icon;
        _nutrition = nutrition;
        _category = category;
        QString localPrice = price.simplified().replace("$", "");
        bool ok = false;
        double dPrice = localPrice.toDouble(&ok);
        _price = ok ? dPrice : 0.;
        _count = 1;
    }
    // Increment:
    void increment()
    {
        _count++;
    }
    // Decrement:
    void decrement()
    {
        if (_count > 0)
            _count--;
    }
    // Return data for role:
    QVariant data(int role) const
    {
        if (role == VendItemNameRole)
            return _vendItemName;
        if (role == IconRole)
            return _icon;
        if (role == NutritionRole)
            return _nutrition;
        if (role == CategoryRole)
            return _category;
        if (role == PriceRole)
            return _price;
        if (role == CountRole)
            return _count;
        return QVariant();
    }
    QString _vendItemName;
    QString _icon;
    QString _nutrition;
    QString _category;
    double _price;
    int _count;
};

#endif // DEFS_H
