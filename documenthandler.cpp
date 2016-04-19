#include "documenthandler.h"
#include <QTextDocument>
#include <QTextCursor>
#include <QFontDatabase>
#include <QFileInfo>

// Constructor:
DocumentHandler::DocumentHandler(QObject *parent) : QObject(parent),
    mTarget(0),
    mDoc(0),
    mCursorPosition(-1),
    mSelectionStart(0),
    mSelectionEnd(0)
{
}

// Set target:
void DocumentHandler::setTarget(QQuickItem *target)
{
    mDoc = 0;

    // Check target:
    mTarget = target;
    if (!mTarget)
        return;

    // Build text document:
    QVariant doc = mTarget->property("textDocument");
    if (doc.canConvert<QQuickTextDocument*>())
    {
        QQuickTextDocument *qqdoc = doc.value<QQuickTextDocument*>();
        if (qqdoc)
            mDoc = qqdoc->textDocument();
    }

    // Notify:
    emit targetChanged();
}

// Set file url:
void DocumentHandler::setFileUrl(const QUrl &arg)
{
    if (mFileURL != arg)
    {
        mFileURL = arg;
        QString fileName = QQmlFile::urlToLocalFileOrQrc(arg);
        if (QFile::exists(fileName))
        {
            QFile file(fileName);
            if (file.open(QFile::ReadOnly))
            {
                QByteArray data = file.readAll();
                QTextCodec *codec = QTextCodec::codecForHtml(data);
                setText(codec->toUnicode(data));
                if (mDoc)
                    mDoc->setModified(false);
                if (fileName.isEmpty())
                    mDocumentTitle = QStringLiteral("untitled.txt");
                else
                    mDocumentTitle = QFileInfo(fileName).fileName();

                // Notify:
                emit textChanged();
                emit documentTitleChanged();

                // Reset:
                reset();
            }
        }
        emit fileUrlChanged();
    }
}

// Return document title:
QString DocumentHandler::documentTitle() const
{
    return mDocumentTitle;
}

// Set document title:
void DocumentHandler::setDocumentTitle(QString arg)
{
    if (mDocumentTitle != arg)
    {
        mDocumentTitle = arg;
        emit documentTitleChanged();
    }
}

// Set text:
void DocumentHandler::setText(const QString &arg)
{
    if (mText != arg)
    {
        mText = arg;
        emit textChanged();
    }
}

// Save as:
void DocumentHandler::saveAs(const QUrl &arg, const QString &fileType)
{
    bool isHtml = fileType.contains(QLatin1String("htm"));
    QLatin1String ext(isHtml ? ".html" : ".txt");
    QString localPath = arg.toLocalFile();
    if (!localPath.endsWith(ext))
        localPath += ext;
    QFile f(localPath);
    if (!f.open(QFile::WriteOnly | QFile::Truncate | (isHtml ? QFile::NotOpen : QFile::Text)))
    {
        emit error(tr("Cannot save: ") + f.errorString());
        return;
    }
    f.write((isHtml ? mDoc->toHtml() : mDoc->toPlainText()).toLocal8Bit());
    f.close();
    qDebug() << "saved to" << localPath;
    setFileUrl(QUrl::fromLocalFile(localPath));
}

// Return file url:
QUrl DocumentHandler::fileUrl() const
{
    return mFileURL;
}

// Return text:
QString DocumentHandler::text() const
{
    return mText;
}

// Set cursor position:
void DocumentHandler::setCursorPosition(int position)
{
    if (position == mCursorPosition)
        return;

    mCursorPosition = position;

    reset();
}

// Reset:
void DocumentHandler::reset()
{
    emit fontFamilyChanged();
    emit boldChanged();
    emit italicChanged();
    emit underlineChanged();
    emit fontSizeChanged();
    emit textColorChanged();
}

// Return text cursor:
QTextCursor DocumentHandler::textCursor() const
{
    QTextCursor cursor = QTextCursor(mDoc);
    if (mSelectionStart != mSelectionEnd)
    {
        cursor.setPosition(mSelectionStart);
        cursor.setPosition(mSelectionEnd, QTextCursor::KeepAnchor);
    }
    else cursor.setPosition(mCursorPosition);
    return cursor;
}

// Merge format on word or selection:
void DocumentHandler::mergeFormatOnWordOrSelection(const QTextCharFormat &format)
{
    QTextCursor cursor = textCursor();
    if (!cursor.hasSelection())
        cursor.select(QTextCursor::WordUnderCursor);
    cursor.mergeCharFormat(format);
}

// Set selection start:
void DocumentHandler::setSelectionStart(int position)
{
    mSelectionStart = position;
}

// Set selection end:
void DocumentHandler::setSelectionEnd(int position)
{
    mSelectionEnd = position;
}

// Return bold state:
bool DocumentHandler::bold() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontWeight() == QFont::Bold;
}

// Return italic state:
bool DocumentHandler::italic() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontItalic();
}

// Return underline text:
bool DocumentHandler::underline() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontUnderline();
}

// Set bold:
void DocumentHandler::setBold(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontWeight(arg ? QFont::Bold : QFont::Normal);
    mergeFormatOnWordOrSelection(fmt);
    emit boldChanged();
}

// Set italic:
void DocumentHandler::setItalic(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontItalic(arg);
    mergeFormatOnWordOrSelection(fmt);
    emit italicChanged();
}

// Set underline:
void DocumentHandler::setUnderline(bool arg)
{
    QTextCharFormat fmt;
    fmt.setFontUnderline(arg);
    mergeFormatOnWordOrSelection(fmt);
    emit underlineChanged();
}

// Return font size:
int DocumentHandler::fontSize() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return 0;
    QTextCharFormat format = cursor.charFormat();
    return format.font().pointSize();
}

// Set font size:
void DocumentHandler::setFontSize(int arg)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setFontPointSize(arg);
    mergeFormatOnWordOrSelection(format);
    emit fontSizeChanged();
}

// Return text color:
QColor DocumentHandler::textColor() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QColor(Qt::black);
    QTextCharFormat format = cursor.charFormat();
    return format.foreground().color();
}

// Set text color:
void DocumentHandler::setTextColor(const QColor &c)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setForeground(QBrush(c));
    mergeFormatOnWordOrSelection(format);
    emit textColorChanged();
}

// Return font family:
QString DocumentHandler::fontFamily() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QString();
    QTextCharFormat format = cursor.charFormat();
    return format.font().family();
}

// Set font family:
void DocumentHandler::setFontFamily(const QString &arg)
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;
    QTextCharFormat format;
    format.setFontFamily(arg);
    mergeFormatOnWordOrSelection(format);
    emit fontFamilyChanged();
}

// Return default font sizes:
QStringList DocumentHandler::defaultFontSizes() const
{
    // uhm... this is quite ugly
    QStringList sizes;
    QFontDatabase db;
    foreach (int size, db.standardSizes())
        sizes.append(QString::number(size));
    return sizes;
}
