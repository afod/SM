
#Область РейсовыйиТопливныйОтчет

Функция ПолучитьПредставлениеТопливо(Документ, Пар) Экспорт
	
	Врем = Документ.Бункеровки.Выгрузить();
	Врем.Свернуть("ДатаБункеровки, ВидТоплива", "Количество");
	
	Если Пар = "Н" Тогда
		Врем = Врем.НайтиСтроки(новый Структура("ДатаБункеровки", '19000101'));
	ИначеЕсли Пар = "Р" Тогда
		Врем = Врем.НайтиСтроки(новый Структура("ДатаБункеровки", '39991215'));
	ИначеЕсли Пар = "К" Тогда
		Врем = Врем.НайтиСтроки(новый Структура("ДатаБункеровки", '39991220'));
	Иначе
		Возврат "";
	КонецЕсли;
	
	Если Врем.Количество() = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	ТопливоСМТКол = 0;
	ТопливоМТ01Кол = 0;
	ТопливоМТ05Кол = 0;
	ТопливоМТ15Кол = 0;
	МаслоГДКол = 0;
	МаслоДГКол = 0;
	// ++ rarus Камаев П.В. 02.10.2020 Задача № 24505
	МаслоКол = 0;
	
	Для каждого ВремСтрока Из Врем Цикл
		
		Если ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.МаслоГД.Значение Тогда
			МаслоГДКол = ВремСтрока.Количество;
			МаслоКол = МаслоКол + МаслоГДКол;
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоМТ01.Значение Тогда
			ТопливоМТ01Кол = ВремСтрока.Количество;
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоМТ05.Значение Тогда
			ТопливоМТ05Кол = ВремСтрока.Количество;
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоМТ15.Значение Тогда
			ТопливоМТ15Кол = ВремСтрока.Количество;
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоСМТ.Значение Тогда
			ТопливоСМТКол = ВремСтрока.Количество;
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.МаслоДГ.Значение Тогда
			МаслоДГКол = ВремСтрока.Количество;
			МаслоКол = МаслоКол + МаслоДГКол;
		КонецЕсли;
	
	КонецЦикла;
	
	Проект = Документ.Судно.Проект;
	МассивВидовТоплива = ПолучитьМассивВидовТопливаПоПроекту(Проект);

	ПредставлениеТопливо = "";
	Для каждого ЭлементМассива Из МассивВидовТоплива Цикл
		Если ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоСМТ Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(ТопливоСМТКол,"ЧДЦ=3; ЧН=; ЧГ=0");	
			
		ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоМТ01 Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(ТопливоМТ01Кол,"ЧДЦ=3; ЧН=; ЧГ=0");
			
		ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоМТ05 Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(ТопливоМТ05Кол,"ЧДЦ=3; ЧН=; ЧГ=0");
			
		ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоМТ15 Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(ТопливоМТ15Кол,"ЧДЦ=3; ЧН=; ЧГ=0");
			
		ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.МаслоГД Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(МаслоГДКол,"ЧДЦ=1; ЧН=; ЧГ=0");
			
		ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.МаслоДГ Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(МаслоДГКол,"ЧДЦ=1; ЧН=; ЧГ=0");
			
		ИначеЕсли ЭлементМассива = "Масло" Тогда
			ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + Формат(МаслоКол,"ЧДЦ=1; ЧН=; ЧГ=0");
		КонецЕсли;
	КонецЦикла;
	
	
	Возврат ПредставлениеТопливо;
	// -- rarus Камаев П.В. 02.10.2020
	
КонецФункции

Процедура ВывестиСтрокуРейсовогоОтчета(Таб,Макет,Номер = "",Буква = "",Значение = "",Описание = "") Экспорт
	
	Область = Макет.ПолучитьОбласть("Строка");
	Область.Параметры.Номер = Номер;
	Область.Параметры.Буква = Буква;
	Область.Параметры.Значение = Значение;
	Область.Параметры.Описание = Описание;
	Таб.Вывести(Область);
	
КонецПроцедуры

