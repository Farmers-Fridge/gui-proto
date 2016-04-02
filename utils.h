#ifndef UTILS_H
#define UTILS_H
#include <QString>
#include <QUrl>
#include <QDir>
#include <QCoreApplication>

class Utils
{

public:
    // To local file:
    static QString toLocalFile(const QString &input)
    {
        QUrl url(input);
        return url.isLocalFile() ? url.toLocalFile() : input;
    }

    // From local file:
    static QString fromLocalFile(const QString &input)
    {
        QUrl url(input);
        return !url.isLocalFile() ? QUrl::fromLocalFile(input).toString() : input;
    }

    // Return application directory:
    static QDir appDir()
    {
        return QDir(QCoreApplication::applicationDirPath());
    }

    // Return path to preferences.ini:
    static QString pathToPreferencesDotIni()
    {
        // Read preferences.ini:
        QDir applicationDir = appDir();
        applicationDir.cdUp();
        applicationDir.cd("ini");
        return applicationDir.filePath("preferences.ini");
    }
};

#endif // UTILS_H
