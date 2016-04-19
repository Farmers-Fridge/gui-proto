TEMPLATE = app

QT += qml quick widgets

win32 {
    DESTDIR = .\\bin
    MOC_DIR = .\\moc
    OBJECTS_DIR = .\\obj
}

unix {
    DESTDIR = ./bin
    MOC_DIR = ./mock
    OBJECTS_DIR = ./obj
}

win32 {
    QMAKE_CLEAN *= $$DESTDIR\\*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR\\*$$TARGET*
    QMAKE_CLEAN *= $$OBJECTS_DIR\\*$$TARGET*
}

unix {
    QMAKE_CLEAN *= $$DESTDIR/*$$TARGET*
    QMAKE_CLEAN *= $$MOC_DIR/*$$TARGET*
    QMAKE_CLEAN *= $$OBJECTS_DIR/*$$TARGET*
}

CONFIG(debug, debug|release) {
    TARGET = menuviewerd
} else {
    TARGET = menuviewer
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

HEADERS += \
    controller.h \
    iservice.h \
    menuviewer.h \
    utils.h \
    eventwatcher.h \
    cartmodel.h \
    defs.h \
    documenthandler.h

SOURCES += \
    controller.cpp \
    main.cpp \
    menuviewer.cpp \
    eventwatcher.cpp \
    cartmodel.cpp \
    documenthandler.cpp

RESOURCES += \
    resources.qrc



