
&НаКлиенте
Процедура СудноПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Запись.Судно) Тогда
		Запись.Пользователь = ПолучитьИмяПользователя();
		Элементы.Пользователь.Доступность = Ложь;
	Иначе
		Запись.Пользователь  = "";
		Элементы.Пользователь.Доступность = Истина;;
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяПользователя()
	Возврат Запись.Судно.КодБыстрогоВвода;
КонецФункции


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(Запись.Пользователь) Тогда
		Если ЗначениеЗаполнено(Запись.Судно) Тогда
			Запись.Пользователь = ПолучитьИмяПользователя();
			Элементы.Пользователь.Доступность = Ложь;
		Иначе
			Запись.Пользователь  = "";
			Элементы.Пользователь.Доступность = Истина;;
		КонецЕсли;	
	КонецЕсли; 
	
КонецПроцедуры
 
