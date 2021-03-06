#-------------------------------------------------
#
# Project created by QtCreator 2016-01-18T09:04:28
#
#-------------------------------------------------

QT       += core gui network xml quick

TEMPLATE = lib
DEFINES += FARMERSUTILS_LIBRARY

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
    TARGET = farmers-utilsd
} else {
    TARGET = farmers-utils
}

HEADERS += \
    csingleton.h \
    cxmlnode.h \
    documenthandler.h \
    eventwatcher.h \
    farmers-utils_global.h \
    utils.h

SOURCES += \
    cxmlnode.cpp \
    documenthandler.cpp \
    eventwatcher.cpp \
    utils.cpp