Функция ПолучитьПредставлениеБункеровки(Документ) Экспорт
	
	// Получаем данные по бункеровкам
	Врем = Документ.Бункеровки.Выгрузить();
	рарусОбщегоНазначенияКлиентСервер.УдалитьСтрокиТЗ(Врем,Новый Структура("Операция",Справочники.vftТиповыеОперации.ПустаяСсылка()));
	Врем.Свернуть("ДатаБункеровки,Операция,Бункеровщик,ВидТоплива","Количество");
	Врем.Сортировать("ДатаБункеровки");
	Врем.Колонки.Добавить("ТопливоСМТКол",Новый ОписаниеТипов("Число"));
	Врем.Колонки.Добавить("ТопливоМТ01Кол",Новый ОписаниеТипов("Число"));
	Врем.Колонки.Добавить("ТопливоМТ05Кол",Новый ОписаниеТипов("Число"));
	Врем.Колонки.Добавить("ТопливоМТ15Кол",Новый ОписаниеТипов("Число"));
	Врем.Колонки.Добавить("МаслоГДКол",Новый ОписаниеТипов("Число"));
	Врем.Колонки.Добавить("МаслоДГКол",Новый ОписаниеТипов("Число"));
	// ++ rarus Камаев П.В. 02.10.2020 Задача № 24505
	Врем.Колонки.Добавить("МаслоКол",Новый ОписаниеТипов("Число"));

	Проект = Документ.Судно.Проект;
		
	Для каждого ВремСтрока Из Врем Цикл
		
		Если ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоСМТ.Значение Тогда
			ВремСтрока.ТопливоСМТКол = ВремСтрока.Количество;
			
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоМТ01.Значение Тогда
			ВремСтрока.ТопливоМТ01Кол = ВремСтрока.Количество;
			
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоМТ05.Значение Тогда
			ВремСтрока.ТопливоМТ05Кол = ВремСтрока.Количество;
			
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.ТопливоМТ15.Значение Тогда
			ВремСтрока.ТопливоМТ15Кол = ВремСтрока.Количество;
			
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.МаслоГД.Значение Тогда
			ВремСтрока.МаслоГДКол	= ВремСтрока.Количество;
			ВремСтрока.МаслоКол		= ВремСтрока.Количество;
			
		ИначеЕсли ВремСтрока.ВидТоплива = Справочники.рарусСправочникСсылок.МаслоДГ.Значение Тогда
			ВремСтрока.МаслоДГКол	= ВремСтрока.Количество;
			ВремСтрока.МаслоКол		= ВремСтрока.Количество;
		КонецЕсли;
	
	КонецЦикла;
	Врем.Свернуть("ДатаБункеровки,Операция,Бункеровщик","ТопливоСМТКол,ТопливоМТ01Кол,ТопливоМТ05Кол,ТопливоМТ15Кол,МаслоГДКол,МаслоДГКол,МаслоКол");
	Врем.Сортировать("ДатаБункеровки");
	// Дополнительные колонки
	Врем.Колонки.Добавить("ЭтоПерваяСтрока",Новый ОписаниеТипов("Булево"));
	Врем.Колонки.Добавить("Значение",Новый ОписаниеТипов("Строка"));
	Врем.Колонки.Добавить("Описание",Новый ОписаниеТипов("Строка"));
	
	// Если данных нет
	Если Врем.Количество() = 0 Тогда
		Стр = Врем.Добавить();
		Стр.ЭтоПерваяСтрока = Истина;
		Стр.Значение = "НЕТ";
		Стр.Описание = "Дата / Операция / Бункеровщик /  " + ПолучитьПредставлениеТопливоШапка(Проект);
		Возврат Врем;
	КонецЕсли;
	
	// Заполняем представление
	Врем[0].ЭтоПерваяСтрока = Истина;
	Врем[0].Описание = "Дата / Операция / Бункеровщик /  " + ПолучитьПредставлениеТопливоШапка(Проект);
	
	МассивВидовТоплива = ПолучитьМассивВидовТопливаПоПроекту(Проект);
	
	Для Каждого Стр из Врем Цикл
		Стр.Значение = Формат(Стр.ДатаБункеровки,"ДФ = dd.MM.yyyy") + " / " + Стр.Операция + " / " + Стр.Бункеровщик; 
		Для каждого ЭлементМассива Из МассивВидовТоплива Цикл
			Если ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоСМТ Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.ТопливоСМТКол,"ЧДЦ=3; ЧН=; ЧГ=0");	
				
			ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоМТ01 Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.ТопливоМТ01Кол,"ЧДЦ=3; ЧН=; ЧГ=0");
				
			ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоМТ05 Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.ТопливоМТ05Кол,"ЧДЦ=3; ЧН=; ЧГ=0");
				
			ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.ТопливоМТ15 Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.ТопливоМТ15Кол,"ЧДЦ=3; ЧН=; ЧГ=0");
				
			ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.МаслоГД Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.МаслоГДКол,"ЧДЦ=1; ЧН=; ЧГ=0");
				
			ИначеЕсли ЭлементМассива = Справочники.рарусСправочникСсылок.МаслоДГ Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.МаслоДГКол,"ЧДЦ=1; ЧН=; ЧГ=0");
				
			ИначеЕсли ЭлементМассива = "Масло" Тогда
				Стр.Значение = Стр.Значение + " / " + Формат(Стр.МаслоКол,"ЧДЦ=1; ЧН=; ЧГ=0");
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// -- rarus Камаев П.В. 02.10.2020
	
	Возврат Врем;
	
