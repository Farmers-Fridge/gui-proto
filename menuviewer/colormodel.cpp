// Application:
#include "colormodel.h"
#include "utils.h"
#include <cxmlnode.h>

// Constructor:
ColorModel::ColorModel(QObject *parent) : QAbstractListModel(parent)
{

}

// Initialize:
void ColorModel::initialize()
{
    // Load settings file:
    QString settingsFile = Utils::pathToSettingsFile("colors.xml");
    if (QFile::exists(settingsFile))
    {
        beginResetModel();
        CXMLNode colorNode = CXMLNode::loadXMLFromFile(settingsFile);
        if (colorNode.nodes().length() > 0)
        {
            beginResetModel();
            foreach (CXMLNode node, colorNode.nodes()) {
                QString colorName = node.attributes()["name"];
                QString colorValue = node.attributes()["value"];
                mColors[colorName] = colorValue;
            }
            endResetModel();
        }
        else useHardCodedSettings();
    }
    else useHardCodedSettings();
}

// Return role names:
QHash<int, QByteArray> ColorModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames[COLOR_NAME] = "colorName";
    roleNames[COLOR_VALUE] = "colorValue";
    return roleNames;
}

// Return row count:
int ColorModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mColors.size();
}

// Return data:
QVariant ColorModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if ((index.row() < 0) || (index.row() > (rowCount()-1)))
        return QVariant();

    QString colorName = mColors.keys()[index.row()];
    QString colorValue = mColors[colorName].toString();
    if (role == COLOR_NAME)
        return colorName;
    if (role == COLOR_VALUE)
        return colorValue;

    return QVariant();
}

// Return colors:
QVariant ColorModel::colors()
{
    return mColors;
}

// Set color value:
void ColorModel::setColorValue(int colorIndex, const QString &colorValue)
{
    if ((colorIndex >= 0) && (colorIndex < rowCount()))
    {
        QString colorName = mColors.keys()[colorIndex];
        mColors[colorName] = colorValue;
        emit dataChanged(index(colorIndex, 0, QModelIndex()), index(colorIndex, 0, QModelIndex()));
        emit updateColors();
    }
}

// Use hard coded settings:
void ColorModel::useHardCodedSettings()
{
    beginResetModel();
    mColors.clear();
    mColors["ffColor1"] = "#858687";
    mColors["ffColor2"] = "#F6F8F3";
    mColors["ffColor3"] = "#BCD4B9";
    mColors["ffColor4"] = "lightgreen";
    mColors["ffColor5"] = "darkgreen";
    mColors["ffColor6"] = "lightgray";
    mColors["ffColor7"] = "#606365";
    mColors["ffColor8"] = "#57585C";
    mColors["ffColor9"] = "#BABCB9";
    mColors["ffColor10"] = "#92B772";
    mColors["ffColor11"] = "#DADFDB";
    mColors["ffColor12"] = "orange";
    mColors["ffColor13"] = "transparent";
    mColors["ffColor14"] = "#9B5A3C";
    mColors["ffColor15"] = "red";
    mColors["ffColor16"] = "white";
    mColors["ffColor17"] = "#C8DBC7";
    mColors["ffColor18"] = "#E1D9C6";
    mColors["ffColor19"] = "#BABBAB";
    endResetModel();
}
