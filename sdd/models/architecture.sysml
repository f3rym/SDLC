// SysML v2 — архитектура DeadlineGuard 1.0: модули, интерфейсы и развёртывание
// (диаграммы images/components.png и images/deployment.png)
package DeadlineGuardArchitecture {
    private import ScalarValues::*;

    // ---------- интерфейсы между модулями ----------
    port def DeadlineApi { doc /* создание, чтение, отметка прогресса; смена срока — только через PostponementApi */ }
    port def PostponementApi { doc /* запрос переноса срока и решение старосты (REQ-FUNC-009) */ }
    port def EscalationPolicyApi { doc /* levelFor(deadline, now) — чистая функция без Spring (REQ-MAINT-001) */ }
    port def ReminderApi { doc /* постановка напоминания в outbox в той же транзакции (ADR-0004) */ }
    port def ChannelSender { doc /* send(reminder) для каналов IN_APP, EMAIL, TELEGRAM */ }
    port def GroupApi { doc /* группы, роли, групповые дедлайны */ }
    port def ICalApi { doc /* экспорт и импорт RFC 5545 */ }
    port def JdbcPort { doc /* JDBC, пул HikariCP, 10 соединений */ }

    // ---------- модули монолита (ADR-0001) ----------
    part def WebModule {
        doc /* Spring MVC + Thymeleaf: контроллеры экранов, формы, валидация (ADR-0002) */
        port deadlines : ~DeadlineApi;
        port postponements : ~PostponementApi;
        port groups : ~GroupApi;
        port ical : ~ICalApi;
    }
    part def SecurityModule { doc /* Spring Security: вход, BCrypt, блокировка, CSRF, роли (REQ-SEC-001…003) */ }
    part def DeadlineModule {
        doc /* дедлайны, контрольные точки, история срока, жёсткая привязка (REQ-FUNC-002/004/008/018) */
        port api : DeadlineApi;
        port postponement : PostponementApi;
        port policy : ~EscalationPolicyApi;
        port reminders : ~ReminderApi;
        port db : ~JdbcPort;
    }
    part def GroupModule {
        port api : GroupApi;
        port db : ~JdbcPort;
    }
    part def EscalationModule {
        doc /* правила уровней и расписание напоминаний; без зависимостей от web и Spring */
        port api : EscalationPolicyApi;
    }
    part def EscalationScheduler {
        doc /* @Scheduled каждые 5 минут, блокировка ShedLock; пересчитывает уровни (REQ-FUNC-005) */
        attribute periodMinutes : Integer = 5;
        port policy : ~EscalationPolicyApi;
        port reminders : ~ReminderApi;
    }
    part def NotificationModule {
        doc /* outbox reminder, обработчик раз в минуту, повторы 1/5/25 мин, тихие часы (REQ-FUNC-006/015, REQ-REL-001…003) */
        attribute workerPeriodSeconds : Integer = 60;
        attribute maxAttempts : Integer = 3;
        port api : ReminderApi;
        port email : ~ChannelSender;
        port telegram : ~ChannelSender;
        port db : ~JdbcPort;
    }
    part def ICalModule { port api : ICalApi; }
    part def OpsModule { doc /* Actuator-метрики, журнал JSON, удаление аккаунта (REQ-SEC-005, REQ-OBS-001/002) */ }
    part def SmtpSender { doc /* JavaMailSender, SMTP + STARTTLS :587 */ port sender : ChannelSender; }
    part def TelegramAdapter {
        doc /* отправка sendMessage и приём getUpdates через long polling (ADR-0005) */
        port sender : ChannelSender;
    }
    part def PostgreSql { port jdbc : JdbcPort; }

    part def DeadlineGuardApp {
        part web : WebModule;
        part security : SecurityModule;
        part deadline : DeadlineModule;
        part group : GroupModule;
        part escalation : EscalationModule;
        part scheduler : EscalationScheduler;
        part notification : NotificationModule;
        part ical : ICalModule;
        part ops : OpsModule;
        part smtp : SmtpSender;
        part telegram : TelegramAdapter;

        connect web.deadlines to deadline.api;
        connect web.postponements to deadline.postponement;
        connect web.groups to group.api;
        connect web.ical to ical.api;
        connect deadline.policy to escalation.api;
        connect scheduler.policy to escalation.api;
        connect deadline.reminders to notification.api;
        connect scheduler.reminders to notification.api;
        connect notification.email to smtp.sender;
        connect notification.telegram to telegram.sender;
    }

    // ---------- развёртывание (представление 009-deployment) ----------
    part def ReverseProxy { doc /* Caddy: HTTPS, сертификат Let's Encrypt, проксирование на :8080 (REQ-SEC-001) */ }
    part def AppContainer {
        doc /* eclipse-temurin:21-jre, deadlineguard.jar, -Xmx384m (представление 010-resources) */
        attribute heapMb : Integer = 384;
    }
    part def DbContainer { doc /* postgres:16, том pgdata */ }
    part def BackupJob { doc /* cron: pg_dump раз в сутки, хранение 14 дней (REQ-AVAIL-002) */ }
    part def VpsNode {
        doc /* Linux x86_64 или ARM64, 1 vCPU, 1 ГБ ОЗУ, Docker Compose (REQ-PERF-003, REQ-PORT-001) */
        part proxy : ReverseProxy;
        part app : AppContainer;
        part db : DbContainer;
        part backup : BackupJob;
    }

    part deployment {
        part vps : VpsNode;
        part application : DeadlineGuardApp;
        part database : PostgreSql;
        allocate application to vps.app;
        allocate database to vps.db;
    }
}
