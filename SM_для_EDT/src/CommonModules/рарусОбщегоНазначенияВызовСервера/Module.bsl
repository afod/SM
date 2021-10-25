
// ++ rarus Камаев П.В. 03.04.2020 Задача № 20783
Функция ЭтоСудноННФ(Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.vftСуда") Тогда
		МодельРДО = Значение.Проект.МодельРДО;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.vftПроектыСудов") Тогда
		МодельРДО = Значение.МодельРДО;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.впМодельРДО") Тогда
		МодельРДО = Значение;
	Иначе
		МодельРДО = Справочники.впМодельРДО.ПустаяСсылка();
	КонецЕсли;		
		
	Если ЗначениеЗаполнено(МодельРДО) Тогда
		Возврат МодельРДО = Справочники.рарусСправочникСсылок.МодельРДО_ННФ.Значение;
	Иначе
		Возврат Ложь
	КонецЕсли;
	
КонецФункции //ЭтоСудноННФ

Функция ЭтоСудноСГФ(Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.vftСуда") Тогда
		МодельРДО = Значение.Проект.МодельРДО;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.vftПроектыСудов") Тогда
		МодельРДО = Значение.МодельРДО;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.впМодельРДО") Тогда
		МодельРДО = Значение;
	Иначе
		МодельРДО = Справочники.впМодельРДО.ПустаяСсылка();
	КонецЕсли;		
		
	Если ЗначениеЗаполнено(МодельРДО) Тогда
		Возврат МодельРДО = Справочники.рарусСправочникСсылок.МодельРДО_СГФ.Значение;
	Иначе
		Возврат Ложь
	КонецЕсли;
	
КонецФункции //ЭтоСудноСГФ

Функция ЭтоСудноМСГФ(Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.vftСуда") Тогда
		МодельРДО = Значение.Проект.МодельРДО;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.vftПроектыСудов") Тогда
		МодельРДО = Значение.МодельРДО;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.впМодельРДО") Тогда
		МодельРДО = Значение;
	Иначе
		МодельРДО = Справочники.впМодельРДО.ПустаяСсылка();
	КонецЕсли;		
		
	Если ЗначениеЗаполнено(МодельРДО) Тогда
		Возврат МодельРДО = Справочники.рарусСправочникСсылок.МодельРДО_СЗП.Значение;
	Иначе
		Возврат Ложь
	КонецЕсли;
	
КонецФункции //ЭтоСудноСГФ
// -- rarus Камаев П.В. 03.04.2020

// ++ rarus Камаев П.В. 06.04.2020 Задача № 20771 
// Проверка на наличие пункта с признаком Пропустить в ТЧ
//
// Параметры:
//  ТЧ  - ТЧ документа, по которому идет проверка
// 
//  Пункт  - СправочникСсылка.рарусПунктыСледования
//
// Возвращаемое значение:
//   Булево
//
Функция ПроверитьНаНаличиеПунктаВТЧПунктыСледования(ТЧ, Пункт) Экспорт
	
	НеИспользуетсяПриПостроенииМаршрута = Истина;
	Отбор = Новый Структура;
	Отбор.Вставить("Пункт", Пункт);
	НайденныеСтроки = ТЧ.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 0  ТОгда
		НеИспользуетсяПриПостроенииМаршрута = Ложь;
	КонецЕсли;
	
	Возврат  НеИспользуетсяПриПостроенииМаршрута;
	
КонецФункции // ПроверитьНаНаличиеПунктаВТЧПунктыСледования()

// Возвращает признак НеИспользоватьПриПостроенииМаршрута для Проекта судна
//
// Параметры:
//  ПроектСудна  - СправочникСсылка.рарусПроектыСудов
// 
//  Пункт  - СправочникСсылка.рарусПунктыСледования
//
// Возвращаемое значение:
//   Булево
//
Функция НеИспользуетсяПриПостроенииМаршрута(ПроектСудна, Пункт) Экспорт
	
	НеИспользуетсяПриПостроенииМаршрута = Ложь;
	МодельРДОСудна = ПроектСудна.МодельРДО;
	Отбор = Новый Структура;
	Отбор.Вставить("МодельРДО", МодельРДОСудна);
	НайденнаяСтрока = Пункт.РазрешеноПропускать.НайтиСтроки(Отбор);
	Если НайденнаяСтрока.Количество() > 0 Тогда
		НеИспользуетсяПриПостроенииМаршрута = НайденнаяСтрока[0].НеИспользуетсяПриПостроенииМаршрута;
	КонецЕсли;
	
	Возврат  НеИспользуетсяПриПостроенииМаршрута;
	
КонецФункции // НеИспользуетсяПриПостроенииМаршрута()
// -- rarus Камаев П.В. 06.04.2020

// ++ rarus Камаев П.В. 06.04.2020 Задача № 20787
Функция ОбменССудном(Судно, ЗагрузкаДанных) Экспорт
	
	Отказ = Ложь;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК Ссылка,
	|	СценарииОбменовДаннымиНастройкиОбмена.НомерСтроки КАК НомерСтроки,
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВидТранспортаОбмена КАК ВидТранспортаОбмена,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие КАК ВыполняемоеДействие
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.Полный.Суда КАК ПолныйСуда
	|		ПО СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = ПолныйСуда.Ссылка
	|			И (ПолныйСуда.Судно = &Судно)
	|ГДЕ
	//|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие = &ВыполняемоеДействие
	|	И НЕ СценарииОбменовДаннымиНастройкиОбмена.Ссылка.ПометкаУдаления";
	Запрос.УстановитьПараметр("Судно", Судно);
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", ПланыОбмена.Полный);
	Если ЗагрузкаДанных Тогда
		Запрос.УстановитьПараметр("ВыполняемоеДействие", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Иначе
		Запрос.УстановитьПараметр("ВыполняемоеДействие", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, Выборка.Ссылка, Выборка.НомерСтроки);
		Возврат Истина
	Иначе
		Возврат Ложь
	КонецЕсли;	
	
КонецФункции

Функция ОбменСЕРП(ЗагрузкаДанных, ПрефиксЕРП) Экспорт
	
	Отказ = Ложь;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК Ссылка,
	|	СценарииОбменовДаннымиНастройкиОбмена.НомерСтроки КАК НомерСтроки,
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВидТранспортаОбмена КАК ВидТранспортаОбмена,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие КАК ВыполняемоеДействие
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы.Код = &ПрефиксЕРП
	//++ rarus isaeva 12.03.2021
	|	 И СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	//-- rarus isaeva 12.03.2021
	|	И СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие = &ВыполняемоеДействие
	|	И НЕ СценарииОбменовДаннымиНастройкиОбмена.Ссылка.ПометкаУдаления";
	//++ rarus isaeva 12.03.2021
	//Запрос.УстановитьПараметр("УзелИнформационнойБазы", ПланыОбмена.рарусОбменУправлениеПредприятиемСудовойМодуль);
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", Константы.рарусУзелДляСинхронизацииПЖ.Получить());
	//-- rarus isaeva 12.03.2021

	Запрос.УстановитьПараметр("ПрефиксЕРП", ПрефиксЕРП);
	Если ЗагрузкаДанных Тогда
		Запрос.УстановитьПараметр("ВыполняемоеДействие", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Иначе
		Запрос.УстановитьПараметр("ВыполняемоеДействие", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, Выборка.Ссылка, Выборка.НомерСтроки);
		Возврат Истина
	Иначе
		Возврат Ложь 
	КонецЕсли;	
	
КонецФункции
// -- rarus Камаев П.В. 06.04.2020

// ++ rarus Камаев П.В. 14.05.2020 Задача № 21489
Функция ОбменСГлавнымУзлом(ЗагрузкаДанных = Ложь) Экспорт
	
	Если vftОбщегоНазначения.ЭтоГлавныйУзел() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Отказ = Ложь;
	
	УстановитьПривилегированныйРежим(Истина); // isaeva 15.05.2020
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК Ссылка,
	|	СценарииОбменовДаннымиНастройкиОбмена.НомерСтроки КАК НомерСтроки,
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВидТранспортаОбмена КАК ВидТранспортаОбмена,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие КАК ВыполняемоеДействие
	|	ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.Полный КАК Полный
	|		ПО (СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = Полный.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.Полный.Суда КАК ПолныйСуда
	|		ПО (СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = ПолныйСуда.Ссылка)
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие = &ВыполняемоеДействие
	|	//И ПолныйСуда.Судно ЕСТЬ NULL
	|	И НЕ СценарииОбменовДаннымиНастройкиОбмена.Ссылка.ПометкаУдаления";
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", ПланыОбмена.Полный);
	Если ЗагрузкаДанных Тогда
		Запрос.УстановитьПараметр("ВыполняемоеДействие", Перечисления.ДействияПриОбмене.ЗагрузкаДанных);
	Иначе
		Запрос.УстановитьПараметр("ВыполняемоеДействие", Перечисления.ДействияПриОбмене.ВыгрузкаДанных);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ОбменДаннымиСервер.ВыполнитьОбменДаннымиПоСценариюОбменаДанными(Отказ, Выборка.Ссылка, Выборка.НомерСтроки);
		Возврат Истина
	Иначе
		Возврат Ложь
	КонецЕсли;	
	
	УстановитьПривилегированныйРежим(Ложь); // isaeva 15.05.2020

КонецФункции
// -- rarus Камаев П.В. 14.05.2020

// ++ rarus Камаев П.В. 08.04.2020 Задача № 20785 
Функция ПолучитьЗначениеКонстанты(ИмяКонстанты) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Если Метаданные.Константы.Найти(ИмяКонстанты) = Неопределено Тогда
		Возврат "";
	Иначе
		Возврат Константы[ИмяКонстанты].Получить();
	КонецЕсли;
КонецФункции //ПолучитьЗначениеКонстанты
// -- rarus Камаев П.В. 09.04.2020

// Камаев П.В. начало Задача № 21489
Процедура ОбменГУПринять(СтруктураПараметров, АдресХранилища) Экспорт
	
	Если НЕ vftОбщегоНазначения.ЭтоГлавныйУзел() Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотУзел = ПланыОбмена.Полный.ЭтотУзел();
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("ЭтотУзел", ЭтотУзел);
	// rarus_afod 23.03.21 Исключил из этого автообмена те суда для которых не включена синхронизация
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	Полный.Ссылка КАК Ссылка
	               |ИЗ
	               |	ПланОбмена.Полный КАК Полный
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	               |		ПО (СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = Полный.Ссылка)
	               |			И (СценарииОбменовДаннымиНастройкиОбмена.Ссылка.ИспользоватьРегламентноеЗадание)
	               |			И (НЕ СценарииОбменовДаннымиНастройкиОбмена.Ссылка.ПометкаУдаления)
	               |ГДЕ
	               |	НЕ Полный.ПометкаУдаления
	               |	И Полный.Ссылка <> &ЭтотУзел";
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоИтераций = Выборка.Количество();
	Сч = 1;
	Пока Выборка.Следующий() Цикл
		
		мПланОбмена = Выборка.Ссылка;
		Если мПланОбмена.Суда.Количество() Тогда
			Судно = мПланОбмена.Суда[0].Судно;
			Описание = "Прием данных из судна """ + Судно + """. " + "Этап " + Сч + " из " + КоличествоИтераций;
			ДлительныеОперации.СообщитьПрогресс(Окр(Сч / КоличествоИтераций * 100, 0), Описание);
			Если ЗначениеЗаполнено(Судно) Тогда
				рарусОбщегоНазначенияВызовСервера.ОбменССудном(Судно, Истина);	
			КонецЕсли;
		КонецЕсли;
		Сч = Сч + 1;
	КонецЦикла;
	
	РезультатФормирования = новый Структура;
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры
// Камаев П.В. Конец

// ++ rarus Камаев П.В. 25.11.2020 Задача № 25503
Процедура ОбменГУПередать(СтруктураПараметров, АдресХранилища) Экспорт
	
	Если НЕ vftОбщегоНазначения.ЭтоГлавныйУзел() Тогда
		Возврат;
	КонецЕсли;
	
	ЭтотУзел = ПланыОбмена.Полный.ЭтотУзел();
	
	Запрос = новый Запрос;
	Запрос.УстановитьПараметр("ЭтотУзел", ЭтотУзел);
	Запрос.Текст = "ВЫБРАТЬ
	|	Полный.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.Полный КАК Полный
	|ГДЕ
	|	НЕ Полный.ПометкаУдаления И Полный.Ссылка <> &ЭтотУзел";
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоИтераций = Выборка.Количество();
	Сч = 1;
	Пока Выборка.Следующий() Цикл
		
		мПланОбмена = Выборка.Ссылка;
		Если мПланОбмена.Суда.Количество() Тогда
			Судно = мПланОбмена.Суда[0].Судно;
			Описание = "Передача данных в судно """ + Судно + """. " + "Этап " + Сч + " из " + КоличествоИтераций;
			ДлительныеОперации.СообщитьПрогресс(Окр(Сч / КоличествоИтераций * 100, 0), Описание);
			
			//рарусОбщегоНазначенияВызовСервера.Пауза(1);
			//РезультатФормирования = новый Структура;
			//РезультатФормирования.Вставить("Описание", Описание);
			//РезультатФормирования.Вставить("Процент", Окр(Сч / КоличествоИтераций * 100, 0));
			//ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
			//
			//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Описание);
			
			Если ЗначениеЗаполнено(Судно) Тогда
				рарусОбщегоНазначенияВызовСервера.ОбменССудном(Судно, Ложь);	
			КонецЕсли;
		КонецЕсли;
		Сч = Сч + 1;
	КонецЦикла;
	
	РезультатФормирования = новый Структура;
	ПоместитьВоВременноеХранилище(РезультатФормирования, АдресХранилища);
	
КонецПроцедуры

Функция ВыполнитьОбменССудамиФоново(Параметры, АдресРезультата) Экспорт
	
	рарусОбщегоНазначенияВызовСервера.ОбменССудном(Параметры.Судно, Параметры.ЗагрузкаДанных);
	
КонецФункции

Функция ВыполнитьОбменССудами(Судно, ЗагрузкаДанных) Экспорт
	
	ВыполняемыйМетод = "рарусОбщегоНазначенияВызовСервера.ВыполнитьОбменССудамиФоново";
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ЗагрузкаДанных", ЗагрузкаДанных);
	ПараметрыПроцедуры.Вставить("Судно", Судно);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "ВыполнитьОбменССудамиФоново";
	ПараметрыВыполнения.ОжидатьЗавершения = Истина;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции
// -- rarus Камаев П.В. 25.11.2020

// ++ rarus Камаев П.В. 05.08.2020 Задача № 23173
Функция ПолучитьМодельРДО(Судно) Экспорт
			
	Возврат Судно.Проект.МодельРДО; 

КонецФункции
// -- rarus Камаев П.В. 05.08.2020

// Возвращает значения реквизита, прочитанного из информационной базы по ссылке на объект.
// Рекомендуется использовать вместо обращения к реквизитам объекта через точку от ссылки на объект
// для быстрого чтения отдельных реквизитов объекта из базы данных.
//
// Если необходимо зачитать реквизит независимо от прав текущего пользователя,
// то следует использовать предварительный переход в привилегированный режим.
//
// Параметры:
//  Ссылка    - ЛюбаяСсылка - объект, значения реквизитов которого необходимо получить.
//            - Строка      - полное имя предопределенного элемента, значения реквизитов которого необходимо получить.
//  ИмяРеквизита       - Строка - имя получаемого реквизита.
//  ВыбратьРазрешенные - Булево - если Истина, то запрос к объекту выполняется с учетом прав пользователя;
//                                если есть ограничение на уровне записей, то возвращается Неопределено;
//                                если нет прав для работы с таблицей, то возникнет исключение;
//                                если Ложь, то возникнет исключение при отсутствии прав на таблицу
//                                или любой из реквизитов.
//
// Возвращаемое значение:
//  Произвольный - зависит от типа значения прочитанного реквизита.
//               - если в параметр Ссылка передана пустая ссылка, то возвращается Неопределено;
//               - если в параметр Ссылка передана ссылка несуществующего объекта (битая ссылка), 
//                 то возвращается Неопределено.
//
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь);
	
КонецФункции 

// ++ rarus Камаев П.В. 29.09.2020 Задача № 24459
Функция ТребуетсяОбновление() Экспорт
	
	Возврат ОбменДаннымиСервер.ТребуетсяУстановкаОбновления();
	
КонецФункции

Функция ГлавныйУзел() Экспорт
	
	Возврат ОбменДаннымиСервер.ГлавныйУзел();
	
КонецФункции

Функция ВыполнитьОбменСГлавнымУзломФоново(Параметры, АдресРезультата) Экспорт
	
	рарусОбщегоНазначенияВызовСервера.ОбменСГлавнымУзлом(Параметры.ЗагрузкаДанных);
	
КонецФункции

Функция ВыполнитьОбменСГлавнымУзлом(ЗагрузкаДанных) Экспорт
	
	ВыполняемыйМетод = "рарусОбщегоНазначенияВызовСервера.ВыполнитьОбменСГлавнымУзломФоново";
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ЗагрузкаДанных", ЗагрузкаДанных);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "ВыполнитьОбменСГлавнымУзломФоново";
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ВыполняемыйМетод, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

Функция ПолучитьКонфигурацияИзменена() Экспорт
	Возврат КонфигурацияИзменена()
КонецФункции

Процедура Пауза(Время) Экспорт

   ВремяЗавершения = ТекущаяДата() + Время;
   Пока ТекущаяДата() < ВремяЗавершения Цикл
   КонецЦикла;

КонецПроцедуры

Функция СоздатьСценарииСинхронизации() Экспорт
	
	Если vftОбщегоНазначения.ЭтоГлавныйУзел() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ВыполняемоеДействиеЗагрузка 	= Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	ВыполняемоеДействиеВыгрузка 	= Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	ИспользоватьРегламентноеЗадание = Ложь;
	Расписание						= Неопределено;
		
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК Ссылка,
	|	СценарииОбменовДаннымиНастройкиОбмена.НомерСтроки КАК НомерСтроки,
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы КАК УзелИнформационнойБазы,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВидТранспортаОбмена КАК ВидТранспортаОбмена,
	|	СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие КАК ВыполняемоеДействие
	|	ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.Полный КАК Полный
	|		ПО (СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = Полный.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.Полный.Суда КАК ПолныйСуда
	|		ПО (СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = ПолныйСуда.Ссылка)
	|ГДЕ
	|	(СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие = &ВыполняемоеДействиеЗагрузка
	|	ИЛИ СценарииОбменовДаннымиНастройкиОбмена.ВыполняемоеДействие = &ВыполняемоеДействиеВыгрузка)
	|	//И ПолныйСуда.Судно ЕСТЬ NULL
	|	И НЕ СценарииОбменовДаннымиНастройкиОбмена.Ссылка.ПометкаУдаления";
	Запрос.УстановитьПараметр("ВыполняемоеДействиеЗагрузка", ВыполняемоеДействиеЗагрузка);
	Запрос.УстановитьПараметр("ВыполняемоеДействиеВыгрузка", ВыполняемоеДействиеВыгрузка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЕстьСценарийЗагрузки = Ложь;
	ЕстьСценарийВыгрузки = Ложь;
	Пока Выборка.Следующий() Цикл
		Если Выборка.ВыполняемоеДействие = ВыполняемоеДействиеЗагрузка Тогда
			ЕстьСценарийЗагрузки = Истина;
		КонецЕсли;
		Если Выборка.ВыполняемоеДействие = ВыполняемоеДействиеВыгрузка Тогда
			ЕстьСценарийВыгрузки = Истина;
		КонецЕсли;
	КонецЦикла;	
	
	//Если есть количество настроек обмена < 2, тогда нужно их создать
	Если ЕстьСценарийВыгрузки И ЕстьСценарийЗагрузки Тогда
		Возврат 0;
	ИначеЕсли ЕстьСценарийВыгрузки ИЛИ ЕстьСценарийЗагрузки Тогда
		//Если нстройка только одна, создаем заново
		СценарийОбменаДанными = Выборка.Ссылка.ПолучитьОбъект();
		СценарийОбменаДанными.НастройкиОбмена.Очистить();
	Иначе
		СценарийОбменаДанными = Справочники.СценарииОбменовДанными.СоздатьЭлемент();
	КонецЕсли;
	
	//Получаем узел
	УзелТекущиейИнформационнойБазы	= ПланыОбмена.Полный.ЭтотУзел();
	УзелИнформационнойБазы			= Неопределено;
	ВыборкаУзлов					= ПланыОбмена.Полный.Выбрать();
	Пока ВыборкаУзлов.Следующий() Цикл
		Если НЕ ВыборкаУзлов.ПометкаУдаления И ВыборкаУзлов.Ссылка <> УзелТекущиейИнформационнойБазы Тогда
			УзелИнформационнойБазы = ВыборкаУзлов.Ссылка;
			Прервать;	
		КонецЕсли;
	КонецЦикла;
	
	Отказ = Ложь;
	
	Наименование = НСтр("ru = 'Автоматическая синхронизация данных с %1'");
	Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Наименование,
	ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелИнформационнойБазы, "Наименование"));
	
	ВидТранспортаОбмена = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелИнформационнойБазы);
	
	Если НЕ ЗначениеЗаполнено(ВидТранспортаОбмена) Тогда
		Возврат 0;
	КонецЕсли;
	
	// Заполняем реквизиты шапки
	СценарийОбменаДанными.Наименование = Наименование;
	СценарийОбменаДанными.ИспользоватьРегламентноеЗадание = ИспользоватьРегламентноеЗадание;
	
	// Создаем регламентное задание.
	Справочники.СценарииОбменовДанными.ОбновитьДанныеРегламентногоЗадания(Отказ, Расписание, СценарийОбменаДанными);
	
	// Табличная часть
	СтрокаТаблицы = СценарийОбменаДанными.НастройкиОбмена.Добавить();
	СтрокаТаблицы.ВидТранспортаОбмена = ВидТранспортаОбмена;
	СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	СтрокаТаблицы = СценарийОбменаДанными.НастройкиОбмена.Добавить();
	СтрокаТаблицы.ВидТранспортаОбмена = ВидТранспортаОбмена;
	СтрокаТаблицы.ВыполняемоеДействие = Перечисления.ДействияПриОбмене.ВыгрузкаДанных;
	СтрокаТаблицы.УзелИнформационнойБазы = УзелИнформационнойБазы;
	
	Попытка
		СценарийОбменаДанными.Записать();
	Исключение
		Возврат 0;
	КонецПопытки;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции
// -- rarus Камаев П.В. 29.09.2020

// ++ rarus makole 2020-12-21
Процедура ЗапуститьРегламентноеЗаданиеОбновленияСоставаПользователей() Экспорт
	
	Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = Метаданные.РегламентныеЗадания.рарусОбновлениеСоставаПользователейНаСудне.ИмяМетода;
	
	// Проверка, выполняется ли фоновое задание по очистке устаревших версий.
	Отбор = Новый Структура;
	Отбор.Вставить("ИмяМетода", ИмяМетода);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОчистки.Количество() = 0 Тогда
		СинонимФЗ = Метаданные.РегламентныеЗадания.рарусОбновлениеСоставаПользователейНаСудне.Синоним;
		НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Запуск вручную: %1'"), СинонимФЗ);
		ФоновыеЗадания.Выполнить(ИмяМетода,,, НаименованиеФоновогоЗадания);
	КонецЕсли;

КонецПроцедуры // -- rarus makole 2020-12-21 
// -- rarus Камаев П.В. 29.09.2020

// ++ rarus PleA 03.03.2021 
Процедура УстановитьВерсиюКонфигурацииСудна() Экспорт

	рарусОбщегоНазначенияСервер.УстановитьВерсиюКонфигурацииСудна();

КонецПроцедуры
// -- rarus PleA

// ++ rarus makole 2021-03-26

// Возвращает структуру версий конфигурации и платформы узла плана обмена Полный
// Параметры:
// 	КодУзла	-	Строка - Необязательный. Код узла плана обмена Полный, по которому запрашиваются данные
//						Если не передать, функция вернёт версии текущей ИБ
Функция ВерсияКонфигурацииПлатформы(КодУзла = Неопределено) Экспорт
	Возврат рарусОбщегоНазначенияСервер.ВерсияКонфигурацииПлатформы(КодУзла);
КонецФункции
// -- rarus makole 2021-03-26

// ++ rarus makole 2021-03-31
Функция ЭтоКапитан(Пользователь = Неопределено) Экспорт
	Возврат рарусОбщегоНазначенияСервер.ЭтоКапитан(Пользователь)
КонецФункции
// -- rarus makole 2021-03-31

// ++ rarus selmik 04.10.2021 РАIT-0023502
Процедура ПолучитьСтатусЗаявкиНаРемонт(ЗаявкаНаРемонт) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗаявкаНаРемонт) Или ТипЗнч(ЗаявкаНаРемонт) <> Тип("ДокументСсылка.впЗаявкаНаРемонт") Тогда
		Возврат;
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	впЗаявкаНаРемонтРемонтыОборудования1.Ссылка КАК ЗаявкаНаРемонт
		|ИЗ
		|	Документ.впЗаявкаНаРемонт.РемонтыОборудования КАК впЗаявкаНаРемонтРемонтыОборудования
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.впЗаявкаНаРемонт.РемонтыОборудования КАК впЗаявкаНаРемонтРемонтыОборудования1
		|		ПО впЗаявкаНаРемонтРемонтыОборудования.Ссылка <> впЗаявкаНаРемонтРемонтыОборудования1.Ссылка
		|			И (НЕ впЗаявкаНаРемонтРемонтыОборудования1.Ссылка.ПометкаУдаления)
		|			И впЗаявкаНаРемонтРемонтыОборудования.ID = впЗаявкаНаРемонтРемонтыОборудования1.ID
		|ГДЕ
		|	впЗаявкаНаРемонтРемонтыОборудования.Ссылка = &ЗаявкаНаРемонт
		|
		|СГРУППИРОВАТЬ ПО
		|	впЗаявкаНаРемонтРемонтыОборудования1.Ссылка";
	
	Запрос.УстановитьПараметр("ЗаявкаНаРемонт", ЗаявкаНаРемонт);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивЗаявокНаРемонт = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ЗаявкаНаРемонт");
	
	МассивЗаявокНаРемонт.Добавить(ЗаявкаНаРемонт);
	
	Для Каждого ЭлементЗаявкаНаРемонт Из МассивЗаявокНаРемонт Цикл // Цикл больше одного элемента, когда по одному ремонту несколько заявок, редкая ситуация
				
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	впЗаявкаНаРемонтРемонтыОборудования.ID КАК ID
		|ПОМЕСТИТЬ Вт_РемонтыИзЗаявки
		|ИЗ
		|	Документ.впЗаявкаНаРемонт.РемонтыОборудования КАК впЗаявкаНаРемонтРемонтыОборудования
		|ГДЕ
		|	впЗаявкаНаРемонтРемонтыОборудования.Ссылка = &ЗаявкаНаРемонт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	впАктОВыполненииЭтапаРаботРемонтыОборудования.ID КАК ID,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА НЕ впАктОВыполненииЭтапаРаботРемонтыОборудования.Ссылка ЕСТЬ NULL
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ЕстьАкт,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА впАктОВыполненииЭтапаРаботРемонтыОборудования.Выполнено
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ЕстьВыполненныйАкт
		|ПОМЕСТИТЬ Вт_Акты_ПоЗаявкам
		|ИЗ
		|	Вт_РемонтыИзЗаявки КАК Вт_РемонтыИзЗаявки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.впАктОВыполненииЭтапаРабот.РемонтыОборудования КАК впАктОВыполненииЭтапаРаботРемонтыОборудования
		|		ПО Вт_РемонтыИзЗаявки.ID = впАктОВыполненииЭтапаРаботРемонтыОборудования.ID
		|			И (впАктОВыполненииЭтапаРаботРемонтыОборудования.Ссылка.Проведен)
		|
		|СГРУППИРОВАТЬ ПО
		|	впАктОВыполненииЭтапаРаботРемонтыОборудования.ID
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(1) КАК КоличествоЗаявокНаРемонт,
		|	СУММА(ВЫБОР
		|			КОГДА Вт_Акты_ПоЗаявкам.ЕстьАкт ЕСТЬ NULL
		|				ТОГДА 0
		|			ИНАЧЕ Вт_Акты_ПоЗаявкам.ЕстьАкт
		|		КОНЕЦ) КАК КоличествоАктов,
		|	СУММА(ВЫБОР
		|			КОГДА Вт_Акты_ПоЗаявкам.ЕстьВыполненныйАкт ЕСТЬ NULL
		|				ТОГДА 0
		|			ИНАЧЕ Вт_Акты_ПоЗаявкам.ЕстьВыполненныйАкт
		|		КОНЕЦ) КАК КоличествоВыполненныхАктов
		|ПОМЕСТИТЬ Вт_ПредварительныеИтоги
		|ИЗ
		|	Вт_РемонтыИзЗаявки КАК Вт_РемонтыИзЗаявки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Вт_Акты_ПоЗаявкам КАК Вт_Акты_ПоЗаявкам
		|		ПО Вт_РемонтыИзЗаявки.ID = Вт_Акты_ПоЗаявкам.ID
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Вт_ПредварительныеИтоги.КоличествоЗаявокНаРемонт <= Вт_ПредварительныеИтоги.КоличествоВыполненныхАктов
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.рарусСтатусыЗаявокНаРемонт.Закрыта)
		|		КОГДА Вт_ПредварительныеИтоги.КоличествоАктов > 0
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.рарусСтатусыЗаявокНаРемонт.ВРаботе)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.рарусСтатусыЗаявокНаРемонт.Сформирована)
		|	КОНЕЦ КАК НовыйСтатус,
		|	рарусСтатусыЗаказовНаРемонт.Статус КАК СтарыйСтатус
		|ИЗ
		|	Вт_ПредварительныеИтоги КАК Вт_ПредварительныеИтоги
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.рарусСтатусыЗаказовНаРемонт КАК рарусСтатусыЗаказовНаРемонт
		|		ПО (&ЗаявкаНаРемонт = рарусСтатусыЗаказовНаРемонт.ЗаявкаНаРемонт)";
		
		Запрос.УстановитьПараметр("ЗаявкаНаРемонт", ЭлементЗаявкаНаРемонт);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		СтарыйСтатус = Неопределено;
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			НовыйСтатус 	= ВыборкаДетальныеЗаписи.НовыйСтатус;
			СтарыйСтатус 	= ВыборкаДетальныеЗаписи.СтарыйСтатус;
		Иначе
			НовыйСтатус = Перечисления.рарусСтатусыЗаявокНаРемонт.Сформирована;
		КонецЕсли;
		
		Если НовыйСтатус <> СтарыйСтатус Тогда
			МенеджерЗаписи 					= РегистрыСведений.рарусСтатусыЗаказовНаРемонт.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ЗаявкаНаРемонт 	= ЭлементЗаявкаНаРемонт;
			МенеджерЗаписи.Статус 			= НовыйСтатус;
			МенеджерЗаписи.Записать();
		КонецЕсли;
	КонецЦикла
КонецПроцедуры // -- rarus selmik 04.10.2021 РАIT-0023502

