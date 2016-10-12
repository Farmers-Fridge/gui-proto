#ifndef LAYOUT_H
#define LAYOUT_H
#include <QList>

#define ROW_MIN 1
#define ROW_MAX 3
#define COL_MIN 1
#define COL_MAX 3

struct Layout
{
    // Constructor:
    Layout(int nCols, int nRows) {
        if (nCols < COL_MIN)
            nCols = COL_MIN;
        if (nCols > COL_MAX)
            nCols = COL_MAX;
        if (nRows < ROW_MIN)
            nRows = ROW_MIN;
        if (nRows > ROW_MAX)
            nRows = ROW_MAX;
        this->nCols = nCols;
        this->nRows = nRows;
    }

    // Set value:
    void setValue(int index, bool bValue)
    {
        if ((index < 0) || (index > (nImages()-1)))
            return;
        this->lValues[index] = bValue;
    }

    // Return value:
    bool value(int index) const
    {
        return this->lValues[index];
    }

    // Set values:
    void setValues(const QList<bool> &lValues)
    {
        if (lValues.size() != this->nCols*this->nRows)
            return;
        this->nCols = this->nCols;
        this->nRows = this->nRows;
        this->lValues = lValues;
    }

    // Return values:
    QList<bool> values() const
    {
        return this->lValues;
    }

    // Return positions:
    QList<int> positions() const
    {
        QList<int> lPositions;
        for (int i=0; i<this->lValues.size(); i++)
            if (this->lValues[i])
                lPositions << i;
        return lPositions;
    }

    // Return number of images in layout:
    int nImages() const
    {
        return nCols*nRows;
    }

    // Return true if cell selected:
    bool cellSelected(int index) const
    {
        if ((index < 0) || (index > (nImages()-1)))
            return false;
        return this->lValues[index];
    }

    int nCols;
    int nRows;
    QList<bool> lValues;
};

#endif // LAYOUT_H
