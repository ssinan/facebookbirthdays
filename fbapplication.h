#ifndef FBAPPLICATION_H
#define FBAPPLICATION_H

#include <QObject>
#include "qmlapplicationviewer.h"

class FBApplication : public QObject
{
    Q_OBJECT
public:
    explicit FBApplication(QObject *parent = 0);
    ~FBApplication();

signals:

public:
    void start();

private:
    QmlApplicationViewer* viewer;

};

#endif // FBAPPLICATION_H
