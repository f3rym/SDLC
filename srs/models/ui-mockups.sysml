// SysML v2 — макеты экранов веб-приложения DeadlineGuard.
// Файл сгенерирован srs/models/render.py по тем же описаниям, что и PNG в srs/images/ui-*.png;
// правки вносить в render.py и перегенерировать.
package DeadlineGuardUI {
    private import ScalarValues::*;

    // ---------- библиотека элементов интерфейса ----------
    part def Screen {
        attribute title : String;
        attribute route : String;
    }
    part def Button { attribute text : String; attribute variant : String; }
    part def ChannelSelector { attribute caption : String; attribute options : String; }
    part def CheckBox { attribute options : String; }
    part def Countdown { attribute text : String; }
    part def DataTable { attribute columns : String; attribute title : String; }
    part def DateTimeField { attribute caption : String; attribute value : String; }
    part def DeadlineForm { attribute title : String; }
    part def DeadlineList { attribute options : String; attribute title : String; }
    part def DeadlineSummary;
    part def DropDown { attribute caption : String; attribute value : String; }
    part def LevelBadge { attribute level : String; attribute text : String; }
    part def LevelLegend { attribute options : String; }
    part def LevelStepper { attribute levels : String; }
    part def Link { attribute text : String; }
    part def LoginForm;
    part def MonthCalendar;
    part def NavBar { attribute tabs : String; }
    part def NavList { attribute options : String; }
    part def NumberField { attribute caption : String; attribute value : String; }
    part def Panel { attribute title : String; }
    part def PasswordField { attribute caption : String; attribute value : String; }
    part def PeriodNavigator { attribute text : String; }
    part def ProgressBar { attribute caption : String; }
    part def RuleTable { attribute columns : String; }
    part def SegmentedControl { attribute options : String; }
    part def TextField { attribute caption : String; attribute placeholder : String; attribute value : String; }
    part def TextLabel { attribute text : String; }
    part def TimeField { attribute caption : String; attribute value : String; }

    // ---------- Вход → images/ui-login.png ----------
    part def LoginScreen :> Screen {
        attribute :>> title = "Вход";
        attribute :>> route = "/login";
        part loginForm : LoginForm {
            part logo : TextLabel {
                attribute :>> text = "DeadlineGuard";
            }
            part slogan : TextLabel {
                attribute :>> text = "Трекер дедлайнов для студентов";
            }
            part emailField : TextField {
                attribute :>> caption = "E-mail";
                attribute :>> placeholder = "student@bsuir.by";
            }
            part passwordField : PasswordField {
                attribute :>> caption = "Пароль";
                attribute :>> value = "••••••••••";
            }
            part rememberMe : CheckBox {
                attribute :>> options = "Запомнить меня";
            }
            part loginButton : Button {
                attribute :>> text = "Войти";
            }
            part registerLink : Link {
                attribute :>> text = "Нет аккаунта? Зарегистрироваться";
            }
        }
        comment loginNote /* Вход по e-mail и паролю (REQ-FUNC-001). После 5 неудачных попыток подряд вход блокируется на 15 минут (REQ-SEC-002). */
        comment tgNote /* После регистрации студент может привязать Telegram в настройках, чтобы получать критичные напоминания. */
    }

    // ---------- Календарь → images/ui-calendar.png ----------
    part def CalendarScreen :> Screen {
        attribute :>> title = "Календарь";
        attribute :>> route = "/calendar";
        part navBar : NavBar {
            attribute :>> tabs = "Календарь; Группа; Настройки";
        }
        part viewSwitch : SegmentedControl {
            attribute :>> options = "Месяц; Неделя";
        }
        part periodNav : PeriodNavigator {
            attribute :>> text = "Октябрь 2026";
        }
        part exportButton : Button {
            attribute :>> text = "Экспорт .ics";
            attribute :>> variant = "secondary";
        }
        part addButton : Button {
            attribute :>> text = "+ Дедлайн";
        }
        part hotList : DeadlineList {
            attribute :>> title = "Горящие дедлайны";
            attribute :>> options = "Курсовой проект: ПЗ; Лаб. №3 — SRS; Контрольная работа; Реферат; Лаб. №4";
        }
        part legend : LevelLegend {
            attribute :>> options = "Норма; Внимание; Срочно; Критично; Эскалация; Просрочен";
        }
        part monthView : MonthCalendar;
    }

    // ---------- Новый дедлайн → images/ui-deadline-form.png ----------
    part def DeadlineFormDialog :> Screen {
        attribute :>> title = "Новый дедлайн";
        attribute :>> route = "/calendar#new";
        doc /* Модальное окно поверх CalendarScreen. */
        part deadlineForm : DeadlineForm {
            attribute :>> title = "Новый дедлайн";
            part titleField : TextField {
                attribute :>> caption = "Название *";
                attribute :>> value = "Лабораторная работа №3 — SRS";
            }
            part subjectField : DropDown {
                attribute :>> caption = "Предмет *";
                attribute :>> value = "ЖЦРПО";
            }
            part typeField : DropDown {
                attribute :>> caption = "Тип";
                attribute :>> value = "Лабораторная работа";
            }
            part dueField : DateTimeField {
                attribute :>> caption = "Срок сдачи (жёсткий) *";
                attribute :>> value = "06.10.2026   23:59";
            }
            part effortField : NumberField {
                attribute :>> caption = "Трудоёмкость, ч";
                attribute :>> value = "6";
            }
            part buddyField : DropDown {
                attribute :>> caption = "Контрольное лицо";
                attribute :>> value = "Петров П. П. — petrov@bsuir.by";
            }
            part channels : ChannelSelector {
                attribute :>> caption = "Каналы напоминаний";
                attribute :>> options = "В приложении; E-mail; Telegram";
            }
            part lockHint : TextLabel {
                attribute :>> text = "После сохранения срок фиксируется: изменить его можно только через запрос переноса с указанием причины, изменение попадает в историю.";
            }
            part cancelButton : Button {
                attribute :>> text = "Отмена";
                attribute :>> variant = "secondary";
            }
            part saveButton : Button {
                attribute :>> text = "Сохранить";
            }
        }
        comment formNote /* Поля с * обязательны. Срок не может быть в прошлом; проверка выполняется и в браузере, и на сервере (REQ-FUNC-002). */
        comment lockNote /* Значок замка — жёсткая привязка к дате (REQ-FUNC-004). Уровень эскалации рассчитывается от этой даты автоматически (REQ-FUNC-005). */
    }

    // ---------- Карточка дедлайна → images/ui-deadline-card.png ----------
    part def DeadlineCardScreen :> Screen {
        attribute :>> title = "Карточка дедлайна";
        attribute :>> route = "/deadlines/42";
        part navBar : NavBar {
            attribute :>> tabs = "Календарь; Группа; Настройки";
        }
        part backLink : Link {
            attribute :>> text = "← Назад к календарю";
        }
        part summary : DeadlineSummary {
            part titleText : TextLabel {
                attribute :>> text = "Лабораторная работа №3 — SRS";
            }
            part metaText : TextLabel {
                attribute :>> text = "ЖЦРПО · лабораторная · срок 06.10.2026 23:59 · групповой (староста)";
            }
            part levelBadge : LevelBadge {
                attribute :>> level = "Срочно";
            }
            part countdown : Countdown {
                attribute :>> text = "2 д 06 ч до срока";
            }
        }
        part levelStepper : LevelStepper {
            attribute :>> levels = "Норма (> 7 суток); Внимание (≤ 7 суток); Срочно (≤ 3 суток); Критично (≤ 24 часов); Эскалация (12 ч без отметки)";
        }
        part progressPanel : Panel {
            attribute :>> title = "Мой прогресс";
            part progress : ProgressBar {
                attribute :>> caption = "Выполнено";
            }
            part markButton : Button {
                attribute :>> text = "Отметить";
                attribute :>> variant = "secondary";
            }
            part doneButton : Button {
                attribute :>> text = "Сдано";
            }
            part postponeButton : Button {
                attribute :>> text = "Перенос…";
                attribute :>> variant = "secondary";
            }
        }
        part dateHistory : DataTable {
            attribute :>> title = "История срока";
            attribute :>> columns = "Когда; Срок; Кто / причина";
        }
        part reminderLog : DataTable {
            attribute :>> title = "Журнал напоминаний";
            attribute :>> columns = "Когда; Канал; Событие";
        }
    }

    // ---------- Настройки эскалации → images/ui-escalation-settings.png ----------
    part def EscalationSettingsScreen :> Screen {
        attribute :>> title = "Настройки эскалации";
        attribute :>> route = "/settings/escalation";
        part navBar : NavBar {
            attribute :>> tabs = "Календарь; Группа; Настройки";
        }
        part settingsMenu : NavList {
            attribute :>> options = "Профиль; Эскалация; Каналы; Контрольное лицо; Тихие часы";
        }
        part telegramPanel : Panel {
            attribute :>> title = "Telegram";
            part tgStatus : TextLabel {
                attribute :>> text = "Аккаунт @ivanov_i привязан";
            }
            part unlinkButton : Button {
                attribute :>> text = "Отвязать";
                attribute :>> variant = "secondary";
            }
            part botHint : TextLabel {
                attribute :>> text = "Бот @DeadlineGuardBot присылает уведомления уровней «Критично» и выше.";
            }
        }
        part rulesPanel : Panel {
            attribute :>> title = "Правила эскалации";
            part levelRules : RuleTable {
                attribute :>> columns = "Уровень; Порог (до срока); Частота; Каналы";
            }
            part quietFrom : TimeField {
                attribute :>> caption = "Тихие часы: с";
                attribute :>> value = "23:00";
            }
            part quietTo : TimeField {
                attribute :>> caption = "по";
                attribute :>> value = "08:00";
            }
            part criticalOverride : CheckBox {
                attribute :>> options = "Уровень «Критично» — и в тихие часы";
            }
            part buddyEmail : TextField {
                attribute :>> caption = "Контрольное лицо (e-mail)";
                attribute :>> value = "petrov@bsuir.by";
            }
            part consentBadge : LevelBadge {
                attribute :>> level = "Выполнен";
                attribute :>> text = "Согласие получено";
            }
            part resetButton : Button {
                attribute :>> text = "По умолчанию";
                attribute :>> variant = "secondary";
            }
            part saveButton : Button {
                attribute :>> text = "Сохранить";
            }
        }
    }

    // ---------- Сводка группы → images/ui-group-dashboard.png ----------
    part def GroupDashboardScreen :> Screen {
        attribute :>> title = "Сводка группы";
        attribute :>> route = "/group";
        part navBar : NavBar {
            attribute :>> tabs = "Календарь; Группа; Настройки";
        }
        part groupTitle : TextLabel {
            attribute :>> text = "Группа 450501 · осенний семестр 2026";
        }
        part addGroupButton : Button {
            attribute :>> text = "+ Групповой дедлайн";
        }
        part groupDeadlines : DataTable {
            attribute :>> columns = "Дедлайн; Предмет; Срок; Уровень; Сдали; Средний прогресс";
        }
        part riskList : DeadlineList {
            attribute :>> title = "Студенты в зоне эскалации";
            attribute :>> options = "Козлов К.; Новикова Н.; Морозов М.";
        }
        part importPanel : Panel {
            attribute :>> title = "Импорт расписания";
            part importHint : TextLabel {
                attribute :>> text = "Загрузите .ics или .csv с датами сдачи — дедлайны будут созданы для всей группы и зафиксированы.";
            }
            part fileButton : Button {
                attribute :>> text = "Выбрать файл…";
                attribute :>> variant = "secondary";
            }
            part importButton : Button {
                attribute :>> text = "Импорт";
            }
            part privacyHint : TextLabel {
                attribute :>> text = "Статусы студентов видны старосте только с их согласия (REQ-SEC-004).";
            }
        }
    }

    // Навигация между экранами (диаграмма images/ui-navigation.png)
    attribute def LoginOk;
    attribute def Logout;
    attribute def AddDeadline;
    attribute def Saved;
    attribute def Cancelled;
    attribute def OpenDeadline { attribute deadlineId : Integer; }
    attribute def Back;
    attribute def OpenTab { attribute tab : String; }

    state def Navigation {
        attribute isGroupHead : Boolean;
        entry; then login;

        state login { doc /* LoginScreen */ }
        state calendar { doc /* CalendarScreen */ }
        state deadlineForm { doc /* DeadlineFormDialog — модальное окно поверх календаря */ }
        state deadlineCard { doc /* DeadlineCardScreen */ }
        state settings { doc /* EscalationSettingsScreen */ }
        state groupDashboard { doc /* GroupDashboardScreen — только для старосты */ }

        transition first login accept LoginOk then calendar;
        transition first calendar accept Logout then login;
        transition first calendar accept AddDeadline then deadlineForm;
        transition first deadlineForm accept Saved then calendar;
        transition first deadlineForm accept Cancelled then calendar;
        transition first calendar accept OpenDeadline then deadlineCard;
        transition first deadlineCard accept Back then calendar;
        transition first calendar accept t : OpenTab if t.tab == "settings" then settings;
        transition first settings accept OpenTab then calendar;
        transition first calendar accept t : OpenTab if t.tab == "group" and isGroupHead then groupDashboard;
        transition first groupDashboard accept OpenTab then calendar;
    }
}
