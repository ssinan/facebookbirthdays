#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QtCore/QVariant>
#include <QDebug>
#include "parser.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    viewer->setMainQmlFile(QLatin1String("qml/facebookbirthdays/main.qml"));
    viewer->showExpanded();

    QByteArray json = "{\"foo\":\"bar\"}";
    QJson::Parser parser;
    bool ok;
    parser.parse(json, &ok);
    qDebug() << "isOk: " << ok;

    return app->exec();
}
