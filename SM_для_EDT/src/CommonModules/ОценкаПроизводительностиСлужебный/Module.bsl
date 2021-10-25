///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Получает N худших замеров производительности за период.
// Параметры:
//	ДатаНачала - ДатаВремя - Начало периода выборки.
//	ДатаОкончания - ДатаВремя - Окончание периода выборка.
//	ТопApdexКоличество - Число - Количество худших замеров, если но, то возвращаются все замеры.
//
Функция ПолучитьТопAPDEX(ДатаНачала, ДатаОкончания, ПериодАгрегации, ТопApdexКоличество) Экспорт
	Возврат РегистрыСведений.ЗамерыВремени.ПолучитьТопAPDEX(ДатаНачала, ДатаОкончания, ПериодАгрегации, ТопApdexКоличество);
КонецФункции

// Получает N худших замеров производительности технологической за период.
// Параметры:
//	ДатаНачала - ДатаВремя - Начало периода выборки.
//	ДатаОкончания - ДатаВремя - Окончание периода выборка.
//	ТопApdexКоличество - Число - Количество худших замеров, если но, то возвращаются все замеры.
//
Функция ПолучитьТопAPDEXТехнологический(ДатаНачала, ДатаОкончания, ПериодАгрегации, ТопApdexКоличество) Экспорт
	Возврат РегистрыСведений.ЗамерыВремениТехнологические.ПолучитьТопAPDEX(ДатаНачала, ДатаОкончания, ПериодАгрегации, ТопApdexКоличество);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ОценкаПроизводительностиСлужебный.ПервоначальноеЗаполнение";
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	Обработчики.Вставить("КомментарийЗамераВремени", "ОценкаПроизводительностиСлужебный.УстановкаПараметровСеанса");
	
КонецПроцедуры

// См. ПользователиПереопределяемый.ПриОпределенииНазначенияРолей.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// ТолькоДляПользователейСистемы.
	НазначениеРолей.ТолькоДляПользователейСистемы.Добавить(
		Метаданные.Роли.НастройкаИОценкаПроизводительности.Имя);
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Зависимости) Экспорт
	Зависимость = Зависимости.Добавить();
	Зависимость.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЭкспортОценкиПроизводительности;
	Зависимость.РаботаетСВнешнимиРесурсами = Истина;
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщийМодуль("РаботаВМоделиСервиса");
		Если МодульРаботаВМоделиСервиса.РазделениеВключено() И МодульРаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
		
	КаталогиЭкспорта = КаталогиЭкспортаОценкиПроизводительности();
	Если КаталогиЭкспорта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураURI = ОценкаПроизводительностиКлиентСервер.СтруктураURI(КаталогиЭкспорта.FTPКаталогЭкспорта);
	КаталогиЭкспорта.Вставить("FTPКаталогЭкспорта", СтруктураURI.ИмяСервера);
	Если ЗначениеЗаполнено(СтруктураURI.Порт) Тогда
		КаталогиЭкспорта.Вставить("FTPКаталогЭкспортаПорт", СтруктураURI.Порт);
	КонецЕсли;
    
    БазоваяФункциональностьСуществует = ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность");
	РаботаВБезопасномРежимеСуществует = ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности");
	
	Если БазоваяФункциональностьСуществует И РаботаВБезопасномРежимеСуществует Тогда
		МодульРаботаВБезопасномРежиме = ОбщийМодуль("РаботаВБезопасномРежиме");
		МодульОбщегоНазначения = ОбщийМодуль("ОбщегоНазначения");
		ЗапросыРазрешений.Добавить(
			МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
				РазрешенияНаРесурсыСервера(КаталогиЭкспорта), 
				МодульОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ВыполнятьЗамерыПроизводительности")));
	КонецЕсли;
			
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = Новый Структура("ПериодЗаписи, ВыполнятьЗамерыПроизводительности");
	
	УстановитьПривилегированныйРежим(Истина);
	ТекущийПериод = Константы.ОценкаПроизводительностиПериодЗаписи.Получить();
	ПараметрыРаботыКлиента.ПериодЗаписи = ?(ТекущийПериод >= 1, ТекущийПериод, 60);
	ПараметрыРаботыКлиента.ВыполнятьЗамерыПроизводительности = Константы.ВыполнятьЗамерыПроизводительности.Получить();

	Параметры.Вставить("ОценкаПроизводительности", Новый ФиксированнаяСтруктура(ПараметрыРаботыКлиента));
	
КонецПроцедуры

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	МодульВариантыОтчетов = ОбщийМодуль("ВариантыОтчетов");
	МодульВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОценкаПроизводительности);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	// Инициализация параметров сеанса должна выполняться без обращения к параметрам работы программы.
	
	Если ИмяПараметра = "КомментарийЗамераВремени" Тогда
		ПараметрыСеанса.КомментарийЗамераВремени = ПолучитьКомментарийЗамераВремени();
		УстановленныеПараметры.Добавить("КомментарийЗамераВремени");
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ПервоначальноеЗаполнение() Экспорт
	
	Если ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщийМодуль("РаботаВМоделиСервиса");
		Если МодульРаботаВМоделиСервиса.РазделениеВключено() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Константы.КоличествоЗамеровВПакетеЭкспорта.Установить(1000);
	Константы.ОценкаПроизводительностиПериодЗаписи.Установить(300);
	Константы.ПериодХраненияЗамеров.Установить(100);
		
