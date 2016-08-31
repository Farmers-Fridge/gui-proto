#-------------------------------------------------
#
# Project created by QtCreator 2016-01-18T09:04:28
#
#-------------------------------------------------

QT       += core gui network xml quick

TEMPLATE = lib
DEFINES += FARMERSSERVER_LIBRARY
INCLUDEPATH += $$PWD/../farmers-utils

unix {
    DESTDIR = ../lib
    MOC_DIR = ../moc
    OBJECTS_DIR = ../obj
}

win32 {
    DESTDIR = ..\\lib
    MOC_DIR = ..\\moc
    OBJECTS_DIR = ..\\obj
}

QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
QMAKE_CLEAN *= $$MOC_DIR\\*$$TARGET*
QMAKE_CLEAN *= $$OBJECTS_DIR\\*$$TARGET*

CONFIG(debug, debug|release) {
    LIBS += -L$$PWD/../lib/ -lfarmers-utilsd
    TARGET = farmers-serverd
} else {
    LIBS += -L$$PWD/../lib/ -lfarmers-utils
    TARGET = farmers-server
}

HEADERS += \
    farmersfridgeserver.h \
    farmers-server_global.h \
    httpworker.h \
    constants.h

SOURCES += \
    farmersfridgeserver.cpp \
    httpworker.cpp

