#ifndef UTILS_H
#define UTILS_H
#include <QString>
#include <QUrl>
#include <QDir>
#include <QCoreApplication>
#include <QCryptographicHash>
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

    // Return path to settings dir:
    static QDir pathToSettingsDir();

    // Return path to settings files:
    static QString pathToSettingsFile(const QString &sSettingsFile);

    // Clear directory:
    static bool clearDirectory(const QString &dirName);

    // Save byte array to file:
    static bool save(const QByteArray &bArray, const QString &filePath);

    // Return a file checksum:
    static QString fileCheckSum(const QString &sFileName,
        QCryptographicHash::Algorithm hashAlgorithm=QCryptographicHash::Md5);

    // Clear string (remove non alphanumerical characters):
    static QString clearString(const QString &sInput);

    // Validate email address:
    static bool validateEmailAddress(const QString &emailAddress);

    // Get key:
    static QString getKey(const QString &input);
};

#endif // UTILS_H
