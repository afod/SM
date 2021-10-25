&НаСервере
Функция ПолучитьРеквизитыРДО() Экспорт
	ТаблицаРеквизитов = Новый ТаблицаЗначений;
	ТаблицаРеквизитов.Колонки.Добавить("Идентификатор");
	ТаблицаРеквизитов.Колонки.Добавить("Наименование");
	Для каждого РеквизитРДО Из Метаданные.Документы.vftРДО.Реквизиты Цикл
		НовыйРеквизит = ТаблицаРеквизитов.Добавить();
		НовыйРеквизит.Идентификатор = РеквизитРДО.Имя;
		НовыйРеквизит.Наименование  = РеквизитРДО.Синоним;
	КонецЦикла;
	
	Для каждого РеквизитРДО Из Метаданные.Документы.vftРДО.СтандартныеРеквизиты Цикл
		НовыйРеквизит = ТаблицаРеквизитов.Добавить();
		НовыйРеквизит.Идентификатор = РеквизитРДО.Имя;
		НовыйРеквизит.Наименование  = РеквизитРДО.Синоним;
	КонецЦикла;
	
	НовыйРеквизит = ТаблицаРеквизитов.Добавить();
	НовыйРеквизит.Идентификатор = "Дислокация";
	НовыйРеквизит.Наименование  = "Группа "+"Дислокация";
	
	НовыйРеквизит = ТаблицаРеквизитов.Добавить();
	НовыйРеквизит.Идентификатор = "Стоянка";
	НовыйРеквизит.Наименование  = "Группа "+"Стоянка";
	
	//raruskzn AydaFZ 15.11.2019{
	НовыйРеквизит = ТаблицаРеквизитов.Добавить();
	НовыйРеквизит.Идентификатор = "Груз";
	НовыйРеквизит.Наименование  = "Группа "+"Грузы";
	//raruskzn AydaFZ 15.11.2019} 

	
	//НовыйРеквизит = ТаблицаРеквизитов.Добавить();
	//НовыйРеквизит.Идентификатор = "СудноКод";
	//НовыйРеквизит.Наименование  = "Группа "+"СудноКод";
	//
	//НовыйРеквизит = ТаблицаРеквизитов.Добавить();
	//НовыйРеквизит.Идентификатор = "СудноНомер";
	//НовыйРеквизит.Наименование  = "Группа "+"СудноНомер";
	
	Возврат ТаблицаРеквизитов
КонецФункции


Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = '%1/%2/%3'"),  
	Данные.Ссылка.Судно,
	Данные.Ссылка.ВидОперации.КодОперации,
	Формат(Данные.Дата, "ДФ='dd.MM Ч-мм'; ДЛФ=DD"));
	
КонецПроцедуры
 
