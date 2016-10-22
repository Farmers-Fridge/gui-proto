// Application:
#include "layoutmanager.h"
#include <utils.h>

// Qt:
#include <QFile>
#include <cxmlnode.h>

// Constructor:
LayoutManager::LayoutManager(QObject *parent) : QObject(parent),
    mCurrentLayout(0)
{
}

// Initialize:
void LayoutManager::initialize()
{
    // Load settings file:
    QString settingsFile = Utils::pathToSettingsFile("layouts.xml");
    if (QFile::exists(settingsFile))
    {
        CXMLNode layoutsNode = CXMLNode::loadXMLFromFile(settingsFile);
        if (!layoutsNode.nodes().isEmpty())
        {
            foreach (CXMLNode node, layoutsNode.nodes()) {
                QString layoutValue = node.attributes()["value"];
                int nCols = node.attributes()["nCols"].toInt();
                int nRows = node.attributes()["nRows"].toInt();
                QStringList lSplitted = layoutValue.split(",");
                if (lSplitted.size() == nCols*nRows)
                {
                    QList<bool> lLayoutValue;
                    foreach (QString sLayoutValue, lSplitted)
                        lLayoutValue << (sLayoutValue == "true" ? true : false);
                    Layout layout(nCols, nRows);
                    layout.setValues(lLayoutValue);
                    mLayouts << layout;
                }
            }
        }
        else defineDefaultLayouts();
    }
    else defineDefaultLayouts();

    setCurrentLayout(0);
    emit currentLayoutChanged();
}

// Define default layouts:
void LayoutManager::defineDefaultLayouts()
{
    mLayouts.clear();
    for (int i=0; i<MAX_IMAGES; i++) {
        Layout layout(3, 3);
        int nImages = i+1;
        QList<bool> lLayoutValues;
        for (int j=0; j<MAX_IMAGES; j++)
            lLayoutValues << (j < nImages);
        layout.setValues(lLayoutValues);
        mLayouts << layout;
    }

    setCurrentLayout(0);
    emit currentLayoutChanged();
}

// Return # layouts:
int LayoutManager::nLayouts() const
{
    return mLayouts.size();
}

// Cell selected?
bool LayoutManager::cellSelected(int index) const
{
    return mLayouts[mCurrentLayout].cellSelected(index);
}

// Update layout:
void LayoutManager::updateLayout(int startIndex, int endIndex)
{
    if ((startIndex < 0) || (startIndex > (MAX_IMAGES-1)))
        return;
    if ((endIndex < 0) || (endIndex > (MAX_IMAGES-1)))
        return;

    // Check for identity:
    if (startIndex == endIndex)
        return;
    if (!cellSelected(startIndex))
        return;
    if (cellSelected(endIndex))
        return;
    mLayouts[mCurrentLayout].setValue(startIndex, false);
    mLayouts[mCurrentLayout].setValue(endIndex, true);
    emit currentLayoutChanged();
}

// Return current layout:
int LayoutManager::currentLayout() const
{
    return mCurrentLayout;
}

// Set current layout:
void LayoutManager::setCurrentLayout(int iCurrentLayout)
{
    mCurrentLayout = iCurrentLayout;
    emit layoutIndexChanged();
}

// Get lsit of layout filled cells:
QList<int> LayoutManager::getLayoutFilledCells(int iLayoutIndex) const
{
    QList<int> positions;
    if ((iLayoutIndex >= 0) && (iLayoutIndex < mLayouts.size()))
        return mLayouts[iLayoutIndex].positions();
    return positions;
}

// Return layouts:
const QList<Layout> &LayoutManager::layouts() const
{
    return mLayouts;
}