КонецПроцедуры

// Заполняет параметр сеанса "КомментарийЗамераВремени"
// при запуске программы.
//
Функция ПолучитьКомментарийЗамераВремени()
	
	КомментарийЗамераВремени = Новый Соответствие;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияПриложения = СистемнаяИнформация.ВерсияПриложения;
		
	КомментарийЗамераВремени.Вставить("Платф", ВерсияПриложения);
	КомментарийЗамераВремени.Вставить("Конф", Метаданные.Синоним);
	КомментарийЗамераВремени.Вставить("КонфВер", Метаданные.Версия);
	
	РазделениеДанных = ПользователиИнформационнойБазы.ТекущийПользователь().РазделениеДанных;
	РазделениеДанныхЗначения = Новый Массив;
	Если РазделениеДанных.Количество() <> 0 Тогда
		Для Каждого ТекРазделитель Из РазделениеДанных Цикл
			РазделениеДанныхЗначения.Добавить(ТекРазделитель.Значение);
		КонецЦикла;
	Иначе
		РазделениеДанныхЗначения.Добавить(0);
	КонецЕсли;
	КомментарийЗамераВремени.Вставить("Разд", РазделениеДанныхЗначения);
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(ЗаписьJSON, КомментарийЗамераВремени);
		
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

// Только для внутреннего использования.
Функция ЗапросНаИспользованиеВнешнихРесурсов(Каталоги) Экспорт
	Если ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульРаботаВБезопасномРежиме = ОбщийМодуль("РаботаВБезопасномРежиме");
		МодульОбщегоНазначения = ОбщийМодуль("ОбщегоНазначения");
		Возврат МодульРаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
					РазрешенияНаРесурсыСервера(Каталоги),
					МодульОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ВыполнятьЗамерыПроизводительности"));
	КонецЕсли;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Находит и возвращает регламентное задание экспорта замеров времени.
//
// Возвращаемое значение:
//  РегламентноеЗадание - РегламентноеЗадание.ЭкспортОценкиПроизводительности, найденное задание.
//
Функция РегламентноеЗаданиеЭкспортаОценкиПроизводительности() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(
		Новый Структура("Метаданные", "ЭкспортОценкиПроизводительности"));
	Если Задания.Количество() = 0 Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(
			Метаданные.РегламентныеЗадания.ЭкспортОценкиПроизводительности);
		Задание.Записать();
		Возврат Задание;
	Иначе
		Возврат Задания[0];
	КонецЕсли;
		
КонецФункции

