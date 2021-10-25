
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать


Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, 
//												представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если  ПолучитьФункциональнуюОпцию("рарусИспользоватьФункционалСУБ") Тогда
		Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДокладОСостоянииБезопасности") Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ДокладОСостоянииБезопасности", НСтр("ru = 'ДокладОСостоянииБезопасности'"),
			ПечатнаяФормаДокладОСостоянииБезопасности(МассивОбъектов, ОбъектыПечати), ,
			"ПФ_MXL_ДокладОСостоянииБезопасностиСУБ");
		КонецЕсли;		
	Иначе
		Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ДокладОСостоянииБезопасности") Тогда
			УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ДокладОСостоянииБезопасности", НСтр("ru = 'ДокладОСостоянииБезопасности'"),
			ПечатьСообщения(МассивОбъектов, ОбъектыПечати), ,
			"ПФ_MXL_ДокладОСостоянииБезопасности");
		КонецЕсли;
			
	КонецЕсли;
		
КонецПроцедуры

Функция ПечатьСообщения(МассивОбъектов, ОбъектыПечати,ВставлятьРазрывВКонцеМакета = Истина) Экспорт
				
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.vftДокладОСостоянииБезопасности.ПФ_MXL_ДокладОСостоянииБезопасности");
		
	ОбластьШапка 				= Макет.ПолучитьОбласть("Шапка");		
	ОбластьШапкаТревоги 		= Макет.ПолучитьОбласть("ШапкаТревоги");
	ОбластьСтрокаТревоги 		= Макет.ПолучитьОбласть("СтрокаТревоги");
	ОбластьШапкаПредложения 	= Макет.ПолучитьОбласть("ШапкаПредложения");
	ОбластьСтрокаПредложения 	= Макет.ПолучитьОбласть("СтрокаПредложения");
	ОбластьШапкаРешения 		= Макет.ПолучитьОбласть("ШапкаРешения");
	ОбластьСтрокаРешения 		= Макет.ПолучитьОбласть("СтрокаРешения");
	ОбластьПодвал 				= Макет.ПолучитьОбласть("Подвал");
		
	
	ДокументыСообщения = vftОбщиеПроцедурыДокументовСервер.ПолучитьРеквизитыДокладОСостоянииБезопасности(МассивОбъектов);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ПолеСлева = 5;
	ТабличныйДокумент.ПолеСправа = 5;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;

	Для каждого Документ из ДокументыСообщения Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.Заполнить(Документ.Шапка);
		
		//ОбластьШапка.параметры.ТССУД 								= ?(Документ.Шапка.ТехническоеСостояниеСудна = Перечисления.vftТехническоеСостояние.Удовлетворительно,"X"," ");
		//ОбластьШапка.параметры.ТССНеуд 								= ?(Документ.Шапка.ТехническоеСостояниеСудна = Перечисления.vftТехническоеСостояние.Удовлетворительно," ","Х");
		ОбластьШапка.параметры.НСДа 								= ?(Документ.Шапка.НесчастныеСлучаи,"Х"," ");
		ОбластьШапка.параметры.НСНет 								= ?(Документ.Шапка.НесчастныеСлучаи," ","Х");
		ОбластьШапка.параметры.ФЗДа 								= ?(Документ.Шапка.ФактыЗагрязнений,"Х"," ");
		ОбластьШапка.параметры.ФЗНет 								= ?(Документ.Шапка.ФактыЗагрязнений," ","Х");
		ОбластьШапка.параметры.САСДа 								= ?(Документ.Шапка.СрокиАвтономностиСоблюдаются,"Х"," ");
		ОбластьШапка.параметры.САСНет 								= ?(Документ.Шапка.СрокиАвтономностиСоблюдаются," ","Х");
		//ОбластьШапка.параметры.СПОУД 								= ?(Документ.Шапка.СостояниеПротивопожарногоОборудования = Перечисления.vftТехническоеСостояние.Удовлетворительно,"X"," ");
		//ОбластьШапка.параметры.СПОНеуд 								= ?(Документ.Шапка.СостояниеПротивопожарногоОборудования = Перечисления.vftТехническоеСостояние.Удовлетворительно," ","Х");
		ОбластьШапка.параметры.АЕПДа 								= ?(Документ.Шапка.АнализЕженедельныхПроверокПроведен,"Х"," ");
		ОбластьШапка.параметры.АЕПНет 								= ?(Документ.Шапка.АнализЕженедельныхПроверокПроведен," ","Х");
		ОбластьШапка.параметры.ЭДа 								= ?(Документ.Шапка.ЭкипахОзнакомленСРезультатамиИнспекций,"Х"," ");
		ОбластьШапка.параметры.ЭНет 								= ?(Документ.Шапка.ЭкипахОзнакомленСРезультатамиИнспекций," ","Х");
								
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТревоги);
		Для Каждого Тревога из Документ.Тревоги Цикл
			ОбластьСтрокаТревоги.Параметры.Заполнить(Тревога);
			ТабличныйДокумент.Вывести(ОбластьСтрокаТревоги); 			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьШапкаПредложения);
		Для Каждого Предложение из Документ.Предложения Цикл
			ОбластьСтрокаПредложения.Параметры.Заполнить(Предложение);
			ТабличныйДокумент.Вывести(ОбластьСтрокаПредложения); 			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьШапкаРешения);
		Для Каждого Предложение из Документ.Решения Цикл
			ОбластьСтрокаРешения.Параметры.Заполнить(Предложение);
			ТабличныйДокумент.Вывести(ОбластьСтрокаРешения); 			
		КонецЦикла;
			
		ОбластьПодвал.Параметры.Заполнить(Документ.Шапка);
		ОбластьПодвал.параметры.РДа 							= ?(Документ.Шапка.РешенияПриняты,"Х"," ");
		ОбластьПодвал.параметры.РНет 							= ?(Документ.Шапка.РешенияПриняты," ","Х");
		
		ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		Если ВставлятьРазрывВКонцеМакета Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Документ.Шапка.Ссылка);	
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатнаяФормаДокладОСостоянииБезопасности(МассивОбъектов, ОбъектыПечати, ВставлятьРазрывВКонцеМакета = Истина) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.vftДокладОСостоянииБезопасности.ПФ_MXL_ДокладОСостоянииБезопасностиСУБ");
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ПолеСлева = 5;
	ТабличныйДокумент.ПолеСправа = 5;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	Для Каждого Документ Из МассивОбъектов Цикл
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ДанныеДляПечатнойФормы = ПолучитьДанныеПечатнойФормы(Документ);	
		
		ШапкаДокумента          = Макет.ПолучитьОбласть("Шапка");	
		СтрокаДолжностей        = Макет.ПолучитьОбласть("ШапкаСтрока|СтрокаСоставТЧ");
		СтрокаДолжностейПустая  = Макет.ПолучитьОбласть("ШапкаСтрока|СтрокаСуставПустая");
		Тело                    = Макет.ПолучитьОбласть("Тело");
		ШапкаТревоги            = Макет.ПолучитьОбласть("ШапкаТревоги");
		СтрокаТревоги           = Макет.ПолучитьОбласть("СтрокаТревоги");
		ШапкаПредложения        = Макет.ПолучитьОбласть("ШапкаПредложения");
		СтрокаПредложения       = Макет.ПолучитьОбласть("СтрокаПредложения");
		ШапкаРешения            = Макет.ПолучитьОбласть("ШапкаРешения");
		СтрокаРешения           = Макет.ПолучитьОбласть("СтрокаРешения");
		Подвал                  = Макет.ПолучитьОбласть("Подвал");
		
		РезультатПоШапке = ДанныеДляПечатнойФормы.РезультатПоШапке.Выгрузить();
		
		СоставСудовогоКомитета =  ДанныеДляПечатнойФормы.РезультатПоСоставуСудовогоКомитета.Выгрузить();
		
		
		//
		СтруктураШапки = Новый Структура;
		СтруктураШапки.Вставить("Судно",       РезультатПоШапке[0].Судно);  
		СтруктураШапки.Вставить("Дата",        РезультатПоШапке[0].Дата); 
		СтруктураШапки.Вставить("МесяцОбзора", РезультатПоШапке[0].МесяцОбзора); 
		
		СтруктураШапки.Вставить("ВиднесчастныхСлучаев",РезультатПоШапке[0].ВиднесчастныхСлучаев);
		СтруктураШапки.Вставить("ТехническоеСостояниеСудна", РезультатПоШапке[0].ТехническоеСостояниеСудна);
		СтруктураШапки.Вставить("КоличествоАктовОПовреждении", РезультатПоШапке[0].КоличествоАктовОПовреждении);
		СтруктураШапки.Вставить("КоличествоАктовРекламационных", РезультатПоШапке[0].КоличествоАктовРекламационных);
		СтруктураШапки.Вставить("ТранспортныеПроисшествия", РезультатПоШапке[0].ТранспортныеПроисшествия);
		СтруктураШапки.Вставить("НСДа",   ?(РезультатПоШапке[0].НесчастныеСлучаи,"Х"," "));
		СтруктураШапки.Вставить("НСНет",  ?(РезультатПоШапке[0].НесчастныеСлучаи," ","Х"));
		СтруктураШапки.Вставить("ФЗДа",   ?(РезультатПоШапке[0].ФактыЗагрязнений,"Х"," "));
		СтруктураШапки.Вставить("ФЗНет",  ?(РезультатПоШапке[0].ФактыЗагрязнений," ","Х"));
		СтруктураШапки.Вставить("КомментарийФактыЗагрязнения", РезультатПоШапке[0].КомментарийФактыЗагрязнения);
		СтруктураШапки.Вставить("САСДа",  ?(РезультатПоШапке[0].СрокиАвтономностиСоблюдаются,"Х"," "));
		СтруктураШапки.Вставить("САСНет", ?(РезультатПоШапке[0].СрокиАвтономностиСоблюдаются," ","Х"));
		СтруктураШапки.Вставить("АЕПДа",  ?(РезультатПоШапке[0].АнализЕженедельныхПроверокПроведен,"Х"," "));
		СтруктураШапки.Вставить("АЕПНет", ?(РезультатПоШапке[0].АнализЕженедельныхПроверокПроведен," ","Х"));
		СтруктураШапки.Вставить("КомментарийАнализПроверок", РезультатПоШапке[0].КомментарийАнализПроверок);
		СтруктураШапки.Вставить("КоличествоНесоответствий", РезультатПоШапке[0].КоличествоНесоответствий);
		СтруктураШапки.Вставить("АудитПроверкиСУБ", РезультатПоШапке[0].АудитПроверкиСУБ);
		СтруктураШапки.Вставить("АудитТехСостояния", РезультатПоШапке[0].АудитТехСостояния);
		СтруктураШапки.Вставить("ПроверокPSC", РезультатПоШапке[0].ПроверокPSC);
		СтруктураШапки.Вставить("ПроверокFSC", РезультатПоШапке[0].ПроверокFSC);
		СтруктураШапки.Вставить("ПроверокГПКнаВВП", РезультатПоШапке[0].ПроверокГПКнаВВП);
		СтруктураШапки.Вставить("ЭДа", ?(РезультатПоШапке[0].ЭкипахОзнакомленСРезультатамиИнспекций,"Х"," "));
		СтруктураШапки.Вставить("ЭНет",?(РезультатПоШапке[0].ЭкипахОзнакомленСРезультатамиИнспекций," ","Х"));
		СтруктураШапки.Вставить("СообщенийОПотенциальномИнциденте", РезультатПоШапке[0].СообщенийОПотенциальномИнциденте);
		
		ШапкаДокумента.Параметры.Заполнить(СтруктураШапки);
		ТабличныйДокумент.Вывести(ШапкаДокумента);
		
		Шаг = 0;
		НомСт = 0; 
		Для Каждого СтрокаТч Из СоставСудовогоКомитета Цикл
				
			НомСт = НомСт + 1; 
			СоствавСудовогоКомитета = Новый Структура;	
			СоствавСудовогоКомитета.Вставить("Ном", НомСт);
			СоствавСудовогоКомитета.Вставить("Должность", СтрокаТч.Роль);
			СоствавСудовогоКомитета.Вставить("Фио",     СтрокаТч.ФиоЧленаКомитета);
			
			Если Шаг = 0 Тогда
				СтрокаДолжностей.Параметры.Заполнить(СоствавСудовогоКомитета);
				ТабличныйДокумент.Вывести(СтрокаДолжностей);
				Шаг = Шаг + 1;
				
				Если СтрокаТч.НомерСтроки = СоставСудовогоКомитета.Количество()Тогда		
					ТабличныйДокумент.Присоединить(СтрокаДолжностейПустая);	
				КонецЕсли;
			
				Продолжить;
			КонецЕсли;
			
			Если Шаг = 1 Тогда
				СтрокаДолжностей.Параметры.Ном = НомСт;
				СтрокаДолжностей.Параметры.Должность = СтрокаТч.Роль;
				СтрокаДолжностей.Параметры.Фио = СтрокаТч.ФиоЧленаКомитета;
				ТабличныйДокумент.Присоединить(СтрокаДолжностей);			
				Шаг = 0;
								
			КонецЕсли
			
		КонецЦикла;                     
					
		Тело.Параметры.Заполнить(СтруктураШапки);
		ТабличныйДокумент.Вывести(Тело);
		
		ТабличныйДокумент.Вывести(ШапкаТревоги);	
		Тревоги = ДанныеДляПечатнойФормы.РезультатПоПроведеннымТревогам.Выгрузить();
		
		Для Каждого Строка Из Тревоги Цикл
			
			СтруктураСтрокиТревоги = Новый Структура;
			СтруктураСтрокиТревоги.Вставить("Дата", Строка.Дата);
			СтруктураСтрокиТревоги.Вставить("НазваниеТревоги", Строка.НазваниеТревоги);
			СтрокаТревоги.Параметры.Заполнить(СтруктураСтрокиТревоги);
			ТабличныйДокумент.Вывести(СтрокаТревоги);
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ШапкаПредложения);
		Предложения = ДанныеДляПечатнойФормы.РезультатПоПредоложениямПоКорректуре.Выгрузить();
		
		Для Каждого Строка Из Предложения Цикл 
			
			СтруктураСтрокиПредложение = Новый Структура;
			СтруктураСтрокиПредложение.Вставить("Предложение", Строка.Предложение);
			СтрокаПредложения.Параметры.Заполнить(СтруктураСтрокиПредложение);
			ТабличныйДокумент.Вывести(СтрокаПредложения);
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ШапкаРешения);
		Решения = ДанныеДляПечатнойФормы.РезультатПоПринятымРешениям.Выгрузить();
		
		Для Каждого Строка Из Решения Цикл 
			
			СтруктураСтрокиРешения = Новый Структура;
			СтруктураСтрокиРешения.Вставить("Дата", Строка.Дата);
			СтруктураСтрокиРешения.Вставить("ТемаСобрания", Строка.ТемаСобрания);
			СтруктураСтрокиРешения.Вставить("ДатаИсполнения", Строка.ДатаИсполнения);
			СтруктураСтрокиРешения.Вставить("ОтветственныйЗаИсполнение", Строка.ОтветственныйЗаИсполнение);
			СтрокаРешения.Параметры.Заполнить(СтруктураСтрокиРешения);
			ТабличныйДокумент.Вывести(СтрокаРешения);
			
		КонецЦикла;
		
		СтруктураПодвал = Новый Структура;
		СтруктураПодвал.Вставить("РДА",?(РезультатПоШапке[0].РешенияПриняты,"Х"," "));
		СтруктураПодвал.Вставить("РНЕТ",?(РезультатПоШапке[0].РешенияПриняты," ","Х"));
		СтруктураПодвал.Вставить("КомментарийРешения",РезультатПоШапке[0].КомментарийРешения);
		СтруктураПодвал.Вставить("Примечание", РезультатПоШапке[0].Примечание);
		СтруктураПодвал.Вставить("ОтветКомпании", РезультатПоШапке[0].ОтветКомпании);
		
		Подвал.Параметры.Заполнить(СтруктураПодвал);
		ТабличныйДокумент.Вывести(Подвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Документ);	
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьДанныеПечатнойФормы(МассивОбъектов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	vftДокладОСостоянииБезопасности.Ссылка КАК Ссылка,
	|	vftДокладОСостоянииБезопасности.ВерсияДанных КАК ВерсияДанных,
	|	vftДокладОСостоянииБезопасности.ПометкаУдаления КАК ПометкаУдаления,
	|	vftДокладОСостоянииБезопасности.Номер КАК Номер,
	|	vftДокладОСостоянииБезопасности.Дата КАК Дата,
	|	vftДокладОСостоянииБезопасности.Проведен КАК Проведен,
	|	vftДокладОСостоянииБезопасности.Статус КАК Статус,
	|	vftДокладОСостоянииБезопасности.ФиоКапитана КАК Капитан,
	|	vftДокладОСостоянииБезопасности.Судно КАК Судно,
	|	vftДокладОСостоянииБезопасности.ОтветКомпании КАК ОтветКомпании,
	|	vftДокладОСостоянииБезопасности.Ответственный КАК Ответственный,
	|	vftДокладОСостоянииБезопасности.ПериодОбзораС КАК ПериодОбзораС,
	|	vftДокладОСостоянииБезопасности.ПериодОбзораПо КАК ПериодОбзораПо,
	|	vftДокладОСостоянииБезопасности.ТехническоеСостояниеСудна КАК ТехническоеСостояниеСудна,
	|	vftДокладОСостоянииБезопасности.КоличествоАктовОПовреждении КАК КоличествоАктовОПовреждении,
	|	vftДокладОСостоянииБезопасности.КоличествоАктовРекламационных КАК КоличествоАктовРекламационных,
	|	vftДокладОСостоянииБезопасности.ТранспортныеПроисшествия КАК ТранспортныеПроисшествия,
	|	vftДокладОСостоянииБезопасности.НесчастныеСлучаи КАК НесчастныеСлучаи,
	|	vftДокладОСостоянииБезопасности.ВиднесчастныхСлучаев КАК ВиднесчастныхСлучаев,
	|	vftДокладОСостоянииБезопасности.ФактыЗагрязнений КАК ФактыЗагрязнений,
	|	vftДокладОСостоянииБезопасности.СрокиАвтономностиСоблюдаются КАК СрокиАвтономностиСоблюдаются,
	|	vftДокладОСостоянииБезопасности.СостояниеПротивопожарногоОборудования КАК СостояниеПротивопожарногоОборудования,
	|	vftДокладОСостоянииБезопасности.АнализЕженедельныхПроверокПроведен КАК АнализЕженедельныхПроверокПроведен,
	|	vftДокладОСостоянииБезопасности.КоличествоНесоответствий КАК КоличествоНесоответствий,
	|	vftДокладОСостоянииБезопасности.АудитПроверкиСУБ КАК АудитПроверкиСУБ,
	|	vftДокладОСостоянииБезопасности.АудитТехСостояния КАК АудитТехСостояния,
	|	vftДокладОСостоянииБезопасности.ОсвидетельствованийРС КАК ОсвидетельствованийРС,
	|	vftДокладОСостоянииБезопасности.ПроверокPSC КАК ПроверокPSC,
	|	vftДокладОСостоянииБезопасности.ПроверокFSC КАК ПроверокFSC,
	|	vftДокладОСостоянииБезопасности.ПроверокГПКнаВВП КАК ПроверокГПКнаВВП,
	|	vftДокладОСостоянииБезопасности.ЭкипахОзнакомленСРезультатамиИнспекций КАК ЭкипахОзнакомленСРезультатамиИнспекций,
	|	vftДокладОСостоянииБезопасности.СообщенийОПотенциальномИнциденте КАК СообщенийОПотенциальномИнциденте,
	|	vftДокладОСостоянииБезопасности.Примечание КАК Примечание,
	|	vftДокладОСостоянииБезопасности.РешенияПриняты КАК РешенияПриняты,
	|	vftДокладОСостоянииБезопасности.КомментарийАнализПроверок КАК КомментарийАнализПроверок,
	|	vftДокладОСостоянииБезопасности.КомментарийФактыЗагрязнения КАК КомментарийФактыЗагрязнения,
	|	vftДокладОСостоянииБезопасности.КомментарийСрокиАвтономности КАК КомментарийСрокиАвтономности,
	|	vftДокладОСостоянииБезопасности.КомментарийРешения КАК КомментарийРешения,
	|	vftДокладОСостоянииБезопасности.МесяцОбзора КАК МесяцОбзора,
	|	vftДокладОСостоянииБезопасности.Периодичность КАК Периодичность,
	|	vftДокладОСостоянииБезопасности.Представление КАК Представление,
	|	vftДокладОСостоянииБезопасности.МоментВремени КАК МоментВремени
	|ИЗ
	|	Документ.vftДокладОСостоянииБезопасности КАК vftДокладОСостоянииБезопасности
	|ГДЕ
	|	vftДокладОСостоянииБезопасности.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПроведенныеТревоги.Ссылка КАК Ссылка,
	|	ПроведенныеТревоги.НомерСтроки КАК НомерСтроки,
	|	ПроведенныеТревоги.Дата КАК Дата,
	|	ПроведенныеТревоги.НазваниеТревоги КАК НазваниеТревоги
	|ИЗ
	|	Документ.vftДокладОСостоянииБезопасности.ПроведенныеТревоги КАК ПроведенныеТревоги
	|ГДЕ
	|	ПроведенныеТревоги.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПредоложенияПоКорректуреСудовойСУБ.Ссылка КАК Ссылка,
	|	ПредоложенияПоКорректуреСудовойСУБ.НомерСтроки КАК НомерСтроки,
	|	ПредоложенияПоКорректуреСудовойСУБ.Предложение КАК Предложение,
	|	ПредоложенияПоКорректуреСудовойСУБ.ОтветКомании КАК ОтветКомании,
	|	ПредоложенияПоКорректуреСудовойСУБ.Ответственный КАК Ответственный
	|ИЗ
	|	Документ.vftДокладОСостоянииБезопасности.ПредоложенияПоКорректуреСудовойСУБ КАК ПредоложенияПоКорректуреСудовойСУБ
	|ГДЕ
	|	ПредоложенияПоКорректуреСудовойСУБ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПринятыеРешения.Ссылка КАК Ссылка,
	|	ПринятыеРешения.НомерСтроки КАК НомерСтроки,
	|	ПринятыеРешения.Дата КАК Дата,
	|	ПринятыеРешения.ТемаСобрания КАК ТемаСобрания,
	|	ПринятыеРешения.ДатаИсполнения КАК ДатаИсполнения,
	|	ПринятыеРешения.ОтветственныйЗаИсполнение КАК ОтветственныйЗаИсполнение
	|ИЗ
	|	Документ.vftДокладОСостоянииБезопасности.ПринятыеРешения КАК ПринятыеРешения
	|ГДЕ
	|	ПринятыеРешения.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоставСудовогоКомитета.Ссылка КАК Ссылка,
	|	СоставСудовогоКомитета.НомерСтроки КАК НомерСтроки,
	|	СоставСудовогоКомитета.Роль КАК Роль,
	|	СоставСудовогоКомитета.ФиоЧленаКомитета КАК ФиоЧленаКомитета
	|ИЗ
	|	Документ.vftДокладОСостоянииБезопасности.СоставСудовогоКомитета КАК СоставСудовогоКомитета
	|ГДЕ
	|	СоставСудовогоКомитета.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",МассивОбъектов);
	
	
	ПакетРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	СтруктураДанныхДляПечати = Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", ПакетРезультатовЗапроса[0]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоПроведеннымТревогам", ПакетРезультатовЗапроса[1]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоПредоложениямПоКорректуре", ПакетРезультатовЗапроса[2]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоПринятымРешениям", ПакетРезультатовЗапроса[3]);
	СтруктураДанныхДляПечати.Вставить("РезультатПоСоставуСудовогоКомитета", ПакетРезультатовЗапроса[4]);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

