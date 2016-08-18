#include "utils.h"

// To local file:
QString Utils::toLocalFile(const QString &input)
{
    QUrl url(input);
    return url.isLocalFile() ? url.toLocalFile() : input;
}

// From local file:
QString Utils::fromLocalFile(const QString &input)
{
    QUrl url(input);
    return !url.isLocalFile() ? QUrl::fromLocalFile(input).toString() : input;
}

// Return application directory:
QDir Utils::appDir()
{
    return QDir(QCoreApplication::applicationDirPath());
}

// Get files  recursively:
void Utils::files(const QString &srcDir, const QStringList &imageFilters, QStringList &files)
{
    files.clear();
    if (imageFilters.isEmpty())
        return;

    QDirIterator it(srcDir, imageFilters, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext())
        files << fromLocalFile(it.next());
}

// Return path to settings dir:
QString Utils::pathToSettingsDir()
{
    // Find settings dir:
    QDir settingsDir = appDir();

    // Load farmers-common:
    if (settingsDir.cdUp())
        if (settingsDir.cd("menuviewer"))
            if (settingsDir.cd("settings"))
                return settingsDir.absolutePath();

    return "";
}

// Return path to settings files:
QString Utils::pathToSettingsFile()
{
    // Get settings dir path:
    QString settingsDirPath = pathToSettingsDir();
    if (settingsDirPath.isEmpty())
        return "";

    // Get settings dir:
    QDir settingsDir(settingsDirPath);
    QString settingsFile = settingsDir.absoluteFilePath("settings.xml");
    if (QFile::exists(settingsFile))
        return settingsFile;

    return "";
}

// Return path to default settings files:
QString Utils::pathToDefaultSettingsFile()
{
    // Get settings dir path:
    QString settingsDirPath = pathToSettingsDir();
    if (settingsDirPath.isEmpty())
        return "";

    // Get settings dir:
    QDir settingsDir(settingsDirPath);
    QString settingsFile = settingsDir.absoluteFilePath("default_settings.xml");
    if (QFile::exists(settingsFile))
        return settingsFile;

    return "";
}
