///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	НастройкиОтчета.Описание = НСтр("ru = 'Анализ зависших задач, которые не могут быть выполнены, так как у них не назначены исполнители.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СводкаПоЗависшимЗадачам");
	НастройкиВарианта.Описание = НСтр("ru = 'Сводка по количеству зависших задач, назначенных на роли, для которых не задано ни одного исполнителя.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЗависшиеЗадачиПоИсполнителям");
	НастройкиВарианта.Описание = НСтр("ru = 'Список зависших задач, назначенных на роли, для которых не задано ни одного исполнителя.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ЗависшиеЗадачиПоОбъектамАдресации");
	НастройкиВарианта.Описание = НСтр("ru = 'Список зависших задач по объектам адресации.'");
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ПросроченныеЗадачи");
	НастройкиВарианта.Описание = НСтр("ru = 'Список просроченных и зависших задач, которые не могут быть выполнены, так как у них не назначены исполнители.'");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли