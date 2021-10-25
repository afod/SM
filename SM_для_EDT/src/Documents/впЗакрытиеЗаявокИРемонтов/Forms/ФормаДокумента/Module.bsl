
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = Константы.впОсновнаяОрганизация.Получить();
	КонецЕсли;
	
	// ++ rarus makole 2021-02-09
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимостьДоступность();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	// -- rarus makole 2021-02-09
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// ++ rarus makole 2021-02-09
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// -- rarus makole 2021-02-09
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ++ rarus makole 2021-02-09
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	// -- rarus makole 2021-02-09
	
	//RARUS-NN EvgenU РАIT-0023372 2021_06_04 ++
	Если Объект.ЗакрываемыеЗаявки.Количество() = 0 
		И Объект.ЗакрываемыеРемонты.Количество() <> 0 Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаЗакрываемыеРемонты;
	КонецЕсли;
	//RARUS-NN EvgenU РАIT-0023372 2021_06_04 --
	
КонецПроцедуры

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

//RARUS-NN EvgenU РАIT-0023372 2021_06_04 ++
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("впЗакрытиеЗаявокИРемонтов_Запись");
КонецПроцедуры //RARUS-NN EvgenU РАIT-0023372 2021_06_04 --

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
// -- rarus makole 2021-02-09

#Область СлужебныеПроцедурыИФункции

//rarus_AfoD 15.09.2021 < 
Процедура УстановитьВидимостьДоступность()

	ИспользоватьСтатусыЗаявокНаПереносРабот = рарусОбщегоНазначенияПовтИсп.ИспользоватьСтатусыЗаявокНаПереносРабот();
	Если ИспользоватьСтатусыЗаявокНаПереносРабот Тогда
	
		Элементы.Согласовано.Видимость = ЛОЖЬ;
	
	КонецЕсли; 

КонецПроцедуры
//rarus_AfoD 15.09.2021 > 

#КонецОбласти
