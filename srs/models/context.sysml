// SysML v2 — контекст системы DeadlineGuard (диаграмма images/context.png)
package DeadlineGuardContext {
    private import ScalarValues::*;

    // ---------- порты ----------
    port def HttpsPort { doc /* HTTPS (TLS 1.2+), браузер ↔ сервер приложения */ }
    port def SmtpPort { doc /* исходящая почта, SMTP с STARTTLS */ }
    port def BotApiPort { doc /* HTTPS-запросы к Telegram Bot API, JSON */ }
    port def ICalPort { doc /* обмен файлами iCalendar (RFC 5545) */ }

    // ---------- пользователи ----------
    part def Student {
        doc /* Студент: ведёт личные дедлайны, получает напоминания. */
        attribute email : String;
        attribute group : String;
        port browser : ~HttpsPort;
    }
    part def GroupHead :> Student {
        doc /* Староста: дополнительно создаёт групповые дедлайны и видит сводку группы. */
    }
    part def Buddy {
        doc /* Контрольное лицо: одногруппник или куратор, выбранный студентом; только получает уведомления об эскалации. */
        attribute email : String;
        port inbox : ~SmtpPort;
    }

    // ---------- внешние сервисы ----------
    part def SmtpServer { port smtp : SmtpPort; }
    part def TelegramBotApi { port api : BotApiPort; }
    part def ExternalCalendar {
        doc /* Google / Apple / Outlook Calendar — импортирует экспортированный .ics. */
        port ics : ICalPort;
    }

    // ---------- разрабатываемая система ----------
    part def WebUi;
    part def AppServer;
    part def Database;
    part def ICalGateway;
    part def EscalationScheduler {
        attribute periodMinutes : Integer = 5;
    }
    part def NotificationService;

    part def DeadlineGuard {
        port web : HttpsPort;
        port ical : ~ICalPort;
        port mail : ~SmtpPort;
        port bot : ~BotApiPort;

        part webUi : WebUi;
        part api : AppServer;
        part db : Database;
        part icalGateway : ICalGateway;
        part scheduler : EscalationScheduler;
        part notifier : NotificationService;

        connect web to webUi;
        connect webUi to api;
        connect api to db;
        connect api to icalGateway;
        connect db to scheduler;
        connect scheduler to notifier;
        connect icalGateway to ical;
        connect notifier to mail;
        connect notifier to bot;
    }

    part context {
        part student : Student;
        part groupHead : GroupHead;
        part buddy : Buddy;
        part system : DeadlineGuard;
        part smtp : SmtpServer;
        part telegram : TelegramBotApi;
        part calendar : ExternalCalendar;

        connect student.browser to system.web;
        connect groupHead.browser to system.web;
        connect system.mail to smtp.smtp;
        connect system.bot to telegram.api;
        connect system.ical to calendar.ics;
        connect smtp.smtp to buddy.inbox;
    }
}
