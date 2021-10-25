///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокКонстант.Очистить();
	Для ТекИнд = 0 По Параметры.МассивИменМетаданных.ВГраница() Цикл
		Строка = СписокКонстант.Добавить();
		Строка.ИндексКартинкиАвторегистрация = Параметры.МассивАвторегистрации[ТекИнд];
		Строка.ИндексКартинки                = 2;
		Строка.МетаПолноеИмя                 = Параметры.МассивИменМетаданных[ТекИнд];
		Строка.Наименование                  = Параметры.МассивПредставлений[ТекИнд];
	КонецЦикла;
	
	ЗаголовокАвторегистрации = НСтр("ru = 'Авторегистрация для узла ""%1""'");
	
	Элементы.ДекорацияАвторегистрация.Заголовок = СтрЗаменить(ЗаголовокАвторегистрации, "%1", Параметры.УзелОбмена);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекПараметры = УстановитьПараметрыФормы();
	Элементы.СписокКонстант.ТекущаяСтрока = ТекПараметры.ТекущаяСтрока;
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	ТекПараметры = УстановитьПараметрыФормы();
	Элементы.СписокКонстант.ТекущаяСтрока = ТекПараметры.ТекущаяСтрока;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКонстант
//

&НаКлиенте
Процедура СписокКонстантВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПроизвестиВыборКонстанты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//

// Производит выбор константы
//
&НаКлиенте
Процедура ВыбратьКонстанту(Команда)
	
	ПроизвестиВыборКонстанты();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

// Производит выбор и оповещает о нем.
//
&НаКлиенте
Процедура ПроизвестиВыборКонстанты()
	Данные = Новый Массив;
	Для Каждого ТекущийЭлементСтроки Из Элементы.СписокКонстант.ВыделенныеСтроки Цикл
		ТекСтрока = СписокКонстант.НайтиПоИдентификатору(ТекущийЭлементСтроки);
		Данные.Добавить(ТекСтрока.МетаПолноеИмя);
	КонецЦикла;
	ОповеститьОВыборе(Данные);
КонецПроцедуры	

&НаСервере
Функция УстановитьПараметрыФормы()
	Результат = Новый Структура("ТекущаяСтрока");
	Если Параметры.НачальноеЗначениеВыбора <> Неопределено Тогда
		Результат.ТекущаяСтрока = ИдентификаторСтрокиПоМетаИмени(Параметры.НачальноеЗначениеВыбора);
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаСервере
Функция ИдентификаторСтрокиПоМетаИмени(ПолноеИмяМетаданных)
	Данные = РеквизитФормыВЗначение("СписокКонстант");
	ТекСтрока = Данные.Найти(ПолноеИмяМетаданных, "МетаПолноеИмя");
	Если ТекСтрока <> Неопределено Тогда
		Возврат ТекСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

#КонецОбласти
