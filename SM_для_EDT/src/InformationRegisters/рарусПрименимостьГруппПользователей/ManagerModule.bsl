
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("ГруппаПользователей") Тогда
		ВыбраннаяФорма = "РегистрСведений.рарусПрименимостьГруппПользователей.Форма.ФормаСпискаСОтбором";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры
