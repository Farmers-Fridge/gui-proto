#include "layoutmanager.h"

// Constructor:
LayoutManager::LayoutManager(QObject *parent) : QObject(parent),
    m_iCurrentLayout(0)
{
    defineDefaultLayouts();
}

// Define default layouts:
void LayoutManager::defineDefaultLayouts()
{
    for (int i=0; i<MAX_IMAGES; i++) {
        QList<bool> vLayout;
        int nImages = i+1;
        for (int j=0; j<MAX_IMAGES; j++)
            vLayout << (j < nImages);
        m_mLayouts[i] = vLayout;
    }
    emit nLayoutsChanged();
}

// Return # layouts:
int LayoutManager::nLayouts() const
{
    return m_mLayouts.size();
}

// Return max images:
int LayoutManager::maxImages() const
{
    return MAX_IMAGES;
}

// Cell selected?
bool LayoutManager::cellSelected(int index) const
{
    return m_mLayouts[m_iCurrentLayout][index];
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
    m_mLayouts[m_iCurrentLayout][startIndex] = false;
    m_mLayouts[m_iCurrentLayout][endIndex] = true;
    emit currentLayoutChanged();
}

// Return current layout:
int LayoutManager::currentLayout() const
{
    return m_iCurrentLayout;
}

// Set current layout:
void LayoutManager::setCurrentLayout(int iCurrentLayout)
{
    m_iCurrentLayout = iCurrentLayout;
    emit layoutIndexChanged();
}

// Get specific layout:
QList<int> LayoutManager::getLayout(int iLayoutIndex) const
{
    QList<int> positions;
    if (m_mLayouts.contains(iLayoutIndex))
    {
        QList<bool> lValues = m_mLayouts[iLayoutIndex];
        for (int i=0; i<lValues.size(); i++)
        {
            if (lValues[i])
                positions << i;
        }
    }
    return positions;
}