// Возвращает каталоги экспорта файлов с результатами замеров.
//
// Параметры:
//	Нет
//
// Возвращаемое значение:
//    Структура - 
//        "ВыполнятьЭкспортНаFTP"              - Булево - Признак выполнения экспорта на FTP
//        "FTPКаталогЭкспорта"                - Строка - FTP-каталог экспорта
//        "ВыполнятьЭкспортВЛокальныйКаталог" - Булево - Признак выполнения экспорта в локальный каталог
//        "ЛокальныйКаталогЭкспорта"          - Строка - Локальный каталог экспорта.
//
Функция КаталогиЭкспортаОценкиПроизводительности() Экспорт
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Каталоги = Новый Структура;
	Если Задание.Параметры.Количество() > 0 Тогда
		Каталоги = Задание.Параметры[0];
	КонецЕсли;
	
	Если ТипЗнч(Каталоги) <> Тип("Структура") ИЛИ Каталоги.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ВыполнятьЭкспортНаFTP");
	ВозвращаемоеЗначение.Вставить("FTPКаталогЭкспорта");
	ВозвращаемоеЗначение.Вставить("ВыполнятьЭкспортВЛокальныйКаталог");
	ВозвращаемоеЗначение.Вставить("ЛокальныйКаталогЭкспорта");
	
	КлючЗаданияВЭлементы = Новый Структура;
	FTPЭлементы = Новый Массив;
	FTPЭлементы.Добавить("ВыполнятьЭкспортНаFTP");
	FTPЭлементы.Добавить("FTPКаталогЭкспорта");
	
	ЛокальныйЭлементы = Новый Массив;
	ЛокальныйЭлементы.Добавить("ВыполнятьЭкспортВЛокальныйКаталог");
	ЛокальныйЭлементы.Добавить("ЛокальныйКаталогЭкспорта");
	
	КлючЗаданияВЭлементы.Вставить(ОценкаПроизводительностиКлиентСервер.FTPКаталогЭкспортаКлючЗадания(), FTPЭлементы);
	КлючЗаданияВЭлементы.Вставить(ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания(), ЛокальныйЭлементы);
	ВыполнятьЭкспорт = Ложь;
	Для Каждого ИмяКлючаЭлементы Из КлючЗаданияВЭлементы Цикл
		ИмяКлюча = ИмяКлючаЭлементы.Ключ;
		ЭлементыНаРедактирование = ИмяКлючаЭлементы.Значение;
		НомерЭлемента = 0;
		Для Каждого ЭлементИмя Из ЭлементыНаРедактирование Цикл
			Значение = Каталоги[ИмяКлюча][НомерЭлемента];
			ВозвращаемоеЗначение[ЭлементИмя] = Значение;
			Если НомерЭлемента = 0 Тогда 
				ВыполнятьЭкспорт = ВыполнятьЭкспорт ИЛИ Значение;
			КонецЕсли;
			НомерЭлемента = НомерЭлемента + 1;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает ссылку на элемент "Общая производительность",
// Если существует предопределенный элемент "ОбщаяПроизводительностьСистемы", то возвращается этот элемент.
// В противном случае возвращается пустая ссылка.
//
// Параметры:
//	Нет
// Возвращаемое значение:
//	СправочникСсылка.КлючевыеОперации
//
Функция ПолучитьЭлементОбщаяПроизводительностьСистемы() Экспорт
	
	ПредопределенныеКО = Метаданные.Справочники.КлючевыеОперации.ПолучитьИменаПредопределенных();
	ЕстьПредопределенныйЭлемент = ?(ПредопределенныеКО.Найти("ОбщаяПроизводительностьСистемы") <> Неопределено, Истина, Ложь);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлючевыеОперации.Ссылка,
	|	2 КАК Приоритет
	|ИЗ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ГДЕ
	|	КлючевыеОперации.Имя = ""ОбщаяПроизводительностьСистемы""
	|	И НЕ КлючевыеОперации.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗНАЧЕНИЕ(Справочник.КлючевыеОперации.ПустаяСсылка),
	|	3
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Если ЕстьПредопределенныйЭлемент Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КлючевыеОперации.Ссылка,
		|	1 КАК Приоритет
		|ИЗ
		|	Справочник.КлючевыеОперации КАК КлючевыеОперации
		|ГДЕ
		|	КлючевыеОперации.ИмяПредопределенныхДанных = ""ОбщаяПроизводительностьСистемы""
		|	И НЕ КлючевыеОперации.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЗапроса;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("КлючевыеОперации", ПредопределенныеКО);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

