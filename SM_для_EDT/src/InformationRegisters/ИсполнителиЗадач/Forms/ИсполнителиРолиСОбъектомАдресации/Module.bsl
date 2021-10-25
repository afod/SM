///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Роль = Параметры.Роль;
	УстановитьДоступностьРоли(Роль);
	ОсновнойОбъектАдресации = Параметры.ОсновнойОбъектАдресации;
	Если ОсновнойОбъектАдресации = Неопределено Или ОсновнойОбъектАдресации = "" Тогда
		Элементы.ДополнительныйОбъектАдресации.Видимость = Ложь;
		Элементы.Список.Шапка = Ложь;
		Элементы.ОсновнойОбъектАдресации.Видимость = Ложь;
	Иначе
		Элементы.ОсновнойОбъектАдресации.Заголовок = ОсновнойОбъектАдресации.Метаданные().ПредставлениеОбъекта;
		ДополнительныйОбъектАдресации = Параметры.Роль.ТипыДополнительногоОбъектаАдресации;
		Элементы.ДополнительныйОбъектАдресации.Видимость = НЕ ДополнительныйОбъектАдресации.Пустая();
		Элементы.ДополнительныйОбъектАдресации.Заголовок = ДополнительныйОбъектАдресации.Наименование;
		ТипыДополнительногоОбъектаАдресации = ДополнительныйОбъектАдресации.ТипЗначения;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Исполнители роли ""%1""'"), Роль);
	
	УстановитьОтборНабораЗаписей();
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРоли(Роль)
	
	РольДоступнаДляВнешнихПользователей = ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	Если Не РольДоступнаДляВнешнихПользователей Тогда
		РольДоступнаДляПользователей = Истина;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РолиИсполнителейНазначение.ТипПользователей
		|ИЗ
		|	Справочник.РолиИсполнителей.Назначение КАК РолиИсполнителейНазначение
		|ГДЕ
		|	РолиИсполнителейНазначение.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Роль);
	
	РезультатЗапроса = Запрос.Выполнить();
	УРолиНеНазначеныВнешниеПользователи = Истина;
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		РольДоступнаДляПользователей = Ложь;
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Назначение.Добавить(ВыборкаДетальныеЗаписи.ТипПользователей);
			Если ВыборкаДетальныеЗаписи.ТипПользователей = Справочники.Пользователи.ПустаяСсылка() Тогда
				РольДоступнаДляПользователей = Истина;
			Иначе
				УРолиНеНазначеныВнешниеПользователи = Ложь;
			КонецЕсли;
		
		КонецЦикла;
	Иначе
		РольДоступнаДляПользователей = Истина;
	КонецЕсли;
	
	Если УРолиНеНазначеныВнешниеПользователи Тогда
		РольДоступнаДляВнешнихПользователей = Ложь;
	КонецЕсли;
	
	Если РольДоступнаДляВнешнихПользователей И РольДоступнаДляПользователей Тогда
		Элементы.Исполнитель.ВыбиратьТип = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьОтборНабораЗаписей();

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборНабораЗаписей()
	
	НаборЗаписейОбъект = РеквизитФормыВЗначение("НаборЗаписей");
	НаборЗаписейОбъект.Отбор.ОсновнойОбъектАдресации.Установить(ОсновнойОбъектАдресации);
	НаборЗаписейОбъект.Отбор.РольИсполнителя.Установить(Роль);
	НаборЗаписейОбъект.Прочитать();
	ЗначениеВРеквизитФормы(НаборЗаписейОбъект, "НаборЗаписей");
	Для каждого Запись Из НаборЗаписей Цикл
		Запись.Недействителен = Запись.Исполнитель.Недействителен;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Для каждого СтрокаИсполнитель Из НаборЗаписей Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаИсполнитель.Исполнитель) Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Необходимо указать исполнителей.'"));
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_РолеваяАдресация", ПараметрыЗаписи, НаборЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если Роль <> Неопределено Тогда
		Элемент.ТекущиеДанные.РольИсполнителя = Роль;
	КонецЕсли;
	Если ОсновнойОбъектАдресации <> Неопределено Тогда
		Элемент.ТекущиеДанные.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
	КонецЕсли;
	
	Элемент.ТекущиеДанные.Недействителен = ОпределитьДействительностьПользователей(Элемент.ТекущиеДанные.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Элементы.ДополнительныйОбъектАдресации.Видимость Тогда
		Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные <> Неопределено И НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Исполнитель) Тогда
		Если РольДоступнаДляПользователей И НЕ РольДоступнаДляВнешнихПользователей Тогда
			Элемент.ТекущиеДанные.Исполнитель = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		ИначеЕсли НЕ РольДоступнаДляПользователей И РольДоступнаДляВнешнихПользователей Тогда
			Элемент.ТекущиеДанные.Исполнитель = ПредопределенноеЗначение("Справочник.ВнешниеПользователи.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СписокПользователей = ОпределитьДействительностьПользователей(ВыбранноеЗначение);
	Для каждого Значение Из СписокПользователей Цикл
		
		Если НаборЗаписей.НайтиСтроки(Новый Структура("Исполнитель", Значение.Ключ)).Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;
			
		Исполнитель = НаборЗаписей.Добавить();
		
		Исполнитель.Исполнитель = Значение.Ключ;
		Исполнитель.Недействителен = Значение.Значение;
		Если Роль <> Неопределено Тогда
			Исполнитель.РольИсполнителя = Роль;
		КонецЕсли;
		Если ОсновнойОбъектАдресации <> Неопределено Тогда
			Исполнитель.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
		КонецЕсли;
		Модифицированность = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервереБезКонтекста
Функция ОпределитьДействительностьПользователей(СписокПользователей)
	
	Если ЗначениеЗаполнено(СписокПользователей) Тогда
		Если ТипЗнч(СписокПользователей) = тип("Массив") Тогда
			Результат = Новый Соответствие;
			Для каждого Значение Из СписокПользователей Цикл
				Результат.Вставить(Значение, Значение.Недействителен);
			КонецЦикла;
			Возврат Результат;
		Иначе
			Возврат СписокПользователей.Недействителен;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура Подобрать(Команда)
	
	Если РольДоступнаДляВнешнихПользователей И РольДоступнаДляПользователей Тогда
		Выбор = Новый СписокЗначений;
		Выбор.Добавить("ВнешнийПользователь", НСтр("ru = 'Внешний пользователь'"));
		Выбор.Добавить("Пользователь", НСтр("ru = 'Пользователь'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораТипаПользователя", ЭтотОбъект);
		Выбор.ПоказатьВыборЭлемента(ОписаниеОповещения, НСтр("ru = 'Выберите тип пользователя'"));
	ИначеЕсли РольДоступнаДляПользователей Тогда
		ОткрытьФормуПодбора("Пользователь");
	ИначеЕсли РольДоступнаДляВнешнихПользователей Тогда
		ОткрытьФормуПодбора("ВнешнийПользователь");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыбораТипаПользователя(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ОткрытьФормуПодбора(Результат.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПодбора(РежимОткрытия)
	
	ПараметрыФормыВыбора = Новый Структура;
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Ложь);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Ложь);
		
	Если РежимОткрытия = "ВнешнийПользователь" Тогда
		ПараметрыФормыВыбора.Вставить("Назначение", Назначение.ВыгрузитьЗначения());
		ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаВыбора", ПараметрыФормыВыбора, Элементы.Список);
	Иначе
		ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормыВыбора, Элементы.Список);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Исполнитель");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаборЗаписей.Недействителен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение);
	
КонецПроцедуры

#КонецОбласти
