#-------------------------------------------------
#
# Project created by QtCreator 2016-01-18T09:04:28
#
#-------------------------------------------------

QT       += core gui network xml quick

TEMPLATE = lib
DEFINES += FARMERSCLIENT_LIBRARY
INCLUDEPATH += $$PWD/../farmers-utils

unix {
    DESTDIR = ../bin
    MOC_DIR = ../moc
    OBJECTS_DIR = ../obj
}

win32 {
    DESTDIR = ..\\bin
    MOC_DIR = ..\\moc
    OBJECTS_DIR = ..\\obj
}

QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
QMAKE_CLEAN *= $$MOC_DIR\\*$$TARGET*
QMAKE_CLEAN *= $$OBJECTS_DIR\\*$$TARGET*

CONFIG(debug, debug|release) {
    LIBS += -L$$PWD/../bin/ -lfarmers-utilsd
    TARGET = farmers-clientd
} else {
    LIBS += -L$$PWD/../bin/ -lfarmers-utils
    TARGET = farmers-client
}

HEADERS += \
    httpworker.h \
    farmersfridgeclient.h \
    httpdownloader.h \
    farmers-client-global.h \
    message.h

SOURCES += \
    httpworker.cpp \
    farmersfridgeclient.cpp \
    httpdownloader.cpp \
    message.cpp

