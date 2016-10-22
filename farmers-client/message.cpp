// Application:
#include "message.h"

// Default constructor:
Message::Message() : m_sMessage(""), m_eMessageType(Message::OK)
{

}

// Constructor:
Message::Message(const QString &sMessage, const MsgType &eMsgType) :
    m_sMessage(sMessage), m_eMessageType(eMsgType)
{

}

// Return message:
const QString &Message::message() const
{
    return m_sMessage;
}

// Return message type:
const Message::MsgType &Message::messageType() const
{
    return m_eMessageType;
}
