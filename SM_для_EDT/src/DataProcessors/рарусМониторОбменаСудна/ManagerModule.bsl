#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Процедура ПолучитьДанныеСБерега(Параметры, АдресРезультата) Экспорт
	
	ПараметрыПодключения = ПолучитьПараметрыПодключения(Параметры.ОсновноеСудно);
	СтруктураОтвета = ПолучитьОтветСервиса(ПараметрыПодключения, СтрШаблон("%1SI/%2/%3/%4/%5",	
																		ПараметрыПодключения.СтрокаHTTPЗапроса,
																		Параметры.НомерВарианта,
																		ПараметрыПодключения.КодУзла, 
																		ПараметрыПодключения.НомерОтправленного, 
																		ПараметрыПодключения.НомерПринятого));
	// Снимем с регистрации объекты, полученные на берегу																	
	МассивНомеровОтЦентра = СтрРазделить(СтруктураОтвета.io,";",Истина);
	ПланыОбмена.УдалитьРегистрациюИзменений(ПараметрыПодключения.Узел, Число(МассивНомеровОтЦентра[0]));
	
	ПоместитьВоВременноеХранилище(СтруктураОтвета, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьДанныеКОбмену(Параметры, АдресРезультата) Экспорт
	
	ДанныеКОбмену = Параметры.ДанныеКОбмену;
	// ++ rarus makole 2021-05-07
	//ПакетИзменений = рарусСинхронизацияССудном.ПолучитьВыборкуИзменений(Параметры.ГлавныйУзел, Параметры.ВариантОбмена, Истина);
	ПакетИзменений = рарусСинхронизацияССудномПовтИсп.ПолучитьВыборкуИзменений(Параметры.ГлавныйУзел, Параметры.ВариантОбмена, Истина);
	// -- rarus makole 2021-05-07
	ВыборкаПоСсылочным = ПакетИзменений[0].Выбрать();
	Пока ВыборкаПоСсылочным.Следующий() Цикл
		Если НЕ ВыборкаПоСсылочным.Уровень() = 0 
			И НЕ ВыборкаПоСсылочным.Удаление Тогда
			ИмяТипа = Метаданные.НайтиПоТипу(ВыборкаПоСсылочным.Тип).ПолноеИмя();
			СтрокаКОбмену = ДанныеКОбмену.Добавить();
			СтрокаКОбмену.Объект = ВыборкаПоСсылочным.Ссылка;
			СтрокаКОбмену.Выгружать = ВыборкаПоСсылочным.мВыгружать;
			СтрокаКОбмену.ВыгружатьПоПравилу = ВыборкаПоСсылочным.мВыгружать;
			СтрокаКОбмену.Объем = Окр((ВыборкаПоСсылочным.РазмерВФайле) / 1024,2,РежимОкругления.Окр15как20);
			Если СтрНачинаетсяС(ИмяТипа, "Документ") Тогда
				СтрокаКОбмену.КартинкаОбъект = 7;
				СтрокаКОбмену.Порядок = 1;
			ИначеЕсли СтрНачинаетсяС(ИмяТипа, "Справочник")
				И НЕ Метаданные.ОпределяемыеТипы.ПрисоединенныйФайл.Тип.СодержитТип(ВыборкаПоСсылочным.Тип) Тогда
				СтрокаКОбмену.КартинкаОбъект = 3;
				СтрокаКОбмену.Порядок = 2;
			ИначеЕсли Метаданные.ОпределяемыеТипы.ПрисоединенныйФайл.Тип.СодержитТип(ВыборкаПоСсылочным.Тип) Тогда
				СтрокаКОбмену.КартинкаОбъект = 0;
				СтрокаКОбмену.Порядок = 3;
			ИначеЕсли СтрНачинаетсяС(ИмяТипа, "ПланВидовХарактеристик") Тогда
				СтрокаКОбмену.КартинкаОбъект = 9;
				СтрокаКОбмену.Порядок = 4;
			ИначеЕсли СтрНачинаетсяС(ИмяТипа, "БизнесПроцесс") Тогда
				СтрокаКОбмену.КартинкаОбъект = 23;
				СтрокаКОбмену.Порядок = 5;
			ИначеЕсли СтрНачинаетсяС(ИмяТипа, "Задача") Тогда
				СтрокаКОбмену.КартинкаОбъект = 25;
				СтрокаКОбмену.Порядок = 6;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВыборкаПоКонстантам = ПакетИзменений[1].Выбрать();
	Пока ВыборкаПоКонстантам.Следующий() Цикл
		СтрокаКОбмену = ДанныеКОбмену.Добавить();
		СсылкаНаИдентификатор = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТИП(ВыборкаПоКонстантам.Тип));
		СтрокаКОбмену.Объект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаИдентификатор, "ПолныйСиноним");
		СтрокаКОбмену.Выгружать = ВыборкаПоКонстантам.мВыгружать;
		СтрокаКОбмену.ВыгружатьПоПравилу = ВыборкаПоКонстантам.мВыгружать;
		СтрокаКОбмену.ПолноеИмяТипа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаИдентификатор, "ПолноеИмя");
		СтрокаКОбмену.Объем = Окр((ВыборкаПоКонстантам.РазмерВФайле) / 1024,2,РежимОкругления.Окр15как20);
		СтрокаКОбмену.КартинкаОбъект = 1;
		СтрокаКОбмену.Порядок = 7;
	КонецЦикла;
	
	КоличествоПакетов = ПакетИзменений.Количество(); 
	Если КоличествоПакетов > 2 Тогда
		Для Пакет = 2 По КоличествоПакетов - 1 Цикл
			
			Если ПакетИзменений[Пакет].Колонки.Найти("Регистратор") = Неопределено Тогда // Выводим только независимые регистры
			
				// ++ rarus makole 2021-05-07
				//ВыборкаПоРегистру = ПакетИзменений[Пакет].Выбрать();
				//
				//Если ВыборкаПоРегистру.Следующий() Тогда
				ВыборкаПоРегистру = ПакетИзменений[Пакет].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

				Пока ВыборкаПоРегистру.Следующий() Цикл
				// -- rarus makole 2021-05-07
				
					Если ВыборкаПоРегистру.Тип = "РегистрСведений.рарусЛогСменыВариантаСинхронизации" Тогда
						Продолжить; // Записи лога не выводим в список 
					КонецЕсли;
					
					СтрокаКОбмену = ДанныеКОбмену.Добавить();
					СсылкаНаИдентификатор = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ВыборкаПоРегистру.Тип);
					СтрокаКОбмену.Объект = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаИдентификатор, "ПолныйСиноним");
					СтрокаКОбмену.Выгружать = ВыборкаПоРегистру.мВыгружать;
					СтрокаКОбмену.ВыгружатьПоПравилу = ВыборкаПоРегистру.мВыгружать;
					СтрокаКОбмену.ПолноеИмяТипа = ВыборкаПоРегистру.Тип;
					СтрокаКОбмену.Объем = Окр((ВыборкаПоРегистру.РазмерВФайле) / 1024,2,РежимОкругления.Окр15как20);
					СтрокаКОбмену.КартинкаОбъект = 15;
					СтрокаКОбмену.Порядок = 8;
				// ++ rarus makole 2021-05-07
					СтрокаКОбмену.ОставшийсяОбъем = ?(ВыборкаПоРегистру.мВыгружать, СтрокаКОбмену.Объем, 0);
					
				//КонецЕсли;
				КонецЦикла;
				// -- rarus makole 2021-05-07
				
			КонецЕсли;
						
		КонецЦикла;
		// ++ rarus makole 2021-05-07
		// По связанным с объектами регистрам может быть несколько записей, а нам нужна итоговая, свернём таблицу
		КолонкиГруппировок = "Объект, Выгружать, ВыгружатьПоПравилу, ПолноеИмяТипа, КартинкаОбъект, Порядок";
		КолонкиСуммирования = "Объем, ОставшийсяОбъем";
		ДанныеКОбмену.Свернуть(КолонкиГруппировок, КолонкиСуммирования);
		// -- rarus makole 2021-05-07
	КонецЕсли;
	ДанныеКОбмену.Сортировать("Порядок, Объект");
	Результат = Новый Структура("ДанныеКОбмену, ПакетИзменений", ДанныеКОбмену, ПакетИзменений);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ЗаполнитьВыгружаемыеДанные(Параметры, АдресРезультата) Экспорт
	СтруктураВыгружаемыхПоВарианту = рарусСинхронизацияССудном.ПолучитьСписокКВыгрузке(Параметры.Узел, Параметры.Вариант);
	ЗаполнитьТаблицуПодготовленных(Параметры.ПодготовленоКОтправке, СтруктураВыгружаемыхПоВарианту, Истина);
	ПоместитьВоВременноеХранилище(Параметры.ПодготовленоКОтправке, АдресРезультата);
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПараметрыПодключения(ОсновноеСудно)
	
	ГлавныйУзел = Константы.ГлавныйУзел.Получить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Полный_ЭтотУзел.Код КАК Код,
		|	Полный_ГлавныйУзел.НомерОтправленного КАК НомерОтправленного,
		|	Полный_ГлавныйУзел.НомерПринятого КАК НомерПринятого,
		|	&Судно КАК Судно,
		|	vftВнешниеДанные.WSИмяСервиса КАК Хост,
		|	vftВнешниеДанные.WSURLВебСервиса КАК СтрокаHTTPЗапроса,
		|	vftВнешниеДанные.WSИмяПользователя КАК ИмяПользователя,
		|	vftВнешниеДанные.WSПароль КАК Пароль,
		|	vftВнешниеДанные.WSПорт КАК Порт
		|ИЗ
		|	ПланОбмена.Полный КАК Полный_ГлавныйУзел
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.Полный КАК Полный_ЭтотУзел
		|		ПО (Полный_ЭтотУзел.ЭтотУзел = ИСТИНА)
		|			И (Полный_ГлавныйУзел.Ссылка = &ГлавныйУзел)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.vftВнешниеДанные КАК vftВнешниеДанные
		|		ПО (vftВнешниеДанные.Судно = &Судно)
		|			И (vftВнешниеДанные.HTTPСервис = ИСТИНА)";
	
	Запрос.УстановитьПараметр("ГлавныйУзел", ГлавныйУзел);
	Запрос.УстановитьПараметр("Судно", ОсновноеСудно);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		КодУзла 			= СокрЛП(Выборка.Код);
		НомерОтправленного 	= Выборка.НомерОтправленного;
		НомерПринятого 		= Выборка.НомерПринятого;
		Хост				= Выборка.Хост;
		Порт				= Выборка.Порт;
		СтрокаHTTPЗапроса	= Выборка.СтрокаHTTPЗапроса;
		ИмяПользователя		= Выборка.ИмяПользователя;
		Пароль				= Выборка.Пароль;
	Иначе
		ВызватьИсключение("Не найдены настройки подключения к Http-сервису");
	КонецЕсли;
	
	Возврат Новый Структура("Узел, КодУзла, НомерОтправленного, НомерПринятого, Хост, Порт, СтрокаHTTPЗапроса, ИмяПользователя, Пароль",
							ГлавныйУзел, КодУзла, НомерОтправленного, НомерПринятого, Хост, Порт, СтрокаHTTPЗапроса, ИмяПользователя, Пароль);
