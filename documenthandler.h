#ifndef DOCUMENTHANDLER_H
#define DOCUMENTHANDLER_H
#include <QQuickTextDocument>
#include <QTextCharFormat>
#include <QTextCodec>
#include <qqmlfile.h>
class QTextDocument;

class DocumentHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem *target READ target WRITE setTarget NOTIFY targetChanged)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition NOTIFY cursorPositionChanged)
    Q_PROPERTY(int selectionStart READ selectionStart WRITE setSelectionStart NOTIFY selectionStartChanged)
    Q_PROPERTY(int selectionEnd READ selectionEnd WRITE setSelectionEnd NOTIFY selectionEndChanged)
    Q_PROPERTY(QColor textColor READ textColor WRITE setTextColor NOTIFY textColorChanged)
    Q_PROPERTY(QString fontFamily READ fontFamily WRITE setFontFamily NOTIFY fontFamilyChanged)
    Q_PROPERTY(bool bold READ bold WRITE setBold NOTIFY boldChanged)
    Q_PROPERTY(bool italic READ italic WRITE setItalic NOTIFY italicChanged)
    Q_PROPERTY(bool underline READ underline WRITE setUnderline NOTIFY underlineChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(QStringList defaultFontSizes READ defaultFontSizes NOTIFY defaultFontSizesChanged)
    Q_PROPERTY(QUrl fileUrl READ fileUrl WRITE setFileUrl NOTIFY fileUrlChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString documentTitle READ documentTitle WRITE setDocumentTitle NOTIFY documentTitleChanged)

public:
    // Constructor:
    DocumentHandler(QObject *parent=0);

    // Get/Set target:
    inline QQuickItem *target() const { return mTarget; }
    void setTarget(QQuickItem *target);

    // Get/Set cursor position:
    inline int cursorPosition() const { return mCursorPosition; }
    void setCursorPosition(int position);

    // Get/Set selection start:
    inline int selectionStart() const { return mSelectionStart; }
    void setSelectionStart(int position);

    // Get/Set selection end:
    inline int selectionEnd() const { return mSelectionEnd; }
    void setSelectionEnd(int position);

    // Get/Set font family:
    QString fontFamily() const;
    void setFontFamily(const QString &arg);

    // Get/Set text color:
    QColor textColor() const;
    void setTextColor(const QColor &arg);

    // Get/Set bold:
    bool bold() const;
    void setBold(bool arg);

    // Get/Set italic:
    bool italic() const;
    void setItalic(bool arg);

    // Get/Set underline:
    bool underline() const;
    void setUnderline(bool arg);

    // Get/Set font size:
    int fontSize() const;
    void setFontSize(int arg);

    // Get/Set file URL:
    QUrl fileUrl() const;
    void setFileUrl(const QUrl &arg);

    // Get/Set Text:
    QString text() const;
    void setText(const QString &arg);

    // Get/Set Document title:
    QString documentTitle() const;
    void setDocumentTitle(QString arg);

    // Defaut font sizes:
    QStringList defaultFontSizes() const;

    // Save as:
    Q_INVOKABLE void saveAs(const QUrl &arg, const QString &fileType);

    // Reset:
    Q_INVOKABLE void reset();

signals:
    // Target changed:
    void targetChanged();

    // Cursor position changed:
    void cursorPositionChanged();

    // Selection start changed:
    void selectionStartChanged();

    // Selection end changed:
    void selectionEndChanged();

    // Font family changed:
    void fontFamilyChanged();

    // Text color changed:
    void textColorChanged();

    // Bold changed:
    void boldChanged();

    // Italic changed:
    void italicChanged();

    // Underline changed:
    void underlineChanged();

    // Font size changed:
    void fontSizeChanged();

    // Default font sizes changed:
    void defaultFontSizesChanged();

    // File url changed:
    void fileUrlChanged();

    // Text changed:
    void textChanged();

    // Document title changed:
    void documentTitleChanged();

    // Error:
    void error(const QString &message);

private:
    // Return text cursor:
    QTextCursor textCursor() const;

    // Merge:
    void mergeFormatOnWordOrSelection(const QTextCharFormat &format);

private:
    // Target:
    QQuickItem *mTarget;

    // Main document:
    QTextDocument *mDoc;

    // Cursor management:
    int mCursorPosition;
    int mSelectionStart;
    int mSelectionEnd;

    // Font:
    QFont mFont;
    int mFontSize;

    // File URL:
    QUrl mFileURL;

    // Text:
    QString mText;

    // Document title:
    QString mDocumentTitle;
};

#endif
