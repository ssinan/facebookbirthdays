#include <QOrganizerManager>
#include <QOrganizerEvent>
#include "birthdayimporter.h"
#include <QDebug>

BirthdayImporter::BirthdayImporter(QDeclarativeItem *parent) :
    QDeclarativeItem(parent)
{
}

QString BirthdayImporter::name() const
{
    return m_name;
}

void BirthdayImporter::setName(const QString& name)
{
    m_name = name;
    emit nameChanged();
}

QDateTime BirthdayImporter::date() const
{
    return m_date;
}

void BirthdayImporter::setDate(const QDateTime& date)
{
    m_date = date;
    emit dateChanged();
}

void BirthdayImporter::importToCalendar()
{
    qDebug() << "ActivityDetailView::addToCalendar()";
    QtMobility::QOrganizerManager defaultManager;
    // create event
    QtMobility::QOrganizerEvent event;
    event.setDisplayLabel(m_name + "\'s Birthday");
    event.setDescription(m_name + "\'s Birthday");
    event.setAllDay(true);
//    QtMobility::QOrganizerRecurrenceRule recurrenceRule;
//    recurrenceRule.setFrequency(QtMobility::QOrganizerRecurrenceRule::Yearly);
//    event.setRecurrenceRule(recurrenceRule);
    event.setStartDateTime(m_date);
    event.setEndDateTime(m_date);
    // set alarm two hours before the event -- does not work on device
//    QtMobility::QOrganizerItemVisualReminder oldReminder = event.detail(QtMobility::QOrganizerItemReminder::DefinitionName);
//    event.removeDetail(&oldReminder);
//    QtMobility::QOrganizerItemVisualReminder reminder;
//    reminder.setMessage(m_name + "\'s Birthday");
//    reminder.setSecondsBeforeStart(24 * 60 * 60);
//    event.saveDetail(&reminder);
    // check if this event is added before
    QList<QtMobility::QOrganizerItem> items = defaultManager.items();
    foreach (QtMobility::QOrganizerItem item, items) {
        if (item.type() == QtMobility::QOrganizerItemType::TypeEvent) {
            QtMobility::QOrganizerEvent e(item);
            if ((e.displayLabel() == event.displayLabel()) && (e.startDateTime() == event.startDateTime())) {
                //MessageBox::showMessageBox(window(), m_activityDetailWidget->m_activity->title() + QString::fromUtf8(" daha \u00f6nce takvime eklenmi\u015f."), QNUConstants::BUTTON_OK);
                qDebug() <<  QString::fromUtf8(" daha \u00f6nce takvime eklenmi\u015f.");
                return;
            }
        }
    }
    if (defaultManager.saveItem(&event)) {
        qDebug() <<  event.description() << QString::fromUtf8(" ba\u015far\u0131yla takvime eklendi.");
        //MessageBox::showMessageBox(window(), m_activityDetailWidget->m_activity->title() + QString::fromUtf8(" ba\u015far\u0131yla takvime eklendi."), QNUConstants::BUTTON_OK);
    } else {
        qDebug() << "error code: " << defaultManager.error();
        //MessageBox::showMessageBox(window(), m_activityDetailWidget->m_activity->title() + QString::fromUtf8(" takvime eklenirken bir sorunla kar\u015f\u0131la\u015f\u0131ld\u0131."), QNUConstants::BUTTON_OK);
    }
}