// Формирует массив разрешений для экспорта данных замеров.
//
// Параметры - КаталогиЭкспорта - Структура
//
// Возвращаемое значение:
//	Массив - 
Функция РазрешенияНаРесурсыСервера(Каталоги)
	
	Разрешения = Новый Массив;
	
	БазоваяФункциональностьСуществует = ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность");
	Если БазоваяФункциональностьСуществует Тогда
		МодульРаботаВБезопасномРежиме = ОбщийМодуль("РаботаВБезопасномРежиме");
		Если Каталоги <> Неопределено Тогда
			Если Каталоги.Свойство("ВыполнятьЭкспортВЛокальныйКаталог") И Каталоги.ВыполнятьЭкспортВЛокальныйКаталог = Истина Тогда
				Если Каталоги.Свойство("ЛокальныйКаталогЭкспорта") И ЗначениеЗаполнено(Каталоги.ЛокальныйКаталогЭкспорта) Тогда
					Элемент = МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
						Каталоги.ЛокальныйКаталогЭкспорта,
						Истина,
						Истина,
						НСтр("ru = 'Сетевой каталог для экспорта результатов замеров производительности.'"));
					Разрешения.Добавить(Элемент);
				КонецЕсли;
			КонецЕсли;
			
			Если Каталоги.Свойство("ВыполнятьЭкспортНаFTP") И Каталоги.ВыполнятьЭкспортНаFTP = Истина Тогда
				Если Каталоги.Свойство("FTPКаталогЭкспорта") И ЗначениеЗаполнено(Каталоги.FTPКаталогЭкспорта) Тогда
					Элемент = МодульРаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
						"FTP",
						Каталоги.FTPКаталогЭкспорта,
						?(Каталоги.Свойство("FTPКаталогЭкспортаПорт"), Каталоги.FTPКаталогЭкспортаПорт, Неопределено),
						НСтр("ru = 'FTP-ресурс для экспорта результатов замеров производительности.'"));
					Разрешения.Добавить(Элемент);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Разрешения;
КонецФункции

#Область ОбщегоНазначенияКопия

// Возвращает Истина, если "функциональная" подсистема существует в конфигурации.
// Предназначена для реализации вызова необязательной подсистемы (условного вызова).
//
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
// Параметры:
//  ПолноеИмяПодсистемы - Строка - полное имя объекта метаданных подсистема
//                        без слов "Подсистема." и с учетом регистра символов.
//                        Например: "СтандартныеПодсистемы.ВариантыОтчетов".
//
// Пример:
//
//  Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
//  	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
//  	МодульВариантыОтчетов.<Имя метода>();
//  КонецЕсли;
//
// Возвращаемое значение:
//  Булево - 
//
Функция ПодсистемаСуществует(ПолноеИмяПодсистемы) Экспорт
	
	Если ЕстьБазоваяФункциональность() Тогда
		МодульОбщегоНазначения = ВычислитьВБезопасномРежиме("ОбщегоНазначения");
		Возврат МодульОбщегоНазначения.ПодсистемаСуществует(ПолноеИмяПодсистемы);
	Иначе
		ИменаПодсистем = ОценкаПроизводительностиПовтИсп.ИменаПодсистем();
		Возврат ИменаПодсистем.Получить(ПолноеИмяПодсистемы) <> Неопределено;
	КонецЕсли;
	
КонецФункции

// Возвращает общие параметры базовой функциональности.
//
// Возвращаемое значение: 
//  Структура - структура со свойствами:
//      * ИмяФормыПерсональныхНастроек            - Строка - имя формы для редактирования персональных настроек.
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ИмяФормыПерсональныхНастроек.
//      * МинимальноНеобходимаяВерсияПлатформы    - Строка - полный номер версии платформы для запуска программы.
//                                                           Например, "8.3.4.365".
//                                                           Ранее определялись в
//                                                           ОбщегоНазначенияПереопределяемый.ПолучитьМинимальноНеобходимуюВерсиюПлатформы.
//      * РаботаВПрограммеЗапрещена               - Булево - Начальное значение Ложь.
//      * ЗапрашиватьПодтверждениеПриЗавершенииПрограммы - Булево - по умолчанию Истина. Если установить Ложь, то 
//                                                                  подтверждение при завершении работы программы не
//                                                                  будет запрашиваться,  если явно не разрешить в
//                                                                  персональных настройках программы.
//      * ОтключитьИдентификаторыОбъектовМетаданных - Булево - отключает заполнение справочников ИдентификаторыОбъектовМетаданных
//              и ИдентификаторыОбъектовРасширений, процедуру выгрузки и загрузки в узлах РИБ.
//              Для частичного встраивания отдельных функций библиотеки в конфигурации без постановки на поддержку.
//      * ОтключенныеПодсистемы                     - Соответствие - Позволяет виртуально отключать подсистемы для целей
//                                                                  тестирования.
//                                                                  Если подсистема отключена, то метод ОбщегоНазначения.ПодсистемаСуществует
//                                                                  вернет Ложь. В соответствии ключ - имя отключенной подсистемы,
//                                                                  значение необходимо установить в Истина.
//
Функция ОбщиеПараметрыБазовойФункциональности() Экспорт
	
	ОбщиеПараметры = Новый Структура;
	ОбщиеПараметры.Вставить("ОтключенныеПодсистемы", Новый Соответствие);
	
	Возврат ОбщиеПараметры;
	
