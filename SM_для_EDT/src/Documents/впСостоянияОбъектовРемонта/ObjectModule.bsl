
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// rarus evgenu 2020_12_18 ++ 
	Для Каждого СтрокаТЧ Из ОбъектыРемонта Цикл
		Если ЗначениеЗаполнено(СтрокаТЧ.ДатаНачала) И ЗначениеЗаполнено(СтрокаТЧ.ДатаОкончания) Тогда
			СтрокаТЧ.ВремяПростоя = СтрокаТЧ.ДатаОкончания - СтрокаТЧ.ДатаНачала;
		КонецЕсли;
	КонецЦикла;
	// rarus evgenu 2020_12_18 --
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

