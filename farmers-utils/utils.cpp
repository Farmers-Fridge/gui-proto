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