КонецФункции

Функция ЕстьБазоваяФункциональность()
	
	ЕстьСтандартныеПодсистемы = Метаданные.Подсистемы.Найти("СтандартныеПодсистемы");
	
	Если ЕстьСтандартныеПодсистемы = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Если ЕстьСтандартныеПодсистемы.Подсистемы.Найти("БазоваяФункциональность") = Неопределено Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Пример:
//
//  1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ПолеВРеквизитеФормыОбъект",
//   "Объект");
//
//  Альтернативный вариант использования в форме объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "Объект.ПолеВРеквизитеФормыОбъект");
//
//  2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ИмяРеквизитаФормы");
//
//  3. Для вывода сообщения связанного с объектом информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
//  4. Для вывода сообщения по ссылке на объект информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
//  Случаи некорректного использования:
//   1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//   2. Передача в параметре КлючДанных значения типа отличного от допустимых.
//   3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю( 
	Знач ТекстСообщенияПользователю,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь) Экспорт
	
	ЭтоОбъект = Ложь;
	
	Если КлючДанных <> Неопределено
		И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = СтрНайти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

// Возвращает ссылку на общий модуль по имени.
//
// Параметры:
//  Имя          - Строка - имя общего модуля, например:
//                 "ОбщегоНазначения",
//                 "ОбщегоНазначенияКлиент".
//
// Возвращаемое значение:
//  ОбщийМодуль - .
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Если ЕстьБазоваяФункциональность() Тогда
		МодульОбщегоНазначения = ВычислитьВБезопасномРежиме("ОбщегоНазначения");
		Модуль = МодульОбщегоНазначения.ОбщийМодуль(Имя);
	Иначе
		Если Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено Тогда
			Модуль = ВычислитьВБезопасномРежиме(Имя);
		ИначеЕсли СтрЧислоВхождений(Имя, ".") = 1 Тогда
			Возврат СерверныйМодульМенеджера(Имя);
		Иначе
			Модуль = Неопределено;
		КонецЕсли;
		
		Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
			СообщениеИсключения = НСтр("ru = 'Общий модуль ""%1"" не найден.'");
			ВызватьИсключение СтрЗаменить(СообщениеИсключения, "%1", Имя);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

// Возвращает серверный модуль менеджера по имени объекта.
Функция СерверныйМодульМенеджера(Имя)
	ОбъектНайден = Ложь;
	
	ЧастиИмени = СтрРазделить(Имя, ".");
	Если ЧастиИмени.Количество() = 2 Тогда
		
		ИмяВида = ВРег(ЧастиИмени[0]);
		ИмяОбъекта = ЧастиИмени[1];
		
		Если ИмяВида = ВРег(ИмяТипаКонстанты()) Тогда
			Если Метаданные.Константы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыСведений()) Тогда
			Если Метаданные.РегистрыСведений.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыНакопления()) Тогда
			Если Метаданные.РегистрыНакопления.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыБухгалтерии()) Тогда
			Если Метаданные.РегистрыБухгалтерии.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаРегистрыРасчета()) Тогда
			Если Метаданные.РегистрыРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаСправочники()) Тогда
			Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаДокументы()) Тогда
			Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаОтчеты()) Тогда
			Если Метаданные.Отчеты.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаОбработки()) Тогда
			Если Метаданные.Обработки.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаБизнесПроцессы()) Тогда
			Если Метаданные.БизнесПроцессы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаЖурналыДокументов()) Тогда
			Если Метаданные.ЖурналыДокументов.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаЗадачи()) Тогда
			Если Метаданные.Задачи.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыСчетов()) Тогда
			Если Метаданные.ПланыСчетов.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыОбмена()) Тогда
			Если Метаданные.ПланыОбмена.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыВидовХарактеристик()) Тогда
			Если Метаданные.ПланыВидовХарактеристик.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег(ИмяТипаПланыВидовРасчета()) Тогда
			Если Метаданные.ПланыВидовРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОбъектНайден Тогда
		СообщениеИсключения = НСтр("ru = 'Объект метаданных ""%1"" не найден,
			|либо для него не поддерживается получение модуля менеджера.'");
		ВызватьИсключение СтрЗаменить(СообщениеИсключения, "%1", Имя);
	КонецЕсли;
	
	Модуль = ВычислитьВБезопасномРежиме(Имя);
	
	Возврат Модуль;
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры сведений".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаРегистрыСведений()
	
	Возврат "РегистрыСведений";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры накопления".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаРегистрыНакопления()
	
	Возврат "РегистрыНакопления";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры бухгалтерии".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаРегистрыБухгалтерии()
	
	Возврат "РегистрыБухгалтерии";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Регистры расчета".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаРегистрыРасчета()
	
	Возврат "РегистрыРасчета";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Документы".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаДокументы()
	
	Возврат "Документы";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Справочники".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаСправочники()
	
	Возврат "Справочники";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Отчеты".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаОтчеты()
	
	Возврат "Отчеты";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Обработки".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаОбработки()
	
	Возврат "Обработки";
	
КонецФункции

// Возвращает значение для идентификации общего типа "ПланыОбмена".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаПланыОбмена()
	
	Возврат "ПланыОбмена";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Планы видов характеристик".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаПланыВидовХарактеристик()
	
	Возврат "ПланыВидовХарактеристик";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Бизнес-процессы".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаБизнесПроцессы()
	
	Возврат "БизнесПроцессы";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Задачи".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаЗадачи()
	
	Возврат "Задачи";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Планы счетов".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаПланыСчетов()
	
	Возврат "ПланыСчетов";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Планы видов расчета".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаПланыВидовРасчета()
	
	Возврат "ПланыВидовРасчета";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Константы".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаКонстанты()
	
	Возврат "Константы";
	
КонецФункции

// Возвращает значение для идентификации общего типа "Журналы документов".
//
// Возвращаемое значение:
//  Строка - .
//
Функция ИмяТипаЖурналыДокументов()
	
	Возврат "ЖурналыДокументов";
	
КонецФункции

Функция КодОсновногоЯзыка() Экспорт
	Если ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность") Тогда
		МодульОбщегоНазначения = ОбщийМодуль("ОбщегоНазначения");
		Возврат МодульОбщегоНазначения.КодОсновногоЯзыка();
	КонецЕсли;	
	Возврат Метаданные.ОсновнойЯзык.КодЯзыка;
КонецФункции

#КонецОбласти

#Область РаботаВБезопасномРежимеКопия

// Вычисляет переданное выражение, предварительно устанавливая безопасный режим выполнения кода
//  и безопасный режим разделения данных для всех разделителей, присутствующих в составе конфигурации.
//  В результате при вычислении выражения:
//   - игнорируются попытки установки привилегированного режима,
//   - запрещаются все внешние (по отношению к платформе 1С:Предприятие) действия (COM,
//       загрузка внешних компонент, запуск внешних приложений и команд операционной системы,
//       доступ к файловой системе и Интернет-ресурсам),
//   - запрещается отключение использования разделителей сеанса,
//   - запрещается изменение значений разделителей сеанса (если разделение данным разделителем не
//       является условно выключенным),
//   - запрещается изменение объектов, которые управляют состоянием условного разделения.
//
// Параметры:
//  Выражение - Строка - выражение, которое требуется вычислить. Например, "МойМодуль.МояФункция(Параметры)".
//  Параметры - Произвольный - в качестве значения данного параметра может быть передано значение,
//    которое требуется для вычисления выражения (при этом в тексте выражения обращение к данному
//    значению должно осуществляться как к имени переменной Параметры).
//
// Возвращаемое значение: 
//   Произвольный - результат вычисления выражения.
//
Функция ВычислитьВБезопасномРежиме(Знач Выражение, Знач Параметры = Неопределено)
	
	УстановитьБезопасныйРежим(Истина);
	
	МассивРазделителей = ОценкаПроизводительностиПовтИсп.РазделителиКонфигурации();
	
	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		
	КонецЦикла;
	
	Возврат Вычислить(Выражение);
	
КонецФункции

#КонецОбласти

#КонецОбласти
