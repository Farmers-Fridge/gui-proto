#include "layoutmanager.h"
#include <QFile>
#include <cxmlnode.h>
#include <utils.h>

// Constructor:
LayoutManager::LayoutManager(QObject *parent) : QObject(parent),
    mCurrentLayout(0)
{
}

// Initialize:
void LayoutManager::initialize()
{
    // Load settings file:
    QString settingsFile = Utils::pathToSettingsFile();
    if (QFile::exists(settingsFile))
    {
        CXMLNode rootNode = CXMLNode::loadXMLFromFile(settingsFile);
        CXMLNode colorNode = rootNode.getNodeByTagName("Layouts");

        if (!colorNode.nodes().isEmpty())
        {
            foreach (CXMLNode node, colorNode.nodes()) {
                QString layoutId = node.attributes()["id"];
                QString layoutValue = node.attributes()["value"];
                QStringList splitted = layoutValue.split(",");
                QList<bool> lLayoutValue;
                foreach (QString sLayoutValue, splitted)
                    lLayoutValue << (sLayoutValue == "true" ? true : false);
                mLayouts[layoutId.toInt()] = lLayoutValue;
            }
        }
        else defineDefaultLayouts();
    }
    else defineDefaultLayouts();

    emit nLayoutsChanged();
}

// Define default layouts:
void LayoutManager::defineDefaultLayouts()
{
    for (int i=0; i<MAX_IMAGES; i++) {
        QList<bool> vLayout;
        int nImages = i+1;
        for (int j=0; j<MAX_IMAGES; j++)
            vLayout << (j < nImages);
        mLayouts[i] = vLayout;
    }
    emit nLayoutsChanged();
}

// Return # layouts:
int LayoutManager::nLayouts() const
{
    return mLayouts.size();
}

// Return max images:
int LayoutManager::maxImages() const
{
    return MAX_IMAGES;
}

// Cell selected?
bool LayoutManager::cellSelected(int index) const
{
    return mLayouts[mCurrentLayout][index];
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
    mLayouts[mCurrentLayout][startIndex] = false;
    mLayouts[mCurrentLayout][endIndex] = true;
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

// Get specific layout:
QList<int> LayoutManager::getLayout(int iLayoutIndex) const
{
    QList<int> positions;
    if (mLayouts.contains(iLayoutIndex))
    {
        QList<bool> lValues = mLayouts[iLayoutIndex];
        for (int i=0; i<lValues.size(); i++)
        {
            if (lValues[i])
                positions << i;
        }
    }
    return positions;
}

// Return layouts:
const QMap<int, QList<bool> > &LayoutManager::layouts() const
{
    return mLayouts;
}