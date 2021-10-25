#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальные;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтаФорма, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьСвойстваПоПараметрам(Параметры);
	
	// ++ rarus PleA 05.03.2021 [27609 ]
	УстановитьВидимость();
	// -- rarus PleA
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Состояние.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.рарусСостоянияЗаявокНаСнабжение.ПустаяСсылка();
		
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", рарусЗаявкаНаСнабжениеСервер.ПредставлениеСтатусаСогласованияЧерновик());
	
	//
	
КонецПроцедуры
 

&НаСервере
Процедура ЗаполнитьСвойстваПоПараметрам(ПараметрыФормы)
	
	ПараметрыФормы.Свойство("Заголовок", Заголовок);
	
	БыстрыеОтборы = Неопределено;

	Если ПараметрыФормы.Свойство("БыстрыеОтборы", БыстрыеОтборы) тогда
		
		Для Каждого ЭлОтбора Из БыстрыеОтборы цикл
			
			Если ПроверитьНаличиеЭлементаФормыПоИмени(ЭлОтбора.Ключ) тогда
				
				ЗаполнитьЗначенияСвойств(Элементы[ЭлОтбора.Ключ], ЭлОтбора.Значение);
				
			КонецЕсли;	
			
		КонецЦикла;	
		
	КонецЕсли;	
	
	//ПАН+
	Если ПолучитьФункциональнуюОпцию("рарусИспользуетсяСхемаСогласованияПоАналогам") Тогда
		ОтборФормы = Неопределено;
		ОтборПоСтатусу = Неопределено;
		
		Если ПараметрыФормы.Свойство("Отбор", ОтборФормы) Тогда
			Если ОтборФормы.Свойство("СтатусСогласования", ОтборПоСтатусу) 
				И ОтборПоСтатусу = 
							рарусЗаявкаНаСнабжениеСервер.СтатусСогласованияНаДоработкуВЗависимотстиОтРолиПользователя() Тогда
							
				ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список,"СтатусСогласования");	
				
				ГруппаЭлементовОтбора = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(Список.Отбор,"ОтборНаДоработку",ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора
					(ГруппаЭлементовОтбора,
					"СтатусСогласования",
					рарусЗаявкаНаСнабжениеСервер.СтатусСогласованияНаДоработкуВЗависимотстиОтРолиПользователя(),
					ВидСравненияКомпоновкиДанных.Равно,
					"Статус согласования",
					Истина);
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора
					(ГруппаЭлементовОтбора,
					"СогласованиеАналоговНеЗавершено",
					Истина,
					ВидСравненияКомпоновкиДанных.Равно,
					"Статус по аналогам",
					Истина);
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
		
КонецПроцедуры	

&НаСервере
Функция ПроверитьНаличиеЭлементаФормыПоИмени(ИмяЭлемента)
	
	Возврат Элементы.Найти(ИмяЭлемента) <> Неопределено;
	
КонецФункции
 
&НаКлиенте
Процедура СтатусСогласованияПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("СтатусСогласования", СтатусСогласования);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	рарусОбщегоНазначенияСМКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент,  СтатусСогласования);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициаторПриИзменении(Элемент)
	
	ПараметрыОтбора = Новый Соответствие;
	Параметрыотбора.Вставить("Инициатор", Инициатор);
	
	УстановитьОтборСписка(Список, ПараметрыОтбора);
	
	рарусОбщегоНазначенияСМКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элемент, Инициатор);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(Список, ПараметрыОтбора)
	 
	СтатусСогласования = ПараметрыОтбора.Получить("СтатусСогласования");
	Если СтатусСогласования <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(СтатусСогласования) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"СтатусСогласования");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"СтатусСогласования",
				СтатусСогласования);
		КонецЕсли;
	КонецЕсли;
	
	Ответственный = ПараметрыОтбора.Получить("Инициатор");
	Если Ответственный <> Неопределено Тогда 
		Если Не ЗначениеЗаполнено(Ответственный) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор,
				"Ответственный");
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
				"Ответственный",
				Ответственный);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	

// ++ rarus PleA 05.03.2021 [27609 ]
&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.Подразделение.Видимость = Не ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ();
	
КонецПроцедуры	
// -- rarus PleA
