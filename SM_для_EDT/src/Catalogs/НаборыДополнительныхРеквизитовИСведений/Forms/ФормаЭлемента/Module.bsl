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
	
	ТолькоПросмотр = Истина;
	
	ВидыСвойствНабора = УправлениеСвойствамиСлужебный.ВидыСвойствНабора(Объект.Ссылка);
	ИспользоватьДопРеквизиты = ВидыСвойствНабора.ДополнительныеРеквизиты;
	ИспользоватьДопСведения  = ВидыСвойствНабора.ДополнительныеСведения;
	
	Если ИспользоватьДопРеквизиты И ИспользоватьДопСведения Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Набор дополнительных реквизитов и сведений)'")
		
	ИначеЕсли ИспользоватьДопРеквизиты Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Набор дополнительных реквизитов)'")
		
	ИначеЕсли ИспользоватьДопСведения Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Набор дополнительных сведений)'")
	КонецЕсли;
	
	Если НЕ ИспользоватьДопРеквизиты И Объект.ДополнительныеРеквизиты.Количество() = 0 Тогда
		Элементы.ДополнительныеРеквизиты.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьДопСведения И Объект.ДополнительныеСведения.Количество() = 0 Тогда
		Элементы.ДополнительныеСведения.Видимость = Ложь;
	КонецЕсли;
	
	// ++ rarus makole 2021-02-09
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// -- rarus makole 2021-02-09
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ++ rarus makole 2021-02-09
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// -- rarus makole 2021-02-09
	
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

// ++ rarus makole 2021-02-09
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры
// -- rarus makole 2021-02-09

#КонецОбласти

// ++ rarus makole 2021-02-09
// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
// -- rarus makole 2021-02-09