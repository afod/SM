///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(Неопределено, Истина, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для администрирования синхронизации данных между приложениями.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Не поддерживается функциональность администрирования синхронизации данных в модели сервиса.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Настройки видимости при запуске.
	Элементы.ГруппаПрименитьНастройки.Видимость = ОбщегоНазначения.ЭтоВебКлиент();
	Элементы.АвтономнаяРабота.Видимость = АвтономнаяРаботаСлужебный.АвтономнаяРаботаПоддерживается();
	Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = (Не ОбщегоНазначения.ИнформационнаяБазаФайловая())
		И Пользователи.ЭтоПолноправныйПользователь(, Истина);
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	#Если Не ВебКлиент Тогда
	ОбновитьИнтерфейсПрограммы();
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КакПрименитьНастройкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбновитьИнтерфейс = Истина;
	ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляWindowsПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляLinuxПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура МониторСинхронизацииДанных(Команда)
	
	ОткрытьФорму("ОбщаяФорма.МониторСинхронизацииДанныхВМоделиСервиса",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспортаОбмена(Команда)
	
	ИмяРегистраНастроекТранспорта = "НастройкиТранспортаОбменаСообщениями";
	ИмяФормыНастроекТранспорта = "РегистрСведений.[ИмяРегистраНастроекТранспорта].ФормаСписка";
	ИмяФормыНастроекТранспорта = СтрЗаменить(ИмяФормыНастроекТранспорта,
		"[ИмяРегистраНастроекТранспорта]", ИмяРегистраНастроекТранспорта);
	
	ОткрытьФорму(ИмяФормыНастроекТранспорта, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиТранспортаОбменаОбластейДанных(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиТранспортаОбменаОбластейДанных.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаДляОбменаДанными(Команда)
	
	ОткрытьФорму("РегистрСведений.ПравилаДляОбменаДанными.ФормаСписка",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьСинхронизациюДанных = Ложь Тогда
		НаборКонстант.ИспользоватьАвтономнуюРаботуВМоделиСервиса = Ложь;
		НаборКонстант.ИспользоватьСинхронизациюДанныхВМоделиСервисаСЛокальнойПрограммой = Ложь;
		НаборКонстант.ИспользоватьСинхронизациюДанныхВМоделиСервисаСПриложениемВИнтернете = Ложь;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтономнуюРаботуВМоделиСервисаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхВМоделиСервисаСПриложениемВИнтернетеПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхВМоделиСервисаСЛокальнойПрограммойПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, НеобходимоОбновлятьИнтерфейс = Истина)
	
	ИмяКонстанты = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если НеобходимоОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если ИмяКонстанты <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, ИмяКонстанты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	ИмяКонстанты = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	УстановитьДоступность(РеквизитПутьКДанным);
	ОбновитьПовторноИспользуемыеЗначения();
	Возврат ИмяКонстанты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
	Если ЧастиИмени.Количество() <> 2 Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяКонстанты = ЧастиИмени[1];
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
		КонстантаМенеджер.Установить(КонстантаЗначение);
	КонецЕсли;
	
	Возврат ИмяКонстанты;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСинхронизациюДанных" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СинхронизацияДанныхПодчиненнаяГруппировка.Доступность           = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаСинхронизацияДанныхМониторСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Доступность             = НаборКонстант.ИспользоватьСинхронизациюДанных;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти
