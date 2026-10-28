// SysML v2 — взаимодействие «пересчёт уровня и доставка напоминания» (диаграмма images/reminder-delivery.png)
package DeadlineGuardReminderDelivery {
    private import DeadlineGuardArchitecture::*;
    private import DeadlineGuardData::*;

    // ---------- сообщения ----------
    attribute def LoadActive { doc /* дедлайны и точки со status = ACTIVE */ }
    attribute def LevelFor { doc /* levelFor(deadline, checkpoints, now) */ }
    attribute def LevelResult { attribute level : Level; }
    attribute def SaveLevelAndEnqueue { doc /* UPDATE deadline + INSERT reminder в одной транзакции */ }
    attribute def PollDue { doc /* SELECT … WHERE status = PENDING AND nextAttemptAt <= now FOR UPDATE SKIP LOCKED LIMIT 100 */ }
    attribute def Send { attribute channel : Channel; }
    attribute def SendResult { attribute ok : Boolean; }
    attribute def MarkResult { doc /* SENT, или attempts + 1 и nextAttemptAt + 1/5/25 мин, или FAILED */ }

    occurrence def ReminderDelivery {
        doc /* «счастливый путь» и путь отказа канала: после 3 неудачных попыток Telegram
               критичное напоминание переставляется в канал EMAIL (REQ-REL-003) */
        part scheduler : EscalationScheduler {
            event occurrence loadSent; event occurrence levelForSent;
            event occurrence levelResultReceived; event occurrence enqueueSent;
        }
        part escalation : EscalationModule { event occurrence levelForReceived; event occurrence levelResultSent; }
        part database : PostgreSql {
            event occurrence loadReceived; event occurrence enqueueReceived;
            event occurrence pollReceived; event occurrence markReceived;
        }
        part worker : NotificationModule {
            event occurrence pollSent; event occurrence sendSent;
            event occurrence resultReceived; event occurrence markSent;
        }
        part channel : TelegramAdapter { event occurrence sendReceived; event occurrence resultSent; }

        message loadActive of LoadActive from scheduler.loadSent to database.loadReceived;
        message levelFor of LevelFor from scheduler.levelForSent to escalation.levelForReceived;
        message levelResult of LevelResult from escalation.levelResultSent to scheduler.levelResultReceived;
        message enqueue of SaveLevelAndEnqueue from scheduler.enqueueSent to database.enqueueReceived;
        message poll of PollDue from worker.pollSent to database.pollReceived;
        message send of Send from worker.sendSent to channel.sendReceived;
        message result of SendResult from channel.resultSent to worker.resultReceived;
        message mark of MarkResult from worker.markSent to database.markReceived;

        first loadActive then levelFor;
        first levelFor then levelResult;
        first levelResult then enqueue;
        first enqueue then poll;
        first poll then send;
        first send then result;
        first result then mark;
    }
}
