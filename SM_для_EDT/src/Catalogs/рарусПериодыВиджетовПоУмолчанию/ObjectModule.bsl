#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Перем мВладелец;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("Владелец", мВладелец)
		И ЗначениеЗаполнено(мВладелец) Тогда
		
		Наименование = Строка(мВладелец);
		
	КонецЕсли;
	
КонецПроцедуры
	
#КонецОбласти 

#КонецЕсли
