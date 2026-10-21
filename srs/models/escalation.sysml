// SysML v2 — жизненный цикл дедлайна и уровни эскалации (диаграмма images/escalation-states.png)
package DeadlineGuardEscalation {
    private import ScalarValues::*;

    // ---------- сигналы ----------
    attribute def MarkedDone { doc /* студент отметил дедлайн выполненным */ }
    attribute def ProgressConfirmed { attribute percent : Integer; }

    enum def Channel { inApp; email; telegram; }

    // Правило уровня: значения по умолчанию из REQ-FUNC-006
    attribute def LevelRule {
        attribute thresholdHours : Real;    // уровень включается, когда hoursLeft <= thresholdHours
        attribute periodHours : Real;       // период повторного напоминания
        attribute channels : Channel[0..*];
    }

    state def DeadlineState {
        attribute hoursLeft : Real;          // часов до жёстко зафиксированного срока
        attribute hoursSinceConfirm : Real;  // часов с последней отметки прогресса
        attribute quietHours : Boolean;      // сейчас тихие часы (по умолчанию 23:00–08:00)

        entry; then active;

        state active {
            doc /* Дедлайн не выполнен и срок не истёк; scheduler пересчитывает уровень каждые 5 минут. */
            entry; then normal;

            state normal { doc /* > 7 суток: напоминаний нет */ }
            state attention { doc /* <= 7 суток: 1 раз в сутки, в приложении */ }
            state urgent { doc /* <= 3 суток: 2 раза в сутки, приложение + e-mail */ }
            state critical { doc /* <= 24 ч: каждые 4 ч, приложение + e-mail + Telegram; в тихие часы не откладывается */ }
            state escalated { doc /* 12 ч без отметки на уровне critical: однократное уведомление контрольному лицу */ }

            transition first normal accept when hoursLeft <= 168 then attention;
            transition first attention accept when hoursLeft <= 72 then urgent;
            transition first urgent accept when hoursLeft <= 24 then critical;
            transition first critical accept when hoursSinceConfirm >= 12 then escalated;
            transition first escalated accept ProgressConfirmed then critical;
        }

        state overdue { doc /* срок истёк: 1 раз в сутки студенту и контрольному лицу */ }
        state done { doc /* выполнен: напоминания прекращены, через 30 дней — архив */ }

        transition first active accept MarkedDone then done;
        transition first active.critical accept when hoursLeft <= 0 then overdue;
        transition first active.escalated accept when hoursLeft <= 0 then overdue;
        transition first overdue accept MarkedDone then done;   // сдан с опозданием
    }
}