КонецФункции

Функция ПолучитьПредставлениеГрузы(Документ) Экспорт
	
	Перем ТЗ,СтрТЗ;
	
	ТЗ = ПолучитьТаблицуГрузов(Документ);
	ЭтоТолкач = Документ.Судно.Проект.Толкач;
	// Подготовка данных для рейсового отчета
	Если ЭтоТолкач Тогда
		ТЗ.Свернуть("ДатаВыпускаКоносамента,Груз,БаржаПриход","ВесГруза");
		ТЗ.Сортировать("ДатаВыпускаКоносамента,Груз,БаржаПриход");
	Иначе
		ТЗ.Свернуть("ДатаВыпускаКоносамента,Груз","ВесГруза");
		ТЗ.Сортировать("ДатаВыпускаКоносамента,Груз");
	КонецЕсли;
	
	// Добавляем дополнительные колонки
	ТЗ.Колонки.Добавить("ЭтоПерваяСтрока",Новый ОписаниеТипов("Булево"));
	ТЗ.Колонки.Добавить("Значение",Новый ОписаниеТипов("Строка"));
	ТЗ.Колонки.Добавить("Описание",Новый ОписаниеТипов("Строка"));
	
	// Если данных нет
	Если ТЗ.Количество() = 0 Тогда
		СтрТЗ = ТЗ.Добавить();
		СтрТЗ.ЭтоПерваяСтрока = Истина;
		СтрТЗ.Значение = "НЕТ";
		Если ЭтоТолкач Тогда
			СтрТЗ.Описание = "Дата выпуска коносамента / номер секции / наименование груза / количество, т";
		Иначе
			СтрТЗ.Описание = "Дата выпуска коносамента / наименование груза / количество, т";
		КонецЕсли;
		Возврат ТЗ;
	КонецЕсли;
	
	// Заполняем представление
	ТЗ[0].ЭтоПерваяСтрока = Истина;
	
	Если ЭтоТолкач Тогда
		ТЗ[0].Описание = "Дата выпуска коносамента / номер секции / наименование груза / количество, т";
		Для Каждого СтрТЗ из ТЗ Цикл
			СтрТЗ.Значение = Формат(СтрТЗ.ДатаВыпускаКоносамента,"ДФ = dd.MM.yyyy; ДП = '<не указано>'") + " / " + СтрТЗ.БаржаПриход + " / " + СтрТЗ.Груз + " / " + Формат(СтрТЗ.ВесГруза,"ЧДЦ = 3; ЧН = ; ЧГ = 0");
		КонецЦикла;
	Иначе
		ТЗ[0].Описание = "Дата выпуска коносамента / наименование груза / количество, т";
		Для Каждого СтрТЗ из ТЗ Цикл
			СтрТЗ.Значение = Формат(СтрТЗ.ДатаВыпускаКоносамента,"ДФ = dd.MM.yyyy; ДП = '<не указано>'") + " / " + СтрТЗ.Груз + " / " + Формат(СтрТЗ.ВесГруза,"ЧДЦ = 3; ЧН = ; ЧГ = 0");
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТЗ;
	
