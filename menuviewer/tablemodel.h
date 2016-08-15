#ifndef TABLEMODEL_H
#define TABLEMODEL_H
#include <QAbstractListModel>
#include <QSet>
#include <cxmlnode.h>

class TableModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int colCount READ colCount NOTIFY colCountChanged)
    Q_PROPERTY(QStringList targetCols READ targetCols NOTIFY targetColsChanged)

public:
    enum {RowIndexRole = Qt::UserRole+1};

    // Constructor:
    TableModel(QObject *parent=0);

    // Return row count:
    virtual int rowCount(const QModelIndex &parent=QModelIndex()) const;

    // Data:
    virtual QVariant data(const QModelIndex &index, int role) const;

    // Return role names:
    virtual QHash<int, QByteArray> roleNames() const;

    // Load:
    Q_INVOKABLE void load(const QString &xmlString, const QStringList &targetColumns);

    // Get cell data:
    Q_INVOKABLE QVariant getCellData(int col, int row) const;

    // Get cell color:
    Q_INVOKABLE QString getCellColor(int col, int row) const;

private:
    // Parse tags:
    void parseTags(const CXMLNode &node);

    // Fill data model:
    void fillDataModel();

    // Clear:
    void clear();

    // Return col count:
    int colCount() const;

    // Return target cols:
    const QStringList &targetCols() const;

private:
    // Root node:
    CXMLNode mRootNode;

    // Available columns:
    QSet<QString> mAvailableColumns;

    // Target columns:
    QStringList mTargetColumns;

    // Data model:
    QList<QVariantMap> mDataModel;

signals:
    void colCountChanged();
    void targetColsChanged();
};

#endif // TABLEMODEL_H
