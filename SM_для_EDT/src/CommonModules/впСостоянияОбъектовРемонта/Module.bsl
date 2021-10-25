
#Область Проведение

// Формирует параметры для проведения документа по регистрам учетного механизма через общий механизм проведения.
//
// Параметры:
//  Документ - ДокументОбъект - записываемый документ
//  Свойства - ФиксированнаяСтруктура - свойства документа (См. ПроведениеДокументов.СвойстваДокумента).
//
// Возвращаемое значение:
//  Структура - параметры учетного механизма (См. ПроведениеДокументов.ПараметрыУчетногоМеханизма()).
//
Функция ПараметрыДляПроведенияДокумента(Документ, Свойства) Экспорт
	
	Параметры = ПроведениеДокументов.ПараметрыУчетногоМеханизма();
	
	// Проведение
	Если Свойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыСведений.впТекущееСостояниеОР);
		Параметры.ПодчиненныеРегистры.Добавить(Метаданные.РегистрыНакопления.впВремяПростояОборудования);
		
	КонецЕсли;
	
	// Контроль
	Если Свойства.РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		
		//Параметры.КонтрольныеРегистрыЗаданий.Добавить(Метаданные.РегистрыНакопления.впВремяПростояОборудования);
		
	КонецЕсли;
		
	Возврат Параметры;
	
КонецФункции

// Процедура формирования движений по подчиненным регистрам
//
// Параметры:
//   ТаблицыДляДвижений - Структура - таблицы данных документа
//   Движения - КоллекцияДвижений - коллекция наборов записей движений документа
//   Отказ - Булево - признак отказа от проведения документа.
//
Процедура ОтразитьДвижения(ТаблицыДляДвижений, Движения, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "впТекущееСостояниеОР");
	ПроведениеДокументов.ОтразитьДвижения(ТаблицыДляДвижений, Движения, "впВремяПростояОборудования");
	
КонецПроцедуры

// Процедура формирования движений по независимым регистрам
//
// Параметры:
//	ТаблицыДляДвижений - Структура - таблицы данных документа
//	Документ - ДокументСсылка - ссылка на документ
//	Отказ - Булево - признак отказа от проведения документа.
//
Процедура ЗаписатьДанные(ТаблицыДляДвижений, Документ, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
