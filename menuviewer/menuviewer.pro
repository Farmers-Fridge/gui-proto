#-------------------------------------------------
#
# Project created by QtCreator 2016-05-02T15:46:08
#
#-------------------------------------------------

QT       += core gui qml quick quickwidgets xml
INCLUDEPATH += $$PWD/../farmers-utils ../farmers-client

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TEMPLATE = app

FORMS    +=

CONFIG(debug, debug|release) {
    LIBS += -L$$PWD/../bin/ -lfarmers-utilsd -lfarmers-clientd
    TARGET = menuviewerd
} else {
    LIBS += -L$$PWD/../bin/ -lfarmers-utils -lfarmers-client
    TARGET = menuviewer
}

unix {
    DESTDIR = ../bin
    MOC_DIR = ./moc
    OBJECTS_DIR = ./obj
}

win32 {
    DESTDIR = ..\\bin
    MOC_DIR = .\\moc
    OBJECTS_DIR = .\\obj
}

unix {
    QMAKE_CLEAN *= $$DESTDIR/*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR/*moc_*
    QMAKE_CLEAN *= $$OBJECTS_DIR/*.o*
}

win32 {
    QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR\\*moc_*
    QMAKE_CLEAN *= $$OBJECTS_DIR\\*.o*
}

HEADERS += \
    controller.h \
    iservice.h \
    menuviewer.h \
    defs.h \
    cartmodel.h \
    tablemodel.h \
    colormodel.h

SOURCES += \
    controller.cpp \
    main.cpp \
    menuviewer.cpp \
    cartmodel.cpp \
    tablemodel.cpp \
    colormodel.cpp

RESOURCES += \
    resources.qrc

QML_IMPORT_PATH += $$PWD/../FarmersCommon

DISTFILES += \
    json/application.json
