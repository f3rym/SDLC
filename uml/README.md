# Модель динамического поведения DeadlineGuard (UML 2.5)

Лабораторная работа №5. Модель построена на основе SRS 0.3, SDD 0.2 и плана итераций из ЛР3–ЛР4; нотация и
правила связи диаграмм — [ADR-0006](../adr/0006-uml-behaviour-models-plantuml.md). Диаграммы включены в SDD
(версия 0.3, представления 007, 012–015).

| Файл | Содержание |
|------|------------|
| [glossary.md](glossary.md) | глоссарий проекта (таблица) |
| [supplementary-specification.md](supplementary-specification.md) | дополнительные спецификации: бизнес-правила BR-01…BR-16, FURPS+ |
| [use-case-model.md](use-case-model.md) | актёры, связи прецедентов, потоки событий UC-01…UC-17 |
| [models/](models) | тексты диаграмм PlantUML (`.puml`) |
| [images/](images) | изображения диаграмм |

| Диаграмма | Текст | Изображение |
|-----------|-------|-------------|
| Варианты использования | [use-cases.puml](models/use-cases.puml) | [use-cases.png](images/use-cases.png) |
| Активность «Создание личного дедлайна» | [activity-create-deadline.puml](models/activity-create-deadline.puml) | [activity-create-deadline.png](images/activity-create-deadline.png) |
| Активность «Перенос срока» | [activity-postponement.puml](models/activity-postponement.puml) | [activity-postponement.png](images/activity-postponement.png) |
| Состояния дедлайна | [state-deadline.puml](models/state-deadline.puml) | [state-deadline.png](images/state-deadline.png) |
| Состояния напоминания | [state-reminder.puml](models/state-reminder.puml) | [state-reminder.png](images/state-reminder.png) |
| Последовательность «Создание дедлайна» | [sequence-create-deadline.puml](models/sequence-create-deadline.puml) | [sequence-create-deadline.png](images/sequence-create-deadline.png) |
| Последовательность «Перенос срока» | [sequence-postponement.puml](models/sequence-postponement.puml) | [sequence-postponement.png](images/sequence-postponement.png) |

Просмотр текста диаграмм: плагин PlantUML для IntelliJ IDEA / VS Code или `java -jar plantuml.jar models/*.puml`.