КонецФункции

Функция ПолучитьОтветСервиса(ПараметрыПодключения, СтрокаHTTPЗапроса)
	
	ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог();

	// Соединение с сервисом
	Соединение = Новый HTTPСоединение(ПараметрыПодключения.Хост, ПараметрыПодключения.Порт,ПараметрыПодключения.ИмяПользователя, ПараметрыПодключения.Пароль);
	HTTPЗапрос = Новый HTTPЗапрос(СтрокаHTTPЗапроса);
	ОтветAPI = Соединение.Получить(HTTPЗапрос);
	
	// Проверка ответа на ошибки
	Если ОтветAPI.КодСостояния <> 200 Тогда
		ЗаписьЖурналаРегистрации("Ответ http-сервиса", УровеньЖурналаРегистрации.Ошибка,,,
						СтрШаблон("Код состояния %1
						|Текст ошибки: %2", ОтветAPI.КодСостояния, ОтветAPI.ПолучитьТелоКакСтроку()));
		
		ВызватьИсключение("Не удалось получить ответ сервера,
						|подробности см. в Журнале регистрации");
	КонецЕсли;
	
	// Получение и распаковка архива ответа
	ДвоичныеДанныеОтвета = ОтветAPI.ПолучитьТелоКакДвоичныеДанные();
	мЧтениеZipФайла = Новый ЧтениеZipФайла(ДвоичныеДанныеОтвета.ОткрытьПотокДляЧтения(),"1");
	Если мЧтениеZipФайла.Элементы.Количество() = 1 Тогда
		ИмяВременногоФайла = мЧтениеZipФайла.Элементы.Получить(0).ИсходноеИмя
	Иначе
		Возврат Неопределено
	КонецЕсли;
	мЧтениеZipФайла.ИзвлечьВсе(ВременныйКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	мЧтениеZipФайла.Закрыть();
	
	мЧтениеJSON = Новый ЧтениеJSON;
	мЧтениеJSON.ОткрытьФайл(ВременныйКаталог + ИмяВременногоФайла);
	
	мСериализаторXDTO = Новый СериализаторXDTO(ФабрикаXDTO);
	СтруктураОтвета = мСериализаторXDTO.ПрочитатьJSON(мЧтениеJSON);

	//Удаление временного каталога
	Попытка
	   ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
	Исключение
	   ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление каталога временных файлов'"), УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
   	КонецПопытки;
   
   	Возврат СтруктураОтвета;
	
КонецФункции

Процедура ЗаполнитьТаблицуПодготовленных(Таблица, СтруктураДанных, Отправка = Ложь) Экспорт
	
	Таблица.Очистить();
	
	МассивКрит = СтрРазделить(СтруктураДанных.КритичныеДанные,";",Ложь);
	КоличествоВМассиве = МассивКрит.Количество();
	Если КоличествоВМассиве Тогда
		СтрочкаКПолучению = Таблица.Добавить();
		СтрочкаКПолучению.ВидОбъекта = ПредопределенноеЗначение("Перечисление.рарусВидыОбъектовДляСинхронизации.КритичныеДанные");
		СтрочкаКПолучению.Количество = Число(МассивКрит[0]);
		СтрочкаКПолучению.Объем = ?(КоличествоВМассиве = 1, 0, Число(МассивКрит[1]));
		Если Отправка Тогда СтрочкаКПолучению.Приоритет = 1 КонецЕсли;
	КонецЕсли;
	
	МассивДок = СтрРазделить(СтруктураДанных.Документы,";",Ложь);
	КоличествоВМассиве = МассивДок.Количество();
	Если КоличествоВМассиве Тогда
		СтрочкаКПолучению = Таблица.Добавить();
		СтрочкаКПолучению.ВидОбъекта = ПредопределенноеЗначение("Перечисление.рарусВидыОбъектовДляСинхронизации.Документы");
		СтрочкаКПолучению.Количество = Число(МассивДок[0]);
		СтрочкаКПолучению.Объем = ?(КоличествоВМассиве = 1, 0, Число(МассивДок[1]));
		Если Отправка Тогда СтрочкаКПолучению.Приоритет = 2 КонецЕсли;
	КонецЕсли;
	
	МассивСпр = СтрРазделить(СтруктураДанных.Справочники,";",Ложь);
	КоличествоВМассиве = МассивСпр.Количество();
	Если КоличествоВМассиве Тогда
		СтрочкаКПолучению = Таблица.Добавить();
		СтрочкаКПолучению.ВидОбъекта = ПредопределенноеЗначение("Перечисление.рарусВидыОбъектовДляСинхронизации.Справочники");
		СтрочкаКПолучению.Количество = Число(МассивСпр[0]);
		СтрочкаКПолучению.Объем = ?(КоличествоВМассиве = 1, 0, Число(МассивСпр[1]));
		Если Отправка Тогда СтрочкаКПолучению.Приоритет = 3 КонецЕсли;
	КонецЕсли;
	
	МассивФл = СтрРазделить(СтруктураДанных.Файлы,";",Ложь);
	КоличествоВМассиве = МассивФл.Количество();
	Если КоличествоВМассиве Тогда
		СтрочкаКПолучению = Таблица.Добавить();
		СтрочкаКПолучению.ВидОбъекта = ПредопределенноеЗначение("Перечисление.рарусВидыОбъектовДляСинхронизации.Файлы");
		СтрочкаКПолучению.Количество = Число(МассивФл[0]);
		СтрочкаКПолучению.Объем = ?(КоличествоВМассиве = 1, 0, Число(МассивФл[1]));
		Если Отправка Тогда СтрочкаКПолучению.Приоритет = 4 КонецЕсли;
	КонецЕсли;
	
	МассивРег = СтрРазделить(СтруктураДанных.СлужебныеДанные,";",Ложь);
	КоличествоВМассиве = МассивРег.Количество();
	Если КоличествоВМассиве Тогда
		СтрочкаКПолучению = Таблица.Добавить();
		СтрочкаКПолучению.ВидОбъекта = ПредопределенноеЗначение("Перечисление.рарусВидыОбъектовДляСинхронизации.СлужебныеДанные");
		СтрочкаКПолучению.Количество = Число(МассивРег[0]);
		СтрочкаКПолучению.Объем = ?(КоличествоВМассиве = 1, 0, Число(МассивРег[1]));
		Если Отправка Тогда СтрочкаКПолучению.Приоритет = 5 КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли