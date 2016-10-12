#include "messagemodel.h"

// Constructor:
MessageModel::MessageModel(QObject *parent) : QAbstractListModel(parent)
{

}

// Return row count:
int MessageModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mMessages.size();
}

// Return data:
QVariant MessageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == MsgText)
        return mMessages[index.row()].message();
    if (role == MsgType)
        return mMessages[index.row()].messageType();

    return QVariant();
}

// Role names:
QHash<int, QByteArray> MessageModel::roleNames() const
{
    QHash<int, QByteArray> hRoleNames;
    hRoleNames[MsgText] = "msgText";
    hRoleNames[MsgType] = "msgType";
    return hRoleNames;
}

// Set messages:
void MessageModel::setMessages(const QVector<Message> &vMessages)
{
    beginResetModel();
    mMessages = vMessages;
    endResetModel();
}
