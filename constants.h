#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QtCore>
#include <QtDeclarative>
#include <QUrl>

 class Constants : public QDeclarativeItem
 {
     Q_OBJECT
     Q_PROPERTY(QString FACEBOOK_API_KEY READ FACEBOOK_API_KEY CONSTANT)
     Q_PROPERTY(QString FACEBOOK_API_SECRET READ FACEBOOK_API_SECRET CONSTANT)
     Q_PROPERTY(QString FACEBOOK_PERMISSIONS READ FACEBOOK_PERMISSIONS CONSTANT)

 public:
     inline QString FACEBOOK_API_KEY() const { return QString("277515672282681");}
     inline QString FACEBOOK_API_SECRET() const { return QString("638d281a19febdc3bd31b26566c61039");}
     inline QString FACEBOOK_PERMISSIONS() const { return QString("friends_birthday,read_friendlists,offline_access");}
 };

#endif // CONSTANTS_H
