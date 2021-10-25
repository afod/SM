
//Обработчики формы//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьВидимость();
	
	СохраненныйОтбор = Новый Структура("ВидРасхода,НомерЗаявки,Получатель,НомерРаспоряжения,ДатаРаспоряжения");
	ЗаполнитьЗначенияСвойств(СохраненныйОтбор, ЭтотОбъект);
	
	НайтиРаспоряженияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СписатьЗавершение(СтруктураПараметров, ДополнительныеПараметры) Экспорт
	
	Если СтруктураПараметров <> Неопределено Тогда
		
		// ++ rarus makole 2021-10-01 [РАIT-0023495]
		// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
			И ДополнительныеПараметры.Свойство("БезРаспоряжения")
			И ДополнительныеПараметры.БезРаспоряжения = Истина Тогда
			
			Результат = СформироватьРасходПоКатегориям(СтруктураПараметров);
			ОповеститьОбИзменении(Тип("ДокументСсылка.рарусРасходТМЦ"));
		Иначе
		// -- rarus makole 2021-10-01 [РАIT-0023495]
			Результат = СписатьНаСервере(СтруктураПараметров);
		КонецЕсли;
		
		Если Результат.Отказ Тогда
			ПоказатьПредупреждение(, Результат.ТекстОшибки ,,Результат.ЗаголовокОшибки);
		// ++ rarus makole 2021-10-04 [РАIT-0023495]
		// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах
		ИначеЕсли ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		    ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстОшибки)
		// -- rarus makole 2021-10-04 [РАIT-0023495]
		Иначе
			ПодключитьОбработчикОжидания("НайтиРаспоряженияОжидание", 1, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОсновноеСудно = рарусОбщегоНазначенияСервер.ОсновноеСудно();
	Если НЕ ЗначениеЗаполнено(ОсновноеСудно) Тогда
		ТекстСообщения = "Не указано основное судно(справочник <Суда>)";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
	ПраваяПанельОтключена = Истина;
	// ++ rarus yukuzi 23.12.2020   // Снабжение ТОИР 2 Приоритет
	ПараметрыФО = Новый Структура;
	ПараметрыФО.Вставить("Судно", ОсновноеСудно);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);

	// -- rarus yukuzi 23.12.2020
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеОтбора(Элемент)
	
	Если ОтгружаемаяНоменклатура.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ИзменениеОтбораЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Выбранные строки будут очищены", РежимДиалогаВопрос.ДаНет,0,КодВозвратаДиалога.Да, "По выбранному отбору уже выбраны строки");
	Иначе
		ЗаполнитьЗначенияСвойств(СохраненныйОтбор, ЭтотОбъект);
		НайтиРаспоряженияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеОтбораЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьЗначенияСвойств(СохраненныйОтбор, ЭтотОбъект);
		НайтиРаспоряженияНаСервере();
	Иначе
		ВосстановитьОтбор();
	КонецЕсли;		
		
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьОтбор()
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СохраненныйОтбор, "НомерЗаявки,НомерРаспоряжения,ДатаРаспоряжения,ВидРасхода");
	ДоступныеТипы = Новый Массив;
	Если ВидРасхода = "" Тогда
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Контрагенты"));
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Склады"));
	ИначеЕсли ВидРасхода = "Контрагенту" Тогда
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Контрагенты"));
	ИначеЕсли ВидРасхода = "НаСклад" Тогда
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Склады"));
	КонецЕсли;
	ОписаниеТипов = Новый ОписаниеТипов(ДоступныеТипы);
	Элементы.Получатель.ОграничениеТипа = ОписаниеТипов;

	Получатель = СохраненныйОтбор.Получатель;
	
КонецПроцедуры
	
//Команды
&НаКлиенте
Процедура НайтиРаспоряжения(Команда)
	НайтиРаспоряженияНаСервере();
КонецПроцедуры
&НаКлиенте
Процедура НайтиРаспоряженияОжидание()
	НайтиРаспоряженияНаСервере();
