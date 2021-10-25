#Область ПроцедурыИФункцииБсп

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена	= Истина;
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса 				= Ложь;
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки	= Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет настроить новый узел распределенной информационной базы.';
									|en = 'Allows you to configure a new node of the distributed infobase.'");
	
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилНаПользовательскомСайте	= "";
	ОписаниеВарианта.ПутьКФайлуКомплектаПравилВКаталогеШаблонов			= "";
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза					= "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	ОписаниеВарианта.ИспользоватьПомощникСозданияОбменаДанными			= Истина;
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена				= ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	ОписаниеВарианта.КраткаяИнформацияПоОбмену							= КраткаяИнформацияПоОбмену;
	
	ОписаниеВарианта.Вставить("ЗаголовокКомандыДляСозданияНовогоОбменаДанными", НСтр("ru = 'Распределенная информационная база';
																					|en = 'Allocated infobase'"));
	ОписаниеВарианта.Вставить("ЗаголовокПомощникаСозданияОбмена",               НСтр("ru = 'Настройка распределенной информационной базы';
																					|en = 'Configure the distributed infobase'"));
	ОписаниеВарианта.Вставить("ЗаголовокУзлаПланаОбмена",                       НСтр("ru = 'Узел распределенной информационной базы';
																					|en = 'Distributed infobase node'"));

КонецПроцедуры

// Определяет несколько вариантов настройки расписания выполнения обмена данными;
// Рекомендуется указывать не более 3 вариантов;
// Эти варианты должны быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  ВариантыНастройки - СписокЗначений - список расписаний обмена данными.
//
Функция ВариантыНастройкиРасписания() Экспорт
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	// Расписание №1
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание1 = Новый РасписаниеРегламентногоЗадания;
	Расписание1.ДниНедели                = ДниНедели;
	Расписание1.ПериодПовтораВТечениеДня = 900; // 15 минут
	Расписание1.ПериодПовтораДней        = 1; // каждый день
	Расписание1.Месяцы                   = Месяцы;
	
	// Расписание №2
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание2 = Новый РасписаниеРегламентногоЗадания;
	Расписание2.ВремяНачала              = Дата('00010101080000');
	Расписание2.ВремяКонца               = Дата('00010101200000');
	Расписание2.ПериодПовтораВТечениеДня = 3600; // каждый час
	Расписание2.ПериодПовтораДней        = 1; // каждый день
	Расписание2.ДниНедели                = ДниНедели;
	Расписание2.Месяцы                   = Месяцы;
	
	// Расписание №3
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	
	Расписание3 = Новый РасписаниеРегламентногоЗадания;
	Расписание3.ДниНедели         = ДниНедели;
	Расписание3.ВремяНачала       = Дата('00010101020000');
	Расписание3.ПериодПовтораДней = 1; // каждый день
	Расписание3.Месяцы            = Месяцы;
	
	// возвращаемое значение функции
	ВариантыНастройки = Новый СписокЗначений;
	
	ВариантыНастройки.Добавить(Расписание1, НСтр("ru = 'Один раз в 15 минут, кроме субботы и воскресенья';
												|en = 'Once in 15 minutes except for Saturday and Sunday'"));
	ВариантыНастройки.Добавить(Расписание2, НСтр("ru = 'Каждый час с 8:00 до 20:00, ежедневно';
												|en = 'Every hour from 8 a.m. to 8 p.m., daily'"));
	ВариантыНастройки.Добавить(Расписание3, НСтр("ru = 'Каждую ночь в 2:00, кроме субботы и воскресенья';
												|en = 'Every night at 2 a.m., except for Saturday and Sunday'"));
	
	Возврат ВариантыНастройки;
	
КонецФункции

#КонецОбласти

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат "Настройки обмена распределенной информационной базы";
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле() Экспорт
	
	СтруктураТабличнойЧастиСуда = Новый Структура;
	СтруктураТабличнойЧастиСуда.Вставить("Судно", Новый Массив);
	
	
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",      НачалоГода(ТекущаяДатаСеанса()));
	СтруктураНастроек.Вставить("ИспользоватьОтборПоСудам",  		 Ложь);
	СтруктураНастроек.Вставить("ПользовательАдминистратор",  		 "Администратор");
	СтруктураНастроек.Вставить("суда",                       СтруктураТабличнойЧастиСуда);
	
	Возврат СтруктураНастроек;
КонецФункции

// Возвращает структуру значений по умолчению для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена
// 
Функция ЗначенияПоУмолчаниюНаУзле() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле) Экспорт
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
	ОграничениеОтборПоСудам = "";
	
	
	// дата начала выгрузки документов
	Если ЗначениеЗаполнено(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов) Тогда
		
		// "Выгружать документы, начиная с 1 января 2009г."
		НСтрока = НСтр("ru = 'Начиная с %1'");
		
		ОграничениеДатаНачалаВыгрузкиДокументов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, Формат(НастройкаОтборовНаУзле.ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
		
	Иначе
		
		ОграничениеДатаНачалаВыгрузкиДокументов = "За весь период ведения учета в программе";
		
	КонецЕсли;
	
	
	
	// отбор по судам
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоСудам Тогда
		
		//СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(НастройкаОтборовНаУзле.Суда.Судно, "; ");
		СтрокаПредставленияОтбора = "";
		
		НСтрока = НСтр("ru = 'Только по Судам: %2'");
		
		ОграничениеОтборПоСудам = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
		
	Иначе
		
		ОграничениеОтборПоСудам = НСтр("ru = 'По всем судам'");
		
	КонецЕсли;
	
	НСтрока = НСтр("ru = 'Выгружать документы и справочную информацию:
		|%1
		|%2'");
			
	//
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(ОграничениеДатаНачалаВыгрузкиДокументов);
	МассивПараметров.Добавить(ОграничениеОтборПоСудам);
	
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(НСтрока, МассивПараметров);
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле) Экспорт
	
	Возврат ".";
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
// Например:
//	Возврат "ПланОбмена.ОбменВРаспределеннойИнформационнойБазе.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
КонецФункции

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, Неогранич - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ДЛЯ РАБОТЫ ОБМЕНА ЧЕРЕЗ ВНЕШНЕЕ СОЕДИНЕНИЕ

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле) Экспорт
	
	Возврат "";
	
КонецФункции

//////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ДЛЯ ОБМЕНА БЕЗ ИСПОЛЬЗОВАНИЯ ПРАВИЛ ОБМЕНА

// Обработчик события коллизий изменений объектов.
// Условие возникновения: 
// Событие возникает при загрузке данных,
// в случае коллизии изменений загружаемого объекта.
// Коллизия изменений возникает, когда в информационной базе 
// зарегистрированы изменения для загружаемого объекта.
//
//  Параметры:
// УзелИнформационнойБазы – ПланОбменаСсылка – узел плана обмена для которого выполняется загрузка данных.
// Объект – объект, для которого возникла коллизия изменений.
//
//  Возвращаемое значение:
// Тип: Булево. Истина – загружаемый объект будет записан в информационную базу;
// Ложь – загружаемый объект записан не будет.
//
Функция ПрименитьОбъектПриКоллизииИзменений(УзелИнформационнойБазы, Объект) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// ++ rarus PleA 12.02.2021
Процедура УдалитьПолучателейНеИспользующихСнабжение1гоПриоритета(Отказ, Объект, ОбъектМетаданных, Получатели, Выгрузка) Экспорт
	
	Если Выгрузка тогда
		Возврат;
	КонецЕсли;
	
	ПолучателиВрем = Новый Массив;
	
	Для Каждого Узел Из Получатели цикл
		
		Если рарусОбщегоНазначенияПовтИсп.ИспользуетсяСудовоеСнабжениеДляУзла(Узел) тогда
			ПолучателиВрем.Добавить(Узел);
		КонецЕсли;	
		
	КонецЦикла;	
	
	Получатели = ПолучателиВрем;
	
КонецПроцедуры
// -- rarus PleA

// ++ rarus ilshil 15.04.2021
Процедура УдалитьПолучателейНеИспользующихДокументациюСУБ(Отказ, Объект, ОбъектМетаданных, Получатели, Выгрузка) Экспорт
	
	Если Выгрузка тогда
		Возврат;
	КонецЕсли;
	
	ПолучателиВрем = Новый Массив;
	
	Для Каждого Узел Из Получатели Цикл
		
		СоответствиеПолучателей = рарусОбщегоНазначенияПовтИсп.ОпределитьПолучателейДокументацииСУБ(Узел);
		
		Если СоответствиеПолучателей.Получить("рарусИспользоватьФункционалСУБ") Тогда
			
			Если Объект.ЭтоГруппа Тогда
				
				ПолучателиВрем.Добавить(Узел);

			Иначе
								
				Для Каждого СтрокаТч Из Объект.Суда Цикл
					
					ДобавитьВМассив = СоответствиеПолучателей.Получить(СтрокаТч.Судно);
					
					Если Не ДобавитьВМассив = Неопределено Тогда
						ПолучателиВрем.Добавить(Узел);
					КонецЕсли;  	
					
				КонецЦикла;
				
			КонецЕсли;
			
		Иначе
			ПолучателиВрем.Добавить(Узел);
		КонецЕсли;
				
	КонецЦикла;
	
	Получатели = ПолучателиВрем;

КонецПроцедуры

Процедура ОпределитьПолучателейДокладаОНесоответствии(Отказ, Объект, ОбъектМетаданных, Получатели, Выгрузка) Экспорт
	
	Если Выгрузка тогда
		Возврат;
	КонецЕсли;
	
	ПолучателиВрем = Новый Массив;
	
	Для Каждого Узел Из Получатели Цикл
		
		Если Не ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() Тогда
			
			СоответствиеПолучателей = рарусОбщегоНазначенияПовтИсп.ОпределитьПолучателейДокументацииСУБ(Узел);
			
			Если Объект.Ссылка = Справочники.vftДокладыОНесоответствии.рарусВременныйДоклад Тогда
				
				ПолучателиВрем.Добавить(Узел);
				
			Иначе
				
				ДобавитьВМассив = СоответствиеПолучателей.Получить(Объект.Судно);
				
				Если Не ДобавитьВМассив = Неопределено Тогда
					ПолучателиВрем.Добавить(Узел);
				КонецЕсли; 
				
			КонецЕсли;
			
		Иначе
			
			//Если Объект.Статус <>  Перечисления.vftСтатусыДокументовСообщений.Черновик Тогда
			//	
			ПолучателиВрем.Добавить(Узел);
			//	
			//КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Получатели = ПолучателиВрем;

КонецПроцедуры

Процедура УдалитьПолучателейНеИсопльзующихСвидетельстваСудов(Отказ, Объект, ОбъектМетаданных, Получатели, Выгрузка) Экспорт

	Если Выгрузка тогда
		Возврат;
	КонецЕсли;
	
	ПолучателиВрем = Новый Массив;
	
	Для Каждого Узел Из Получатели Цикл
		
		Если рарусОбщегоНазначенияПовтИсп.ПроверитьПолучателяПоСудну(Узел, Объект.Владелец) Тогда
			
			 ПолучателиВрем.Добавить(Узел);

		КонецЕсли;
		
	КонецЦикла;
	
	Получатели = ПолучателиВрем;
	
КонецПроцедуры
// -- rarus ilshil 15.04.2021

// ++ rarus PleA 26.03.2021 [номерзадачи]
Процедура ПередОбработкой(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО) Экспорт
			
	Если ИмяПланаОбмена = "Полный" тогда
		
		Если ТипЗнч(Объект) = Тип("ДокументОбъект.рарусУстановкаМинимальногоОстатка")
			ИЛИ ТипЗнч(Объект) = Тип("ДокументСсылка.рарусУстановкаМинимальногоОстатка") тогда
			
			ПередОбработкой_Полный_рарусУстановкаМинимальногоОстатка(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО);										
			
		ИначеЕсли ТипЗнч(Объект) = Тип("РегистрСведенийНаборЗаписей.рарусМинимальныеОстаткиНоменклатуры") тогда
			
			ПередОбработкой_Полный_рарусМинимальныеОстаткиНоменклатуры(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО);										
						
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПослеОбработки(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, Получатели) Экспорт

	Если Выгрузка тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяПланаОбмена = "Полный" тогда
		
		Если ТипЗнч(Объект) = Тип("ДокументОбъект.рарусУстановкаМинимальногоОстатка")
			ИЛИ ТипЗнч(Объект) = Тип("ДокументСсылка.рарусУстановкаМинимальногоОстатка") тогда
			
			ПослеОбработки_Полный_рарусУстановкаМинимальногоОстатка(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, Получатели);										
			
		ИначеЕсли ТипЗнч(Объект) = Тип("РегистрСведенийНаборЗаписей.рарусМинимальныеОстаткиНоменклатуры") тогда
			
			ПослеОбработки_Полный_рарусМинимальныеОстаткиНоменклатуры(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, Получатели);										
						
		КонецЕсли;	
		
	КонецЕсли;	

КонецПроцедуры

Процедура ПередОбработкой_Полный_рарусМинимальныеОстаткиНоменклатуры(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО)
	
	Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры	

Процедура ПередОбработкой_Полный_рарусУстановкаМинимальногоОстатка(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО)
	
	Если ОбменДаннымиСервер.ЭтоПодчиненныйУзелРИБ() тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПослеОбработки_Полный_рарусУстановкаМинимальногоОстатка(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, Получатели)
	
	
	
КонецПроцедуры

Процедура ПослеОбработки_Полный_рарусМинимальныеОстаткиНоменклатуры(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, Получатели)
	
	ХэшСкладСудно 		= Новый Соответствие;
	ИспользуемыеСуда 	= Новый Массив;
	
	Для Каждого Запись Из Объект цикл
		
		Если ХэшСкладСудно.Получить(Запись.Склад) = Неопределено тогда
			
			ХэшСкладСудно.Вставить(Запись.Склад, Запись.Склад.Судно);
			
			ИспользуемыеСуда.Добавить(ХэшСкладСудно.Получить(Запись.Склад));
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	ПолучателиВрем = Новый Массив;
	
	Для Каждого Узел Из Получатели цикл
		
		Для Каждого Судно Из ИспользуемыеСуда цикл
			
			Если рарусОбщегоНазначенияПовтИсп.ПроверитьПолучателяПоСудну(Узел, Судно) тогда
				ПолучателиВрем.Добавить(Узел);
			КонецЕсли;	
		
		КонецЦикла;
		
	КонецЦикла;	
	
	Получатели = ПолучателиВрем;
	
КонецПроцедуры

// -- rarus PleA