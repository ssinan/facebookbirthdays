#include <QtGui/QApplication>
#include "fbapplication.h"
#include "qmlapplicationviewer.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    FBApplication fbapp;
    fbapp.start();
    return app->exec();
}