КонецФункции

Функция ПолучитьТаблицуГрузов(Документ) Экспорт
	
	// Причины, у которых возможно получение груза
	СписокПричин = Новый Массив;
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.НачалоРейса);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.ФормированиеСостава);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.Маневры);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.МаневрыНаПереходе);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.Погрузка);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.Перевалка);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.ОжиданиеВыгрузки);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.ОжиданиеДогрузки);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.ОжиданиеПаузки);
	СписокПричин.Добавить(Справочники.vftТиповыеОперации.ОжиданиеПогрузки);
	
	// Строки ТЧ "Пункты" с указанными причинами
	СписокИД = Новый Массив;
	
	Для Каждого СтрП из Документ.Пункты Цикл
		Если СписокПричин.Найти(СтрП.ПричинаСтоянки)<>Неопределено Тогда
			СписокИД.Добавить(СтрП.ИД);
		КонецЕсли;
	КонецЦикла;
	
	// Отбираем строки из ТЧ "Баржи"
	ТЗ = Документ.Баржи.ВыгрузитьКолонки("БаржаПриход,Груз,ВесГруза,ДатаВыпускаКоносамента");
	
	Для Каждого СтрБ из Документ.Баржи Цикл
		Если СтрБ.ВесГруза<>0 и не СтрБ.ВесГрузаМетка и СписокИД.Найти(СтрБ.ИД)<>Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ТЗ.Добавить(),СтрБ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТЗ;
	
КонецФункции

// ++ rarus Камаев П.В. 02.10.2020 Задача № 24505
Функция ПолучитьПредставлениеТопливоШапка(Проект) Экспорт
	
	Соответствие = новый Соответствие;
	Соответствие.Вставить(Справочники.рарусСправочникСсылок.ТопливоСМТ, "СМТ, т");
	Соответствие.Вставить(Справочники.рарусСправочникСсылок.ТопливоМТ01, "МТ 0.1, т");
	Соответствие.Вставить(Справочники.рарусСправочникСсылок.ТопливоМТ05, "МТ 0.5, т");
	Соответствие.Вставить(Справочники.рарусСправочникСсылок.ТопливоМТ15, "МТ 1.5, т");
	Соответствие.Вставить(Справочники.рарусСправочникСсылок.МаслоГД, "Масло ГД, кг");
	Соответствие.Вставить(Справочники.рарусСправочникСсылок.МаслоДГ, "Масло ДГ, кг");
	Соответствие.Вставить("Масло", "Масло ГД+ДГ, кг");
	
	МассивВидовТоплива = ПолучитьМассивВидовТопливаПоПроекту(Проект);
	
	ПредставлениеТопливо = "";
	
	Для Каждого ЭлементМассива ИЗ МассивВидовТоплива Цикл
		ТекПредставлениеТопливо = Соответствие.Получить(ЭлементМассива);
		ПредставлениеТопливо = ПредставлениеТопливо + ?(ЗначениеЗаполнено(ПредставлениеТопливо), " / ", "") + ТекПредставлениеТопливо;	
	КонецЦикла;
	
	Возврат ПредставлениеТопливо
	
КонецФункции

Функция ПолучитьМассивВидовТопливаПоПроекту(Проект) Экспорт
	
	Массив = новый Массив;
	
	Если Проект.ШаблонДляТопливныхОтчетов.Количество() Тогда
		ТЗ = Проект.ШаблонДляТопливныхОтчетов.Выгрузить();
		Массив = ТЗ.ВыгрузитьКолонку("ВидТоплива");
	Иначе
		Массив.Добавить(Справочники.рарусСправочникСсылок.ТопливоСМТ);
		Массив.Добавить(Справочники.рарусСправочникСсылок.ТопливоМТ01);
		Массив.Добавить(Справочники.рарусСправочникСсылок.ТопливоМТ05);
		Массив.Добавить(Справочники.рарусСправочникСсылок.ТопливоМТ15);
		Массив.Добавить(Справочники.рарусСправочникСсылок.МаслоГД);
		Массив.Добавить(Справочники.рарусСправочникСсылок.МаслоДГ);
	КонецЕсли;
	
	Возврат Массив
	
