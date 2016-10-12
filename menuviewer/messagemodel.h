#ifndef MESSAGEMODEL_H
#define MESSAGEMODEL_H
#include <QAbstractListModel>
#include "farmersfridgeclient.h"
#include <message.h>

class MessageModel : public QAbstractListModel
{
public:
    enum MessageDesc {MsgText=0, MsgType};
    Q_ENUMS(MessageDesc)

    // Constructor:
    MessageModel(QObject *parent=0);

    // Return row count:
    virtual int rowCount(const QModelIndex &parent=QModelIndex()) const;

    // Return data:
    virtual QVariant data(const QModelIndex &index, int role) const;

    // Role names:
    virtual QHash<int, QByteArray> roleNames() const;

    // Set messages:
    void setMessages(const QVector<Message> &vMessages);

private:
    // Messages:
    QVector<Message> mMessages;
};

#endif // MESSAGEMODEL_H
