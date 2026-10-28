// SysML v2 — модель данных DeadlineGuard 1.0 (диаграмма images/data-model.png)
// Каждое item def соответствует таблице PostgreSQL; время хранится в UTC (timestamptz, REQ-PORT-002).
package DeadlineGuardData {
    private import ScalarValues::*;

    enum def Role { student; groupHead; admin; }
    enum def Level { normal; attention; urgent; critical; escalated; overdue; done; }
    enum def Channel { inApp; email; telegram; }
    enum def DeliveryStatus { pending; sent; failed; skipped; }
    enum def ConsentStatus { pending; granted; revoked; }
    enum def RequestStatus { pending; approved; rejected; }

    attribute def Instant :> String { doc /* timestamptz, UTC */ }

    item def AppUser {
        attribute id : Integer;
        attribute email : String;
        attribute passwordHash : String;      // BCrypt, cost >= 10 (REQ-SEC-001)
        attribute role : Role;
        attribute emailVerified : Boolean;
        attribute failedLogins : Integer;
        attribute lockedUntil : Instant[0..1];  // REQ-SEC-002
        attribute timezone : String;          // по умолчанию Europe/Minsk
        attribute telegramChatId : Integer[0..1];
        attribute quietFrom : String;         // 23:00
        attribute quietTo : String;           // 08:00
        ref item group : StudyGroup[0..1];
    }

    item def StudyGroup {
        attribute id : Integer;
        attribute number : String;            // 450501
        ref item head : AppUser[0..1];
    }

    item def GroupDeadline {
        doc /* шаблон группового дедлайна; срок меняет только староста (REQ-FUNC-011) */
        attribute id : Integer;
        attribute title : String;
        attribute subject : String;
        attribute dueAt : Instant;
        attribute icalUid : String[0..1];     // для поиска дублей при импорте (REQ-FUNC-012)
        ref item group : StudyGroup;
    }

    item def Deadline {
        attribute id : Integer;
        attribute title : String;
        attribute subject : String;
        attribute workType : String;
        attribute dueAt : Instant;            // жёстко зафиксирован (REQ-FUNC-004)
        attribute effortHours : Integer;
        attribute progress : Integer;         // 0…100, шаг 10
        attribute level : Level;
        attribute lastProgressAt : Instant;
        attribute postponeCount : Integer;    // не более 2 для личного (REQ-FUNC-009)
        attribute doneAt : Instant[0..1];
        ref item owner : AppUser;
        ref item groupDeadline : GroupDeadline[0..1];
        ref item buddy : Buddy[0..1];
    }

    item def Checkpoint {
        doc /* контрольная точка большой работы (REQ-FUNC-018), не более 5 на дедлайн */
        attribute id : Integer;
        attribute title : String;
        attribute dueAt : Instant;            // не позже Deadline.dueAt, жёсткая привязка
        attribute position : Integer;
        attribute doneAt : Instant[0..1];
        ref item deadline : Deadline;
    }

    item def DueDateChange {
        doc /* история срока: каждое изменение (REQ-FUNC-004, BG-4) */
        attribute id : Integer;
        attribute changedAt : Instant;
        attribute oldDueAt : Instant;
        attribute newDueAt : Instant;
        attribute reason : String;
        ref item deadline : Deadline;
        ref item checkpoint : Checkpoint[0..1];
        ref item author : AppUser;
    }

    item def PostponementRequest {
        attribute id : Integer;
        attribute newDueAt : Instant;
        attribute reason : String;            // 10…500 символов
        attribute status : RequestStatus;
        ref item deadline : Deadline;
        ref item requester : AppUser;
        ref item decidedBy : AppUser[0..1];
    }

    item def Buddy {
        attribute id : Integer;
        attribute email : String;
        attribute consent : ConsentStatus;    // REQ-SEC-004
        attribute consentToken : String;
        ref item student : AppUser;
    }

    item def Reminder {
        doc /* transactional outbox (ADR-0004); UNIQUE (deadline, checkpoint, level, channel, plannedAt) */
        attribute id : Integer;
        attribute level : Level;
        attribute channel : Channel;
        attribute plannedAt : Instant;
        attribute status : DeliveryStatus;
        attribute attempts : Integer;         // не более 3 (REQ-REL-001)
        attribute nextAttemptAt : Instant;
        attribute lastError : String[0..1];
        ref item deadline : Deadline;
        ref item checkpoint : Checkpoint[0..1];
        ref item recipient : AppUser[0..1];   // пусто — получатель Buddy
    }

    item def InAppNotification {
        attribute id : Integer;
        attribute text : String;
        attribute createdAt : Instant;
        attribute readAt : Instant[0..1];
        ref item user : AppUser;
    }

    item def TelegramLinkCode {
        attribute code : String;
        attribute expiresAt : Instant;        // 15 минут (REQ-INT-005)
        ref item user : AppUser;
    }
}
