// SysML v2 — варианты использования DeadlineGuard (диаграмма images/use-cases.png)
package DeadlineGuardUseCases {
    private import DeadlineGuardContext::*;

    // ---------- студент ----------
    use case def Login {
        subject system : DeadlineGuard;
        actor user : Student;
        objective { doc /* Пользователь вошёл по e-mail и паролю (REQ-FUNC-001). */ }
    }
    use case def CreatePersonalDeadline {
        subject system : DeadlineGuard;
        actor student : Student;
        objective { doc /* Создан дедлайн с жёстко зафиксированным сроком (REQ-FUNC-002, REQ-FUNC-004). */ }
    }
    use case def RequestPostponement {
        subject system : DeadlineGuard;
        actor student : Student;
        objective { doc /* Отправлен запрос на перенос срока с указанием причины (REQ-FUNC-009). */ }
        include use case approve : ApprovePostponement;
    }
    use case def ViewCalendar {
        subject system : DeadlineGuard;
        actor student : Student;
        objective { doc /* Студент видит дедлайны месяца/недели с цветом уровня эскалации (REQ-FUNC-003). */ }
    }
    use case def MarkProgress {
        subject system : DeadlineGuard;
        actor student : Student;
        objective { doc /* Отмечен процент выполнения или факт сдачи (REQ-FUNC-008). */ }
    }
    use case def ConfigureEscalation {
        subject system : DeadlineGuard;
        actor student : Student;
        objective { doc /* Настроены пороги, каналы, тихие часы и контрольное лицо (REQ-FUNC-010). */ }
    }
    use case def ExportCalendar {
        subject system : DeadlineGuard;
        actor student : Student;
        objective { doc /* Получен файл .ics или ссылка-подписка (REQ-FUNC-013). */ }
    }
    use case def ReceiveReminders {
        subject system : DeadlineGuard;
        actor student : Student;
        actor smtp : SmtpServer;
        actor telegram : TelegramBotApi;
        objective { doc /* Напоминания приходят по каналам текущего уровня (REQ-FUNC-006). */ }
    }

    // ---------- староста ----------
    use case def CreateGroupDeadline {
        subject system : DeadlineGuard;
        actor head : GroupHead;
        objective { doc /* Дедлайн создан у всех студентов группы (REQ-FUNC-011). */ }
    }
    use case def ImportSchedule {
        subject system : DeadlineGuard;
        actor head : GroupHead;
        objective { doc /* Даты сдачи импортированы из .ics/.csv (REQ-FUNC-012). */ }
    }
    use case def ApprovePostponement {
        subject system : DeadlineGuard;
        actor head : GroupHead;
        objective { doc /* Запрос на перенос одобрен или отклонён, решение записано в историю (REQ-FUNC-009). */ }
    }
    use case def ViewGroupSummary {
        subject system : DeadlineGuard;
        actor head : GroupHead;
        objective { doc /* Староста видит долю сдавших и студентов в зоне эскалации (REQ-FUNC-014). */ }
    }

    // ---------- контрольное лицо ----------
    use case def NotifyBuddy {
        subject system : DeadlineGuard;
        actor buddy : Buddy;
        actor smtp : SmtpServer;
        actor telegram : TelegramBotApi;
        objective { doc /* Контрольное лицо получило уведомление об эскалации (REQ-FUNC-007). */ }
    }

    // «extend»: уведомление контрольного лица расширяет обычные напоминания
    // при отсутствии отметки прогресса 12 ч на уровне Critical
    use case reminders : ReceiveReminders;
    use case buddyNotification : NotifyBuddy;
    dependency buddyExtendsReminders from buddyNotification to reminders {
        doc /* «extend», условие: hoursSinceConfirm >= 12 в состоянии Critical (escalation.sysml) */
    }
}