КонецПроцедуры
&НаКлиенте
Процедура Списать(Команда)
	
	// ++ rarus makole 2021-09-30 [РАIT-0023495]
	// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах
	Если ВидРасхода = "БезРаспоряжения"
		И ЕстьВыбранныеСтрокиРаспоряжений() Тогда
		Оповещение = Новый ОписаниеОповещения("СписатьЗавершение", ЭтотОбъект, Новый Структура("БезРаспоряжения", Истина));
		ПараметрыФормы = Новый Структура("UID", УникальныйИдентификатор);
		ИмяФормыОформления = Лев(ИмяФормы, СтрДлина(ИмяФормы)-5) + "ФормаДополнительныхДанных";
		ОткрытьФорму(ИмяФормыОформления, ПараметрыФормы,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	// -- rarus makole 2021-09-30 [РАIT-0023495]
	ИначеЕсли ЕстьВыбранныеСтрокиРаспоряжений() Тогда
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("Комментарий", "");
		СтруктураПараметров.Вставить("СведенияОФайлах", Новый Массив);
		СтруктураПараметров.Вставить("ЕстьПриложенныеФайлы", Ложь);
		СписатьНаСервере(СтруктураПараметров);
		
		ПодключитьОбработчикОжидания("НайтиРаспоряженияОжидание", 1, Истина);
	Иначе
		ПоказатьПредупреждение(, "Отсутствуют выбранные строки" ,,"Ошибка");
	КонецЕсли;

КонецПроцедуры

//Обработчики элементов формы//
&НаКлиенте
Процедура ВидПриходаПриИзменении(Элемент)
	
	ДоступныеТипы = Новый Массив;
	Если ВидРасхода = "" Тогда
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Контрагенты"));
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Склады"));
	ИначеЕсли ВидРасхода = "Контрагенту" Тогда
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Контрагенты"));
	ИначеЕсли ВидРасхода = "НаСклад" Тогда
		ДоступныеТипы.Добавить(Тип("СправочникСсылка.Склады"));
	КонецЕсли;
	ОписаниеТипов = Новый ОписаниеТипов(ДоступныеТипы);
	Элементы.Получатель.ОграничениеТипа = ОписаниеТипов;
	Получатель = ОписаниеТипов.ПривестиЗначение(Получатель);
	
	ИзменениеОтбора(Элемент);
	
	// ++ rarus makole 2021-09-29 [РАIT-0023495]
	// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах 
	ИзменитьВидимость();
	// -- rarus makole 2021-09-29 [РАIT-0023495]
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаРаспоряженийВыбраноПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаРаспоряжений.ТекущиеДанные;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Выбрано", ТекущаяСтрока.Выбрано);
	СтруктураПараметров.Вставить("Получатель", ТекущаяСтрока.Получатель);
	СтруктураПараметров.Вставить("Распоряжение", ТекущаяСтрока.Распоряжение);
	СтруктураПараметров.Вставить("Отказ", Ложь);
	
	Если СтруктураПараметров.Выбрано Тогда
		ДобавитьДанныеРаспоряженияВРасход(СтруктураПараметров);
	Иначе
		УдалитьДанныеРаспоряженияИзРасхода(СтруктураПараметров);
	КонецЕсли;
	
	Если СтруктураПараметров.Отказ Тогда
		ПоказатьПредупреждение(, "Документ прихода можно оформить только по одному распоряжению" ,,"Ошибка");
		ТекущаяСтрока.Выбрано = Не ТекущаяСтрока.Выбрано;
	КонецЕсли;
	
	ИзменитьВидимость();
		
КонецПроцедуры
&НаКлиенте
Процедура ИзменитьВидимость()
	
	ВыбранныхСтрок = ОтгружаемаяНоменклатура.Количество();
	
	// ++ rarus makole 2021-09-30 [РАIT-0023495]
	// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах 
	ПоРаспоряжению = ВидРасхода <> "БезРаспоряжения";
	//Элементы.ГруппаТоварыКОтправке.Видимость = ВыбранныхСтрок > 0; 
	//Элементы.ТаблицаРаспоряженийОформитьПриход.Видимость = ВыбранныхСтрок > 0; 
	Элементы.ГруппаТоварыКОтправке.Видимость = ВыбранныхСтрок > 0 ИЛИ НЕ ПоРаспоряжению;
	Элементы.ТаблицаРаспоряженийОформитьПриход.Видимость = ВыбранныхСтрок > 0 И ПоРаспоряжению;
	Элементы.НадписьПодобраноСтрок.Заголовок = "Подобрано строк: " + ВыбранныхСтрок;
	Если НЕ ПоРаспоряжению Тогда
		Элементы.ГруппаТоварыКОтправке.Заголовок = "Товары расхода без распоряжения";
	// -- rarus makole 2021-09-30 [РАIT-0023495]
	ИначеЕсли ВыбранныхСтрок = 0 Тогда
		Элементы.ГруппаТоварыКОтправке.Заголовок = "Подбор строк расхода";
		ТаблицаДокументовРасхода.Очистить();
	Иначе
		Элементы.ГруппаТоварыКОтправке.Заголовок = ?(РазрешеноИзменениеСоставаПоступления(ОтгружаемаяНоменклатура[0].Распоряжение), "Товары расхода по заказу (изменение состава разрешено)", "Товары расхода по заказу (изменение состава не разрешено)");
	КонецЕсли;
	
	Если ПраваяПанельОтключена Тогда
		Элементы.ГруппаДанныхПраво.Видимость = Ложь;
	Иначе
		Элементы.ГруппаДанныхПраво.Видимость = ПоказатьДокументыРасходаТМЦ;
	КонецЕсли;
	
	// ++ rarus makole 2021-06-10 [РАIT-0023374]
	// Учёт номенклатуры разного качества 
	Элементы.ОтгружаемаяНоменклатураНоменклатураКачество.Видимость = рарусИмущественныйУчетВызовСервера.ИспользуетсяКачествоТоваров();
	// -- rarus makole 2021-06-10 [РАIT-0023374]
	
	// ++ rarus makole 2021-09-29 [РАIT-0023495]
	// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах
	Элементы.НомерРаспоряжения.Видимость = ПоРаспоряжению;
	Элементы.Получатель.Видимость = ПоРаспоряжению;
	Элементы.ДатаРаспоряжения.Видимость = ПоРаспоряжению;
	Элементы.ТаблицаРаспоряжений.Видимость = ПоРаспоряжению;
	Элементы.ТаблицаРаспоряженийНайтиРаспоряжения.Видимость = ПоРаспоряжению;
	Элементы.ГруппаПоиск.Видимость = ПоРаспоряжению;
	Элементы.ГруппаКоманднаяПанельОтгружаемаяНоменклатура.Видимость = НЕ ПоРаспоряжению;
	Элементы.ОтгружаемаяНоменклатураКоличествоРаспоряжение.Видимость = ПоРаспоряжению;
	Элементы.ОтгружаемаяНоменклатураКоличествоОстаток.Видимость = ПоРаспоряжению;
	Элементы.ОтгружаемаяНоменклатура.ИзменятьСоставСтрок = НЕ ПоРаспоряжению;
	Элементы.ОтгружаемаяНоменклатураНоменклатура.ТолькоПросмотр = ПоРаспоряжению;
	// -- rarus makole 2021-09-29 [РАIT-0023495]
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаРаспоряженийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаРаспоряжений.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Выбрано = НЕ ТекущиеДанные.Выбрано;
		ТаблицаРаспоряженийВыбраноПриИзменении(Элемент);
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗагружаемаяНоменклатураКоличествоПриИзменении(Элемент)
	
	// ++ rarus makole 2021-09-30 [РАIT-0023495]
	// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах 
	Если ВидРасхода = "БезРаспоряжения" Тогда
		Возврат
	КонецЕсли;
	// -- rarus makole 2021-09-30 [РАIT-0023495]
	
	ТекущиеДанные = Элементы.ОтгружаемаяНоменклатура.ТекущиеДанные;
	Если ТекущиеДанные.Количество > ТекущиеДанные.КоличествоОстаток Тогда
		ТекущиеДанные.Количество = ТекущиеДанные.КоличествоОстаток;
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура НадписьДокументыПриемкиТМЦНажатие(Элемент)
	
	Если ПраваяПанельОтключена Тогда
		ОткрытьФорму("Документ.рарусРасходТМЦ.ФормаСписка");
	Иначе
		ПоказатьДокументыРасходаТМЦ = НЕ ПоказатьДокументыРасходаТМЦ;
		Элементы.НадписьДокументыПриемкиТМЦ.Заголовок = ?(ПоказатьДокументыРасходаТМЦ, "Скрыть документы расхода ТМЦ", "Показать документы расхода ТМЦ");
		ЗагружаемаяНоменклатураПриАктивизацииСтроки(Элемент);
	
		ИзменитьВидимость();
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗагружаемаяНоменклатураПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ОтгружаемаяНоменклатура.ТекущиеДанные;
	Если ПоказатьДокументыРасходаТМЦ Тогда
		Если ТекущиеДанные <> Неопределено Тогда
			ЗаполнитьДокументыРасходаТМЦ(ТекущиеДанные.Распоряжение, ТекущиеДанные.Номенклатура);
		Иначе
			ТаблицаДокументовРасхода.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Элементы.ОтгружаемаяНоменклатураКоличество.ТолькоПросмотр = ЗапрещеноРедактированиеКоличества(ТекущиеДанные.Распоряжение);
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ТаблицаДокументовПриемкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаДокументовРасхода.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Документ) Тогда
		ОткрытьФорму("Документ.рарусРасходТМЦ.ФормаОбъекта", Новый Структура("Ключ", ТекущиеДанные.Документ));
	КонецЕсли;
	
