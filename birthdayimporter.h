#ifndef BIRTHDAYIMPORTER_H
#define BIRTHDAYIMPORTER_H

#include <QDeclarativeItem>
#include <QDateTime>

class BirthdayImporter : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)

public:
    explicit BirthdayImporter(QDeclarativeItem *parent = 0);

    QString name() const;
    void setName(const QString&);
    QDateTime date() const;
    void setDate(const QDateTime&);

    Q_INVOKABLE void importToCalendar();

signals:
    void nameChanged();
    void dateChanged();

private:
    QString m_name;
    QDateTime m_date;

};

#endif // BIRTHDAYIMPORTER_H
