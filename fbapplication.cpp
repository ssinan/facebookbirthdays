#include "constants.h"
#include "fbapplication.h"

FBApplication::FBApplication(QObject *parent) :
    QObject(parent)
{
    viewer = QmlApplicationViewer::create();
    qmlRegisterType<Constants>("FBLibrary", 1, 0, "Constants");
}

FBApplication::~FBApplication()
{
    delete viewer;
}

void FBApplication::start()
{
    viewer->setMainQmlFile(QLatin1String("qml/facebookbirthdays/main.qml"));
    viewer->showExpanded();
}