КонецФункции
// -- rarus Камаев П.В. 02.10.2020

Функция ПолучитьТЗТиповыхОперацийиАналитик() Экспорт
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	рарусГруппыТиповыхОперацийИАналитикДляОтчетов.ТиповыеОперации КАК ТиповаяОперация,
	|	рарусГруппыТиповыхОперацийИАналитикДляОтчетов.АналитикиПростоя КАК Аналитика,
	|	рарусГруппыТиповыхОперацийИАналитикДляОтчетов.ВидГруппыТиповыхОперацийИАналитик КАК Группа
	|ИЗ
	|	РегистрСведений.рарусГруппыТиповыхОперацийИАналитикДляОтчетов КАК рарусГруппыТиповыхОперацийИАналитикДляОтчетов";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция УсловиеВыполнено(ТЗТиповыхОперацийиАналитик, Представление, ТиповаяОперация, Аналитика) Экспорт
	
	Попытка
		Группа = Перечисления.рарусВидыГруппТиповыхОперацийИАналитик[Представление];
	Исключение
		Возврат Ложь
	КонецПопытки;
	
	Отбор = новый Структура("Группа, ТиповаяОперация, Аналитика", Группа, ТиповаяОперация, Аналитика);
	НайденныеСтроки = ТЗТиповыхОперацийиАналитик.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() Тогда
		Возврат Истина
	Иначе
		Возврат Ложь
	КонецЕсли;
	
КонецФункции

Функция ПолучитьМассивРеквизитов(ВидОбъекта, НаименованиеОбъекта) Экспорт
	
	МассивМета = новый Массив;
	
	Для каждого Реквизит Из Метаданные[ВидОбъекта][НаименованиеОбъекта].Реквизиты Цикл
		МассивМета.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Возврат МассивМета
			
КонецФункции

Функция ПолучитьКонДатуОформленияДокументов(Дата, Судно) Экспорт
	
	// Строка 01: выгрузка, кон. дата оформления документов предыдущего рейса
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачДата",	НачалоГода(Дата));
	Запрос.УстановитьПараметр("КонДата",	Дата - 1);
	Запрос.УстановитьПараметр("Судно",		Судно);
	Запрос.УстановитьПараметр("Выгрузка",	Справочники.vftТиповыеОперации.Выгрузка);
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рейс.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ПредыдущийРейс
	|ИЗ
	|	Документ.vftРейс КАК Рейс
	|ГДЕ
	|	Рейс.Дата МЕЖДУ &НачДата И &КонДата
	|	И НЕ Рейс.ПометкаУдаления
	|	И Рейс.Судно = &Судно
	|
	|УПОРЯДОЧИТЬ ПО
	|	Рейс.Дата УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РейсПункты.ИД КАК ИД,
	|	РейсПункты.ПричинаСтоянки КАК ПричинаСтоянки
	|ПОМЕСТИТЬ РейсПункты
	|ИЗ
	|	Документ.vftРейс.Пункты КАК РейсПункты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПредыдущийРейс КАК ПредыдущийРейс
	|		ПО РейсПункты.Ссылка = ПредыдущийРейс.Ссылка
	|ГДЕ
	|	РейсПункты.ПричинаСтоянки = &Выгрузка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РейсБаржи.ИД КАК ИД,
	|	РейсБаржи.ДокументыНаБортуКонДата КАК ДокументыНаБортуКонДата
	|ПОМЕСТИТЬ РейсБаржи
	|ИЗ
	|	Документ.vftРейс.Баржи КАК РейсБаржи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПредыдущийРейс КАК ПредыдущийРейс
	|		ПО РейсБаржи.Ссылка = ПредыдущийРейс.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(РейсБаржи.ДокументыНаБортуКонДата) КАК ДокументыНаБортуКонДата
	|ИЗ
	|	РейсБаржи КАК РейсБаржи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РейсПункты КАК РейсПункты
	|		ПО РейсБаржи.ИД = РейсПункты.ИД";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДокументыНаБортуКонДата;
	Иначе
		Возврат Дата(1,1,1);
	КонецЕсли;
	
КонецФункции

#КонецОбласти