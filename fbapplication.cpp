#include "constants.h"
#include "fbapplication.h"
#include "birthdayimporter.h"

FBApplication::FBApplication(QObject *parent) :
    QObject(parent)
{
    viewer = QmlApplicationViewer::create();
    qmlRegisterType<Constants>("FBLibrary", 1, 0, "Constants");
    qmlRegisterType<BirthdayImporter>("FBLibrary", 1, 0, "BirthdayImporter");
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
