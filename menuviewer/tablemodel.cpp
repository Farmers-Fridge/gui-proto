// Application:
#include "tablemodel.h"

// Qt:
#include <QFileInfo>
#include <QDebug>

// Constructor:
TableModel::TableModel(QObject *parent) : QAbstractListModel(parent)
{

}

// Return row count:
int TableModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mDataModel.size();
}

// Data:
QVariant TableModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if (role == RowIndexRole)
        return index.row();
    return QVariant();
}

// Return role names:
QHash<int, QByteArray> TableModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[RowIndexRole] = "rowIndex";
    return roles;
}

// Set XML file:
void TableModel::load(const QString &xmlString, const QStringList &targetColumns)
{
    // Check XML string:
    if (xmlString.isEmpty())
        return;

    // Clear previous data:
    clear();

    // Set target columns:
    mTargetColumns = targetColumns;

    // Reload:
    beginResetModel();

    // Set root node:
    mRootNode = CXMLNode::parseXML(xmlString);

    // Parse available tags:
    parseTags(mRootNode);

    // Parse available tags:
    fillDataModel();

    // End reset:
    endResetModel();
}

// Parse tags:
void TableModel::parseTags(const CXMLNode &node)
{
    QVector<CXMLNode> nodes = node.getNodesByTagName("item");
    foreach (CXMLNode node, nodes)
    {
        QVector<CXMLNode> childNodes = node.nodes();
        foreach (CXMLNode childNode, childNodes)
        {
            QString tag = childNode.tag();
            mAvailableColumns.insert(tag);
        }
    }
}

// Fill data model:
void TableModel::fillDataModel()
{
    // Filter target columns:
    foreach (QString targetColumn, mTargetColumns)
    {
        // Make sure target column exists in dataset:
        if (!mAvailableColumns.contains(targetColumn))
            mTargetColumns.removeAll(targetColumn);

        // Don't care about color (treated automatically):
        if (targetColumn.contains("color", Qt::CaseInsensitive))
            mTargetColumns.removeAll(targetColumn);
    }

    // Empty?
    if (mTargetColumns.isEmpty())
        return;

    // Get all items:
    QVector<CXMLNode> nodes = mRootNode.getNodesByTagName("item");
    foreach (CXMLNode node, nodes)
    {
        QVariantMap values;
        foreach (QString targetColumn, mAvailableColumns)
        {
            CXMLNode childNode = node.getNodeByTagName(targetColumn);
            values[targetColumn] = childNode.value();
        }
        mDataModel << values;
    }
}

// Clear:
void TableModel::clear()
{
    beginResetModel();
    mAvailableColumns.clear();
    mTargetColumns.clear();
    mDataModel.clear();
    endResetModel();
}

// Return col count:
int TableModel::colCount() const
{
    return mTargetColumns.size();
}

// Return target cols:
const QStringList &TableModel::targetCols() const
{
    return mTargetColumns;
}

// Get cell data:
QVariant TableModel::getCellData(int col, int row) const
{
    if (col > (mTargetColumns.size()-1))
        return QVariant();
    if (row > (mDataModel.size()-1))
        return QVariant();
    QString targetCol = mTargetColumns[col];
    return mDataModel[row][targetCol];
}

// Get cell color:
QString TableModel::getCellColor(int col, int row) const
{
    if (col > (mTargetColumns.size()-1))
        return "black";
    if (row > (mDataModel.size()-1))
        return "black";
    QString targetCol = mTargetColumns[col];
    QString colorTag = targetCol + "Color";
    if (!mDataModel[row].contains(colorTag))
        return "black";
    return mDataModel[row][colorTag].toString();
}
