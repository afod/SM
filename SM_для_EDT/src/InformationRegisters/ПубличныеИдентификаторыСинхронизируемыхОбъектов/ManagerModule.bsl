///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСлужебный.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "ПубличныеИдентификаторыСинхронизируемыхОбъектов", Загрузка);
	
КонецПроцедуры

Функция ЗаписьЕстьВРегистре(СтруктураЗаписи) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЕстьЗапись
	|ИЗ
	|	РегистрСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов КАК РПИ
	|ГДЕ
	|	РПИ.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И РПИ.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", СтруктураЗаписи.УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("Ссылка",                 СтруктураЗаписи.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

// Процедура удаляет набор записей в регистре по переданным значениям структуры.
Процедура УдалитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСлужебный.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "ПубличныеИдентификаторыСинхронизируемыхОбъектов", Загрузка);
	
КонецПроцедуры

// Преобразует ссылку на объект текущей информационной базы в строковое представление УИД.
// Если в регистре ПубличныеИдентификаторыСинхронизируемыхОбъектов есть такая ссылка, возвращается УИД из регистра.
// В противном случае возвращается УИД переданной ссылки.
// 
// Параметры:
//  УзелИнформационнойБазы - Ссылка на узел плана обмена, в который происходит выгрузка данных.
//  СсылкаНаОбъект - ссылка на объект информационной базы, для которого необходимо получить
//                   уникальный идентификатор объекта XDTO.
//
// Возвращаемое значение:
//  Строка - Уникальный идентификатор объекта.
Функция ПубличныйИдентификаторПоСсылкеОбъекта(УзелИнформационнойБазы, СсылкаНаОбъект) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Определение публичной ссылки через ссылку на объект.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	РПИ.Идентификатор КАК Идентификатор
	|ИЗ
	|	РегистрСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов КАК РПИ
	|ГДЕ
	|	РПИ.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	И РПИ.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.УстановитьПараметр("Ссылка",                 СсылкаНаОбъект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат СокрЛП(Выборка.Идентификатор);
	ИначеЕсли Выборка.Количество() > 1 Тогда
		СтруктураЗаписи = Новый Структура();
		СтруктураЗаписи.Вставить("УзелИнформационнойБазы", УзелИнформационнойБазы);
		СтруктураЗаписи.Вставить("Ссылка",                 СсылкаНаОбъект);
		УдалитьЗапись(СтруктураЗаписи, Истина);
	КонецЕсли;
	
	Возврат СокрЛП(СсылкаНаОбъект.УникальныйИдентификатор());

КонецФункции

#КонецОбласти

#КонецЕсли