
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КонтролироватьВыборЗаблокированных", КонтролироватьВыборЗаблокированных);
	
	//rarus_AfoD 10.09.2021 < 
	ТекущаяНоменклатура = Неопределено;
	Параметры.Свойство("ТекущаяСтрока", ТекущаяНоменклатура);
	Если ЗначениеЗаполнено(ТекущаяНоменклатура) Тогда
		Элементы.Список.ТекущаяСтрока = ТекущаяНоменклатура;
	КонецЕсли; 
	//rarus_AfoD 10.09.2021 > 
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// ++ rarus ilshil 15.07.2021 № 29823  
	ТекущиеДанные = Элемент.ТекущиеДанные;	
	ВыбраннаяСтрока = ТекущиеДанные.Ссылка;
	// -- rarus ilshil 15.07.2021

	Если КонтролироватьВыборЗаблокированных И ЭтоЗаблокированнаяНоменклатура(ВыбраннаяСтрока) тогда
		
		рарусНоменклатураКлиент.ВыборЗаблокированнойНоменклатуры(ЭтаФорма, ВыбраннаяСтрока, СтандартнаяОбработка);
			
	КонецЕсли;
	
КонецПроцедуры 

// ++ rarus ilshil 15.07.2021 № 29823  
&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;		
	Значение = ТекущиеДанные.Ссылка;
	
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры
// -- rarus ilshil 15.07.2021

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// ++ rarus PleA 21.12.2020 [26103]
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	ПолеЭлемента.Использование = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатусНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.рспбСтатусыНоменклатуры.НеЗаблокирован;
	ОтборЭлемента.Использование = Истина;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.СтатусНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;	
	ОтборЭлемента.Использование = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗаблокированныйРеквизитЦвет);
	
	// -- rarus PleA
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЗаблокированнаяНоменклатура(ВыбраннаяСтрока)
	
	Возврат рарусНоменклатураСервер.ЭтоЗаблокированнаяНоменклатура(ВыбраннаяСтрока);
	
КонецФункции 

&НаКлиенте
Процедура ВыборЗаблокированнойЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> Неопределено И РезультатВопроса.Значение = "ВыбратьЗаблокированную" Тогда
		
		ОповеститьОВыбореНоменклатуры(ДополнительныеПараметры.Номенклатура);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореНоменклатуры(Номенклатура)
	
	ОповеститьОВыборе(Номенклатура);
	
КонецПроцедуры	

#КонецОбласти