КонецПроцедуры

// ++ rarus makole 2021-09-30 [РАIT-0023495]
// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах 
&НаКлиенте
Процедура ОтгружаемаяНоменклатураНоменклатураПриИзменении(Элемент)
	ЗаполнитьПодобраноСтрок();
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыФормыЗаголовок =  НСтр("ru = 'Подбор товаров'");
	ОтборПоТипуНоменклатуры = рарусНоменклатураКлиентСервер.ОтборПоТовару();
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Заголовок",                                 ПараметрыФормыЗаголовок);
	ПараметрыФормы.Вставить("Дата",                                      ТекущаяДата());
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",				 "ПростойПодборНоменклатуры");
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры",                   Новый ФиксированныйМассив(ОтборПоТипуНоменклатуры));
	ПараметрыФормы.Вставить("Судно",                   					 ОсновноеСудно);
	
	ОткрытьФорму("Обработка.впПодборНоменклатуры.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.Имяформы = "Обработка.впПодборНоменклатуры.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
		ЗаполнитьПодобраноСтрок();
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборНаСервере(АдресТоваровВХранилище)
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = ОтгружаемаяНоменклатура.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, "Номенклатура, Количество");
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтгружаемаяНоменклатураПослеУдаления(Элемент)
	ЗаполнитьПодобраноСтрок();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодобраноСтрок()
	Элементы.НадписьПодобраноСтрок.Заголовок = "Подобрано строк: " + ОтгружаемаяНоменклатура.Количество();
КонецПроцедуры
// -- rarus makole 2021-09-30 [РАIT-0023495]

&НаСервереБезКонтекста
Функция ЗапрещеноРедактированиеКоличества(Распоряжение)
	
	Возврат ТипЗнч(Распоряжение) = Тип("ДокументСсылка.рарусЗаказНаПеремещение");
	
КонецФункции
&НаСервереБезКонтекста
Функция РазрешеноИзменениеСоставаПоступления(Распоряжение)
	
	Возврат ТипЗнч(Распоряжение) = Тип("ДокументСсылка.рарусЗаказКлиента");
	
КонецФункции

//Заполнение списка распоряжений//
&НаСервере
Процедура НайтиРаспоряженияНаСервере()
	
	ВыбиратьЗаказыКлиента = ВидРасхода <> "НаСклад";
	ВыбиратьЗаказыНаПеремещения = ВидРасхода <> "Контрагенту";
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	рарусЗаказКлиента.Ссылка КАК Распоряжение,
		|	рарусЗаказКлиента.Контрагент КАК Получатель
		|ПОМЕСТИТЬ ВТ_ВыбранныеРаспоряжения
		|ИЗ
		|	Документ.рарусЗаказКлиента.Товары КАК рарусЗаказКлиентаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусЗаказКлиента КАК рарусЗаказКлиента
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.vftСуда КАК vftСуда
		|			ПО рарусЗаказКлиента.Склад.Судно = vftСуда.Ссылка
		|				И (vftСуда.Ссылка = &ОсновноеСудно)
		|		ПО рарусЗаказКлиентаТовары.Ссылка = рарусЗаказКлиента.Ссылка
		|			И (&ВыбиратьЗаказыКлиента)
		|			И (рарусЗаказКлиента.Номер ПОДОБНО &НомерРаспоряжения)
		|			И (НАЧАЛОПЕРИОДА(рарусЗаказКлиента.Дата, ДЕНЬ) = &ДатаРаспоряжения)
		|			И (рарусЗаказКлиента.Контрагент = &Получатель)
		|			И (рарусЗаказКлиентаТовары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга))
		|
		|СГРУППИРОВАТЬ ПО
		|	рарусЗаказКлиента.Ссылка,
		|	рарусЗаказКлиента.Контрагент
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	рарусЗаказНаПеремещение.Ссылка,
		|	рарусЗаказНаПеремещение.СкладПолучатель
		|ИЗ
		|	Документ.рарусЗаказНаПеремещение.Товары КАК рарусЗаказНаПеремещениеТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусЗаказНаПеремещение КАК рарусЗаказНаПеремещение
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.vftСуда КАК vftСуда
		|			ПО рарусЗаказНаПеремещение.СкладОтправитель.Судно = vftСуда.Ссылка
		|				И (vftСуда.Ссылка = &ОсновноеСудно)
		|		ПО рарусЗаказНаПеремещениеТовары.Ссылка = рарусЗаказНаПеремещение.Ссылка
		|			И (&ВыбиратьЗаказыНаПеремещения)
		|			И (рарусЗаказНаПеремещение.Номер ПОДОБНО &НомерРаспоряжения)
		|			И (НАЧАЛОПЕРИОДА(рарусЗаказНаПеремещение.Дата, ДЕНЬ) = &ДатаРаспоряжения)
		|			И (рарусЗаказНаПеремещение.СкладПолучатель = &Получатель)
		|
		|СГРУППИРОВАТЬ ПО
		|	рарусЗаказНаПеремещение.Ссылка,
		|	рарусЗаказНаПеремещение.СкладПолучатель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ВыбранныеРаспоряжения.Распоряжение КАК Распоряжение,
		|	ВТ_ВыбранныеРаспоряжения.Получатель КАК Получатель,
		|	ЕСТЬNULL(рарусТоварыКОтгрузкеОстатки.КоличествоОстаток, 0) <> 0 КАК ЕстьНеотправленное,
		|	ВТ_ВыбранныеРаспоряжения.Распоряжение.Комментарий КАК КомментарийРаспоряжения
		|ИЗ
		|	ВТ_ВыбранныеРаспоряжения КАК ВТ_ВыбранныеРаспоряжения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.рарусТоварыКОтгрузке.Остатки(
		|				&Период,
		|				Судно = &ОсновноеСудно
		|					И Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)) КАК рарусТоварыКОтгрузкеОстатки
		|		ПО ВТ_ВыбранныеРаспоряжения.Распоряжение = рарусТоварыКОтгрузкеОстатки.Распоряжение
		|ГДЕ
		|	ЕСТЬNULL(рарусТоварыКОтгрузкеОстатки.КоличествоОстаток, 0) > 0");
	Если Не ЗначениеЗаполнено(НомерРаспоряжения) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И (рарусЗаказКлиента.Номер ПОДОБНО &НомерРаспоряжения)", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И (рарусЗаказНаПеремещение.Номер ПОДОБНО &НомерРаспоряжения)", "");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаРаспоряжения) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И (НАЧАЛОПЕРИОДА(рарусЗаказКлиента.Дата, ДЕНЬ) = &ДатаРаспоряжения)", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И (НАЧАЛОПЕРИОДА(рарусЗаказНаПеремещение.Дата, ДЕНЬ) = &ДатаРаспоряжения)", "");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Получатель) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И (рарусЗаказКлиента.Контрагент = &Получатель)", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И (рарусЗаказНаПеремещение.СкладПолучатель = &Получатель)", "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВыбиратьЗаказыКлиента", ВыбиратьЗаказыКлиента);
	Запрос.УстановитьПараметр("ВыбиратьЗаказыНаПеремещения", ВыбиратьЗаказыНаПеремещения);
	Запрос.УстановитьПараметр("НомерРаспоряжения", "%" + НомерРаспоряжения + "%");
	Запрос.УстановитьПараметр("ДатаРаспоряжения", НачалоДня(ДатаРаспоряжения));
	Запрос.УстановитьПараметр("Получатель", Получатель);
	
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.УстановитьПараметр("ОсновноеСудно", ОсновноеСудно);
	
	ТаблицаРаспоряжений.Очистить();
	ОтгружаемаяНоменклатура.Очистить();
	
	ВыбранныеРаспоряжения = ВыполнитьПоискПоСтрокеПоиска(Запрос.Выполнить().Выгрузить());
		
	Для Каждого СтрокаРаспоряжения Из ВыбранныеРаспоряжения Цикл
		Если СтрокаРаспоряжения.ЕстьНеотправленное Или ПоказыватьОформленные Тогда
			Строка = ТаблицаРаспоряжений.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, СтрокаРаспоряжения);
			Строка.ВидРасхода = ?(ТипЗнч(СтрокаРаспоряжения.Распоряжение) = Тип("ДокументСсылка.рарусЗаказКлиента"), "Контрагенту", "На склад");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

//Заполнение ТЧ номенклатуры для поступления//
&НаСервере
Процедура ДобавитьДанныеРаспоряженияВРасход(СтруктураПараметров)
	
	Если РазрешеноДобавлениеРаспоряженияВЗагружаемуюНоменклатуру(СтруктураПараметров.Распоряжение) Тогда
		ДанныеРаспоряженияПоОтбору = ДанныеРаспоряженияПоОтбору(СтруктураПараметров, ОсновноеСудно);
		Пока ДанныеРаспоряженияПоОтбору.Следующий() Цикл
			Если ДанныеРаспоряженияПоОтбору.КоличествоОстаток > 0 ИЛИ ПоказыватьОформленные Тогда
				Строка = ОтгружаемаяНоменклатура.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, ДанныеРаспоряженияПоОтбору);
			КонецЕсли;
		КонецЦикла;
	Иначе
		СтруктураПараметров.Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура УдалитьДанныеРаспоряженияИзРасхода(СтруктураПараметров)
	
	МассивУдаляемыхСтрок = Новый Массив;
	Отбор = Новый Структура("Распоряжение", СтруктураПараметров.Распоряжение);
	Для Каждого Строка Из ОтгружаемаяНоменклатура.НайтиСтроки(Отбор) Цикл
		МассивУдаляемыхСтрок.Добавить(Строка);
	КонецЦикла;
	
	Для Каждого Строка Из МассивУдаляемыхСтрок Цикл
		ОтгружаемаяНоменклатура.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры
&НаСервере
Функция РазрешеноДобавлениеРаспоряженияВЗагружаемуюНоменклатуру(Распоряжение)
	
	РазрешеноДобавлениеРаспоряжения = Ложь;
	Таблица = ОтгружаемаяНоменклатура.Выгрузить(,"Распоряжение");
	Таблица.Свернуть("Распоряжение");
	ВыгружаемыеРаспоряжения = Таблица.ВыгрузитьКолонку("Распоряжение");
	Если ВыгружаемыеРаспоряжения.Количество() = 0 Тогда
		РазрешеноДобавлениеРаспоряжения = Истина;
	ИначеЕсли ВыгружаемыеРаспоряжения.Количество() = 1 И ВыгружаемыеРаспоряжения[0] = Распоряжение Тогда
		РазрешеноДобавлениеРаспоряжения = Истина;
	КонецЕсли;
	
	Возврат РазрешеноДобавлениеРаспоряжения;
	
КонецФункции
&НаСервереБезКонтекста
Функция ДанныеРаспоряженияПоОтбору(СтруктураПараметров, ОсновноеСудно)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	рарусЗаказКлиентаТовары.Ссылка КАК Распоряжение,
		|	рарусЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
		|	СУММА(рарусЗаказКлиентаТовары.Количество) КАК Количество,
		|	рарусЗаказКлиентаТовары.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВТ_ДанныеРаспоряжения
		|ИЗ
		|	Документ.рарусЗаказКлиента.Товары КАК рарусЗаказКлиентаТовары
		|ГДЕ
		|	рарусЗаказКлиентаТовары.Ссылка = &Распоряжение
		|	И рарусЗаказКлиентаТовары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
		|
		|СГРУППИРОВАТЬ ПО
		|	рарусЗаказКлиентаТовары.Ссылка,
		|	рарусЗаказКлиентаТовары.Номенклатура,
		|	рарусЗаказКлиентаТовары.КодСтроки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	рарусЗаказНаПеремещениеТовары.Ссылка,
		|	рарусЗаказНаПеремещениеТовары.Номенклатура,
		|	СУММА(рарусЗаказНаПеремещениеТовары.Количество),
		|	рарусЗаказНаПеремещениеТовары.КодСтроки
		|ИЗ
		|	Документ.рарусЗаказНаПеремещение.Товары КАК рарусЗаказНаПеремещениеТовары
		|ГДЕ
		|	рарусЗаказНаПеремещениеТовары.Ссылка = &Распоряжение
		|	И рарусЗаказНаПеремещениеТовары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
		|
		|СГРУППИРОВАТЬ ПО
		|	рарусЗаказНаПеремещениеТовары.Номенклатура,
		|	рарусЗаказНаПеремещениеТовары.Ссылка,
		|	рарусЗаказНаПеремещениеТовары.КодСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеРаспоряжения.Распоряжение КАК Распоряжение,
		|	ДанныеРаспоряжения.Номенклатура КАК Номенклатура,
		|	ДанныеРаспоряжения.КодСтроки КАК КодСтроки,
		//|	ДанныеРаспоряжения.Номенклатура.рспбКодMDG КАК НоменклатураКодMDG,
		|	ДанныеРаспоряжения.Количество КАК КоличествоРаспоряжение,
		|	ЕСТЬNULL(рарусТоварыКОтгрузкеОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(рарусТоварыКОтгрузкеОстатки.КоличествоОстаток, 0) КАК Количество
		|ИЗ
		|	ВТ_ДанныеРаспоряжения КАК ДанныеРаспоряжения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.рарусТоварыКОтгрузке.Остатки(
		|				&Период,
		|				Распоряжение = &Распоряжение
		|					И Судно = &ОсновноеСудно) КАК рарусТоварыКОтгрузкеОстатки
		|		ПО (ДанныеРаспоряжения.Распоряжение = рарусТоварыКОтгрузкеОстатки.Распоряжение)
		|			И (ДанныеРаспоряжения.Номенклатура = рарусТоварыКОтгрузкеОстатки.Номенклатура)
		|			И (ДанныеРаспоряжения.КодСтроки = рарусТоварыКОтгрузкеОстатки.КодСтроки)");
	
	Запрос.УстановитьПараметр("Распоряжение", СтруктураПараметров.Распоряжение);
	Запрос.УстановитьПараметр("Период", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ОсновноеСудно", ОсновноеСудно);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

//Формирование документа Расход ТМЦ//
&НаСервере
Функция СписатьНаСервере(СтруктураПараметров)
	
	РезультатОбработки = Новый Структура("Отказ,ТекстОшибки,ЗаголовокОшибки", Ложь, "", "");
	
	//Формирование документа расхода//
	ДокументРасхода = Документы.рарусРасходТМЦ.СоздатьДокумент();
	ДокументРасхода.Комментарий = СтруктураПараметров.Комментарий;
	ДокументРасхода.ДокументОснование = ОтгружаемаяНоменклатура[0].Распоряжение;
	ДокументРасхода.Заполнить(Неопределено);
	
	// ++ rarus makole 2021-06-30 [РАIT-0023374]
	// Учёт номенклатуры разного качества 
	Если ЕстьНеНоваяНоменклатура(ДокументРасхода.ДокументОснование) Тогда
		ДокументРасхода.ВидОперации = Перечисления.рарусВидыОперацийРасходаТМЦ.БУ;
	КонецЕсли;
	// -- rarus makole 2021-06-30 [РАIT-0023374]
	
	Для Каждого Строка Из ОтгружаемаяНоменклатура Цикл
		Если Строка.Количество > 0 Тогда
			СтрокаТЧ = ДокументРасхода.ТМЦ.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТЧ, Строка);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		ДокументРасхода.Записать(РежимЗаписиДокумента.Проведение);
		// ++ rarus makole 2021-04-22 [Задача № 28687]
		// По списаниям ТМЦ, автоматически создаваемым в класс. ТОИР автоматически включать отправку 
		// на берег при создании и проведении
		рарусИмущественныйУчетВызовСервера.УстановитьСтатусЗарегистрированоКОтправке(ДокументРасхода.Ссылка);
		// -- rarus makole 2021-04-22 [Задача № 28687]
	Исключение
		РезультатОбработки.Отказ = Истина;
		РезультатОбработки.ТекстОшибки = ОписаниеОшибки();
		РезультатОбработки.ЗаголовокОшибки = "Не удалось записать документ";
	КонецПопытки;
	
	//Создание файла//
	Если СтруктураПараметров.ЕстьПриложенныеФайлы Тогда
		Если Не РезультатОбработки.Отказ Тогда
			Для Каждого ПриложенныйФайл Из СтруктураПараметров.СведенияОФайлах Цикл
				ПараметрыФайла = Новый Структура;
				ПараметрыФайла.Вставить("Автор", ПараметрыСеанса.АвторизованныйПользователь);
				ПараметрыФайла.Вставить("ВладелецФайлов", ДокументРасхода.Ссылка);
				ПараметрыФайла.Вставить("ИмяБезРасширения", ПриложенныйФайл.СведенияОФайле.ИмяБезРасширения);
				ПараметрыФайла.Вставить("РасширениеБезТочки", ПриложенныйФайл.СведенияОФайле.РасширениеБезТочки);
				ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяУниверсальнаяДата());
				ПараметрыФайла.Вставить("ГруппаФайлов", Неопределено);
				ПараметрыФайла.Вставить("Служебный", Ложь);
				Результат = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, ПриложенныйФайл.СведенияОФайле.АдресВременногоХранилищаФайла);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезультатОбработки;
	
КонецФункции
&НаСервере
Функция ЕстьВыбранныеСтрокиРаспоряжений()
	
	Возврат ОтгружаемаяНоменклатура.Итог("Количество") > 0;
	
КонецФункции

// ++ rarus makole 2021-10-01 [РАIT-0023495]
// Доработка отдельных механизмов по учёту и списанию ТМЦ на судах 
&НаСервере
Функция СформироватьРасходПоКатегориям(СтруктураПараметров)
	
	Перем ТаблицаНесписанных;
	
	РезультатОбработки = Новый Структура("Отказ,ТекстОшибки,ЗаголовокОшибки", Ложь, "", "");
	ТаблицаДляОбработки = ОтгружаемаяНоменклатура.Выгрузить(,"Номенклатура, Количество");
	СтруктураПараметров.Вставить("ОсновноеСудно", ОсновноеСудно);
	Обработки.рарусОформлениеРасходаТМЦ.СформироватьРасход(СтруктураПараметров, РезультатОбработки, ТаблицаДляОбработки, ТаблицаНесписанных);
	
	Если ТаблицаНесписанных <> Неопределено Тогда
		ОтгружаемаяНоменклатура.Загрузить(ТаблицаНесписанных)
	КонецЕсли;
	
	Возврат РезультатОбработки;
	
КонецФункции
// -- rarus makole 2021-10-01 [РАIT-0023495]

//Отображение документов приемки//
&НаСервере
Процедура ЗаполнитьДокументыРасходаТМЦ(Распоряжение, Номенклатура)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	рарусТоварыКОтгрузкеОбороты.Регистратор КАК Документ,
	                      |	рарусТоварыКОтгрузкеОбороты.КоличествоРасход КАК Количество
	                      |ИЗ
	                      |	РегистрНакопления.рарусТоварыКОтгрузке.Обороты(
	                      |			,
	                      |			,
	                      |			Регистратор,
	                      |				Распоряжение = &Распоряжение
	                      |				И Номенклатура = &Номенклатура
	                      |				И Судно = &ОсновноеСудно) КАК рарусТоварыКОтгрузкеОбороты");
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ОсновноеСудно", ОсновноеСудно);
	
	ТаблицаДокументовРасхода.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтгружаемаяНоменклатура.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗагружаемаяНоменклатура.Количество");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста, , ,Истина));
	
	//
	
КонецПроцедуры

Функция ВыполнитьПоискПоСтрокеПоиска(ВходящиеДанные)
	
	Если Не ЗначениеЗаполнено(СтрокаПоиска) тогда
		Возврат ВходящиеДанные;
	КонецЕсли;
	
	Возврат ВыполнитьПоискСКД(ВходящиеДанные, СтрокаПоиска);
	
КонецФункции

Функция ВыполнитьПоискСКД(ВходящиеДанные, ПараметрПоиска)
		
	// Программно делаем вывод результата в таблицу значений
	Результат = Новый ТаблицаЗначений;
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	СхемаКомпоновкиДанных = РеквизитФормыВЗначение("Объект").ПолучитьМакет("МакетПоиска");
	
	ИсточникДоступныхНастроекКомпоновкиДанных  = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
	КомпановщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпановщикНастроек.Инициализировать(ИсточникДоступныхНастроекКомпоновкиДанных);
	КомпановщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	// параметры и отборы                                                                                  
	КомпановщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПараметрПоиска", ПараметрПоиска);
	//                                                                                                                                   , использование
		
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		КомпановщикНастроек.ПолучитьНастройки(),,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
	);
	
	ВнешниеНаборы = Новый Структура;
	ВнешниеНаборы.Вставить("ВходящиеДанные", ВходящиеДанные);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборы);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Возврат Результат;
	
КонецФункции	

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПоиск()
	
	Перем Оповещение;
	
	Если ОтгружаемаяНоменклатура.Количество() > 0 Тогда
		Оповещение = Новый ОписаниеОповещения("ИзменениеОтбораЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, "Выбранные строки будут очищены", РежимДиалогаВопрос.ДаНет,0,КодВозвратаДиалога.Да, "По выбранному отбору уже выбраны строки");
	Иначе
		ЗаполнитьЗначенияСвойств(СохраненныйОтбор, ЭтотОбъект);
		НайтиРаспоряженияНаСервере();
	КонецЕсли;
	
	рарусОбщегоНазначенияСМКлиентСервер.ПоказатьСкрытьКнопкуОчисткиОтбора(Элементы.СтрокаПоиска, СтрокаПоиска);

КонецПроцедуры

&НаКлиенте
Процедура ПоискВыполнить(Команда)
	
	ВыполнитьПоиск();
	
КонецПроцедуры

// ++ rarus makole 2021-06-30 [РАIT-0023374]
// Учёт номенклатуры разного качества 
&НаСервере
Функция ЕстьНеНоваяНоменклатура(Распоряжение)
	
	Если (ТипЗнч(Распоряжение) = Тип("ДокументСсылка.рарусЗаказНаПеремещение")
		ИЛИ ТипЗнч(Распоряжение) = Тип("ДокументСсылка.рарусЗаказКлиента"))
		И ПолучитьФункциональнуюОпцию("ИспользоватьКачествоТоваров") Тогда
		
		МассивНоменклатуры = ОтгружаемаяНоменклатура.Выгрузить(,"Номенклатура").ВыгрузитьКолонку("Номенклатура");
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Номенклатура.Качество КАК Качество
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Ссылка В(&МассивНоменклатуры)
			|	И Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.Новый)
			|	И Номенклатура.Качество <> ЗНАЧЕНИЕ(Перечисление.ГрадацииКачества.ПустаяСсылка)";
		
		Запрос.УстановитьПараметр("МассивНоменклатуры", МассивНоменклатуры);
		
		РезультатЗапроса = Запрос.Выполнить();
	
		Возврат НЕ РезультатЗапроса.Пустой();
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
// -- rarus makole 2021-06-30 [РАIT-0023374]










