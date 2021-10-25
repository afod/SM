///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Добавляет признак изменения пометки удаления документа.
// Состав параметров процедуры соответствует подписке на событие ПередЗаписью объекта Документ.
// Описание см. в синтакс-помощнике.
//
// Параметры:
//  Источник  - ДокументОбъект - источник события подписки.
//  Отказ     - Булево         - признак отказа от записи. Если установить Истина, то запись выполнена не будет 
//                               и будет вызвано исключение.
//  РежимЗаписи     - РежимЗаписиДокумента     - текущий режим записи документа-источника.
//  РежимПроведения - РежимПроведенияДокумента - текущий режим проведения документа-источника.
//
Процедура УстановитьСтатусИзмененияПометкиУдаленияДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ЗаметкиПользователяСлужебный.УстановитьСтатусИзмененияПометкиУдаления(Источник);
КонецПроцедуры

// Добавляет признак изменения пометки удаления объекта.
// Состав параметров процедуры соответствует подписке на событие ПередЗаписью любых объектов, кроме документов.
// Описание см. в синтакс-помощнике.
//
// Параметры:
//  Источник - Объект - источник события подписки.
//  Отказ    - Булево - признак отказа от записи. Если установить Истина, то запись выполнена не будет
//                      и будет вызвано исключение.
//
Процедура УстановитьСтатусИзмененияПометкиУдаленияОбъекта(Источник, Отказ) Экспорт
	ЗаметкиПользователяСлужебный.УстановитьСтатусИзмененияПометкиУдаления(Источник);
КонецПроцедуры

#КонецОбласти
