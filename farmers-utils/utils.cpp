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

// Clear directory:
bool Utils::clearDirectory(const QString &dirName)
{
    bool result = true;
    QDir dir(dirName);

    if (dir.exists(dirName)) {
        Q_FOREACH(QFileInfo info, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::System | QDir::Hidden  | QDir::AllDirs | QDir::Files, QDir::DirsFirst)) {
            if (info.isDir()) {
                result = clearDirectory(info.absoluteFilePath());
            }
            else {
                result = QFile::remove(info.absoluteFilePath());
            }

            if (!result) {
                return result;
            }
        }
        result = dir.rmdir(dirName);
    }

    return result;
}

// Save byte array to file:
bool Utils::save(const QByteArray &bArray, const QString &filePath)
{
    if (bArray.isEmpty() || bArray.isNull())
        return false;
    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly))
    {
        file.write(bArray);
        file.close();
    }
    return true;
}
