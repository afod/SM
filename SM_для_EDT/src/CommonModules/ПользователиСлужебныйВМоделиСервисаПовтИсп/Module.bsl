///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Читает из константы информацию о регистрах и формирует соответствие для СписокРегистровСсылающихсяНаПользователей.
//
Функция СписокНаборовЗаписейСоСсылкамиНаПользователей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ОписаниеМетаданных = НаборыЗаписейСоСсылкамиНаПользователей();
	
	СписокМетаданных = Новый Соответствие;
	Для Каждого Строка Из ОписаниеМетаданных Цикл
		СписокМетаданных.Вставить(Метаданные[Строка.Коллекция][Строка.Объект], Строка.Измерения);
	КонецЦикла;
	
	Возврат СписокМетаданных;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает наборы записей, содержащие полей, для которых в качестве типа значения установлен
// тип СправочникСсылка.Пользователи.
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//                         * Коллекция - Строка - имя коллекции метаданных,
//                         * Объект - Строка - имя объекта метаданных,
//                         * Измерения - Массив(Строка) - имена измерений.
//
Функция НаборыЗаписейСоСсылкамиНаПользователей()
	
	ОписаниеМетаданных = Новый ТаблицаЗначений;
	ОписаниеМетаданных.Колонки.Добавить("Коллекция", Новый ОписаниеТипов("Строка"));
	ОписаниеМетаданных.Колонки.Добавить("Объект", Новый ОписаниеТипов("Строка"));
	ОписаниеМетаданных.Колонки.Добавить("Измерения", Новый ОписаниеТипов("Массив"));
	
	Для Каждого РегистрСведений Из Метаданные.РегистрыСведений Цикл
		ДобавитьКСпискуМетаданных(ОписаниеМетаданных, РегистрСведений, "РегистрыСведений");
	КонецЦикла;
	
	Для Каждого Последовательность Из Метаданные.Последовательности Цикл
		ДобавитьКСпискуМетаданных(ОписаниеМетаданных, Последовательность, "Последовательности");
	КонецЦикла;
	
	Возврат ОписаниеМетаданных;
	
КонецФункции

Процедура ДобавитьКСпискуМетаданных(Знач СписокМетаданных, Знач МетаданныеОбъекта, Знач ИмяКоллекции)
	
	ТипСсылкиПользователя = Тип("СправочникСсылка.Пользователи");
	
	Измерения = Новый Массив;
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл 
		
		Если (Измерение.Тип.СодержитТип(ТипСсылкиПользователя)) Тогда
			Измерения.Добавить(Измерение.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Измерения.Количество() > 0 Тогда
		Строка = СписокМетаданных.Добавить();
		Строка.Коллекция = ИмяКоллекции;
		Строка.Объект = МетаданныеОбъекта.Имя;
		Строка.Измерения = Измерения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти