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
	
	КонтейнерСостояний = Новый Структура;
	КонтейнерСостояний.Вставить("ОбластиПоиска", Новый СписокЗначений); // Идентификаторы объектов метаданных.
	КонтейнерСостояний.Вставить("ТекущийРаздел", "");
	КонтейнерСостояний.Вставить("ИдентификаторСтроки", 0);
	
	Параметры.Свойство("ОбластиПоиска", КонтейнерСостояний.ОбластиПоиска);
	Параметры.Свойство("ИскатьВРазделах", ПереключательВездеВРазделах); // Конвертация из Булево в Число.
	
	ЗагрузитьТекущийПутьРаздела(КонтейнерСостояний);
	
	ПриЗаполненииДереваРазделовПоиска(КонтейнерСостояний);
	
	ИскатьВРазделах = ИскатьВРазделах(ПереключательВездеВРазделах);
	ОбновитьДоступностьПриПереключенииВездеВРазделах(Элементы.ДеревоРазделовПоиска, ИскатьВРазделах);
	ОбновитьДоступностьПриПереключенииВездеВРазделах(Элементы.Команды, ИскатьВРазделах);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьТекущийРазделДереваРазделов(Элементы.ДеревоРазделовПоиска, КонтейнерСостояний)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбластьПоискаПриИзменении(Элемент)
	
	ИскатьВРазделах = ИскатьВРазделах(ПереключательВездеВРазделах);
	ОбновитьДоступностьПриПереключенииВездеВРазделах(Элементы.ДеревоРазделовПоиска, ИскатьВРазделах);
	ОбновитьДоступностьПриПереключенииВездеВРазделах(Элементы.Команды, ИскатьВРазделах);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоРазделовПоиска

&НаКлиенте
Процедура ДеревоРазделовПоискаПометкаПриИзменении(Элемент)
	
	ЭлементДерева = ТекущийЭлемент.ТекущиеДанные;
	
	ПриПометкеЭлементаДерева(ЭлементДерева);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ТекущиеДанные = Элементы.ДеревоРазделовПоиска.ТекущиеДанные;
	
	ТекущийРаздел = "";
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийРаздел = ТекущиеДанные.Раздел;
	КонецЕсли;
	ИдентификаторСтроки = Элементы.ДеревоРазделовПоиска.ТекущаяСтрока;
	
	СохранитьТекущийПутьРаздела(ТекущийРаздел, ИдентификаторСтроки);
	
	НастройкиПоиска = Новый Структура;
	НастройкиПоиска.Вставить("ОбластиПоиска", СписокОбластейДереваРазделов());
	НастройкиПоиска.Вставить("ИскатьВРазделах", ИскатьВРазделах(ПереключательВездеВРазделах));
	
	Закрыть(НастройкиПоиска);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	ПометитьВсеЭлементыДереваРекурсивно(ДеревоРазделовПоиска, ПометкаФлажокНеУстановлен());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	ПометитьВсеЭлементыДереваРекурсивно(ДеревоРазделовПоиска, ПометкаФлажокУстановлен());
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсе(Команда)
	
	КоллекцияЭлементовДерева = ДеревоРазделовПоиска.ПолучитьЭлементы();
	ЭлементДеревоРазделов = Элементы.ДеревоРазделовПоиска;
	
	Для каждого ЭлементДерева Из КоллекцияЭлементовДерева Цикл
		ЭлементДеревоРазделов.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе(Команда)
	
	КоллекцияЭлементовДерева = ДеревоРазделовПоиска.ПолучитьЭлементы();
	ЭлементДеревоРазделов = Элементы.ДеревоРазделовПоиска;
	
	Для каждого ЭлементДерева Из КоллекцияЭлементовДерева Цикл
		ЭлементДеревоРазделов.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеОбработчикиСобытий

&НаСервере
Процедура ПриЗаполненииДереваРазделовПоиска(КонтейнерСостояний)
	
	Дерево = РеквизитФормыВЗначение("ДеревоРазделовПоиска");
	ЗаполнитьДеревоРазделовПоиска(Дерево);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоРазделовПоиска");
	
	ПриУстановкеОбластиПоиска(ДеревоРазделовПоиска, КонтейнерСостояний);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриУстановкеОбластиПоиска(ДеревоРазделовПоиска, КонтейнерСостояний)
	
	ОбластиПоиска = КонтейнерСостояний.ОбластиПоиска;
	
	Для каждого ОбластьПоиска Из ОбластиПоиска Цикл
		
		ЭлементДерева = Неопределено;
		ТекущийРаздел = Неопределено;
		ВложенныеЭлементы = ДеревоРазделовПоиска.ПолучитьЭлементы();
		
		// Поиск элемента дерева по пути к данным.
		
		ПутьКДанным = ОбластьПоиска.Представление;
		Разделы = СтрРазделить(ПутьКДанным, ",", Ложь);
		Для каждого ТекущийРаздел Из Разделы Цикл
			Для каждого ЭлементДерева Из ВложенныеЭлементы Цикл
				
				Если ЭлементДерева.Раздел = ТекущийРаздел Тогда
					ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
		// Если элемент дерева найден, установка пометки.
		
		Если ЭлементДерева <> Неопределено
			И ЭлементДерева.Раздел = ТекущийРаздел Тогда
			
			ЭлементДерева.Пометка = ПометкаФлажокУстановлен();
			ПометитьЭлементыРодителейРекурсивно(ЭлементДерева);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПриПометкеЭлементаДерева(ЭлементДерева)
	
	ЭлементДерева.Пометка = СледующееЗначениеПометкиЭлемента(ЭлементДерева);
	
	Если ТребуетсяПометитьВложенныеЭлементы(ЭлементДерева) Тогда 
		ПометитьВложенныеЭлементыРекурсивно(ЭлементДерева);
	КонецЕсли;
	
	Если ЭлементДерева.Пометка = ПометкаФлажокНеУстановлен() Тогда 
		ЭлементДерева.Пометка = ЗначениеПометкиОтносительноВложенныхЭлементов(ЭлементДерева);
	КонецЕсли;
	
	ПометитьЭлементыРодителейРекурсивно(ЭлементДерева);
	
КонецПроцедуры

#КонецОбласти

#Область МодельПредставления

&НаКлиентеНаСервереБезКонтекста
Функция ПометкаФлажокНеУстановлен()
	
	Возврат 0;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПометкаФлажокУстановлен()
	
	Возврат 1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПометкаКвадрат()
	
	Возврат 2;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоРазделовПоиска(ДеревоРазделовПоиска)
	
	ДобавитьСтрокиДереваРазделовПоискаПоПодсистемамРекурсивно(ДеревоРазделовПоиска, Метаданные.Подсистемы);
	
	ПолнотекстовыйПоискСерверПереопределяемый.ПриПолученииРазделовПолнотекстовогоПоиска(ДеревоРазделовПоиска);
	
	ЗаполнениеСлужебныхСвойствПослеПолученияРазделовРекурсивно(ДеревоРазделовПоиска);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСтрокиДереваРазделовПоискаПоПодсистемамРекурсивно(ТекущаяСтрокаДерева, Подсистемы)
	
	Для каждого Подсистема Из Подсистемы Цикл
		
		Если ОбъектМетаданныхДоступен(Подсистема) Тогда
			
			НоваяСтрокаПодсистема = НовыйЭлементДереваРаздел(ТекущаяСтрокаДерева, Подсистема);
			
			ДобавитьСтрокиДереваРазделовПоискаПоСоставуРекурсивно(НоваяСтрокаПодсистема, Подсистема.Состав);
			
			Если Подсистема.Подсистемы.Количество() > 0 Тогда
				ДобавитьСтрокиДереваРазделовПоискаПоПодсистемамРекурсивно(НоваяСтрокаПодсистема, Подсистема.Подсистемы);
			КонецЕсли;
			
			Если НоваяСтрокаПодсистема.Строки.Количество() = 0 Тогда
				ТекущаяСтрокаДерева.Строки.Удалить(НоваяСтрокаПодсистема);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСтрокиДереваРазделовПоискаПоСоставуРекурсивно(ТекущаяСтрокаДерева, СоставПодсистемы)
	
	Для каждого ОбъектПодсистемы Из СоставПодсистемы Цикл
		
		Если ОбщегоНазначения.ЭтоСправочник(ОбъектПодсистемы)
			Или ОбщегоНазначения.ЭтоДокумент(ОбъектПодсистемы)
			Или ОбщегоНазначения.ЭтоРегистрСведений(ОбъектПодсистемы)
			Или ОбщегоНазначения.ЭтоЗадача(ОбъектПодсистемы) Тогда
			
			Если ОбъектМетаданныхДоступен(ОбъектПодсистемы) Тогда
				
				НоваяСтрокаОбъект = НовыйЭлементДереваОбъектМетаданных(ТекущаяСтрокаДерева, ОбъектПодсистемы);
				
				Если ОбщегоНазначения.ЭтоСправочник(ОбъектПодсистемы) Тогда 
					ПодчиненныеСправочники = ПодчиненныеСправочники(ОбъектПодсистемы);
					ДобавитьСтрокиДереваРазделовПоискаПоСоставуРекурсивно(НоваяСтрокаОбъект, ПодчиненныеСправочники);
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли ОбщегоНазначения.ЭтоЖурналДокументов(ОбъектПодсистемы) Тогда
			
			Если ОбъектМетаданныхДоступен(ОбъектПодсистемы) Тогда
				
				НоваяСтрокаЖурнал = НовыйЭлементДереваРаздел(ТекущаяСтрокаДерева, ОбъектПодсистемы);
				
				ДобавитьСтрокиДереваРазделовПоискаПоСоставуРекурсивно(НоваяСтрокаЖурнал, ОбъектПодсистемы.РегистрируемыеДокументы);
				
				Если НоваяСтрокаЖурнал.Строки.Количество() = 0 Тогда
					ТекущаяСтрокаДерева.Строки.Удалить(НоваяСтрокаЖурнал);
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НовыйЭлементДереваРаздел(ТекущаяСтрокаДерева, Раздел)
	
	ПредставлениеРаздела = Раздел;
	Если ОбщегоНазначения.ЭтоЖурналДокументов(Раздел) Тогда
		ПредставлениеРаздела = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (Журнал)'"), ПредставлениеРаздела);
	КонецЕсли;
	
	НоваяСтрока = ТекущаяСтрокаДерева.Строки.Добавить();
	НоваяСтрока.Раздел = ПредставлениеРаздела;
	
	Если ЭтоКорневаяПодсистема(Раздел) Тогда 
		НоваяСтрока.Картинка = Раздел.Картинка;
	КонецЕсли;
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервереБезКонтекста
Функция НовыйЭлементДереваОбъектМетаданных(ТекущаяСтрокаДерева, ОбъектМетаданных)
	
	ПредставлениеОбъекта = ОбщегоНазначения.ПредставлениеСписка(ОбъектМетаданных);
	
	НоваяСтрока = ТекущаяСтрокаДерева.Строки.Добавить();
	НоваяСтрока.Раздел = ПредставлениеОбъекта;
	НоваяСтрока.ОбъектМД = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнениеСлужебныхСвойствПослеПолученияРазделовРекурсивно(ТекущаяСтрокаДерева)
	
	Если ТипЗнч(ТекущаяСтрокаДерева) = Тип("СтрокаДереваЗначений") Тогда 
		
		// Заполнение ПутьКДанным и ЭтоПодраздел и ЭтоОбъектМетаданных выполняется после формирования дерева
		// для того, чтобы корректно расставить эти признаки для добавленных в событии
		// ПолнотекстовыйПоискСерверПереопределяемый.ПриПолученииРазделовПолнотекстовогоПоиска
		// разделов и освободить разработчиков конфигурации от необходимости думать над этими полями.
		
		ЭтоОбъектМетаданных = ЗначениеЗаполнено(ТекущаяСтрокаДерева.ОбъектМД);
		
		ТекущаяСтрокаДерева.ЭтоОбъектМетаданных = ЭтоОбъектМетаданных;
		
		Если ТекущаяСтрокаДерева.Уровень() = 0 Тогда 
			ТекущаяСтрокаДерева.ПутьКДанным = ТекущаяСтрокаДерева.Раздел;
		Иначе 
			ТекущаяСтрокаДерева.ЭтоПодраздел = Не ЭтоОбъектМетаданных;
			ТекущаяСтрокаДерева.ПутьКДанным = ТекущаяСтрокаДерева.Родитель.ПутьКДанным + "," + ТекущаяСтрокаДерева.Раздел;
		КонецЕсли;
		
	КонецЕсли;
	
	Для каждого ПодчиненнаяСтрока Из ТекущаяСтрокаДерева.Строки Цикл 
		ЗаполнениеСлужебныхСвойствПослеПолученияРазделовРекурсивно(ПодчиненнаяСтрока);
		ПодчиненнаяСтрока.Строки.Сортировать("ЭтоПодраздел, Раздел");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СписокОбластейДереваРазделов()
	
	Дерево = РеквизитФормыВЗначение("ДеревоРазделовПоиска");
	
	СписокОбластей = Новый СписокЗначений;
	ЗаполнитьСписокОбластейРекурсивно(СписокОбластей, Дерево.Строки);
	
	Возврат СписокОбластей;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокОбластейРекурсивно(СписокОбластей, СтрокиДереваРазделов)
	
	Для каждого СтрокаРаздел Из СтрокиДереваРазделов Цикл
		
		Если СтрокаРаздел.Пометка = ПометкаФлажокУстановлен() Тогда
			
			Если СтрокаРаздел.ЭтоОбъектМетаданных Тогда
				СписокОбластей.Добавить(СтрокаРаздел.ОбъектМД, СтрокаРаздел.ПутьКДанным);
			КонецЕсли;
			
		КонецЕсли;
		
		ЗаполнитьСписокОбластейРекурсивно(СписокОбластей, СтрокаРаздел.Строки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИскатьВРазделах(ПереключательВездеВРазделах)
	
	Возврат (ПереключательВездеВРазделах = 1);
	
КонецФункции

#КонецОбласти

#Область Представления

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Раздел.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоРазделовПоиска.ЭтоПодраздел");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветРазделаПанелиФункций);
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерактивнаяЛогикаПредставления

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьДоступностьПриПереключенииВездеВРазделах(Элемент, ИскатьВРазделах)
	
	Элемент.Доступность = ИскатьВРазделах;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьТекущийРазделДереваРазделов(Элемент, КонтейнерСостояний)
	
	ТекущийРаздел       = КонтейнерСостояний.ТекущийРаздел;
	ИдентификаторСтроки = КонтейнерСостояний.ИдентификаторСтроки;
	
	// Перейдем к разделу, с которым работали при предыдущих настройках.
	Если Не ПустаяСтрока(ТекущийРаздел) И ИдентификаторСтроки <> 0 Тогда
		
		РазделПоиска = ДеревоРазделовПоиска.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если РазделПоиска = Неопределено 
			Или РазделПоиска.Раздел <> ТекущийРаздел Тогда
			Возврат;
		КонецЕсли;
		
		РодительРаздела = РазделПоиска.ПолучитьРодителя();
		Пока РодительРаздела <> Неопределено Цикл
			Элементы.ДеревоРазделовПоиска.Развернуть(РодительРаздела.ПолучитьИдентификатор());
			РодительРаздела = РодительРаздела.ПолучитьРодителя();
		КонецЦикла;
		
		Элементы.ДеревоРазделовПоиска.ТекущаяСтрока = ИдентификаторСтроки;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Функция СледующееЗначениеПометкиЭлемента(ЭлементДерева)
	
	// 0 - Флажок не установлен.
	// 1 - Флажок установлен.
	// 2 - Установлен квадрат.
	//
	// Переопределение графа конечного автомата (или машины состояний, как ее еще можно назвать).
	//
	// Платформа делает постоянный цикл при изменении пометки,
	// т.е. имеет компоненту сильной связности орграфа:
	// 0-1-2-0-1-2-0-1...
	//
	//    0
	//   / \
	//  2 - 1
	//
	// т.е. совершает цикл: не помеченный - помеченный - квадрат - не помеченный.
	//
	// Нам требуется поведение недетерминированного конечного автомата с компонентой сильной связности:
	// 0-1-0-1-0...
	//
	// т.е. помеченный должен переходить в не помеченный, а тот - опять в помеченный.
	//
	// При этом:
	//
	// Для разделов циклы:
	// 1) 1-0-1-0-1...
	// 2) 2-0-1-0-1-0-...
	//
	//      /\
	// 2 - 0 -1
	//
	// т.е. с квадрата должен быть переход к неустановленному флажку.
	//
	// Для метаданных циклы:
	// 1) 1-0-1-0-1-0...
	// 2) 2-1-0-1-0-1-0...
	//
	//      /\
	// 2 - 1 -0
	//
	// т.е. с квадрата должен быть переход к установленному флажку.
	
	// На момент проверки платформа уже изменила значение пометки.
	
	Если ЭлементДерева.ЭтоОбъектМетаданных Тогда
		// Предыдущее значение пометки = 2 : Установлен квадрат.
		Если ЭлементДерева.Пометка = 0 Тогда
			Возврат ПометкаФлажокУстановлен();
		КонецЕсли;
	КонецЕсли;
	
	// Предыдущее значение пометки = 1 : Флажок установлен.
	Если ЭлементДерева.Пометка = 2 Тогда 
		Возврат ПометкаФлажокНеУстановлен();
	КонецЕсли;
	
	// Во всех остальных случаях - значение установленное платформой.
	Возврат ЭлементДерева.Пометка;
	
КонецФункции

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПометитьЭлементыРодителейРекурсивно(ЭлементДерева)
	
	Родитель = ЭлементДерева.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементыРодителя = Родитель.ПолучитьЭлементы();
	Если ЭлементыРодителя.Количество() = 0 Тогда
		Родитель.Пометка = ПометкаФлажокУстановлен();
	ИначеЕсли ЭлементДерева.Пометка = ПометкаКвадрат() Тогда
		Родитель.Пометка = ПометкаКвадрат();
	Иначе
		Родитель.Пометка = ЗначениеПометкиОтносительноВложенныхЭлементов(Родитель);
	КонецЕсли;
	
	ПометитьЭлементыРодителейРекурсивно(Родитель);
	
КонецПроцедуры

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПометкиОтносительноВложенныхЭлементов(ЭлементДерева)
	
	СостояниеВложенныхЭлементов = СостояниеВложенныхЭлементов(ЭлементДерева);
	
	ЕстьПомеченные   = СостояниеВложенныхЭлементов.ЕстьПомеченные;
	ЕстьНепомеченные = СостояниеВложенныхЭлементов.ЕстьНепомеченные;
	
	Если ЭлементДерева.ЭтоОбъектМетаданных Тогда 
		
		// Для объекта метаданных важно какое у него состояние сейчас,
		// ведь этот объект метаданных надо возвращать.
		// Нельзя сбрасывать установленный флажок.
		
		Если ЭлементДерева.Пометка = ПометкаФлажокУстановлен() Тогда 
			// Оставляем флажок взведенным независимо от вложенных.
			Возврат ПометкаФлажокУстановлен();
		КонецЕсли;
		
		Если ЭлементДерева.Пометка = ПометкаФлажокНеУстановлен()
			Или ЭлементДерева.Пометка = ПометкаКвадрат() Тогда 
			
			Если ЕстьПомеченные Тогда
				Возврат ПометкаКвадрат();
			Иначе 
				Возврат ПометкаФлажокНеУстановлен();
			КонецЕсли;
		КонецЕсли;
		
	Иначе 
		
		// Для разделов не важно какое состояние сейчас, 
		// они всегда зависят только от вложенных.
		
		Если ЕстьПомеченные Тогда
			
			Если ЕстьНепомеченные Тогда
				Возврат ПометкаКвадрат();
			Иначе
				Возврат ПометкаФлажокУстановлен();
			КонецЕсли;
			
		КонецЕсли;
		
		Возврат ПометкаФлажокНеУстановлен();
		
	КонецЕсли;
	
КонецФункции

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Функция СостояниеВложенныхЭлементов(ЭлементДерева)
	
	ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	
	ЕстьПомеченные   = Ложь;
	ЕстьНепомеченные = Ложь;
	
	Для каждого ВложенныйЭлемент Из ВложенныеЭлементы Цикл
		
		Если ВложенныйЭлемент.Пометка = ПометкаФлажокНеУстановлен() Тогда 
			ЕстьНепомеченные = Истина;
			Продолжить;
		КонецЕсли;
		
		Если ВложенныйЭлемент.Пометка = ПометкаФлажокУстановлен() Тогда 
			ЕстьПомеченные = Истина;
			
			Если ВложенныйЭлемент.ЭтоОбъектМетаданных Тогда 
				
				// Для объекта метаданных допустимо иметь непомеченные в своем составе вложенных,
				// при этом самостоятельно быть помеченным. Чтобы обыграть эту ситуацию надо поднять
				// вложенные элементы на один уровень с самим объектом, к которому они относятся.
				
				Состояние = СостояниеВложенныхЭлементов(ВложенныйЭлемент);
				ЕстьПомеченные   = ЕстьПомеченные   Или Состояние.ЕстьПомеченные;
				ЕстьНепомеченные = ЕстьНепомеченные Или Состояние.ЕстьНепомеченные;
			КонецЕсли;
			
			Продолжить;
		КонецЕсли;
		
		Если ВложенныйЭлемент.Пометка = ПометкаКвадрат() Тогда 
			ЕстьПомеченные   = Истина;
			ЕстьНепомеченные = Истина;
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьПомеченные",   ЕстьПомеченные);
	Результат.Вставить("ЕстьНепомеченные", ЕстьНепомеченные);
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяПометитьВложенныеЭлементы(ЭлементДерева)
	
	Если ЭлементДерева.ЭтоОбъектМетаданных Тогда 
		
		// Если для объекта метаданных есть не полностью выбранные вложенные элементы,
		// значит эти элементы были выбраны пользователем и не следует портить его выбор.
		
		СостояниеВложенныхЭлементов = СостояниеВложенныхЭлементов(ЭлементДерева);
		
		ЕстьПомеченные   = СостояниеВложенныхЭлементов.ЕстьПомеченные;
		ЕстьНепомеченные = СостояниеВложенныхЭлементов.ЕстьНепомеченные;
		
		Если ЕстьПомеченные И ЕстьНепомеченные Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Параметры:
//  ЭлементДерева - ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПометитьВложенныеЭлементыРекурсивно(ЭлементДерева)
	
	ВложенныеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	
	Для каждого ВложенныйЭлемент Из ВложенныеЭлементы Цикл
		
		ВложенныйЭлемент.Пометка = ЭлементДерева.Пометка;
		ПометитьВложенныеЭлементыРекурсивно(ВложенныйЭлемент);
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
//  КоллекцияЭлементовДерева - ДанныеФормыДерева, ДанныеФормыЭлементДерева.
//      * Пометка             - Число  - Обязательный реквизит дерева.
//      * ЭтоОбъектМетаданных - Булево - Обязательный реквизит дерева.
//  ЗначениеПометки - Число - Устанавливаемое значение.
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПометитьВсеЭлементыДереваРекурсивно(ЭлементДеревоРазделовПоиска, ЗначениеПометки)
	
	КоллекцияЭлементовДерева = ЭлементДеревоРазделовПоиска.ПолучитьЭлементы();
	
	Для каждого ЭлементДерева Из КоллекцияЭлементовДерева Цикл
		ЭлементДерева.Пометка = ЗначениеПометки;
		ПометитьВсеЭлементыДереваРекурсивно(ЭлементДерева, ЗначениеПометки);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область БизнесЛогика

&НаСервереБезКонтекста
Функция ЭтоКорневаяПодсистема(ОбъектМетаданных)
	
	Возврат Метаданные.Подсистемы.Содержит(ОбъектМетаданных);
	
КонецФункции

&НаСервереБезКонтекста
Функция ОбъектМетаданныхДоступен(ОбъектМетаданных)
	
	ДоступенПоПравам = ПравоДоступа("Просмотр", ОбъектМетаданных);
	ДоступенПоФункциональнымОпциям = ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных);
	
	СвойстваМетаданного = Новый Структура("ПолнотекстовыйПоиск, ВключатьВКомандныйИнтерфейс");
	ЗаполнитьЗначенияСвойств(СвойстваМетаданного, ОбъектМетаданных);
	
	Если СвойстваМетаданного.ПолнотекстовыйПоиск = Неопределено Тогда 
		ИспользованиеПолнотекстовогоПоиска = Истина; // Если свойства нет - игнорируем.
	Иначе 
		ИспользованиеПолнотекстовогоПоиска = (СвойстваМетаданного.ПолнотекстовыйПоиск = 
			Метаданные.СвойстваОбъектов.ИспользованиеПолнотекстовогоПоиска.Использовать);
	КонецЕсли;
	
	Если СвойстваМетаданного.ВключатьВКомандныйИнтерфейс = Неопределено Тогда 
		ВключатьВКомандныйИнтерфейс = Истина; // Если свойства нет - игнорируем.
	Иначе 
		ВключатьВКомандныйИнтерфейс = СвойстваМетаданного.ВключатьВКомандныйИнтерфейс;
	КонецЕсли;
	
	Возврат ДоступенПоПравам И ДоступенПоФункциональнымОпциям 
		И ИспользованиеПолнотекстовогоПоиска И ВключатьВКомандныйИнтерфейс;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПодчиненныеСправочники(ОбъектМетаданных)
	
	Результат = Новый Массив;
	
	Для Каждого Справочник Из Метаданные.Справочники Цикл
		Если Справочник.Владельцы.Содержит(ОбъектМетаданных)
			И ОбъектМетаданныхДоступен(Справочник) Тогда 
			
			Результат.Добавить(Справочник);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьТекущийПутьРаздела(ТекущийРаздел, ИдентификаторСтроки)
	
	ПараметрыТекущегоРаздела = Новый Структура;
	ПараметрыТекущегоРаздела.Вставить("ТекущийРаздел",       ТекущийРаздел);
	ПараметрыТекущегоРаздела.Вставить("ИдентификаторСтроки", ИдентификаторСтроки);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПолнотекстовыйПоискТекущийРаздел", "", ПараметрыТекущегоРаздела);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьТекущийПутьРаздела(ПараметрыТекущегоРаздела)
	
	СохраненныеНастройкиПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискТекущийРаздел", "");
	
	ТекущийРаздел       = Неопределено;
	ИдентификаторСтроки = Неопределено;
	
	Если ТипЗнч(СохраненныеНастройкиПоиска) = Тип("Структура") Тогда
		СохраненныеНастройкиПоиска.Свойство("ТекущийРаздел",       ТекущийРаздел);
		СохраненныеНастройкиПоиска.Свойство("ИдентификаторСтроки", ИдентификаторСтроки);
	КонецЕсли;
	
	ПараметрыТекущегоРаздела.ТекущийРаздел       = ?(ТекущийРаздел = Неопределено, "", ТекущийРаздел);
	ПараметрыТекущегоРаздела.ИдентификаторСтроки = ?(ИдентификаторСтроки = Неопределено, 0, ИдентификаторСтроки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти