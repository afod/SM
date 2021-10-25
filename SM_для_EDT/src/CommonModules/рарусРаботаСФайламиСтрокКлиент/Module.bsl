&НаКлиенте
Функция ПараметрыДобавленияФайла(ВыбраннаяСтрока, Форма, ИмяТаблицы, ИмяТаблицыХранения) Экспорт
		
	ПараметрыДобавленияФайла = Новый Структура;
	ПараметрыДобавленияФайла.Вставить("Владелец", Форма.Объект.Ссылка);
	ПараметрыДобавленияФайла.Вставить("ИмяТаблицы", ИмяТаблицы);
	ПараметрыДобавленияФайла.Вставить("ИмяТаблицыХранения", ИмяТаблицыХранения);
	ПараметрыДобавленияФайла.Вставить("Таблица", Форма.Объект[ИмяТаблицы]);
	ПараметрыДобавленияФайла.Вставить("ТаблицаХранения", Форма.Объект[ИмяТаблицыХранения]);
	ПараметрыДобавленияФайла.Вставить("ВыбраннаяСтрока", ВыбраннаяСтрока);
	ПараметрыДобавленияФайла.Вставить("Форма", Форма);
	
	Возврат ПараметрыДобавленияФайла;
	
КонецФункции

Процедура ОбновитьПараметрыДобавленияФайла(ПараметрыДобавленияФайла)
	
	ПараметрыДобавленияФайла.Владелец = ПараметрыДобавленияФайла.Форма.Объект.Ссылка;
	
КонецПроцедуры	

Функция ФайлЗаполенПоСтроке(Параметры)
	
	СтрокаДанных = Параметры.Таблица.НайтиПоИдентификатору(Параметры.ВыбраннаяСтрока);	
	
	СтрокиФайлов = рарусРаботаСФайламиСтрокКлиентСервер.НайтиСтрокиФайлов(СтрокаДанных, Параметры.ТаблицаХранения); 
	
	Возврат СтрокиФайлов.Количество(); 
	
КонецФункции 

Процедура ОткрытьВыбратьФайлПоСтрокеНачать(Параметры) Экспорт
	
	Если ФайлЗаполенПоСтроке(Параметры) тогда
		
		ОткрытьФайлПоСтроке(Параметры);
		
	Иначе
		
		ВыбратьФайлПоСтрокеНачать(Параметры);
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ВыбратьФайлПоСтрокеНачать(Параметры)
	
	Форма = Параметры.Форма;
	
	Если Форма.Модифицированность тогда
				
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФайлПоСтрокеВопрос", ЭтотОбъект, Параметры);
		
		ПоказатьВопрос(ОписаниеОповещения, "Заявку необходимо записать перед добавлением файлов. Записать и продолжить?",РежимДиалогаВопрос.ДаНет, 60);
				
	Иначе
		
		ВыбратьФайлПоСтроке(Параметры);
		
	КонецЕсли;
		
КонецПроцедуры	
 
Процедура ВыбратьФайлПоСтрокеВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Оповещение = Новый ОписаниеОповещения("ВыбратьФайлПоСтрокеПослеЗаписи", ЭтотОбъект, ДополнительныеПараметры);
		
		Форма = ДополнительныеПараметры.Форма;
		ОбщегоНазначенияУТКлиент.Записать(Форма, Ложь, Оповещение);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыбратьФайлПоСтрокеПослеЗаписи(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		ОбновитьПараметрыДобавленияФайла(ДополнительныеПараметры);
		
		ВыбратьФайлПоСтроке(ДополнительныеПараметры);		
		
	КонецЕсли; 
	
КонецПроцедуры


Процедура ВыбратьФайлПоСтроке(ДополнительныеПараметры)
			
	ДобавитьФайлПоСтроке(ДополнительныеПараметры);
		
КонецПроцедуры

Процедура ОткрытьФайлПоСтроке(Параметры)
	
	СтрокаДанных = Параметры.Таблица.НайтиПоИдентификатору(Параметры.ВыбраннаяСтрока);
	
	СтрокиФайлов = рарусРаботаСФайламиСтрокКлиентСервер.НайтиСтрокиФайлов(СтрокаДанных, Параметры.ТаблицаХранения);
	
	МассивФайлов = Новый Массив;
	Для Каждого СтрокаФайла Из СтрокиФайлов Цикл 
		МассивФайлов.Добавить(СтрокаФайла.Файл);
	КонецЦикла;	
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВладелецФайла", Параметры.Владелец);
	ПараметрыОткрытия.Вставить("ФайлыОтбор", МассивФайлов);
	ПараметрыОткрытия.Вставить("ПростаяФорма", Истина);
	ПараметрыОткрытия.Вставить("СтрокаТаблицы", Параметры.ВыбраннаяСтрока);
	ПараметрыОткрытия.Вставить("ИмяТаблицыВладельца", Параметры.ИмяТаблицы);
	ПараметрыОткрытия.Вставить("ИмяТаблицыХраненияВладельца", Параметры.ИмяТаблицыХранения);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.рарусПрисоединенныеФайлыСтрок", ПараметрыОткрытия, Параметры.Форма, , , , ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ОткрытьФайл(ФайлСсылка)		
	
	//ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ФайлСсылка, Неопределено, УникальныйИдентификатор);
	//
	//РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);

КонецПроцедуры
 
Процедура ДобавитьФайлПоСтроке(Параметры)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлПоСтрокеЗавершение", 
		ЭтотОбъект, 
		Параметры
		); 
		
	РаботаСФайламиКлиент.ДобавитьФайлы(Параметры.Владелец, Параметры.Форма.УникальныйИдентификатор, , ,ОписаниеОповещения);
	
