#ifndef MESSAGE_H
#define MESSAGE_H

// Application:
#include "farmers-client-global.h"

// Qt:
#include <QString>

class FARMERSCLIENTVERSHARED_EXPORT Message
{
public:
    enum MsgType {OK=0, WARNING, ERROR, INFO, NEED_UPDATE, DONT_NEED_UPDATE, TIMEOUT};

    // Default constructor:
    Message();

    // Constructor:
    Message(const QString &sMessage, const MsgType &eMsgType);

    // Return message:
    const QString &message() const;

    // Return message type:
    const MsgType &messageType() const;

private:
    QString m_sMessage;
    MsgType m_eMessageType;
};

#endif // MESSAGE_H
