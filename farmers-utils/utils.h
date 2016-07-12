#ifndef UTILS_H
#define UTILS_H
#include <QString>
#include <QUrl>
#include <QDir>
#include <QCoreApplication>
#include <QDirIterator>
#include "farmers-utils_global.h"

class FARMERSUTILSSHARED_EXPORT Utils
{
public:
    // To local file:
    static QString toLocalFile(const QString &input);

    // From local file:
    static QString fromLocalFile(const QString &input);

    // Return application directory:
    static QDir appDir();

    // Get files  recursively:
    static void files(const QString &srcDir, const QStringList &imageFilters, QStringList &files);
};

#endif // UTILS_H