КонецПроцедуры
 
Процедура ДобавитьФайлПоСтрокеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено тогда
		
		Таблица = Параметры.Таблица;
		ТаблицаХранения = Параметры.ТаблицаХранения;
		ВыбраннаяСтрока = Параметры.ВыбраннаяСтрока;
		Форма = Параметры.Форма;
		
		Форма.Модифицированность = Истина;
		
		ФайлыМассив = рарусРаботаСФайламиСтрокКлиентСервер.РезультатВМассивФайлов(Результат);
			
		СтрокаДанных = Таблица.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		ПрикрепитьФайлыКСтроке(СтрокаДанных, ФайлыМассив, ТаблицаХранения);
		
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Запись);
		Форма.Записать(ПараметрыЗаписи);
						
	КонецЕсли;
	
КонецПроцедуры
 
Процедура ПрикрепитьФайлКСтроке(СтрокаДанных, ФайлСсылка, ТаблицаХранения)
		
	СтрокаДанных.Файл = ФайлСсылка;
	
	рарусРаботаСФайламиСтрокКлиентСервер.ЗаполнитьПредставлениеФайлаСтроки(СтрокаДанных, ТаблицаХранения);
	
КонецПроцедуры

Процедура ПрикрепитьФайлыКСтроке(СтрокаДанных, ФайлыМассив, ТаблицаХранения)
	
	УстановитьИдентификаторФайловСтроки(СтрокаДанных);
	
	Для Каждого ФайлСсылка Из ФайлыМассив цикл
				
		ДобавитьФайлыКСтроке(СтрокаДанных, ФайлСсылка, ТаблицаХранения);
											
	КонецЦикла;
	
	рарусРаботаСФайламиСтрокКлиентСервер.ЗаполнитьПредставлениеФайлаСтроки(СтрокаДанных, ТаблицаХранения);
	
КонецПроцедуры

Процедура ДобавитьФайлыКСтроке(СтрокаДанных, ФайлСсылка, ТаблицаХранения)
		
	СтрокаФайла = ТаблицаХранения.Добавить();
	СтрокаФайла.ИдентификаторФайлов = СтрокаДанных.ИдентификаторФайлов;
	СтрокаФайла.Файл = ФайлСсылка;		

КонецПроцедуры

Процедура УстановитьИдентификаторФайловСтроки(Знач СтрокаДанных)
	
	Если Не ЗначениеЗаполнено(СтрокаДанных.ИдентификаторФайлов) тогда
		СтрокаДанных.ИдентификаторФайлов = Новый УникальныйИдентификатор;
	КонецЕсли;

КонецПроцедуры

Процедура УдалитьФайлПоСтрокеНачать(Параметры) Экспорт
	
	Если ФайлЗаполенПоСтроке(Параметры) тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьФайлПоСтрокеВопрос", ЭтотОбъект, Параметры);
		ПоказатьВопрос(ОписаниеОповещения, "Для указанной строки будут удалены прикрепленные файлы. Продолжить?",РежимДиалогаВопрос.ДаНет, 60);
		
	КонецЕсли;

КонецПроцедуры

Процедура УдалитьФайлПоСтрокеВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		УдалитьФайлПоСтроке(ДополнительныеПараметры);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура УдалитьФайлПоСтроке(Параметры)
	
	Форма = Параметры.Форма;
	ТаблицаХранения = Параметры.ТаблицаХранения;
	ВыбраннаяСтрока = Параметры.ВыбраннаяСтрока;
	
	Форма.Модифицированность = Истина;
	
	СтрокаДанных = Параметры.Таблица.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	// ++ rarus PleA 18.05.2021 [26397 ]
	Попытка
		рарусРаботаСФайламиСтрокВызовСервера.ПометитьНаУдалениеФайл(СтрокаДанных.ИдентификаторФайлов, ТаблицаХранения);
	Исключение
		ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	// -- rarus PleA
	
	СтрокаДанных.ИдентификаторФайлов = ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор();
	
	рарусРаботаСФайламиСтрокКлиентСервер.ЗаполнитьПредставлениеФайлаСтроки(СтрокаДанных, ТаблицаХранения);
	
КонецПроцедуры
 