#КонецОбласти

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ФИОКапитана");
	Результат.Добавить("Судно");
	Результат.Добавить("Дата");	
	Результат.Добавить("ОтветКомпании");
	Результат.Добавить("Ответственный");
	Результат.Добавить("ПериодОбзораС");
	Результат.Добавить("ПериодОбзораПо");
	Результат.Добавить("Председатель");
	Результат.Добавить("ОфицерПоБезопасности");
	Результат.Добавить("СПКМ");
	Результат.Добавить("СМХ");
	Результат.Добавить("ПредставительМоряков");
	Результат.Добавить("ПредставительРядовогоСостава");
	Результат.Добавить("ТехническоеСостояниеСудна");
	Результат.Добавить("КоличествоАктовОПовреждении");
	Результат.Добавить("КоличествоАктовРекламационных");
	Результат.Добавить("ТранспортныеПроисшествия");
	Результат.Добавить("НесчастныеСлучаи");
	Результат.Добавить("ВиднесчастныхСлучаев");
	Результат.Добавить("ФактыЗагрязнений");
	Результат.Добавить("СрокиАвтономностиСоблюдаются");
	Результат.Добавить("СостояниеПротивопожарногоОборудования");
	Результат.Добавить("АнализЕженедельныхПроверокПроведен");
	Результат.Добавить("КоличествоНесоответствий");
	Результат.Добавить("АудитПроверкиСУБ");
	Результат.Добавить("АудитТехСостояния");
	Результат.Добавить("ОсвидетельствованийРС");
	Результат.Добавить("ПроверокPSC");
	Результат.Добавить("ПроверокFSC");
	Результат.Добавить("ПроверокГПКнаВВП");
	Результат.Добавить("ЭкипахОзнакомленСРезультатамиИнспекций");
	Результат.Добавить("СообщенийОПотенциальномИнциденте");
	Результат.Добавить("Примечание");
	Результат.Добавить("ФИОКапитана");
	Результат.Добавить("РешенияПриняты");
	Результат.Добавить("КомментарийАнализПроверок");
	Результат.Добавить("КомментарийФактыЗагрязнения");
	Результат.Добавить("КомментарийСрокиАвтономности");
	Результат.Добавить("КомментарийРешения");
	Результат.Добавить("МесяцОбзора");
	Результат.Добавить("СоставСудовогоКомитета; 
	|СоставСудовогоКомитетаДобавить, 
	|СоставСудовогоКомитетаУдалить,
	|СоставСудовогоКомитетаЗаполнитьПоШаблону");
	Результат.Добавить("ПроведенныеТревоги; ПроведенныеТревогиДобавить,ПроведенныеТревогиУдалить");
	Результат.Добавить("ПредоложенияПоКорректуреСудовойСУБ; 
	|ПредоложенияПоКорректуреСудовойСУБДобавить,
	|ПредоложенияПоКорректуреСудовойСУБУдалить,
	|Предложение,
	|ОтветКомпанииНаПредложение");
	Результат.Добавить("Предложение");
	Результат.Добавить("ПринятыеРешения; ПринятыеРешенияДобавить, ПринятыеРешенияУдалить");
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИспользоватьФункционалСУБ = ПолучитьФункциональнуюОпцию("рарусИспользоватьФункционалСУБ");
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		Если ИспользоватьФункционалСУБ Тогда 
			
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаДокументаСУБ";		
			
		КонецЕсли;
		
	ИначеЕсли ВидФормы = "ФормаСписка" Тогда
		
		Если ИспользоватьФункционалСУБ Тогда 
			
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаСпискаСУБ";
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПодготовитьСтруктуруДанныхДляЗаполненияДокумента(Судно, НачалоПериода, КонецПериода) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КОЛИЧЕСТВО(vftСообщениеОПотенциальномИнциденте.Ссылка) КАК КоличествоСообщений
	|ПОМЕСТИТЬ втСообщенияОбИнциденте
	|ИЗ
	|	Документ.vftСообщениеОПотенциальномИнциденте КАК vftСообщениеОПотенциальномИнциденте
	|ГДЕ
	|	vftСообщениеОПотенциальномИнциденте.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И vftСообщениеОПотенциальномИнциденте.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И vftСообщениеОПотенциальномИнциденте.Судно = &Судно
	|	И НЕ vftСообщениеОПотенциальномИнциденте.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(vftНесоответствия.Ссылка) КАК ОбщееКоличествоЗамечаний
	|ПОМЕСТИТЬ втОбщееКоличествоЗамечаний
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ vftНесоответствия.Ссылка) КАК КоличествоЗамечанийАудитСУБ
	|ПОМЕСТИТЬ втКоличествоЗамечанийАудитСУБ
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусМероприятиеСУБ КАК рарусМероприятиеСУБ
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.рарусВидыМероприятийСУБ КАК рарусВидыМероприятийСУБ
	|			ПО рарусМероприятиеСУБ.ВидМероприятия = рарусВидыМероприятийСУБ.Ссылка
	|		ПО vftНесоответствия.ВладелецЗамечания = рарусМероприятиеСУБ.Ссылка
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И рарусВидыМероприятийСУБ.ХарактерМероприятия = ЗНАЧЕНИЕ(перечисление.рарусХарактерМероприятия.АудитСУБ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ vftНесоответствия.Ссылка) КАК КоличествоЗамечанийТехОсмотр
	|ПОМЕСТИТЬ втКоличествоЗамечанийТехОсмотр
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусМероприятиеСУБ КАК рарусМероприятиеСУБ
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.рарусВидыМероприятийСУБ КАК рарусВидыМероприятийСУБ
	|			ПО рарусМероприятиеСУБ.ВидМероприятия = рарусВидыМероприятийСУБ.Ссылка
	|		ПО vftНесоответствия.ВладелецЗамечания = рарусМероприятиеСУБ.Ссылка
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И рарусВидыМероприятийСУБ.ХарактерМероприятия = ЗНАЧЕНИЕ(перечисление.рарусХарактерМероприятия.ТехническийОсмотр)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ vftНесоответствия.Ссылка) КАК КоличествоЗамечанийОсвидетельствованиеРМРС
	|ПОМЕСТИТЬ втКоличествоЗамечанийПоОсвидетельствованиюРМРС
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусМероприятиеСУБ КАК рарусМероприятиеСУБ
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.рарусВидыМероприятийСУБ КАК рарусВидыМероприятийСУБ
	|			ПО рарусМероприятиеСУБ.ВидМероприятия = рарусВидыМероприятийСУБ.Ссылка
	|		ПО vftНесоответствия.ВладелецЗамечания = рарусМероприятиеСУБ.Ссылка
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И рарусВидыМероприятийСУБ.ТипМероприятия = ЗНАЧЕНИЕ(перечисление.рарусТипыМероприятия.ОсвидетельствованиеСудна)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	рарусСправочникСсылок.Значение КАК Значение
	|ПОМЕСТИТЬ втОтборPSC
	|ИЗ
	|	Справочник.рарусСправочникСсылок КАК рарусСправочникСсылок
	|ГДЕ
	|	рарусСправочникСсылок.Ссылка = ЗНАЧЕНИЕ(Справочник.рарусСправочникСсылок.PSC)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	рарусСправочникСсылок.Значение КАК Значение
	|ПОМЕСТИТЬ втОтборFSC
	|ИЗ
	|	Справочник.рарусСправочникСсылок КАК рарусСправочникСсылок
	|ГДЕ
	|	рарусСправочникСсылок.Ссылка = ЗНАЧЕНИЕ(Справочник.рарусСправочникСсылок.FSC)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	рарусСправочникСсылок.Значение КАК Значение
	|ПОМЕСТИТЬ втОтборГПК
	|ИЗ
	|	Справочник.рарусСправочникСсылок КАК рарусСправочникСсылок
	|ГДЕ
	|	рарусСправочникСсылок.Ссылка = ЗНАЧЕНИЕ(Справочник.рарусСправочникСсылок.ГПК)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ vftНесоответствия.Ссылка) КАК КоличествоЗамечанийPSC
	|ПОМЕСТИТЬ втКоличествоЗамечанийPSC
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусМероприятиеСУБ КАК рарусМероприятиеСУБ
	|		ПО vftНесоответствия.ВладелецЗамечания = рарусМероприятиеСУБ.Ссылка
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И рарусМероприятиеСУБ.КонтролирующийОрган В ИЕРАРХИИ
	|			(ВЫБРАТЬ
	|				втОтборPSC.Значение КАК Значение
	|			ИЗ
	|				втОтборPSC КАК втОтборPSC)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ vftНесоответствия.Ссылка) КАК КоличествоЗамечанийFSC
	|ПОМЕСТИТЬ втКоличествоЗамечанийFSC
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусМероприятиеСУБ КАК рарусМероприятиеСУБ
	|		ПО vftНесоответствия.ВладелецЗамечания = рарусМероприятиеСУБ.Ссылка
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И рарусМероприятиеСУБ.КонтролирующийОрган В ИЕРАРХИИ
	|			(ВЫБРАТЬ
	|				втОтборFSC.Значение КАК Значение
	|			ИЗ
	|				втОтборFSC КАК втОтборFSC)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ vftНесоответствия.Ссылка) КАК КоличествоЗамечанийГПК
	|ПОМЕСТИТЬ втКоличествоЗамечанийГПК
	|ИЗ
	|	Справочник.vftНесоответствия КАК vftНесоответствия
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.рарусМероприятиеСУБ КАК рарусМероприятиеСУБ
	|		ПО vftНесоответствия.ВладелецЗамечания = рарусМероприятиеСУБ.Ссылка
	|ГДЕ
	|	vftНесоответствия.Статус <> ЗНАЧЕНИЕ(Перечисление.vftСтатусыДокументовСообщений.Черновик)
	|	И НЕ vftНесоответствия.ПометкаУдаления
	|	И vftНесоответствия.Судно = &Судно
	|	И vftНесоответствия.Дата МЕЖДУ &ДатаНачало И &ДатаКонец
	|	И рарусМероприятиеСУБ.КонтролирующийОрган В ИЕРАРХИИ
	|			(ВЫБРАТЬ
	|				втОтборГПК.Значение КАК Значение
	|			ИЗ
	|				втОтборГПК КАК втОтборГПК)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСообщенияОбИнциденте.КоличествоСообщений КАК КоличествоСообщений,
	|	втОбщееКоличествоЗамечаний.ОбщееКоличествоЗамечаний КАК ОбщееКоличествоЗамечаний,
	|	втКоличествоЗамечанийАудитСУБ.КоличествоЗамечанийАудитСУБ КАК КоличествоЗамечанийАудитСУБ,
	|	втКоличествоЗамечанийТехОсмотр.КоличествоЗамечанийТехОсмотр КАК КоличествоЗамечанийТехОсмотр,
	|	втКоличествоЗамечанийПоОсвидетельствованиюРМРС.КоличествоЗамечанийОсвидетельствованиеРМРС КАК КоличествоЗамечанийОсвидетельствованиеРМРС,
	|	втКоличествоЗамечанийPSC.КоличествоЗамечанийPSC КАК КоличествоЗамечанийPSC,
	|	втКоличествоЗамечанийFSC.КоличествоЗамечанийFSC КАК КоличествоЗамечанийFSC,
	|	втКоличествоЗамечанийГПК.КоличествоЗамечанийГПК КАК КоличествоЗамечанийГПК
	|ИЗ
	|	втОбщееКоличествоЗамечаний КАК втОбщееКоличествоЗамечаний,
	|	втСообщенияОбИнциденте КАК втСообщенияОбИнциденте,
	|	втКоличествоЗамечанийАудитСУБ КАК втКоличествоЗамечанийАудитСУБ,
	|	втКоличествоЗамечанийТехОсмотр КАК втКоличествоЗамечанийТехОсмотр,
	|	втКоличествоЗамечанийПоОсвидетельствованиюРМРС КАК втКоличествоЗамечанийПоОсвидетельствованиюРМРС,
	|	втКоличествоЗамечанийPSC КАК втКоличествоЗамечанийPSC,
	|	втКоличествоЗамечанийFSC КАК втКоличествоЗамечанийFSC,
	|	втКоличествоЗамечанийГПК КАК втКоличествоЗамечанийГПК";
	
	Запрос.УстановитьПараметр("Судно",Судно);
	Запрос.УстановитьПараметр("ДатаНачало", НачалоПериода);
	Запрос.УстановитьПараметр("ДатаКонец",  КонецПериода);
	
	Результат = Запрос.Выполнить();
	Выборка   = Результат.Выбрать();
	Выборка.Следующий();
	
	СтруктураДанныхЗаполнения = Новый Структура;
	СтруктураДанныхЗаполнения.Вставить("КоличествоСообщений",                        Выборка.КоличествоСообщений);
	СтруктураДанныхЗаполнения.Вставить("ОбщееКоличествоЗамечаний",                   Выборка.ОбщееКоличествоЗамечаний);
	СтруктураДанныхЗаполнения.Вставить("КоличествоЗамечанийАудитСУБ",                Выборка.КоличествоЗамечанийАудитСУБ);
	СтруктураДанныхЗаполнения.Вставить("КоличествоЗамечанийТехОсмотр",               Выборка.КоличествоЗамечанийТехОсмотр);
	СтруктураДанныхЗаполнения.Вставить("КоличествоЗамечанийОсвидетельствованиеРМРС", Выборка.КоличествоЗамечанийОсвидетельствованиеРМРС);
	СтруктураДанныхЗаполнения.Вставить("КоличествоЗамечанийPSC",                     Выборка.КоличествоЗамечанийPSC);
	СтруктураДанныхЗаполнения.Вставить("КоличествоЗамечанийFSC",                     Выборка.КоличествоЗамечанийFSC);
	СтруктураДанныхЗаполнения.Вставить("КоличествоЗамечанийГПК",                     Выборка.КоличествоЗамечанийГПК);
	
	Возврат СтруктураДанныхЗаполнения; 
	
КонецФункции

Функция СписокЗначенияРолей() Экспорт 
	
	СписокЗначенийРолей = Новый СписокЗначений;
	СписокЗначенийРолей.Добавить("Председатель");
	СписокЗначенийРолей.Добавить("Старший помощник капитана");
	СписокЗначенийРолей.Добавить("Старший механик");
	СписокЗначенийРолей.Добавить("Офицер по безопасности");
	СписокЗначенийРолей.Добавить("Представитель моряков");
	СписокЗначенийРолей.Добавить("Представитель рядового состава");

	Возврат СписокЗначенийРолей;
	
КонецФункции

#КонецОбласти

#Область РегистрацияОбмена

Процедура ПередОбработкой(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО) Экспорт
	
	рарусОбменСУБСервер.ПередОбработкой(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, ПРО);
	
КонецПроцедуры	

Процедура ПослеОбработки(ИмяПланаОбмена, Отказ, Объект, Объектметаданных, Выгрузка, Получатели) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецЕсли