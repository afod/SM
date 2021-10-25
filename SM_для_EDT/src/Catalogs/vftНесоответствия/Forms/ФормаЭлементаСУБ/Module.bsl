
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПолномочияАудитора = рарусОбщегоНазначенияПовтИсп.ПолномочияАудитораСУБ();
	
	ИспользуютсяКоды 
	     = Справочники.vftНесоответствия.ПолучитьЗначениеРеквзитовПоверкиПоВидуМероприятийСУБ(Объект.ВладелецЗамечания);

	КонтролирующийОрганВходитВРМРС 
	     =  Справочники.vftНесоответствия.ПроверитьВхождениеКонтролирующегоОрганаВГруппуРМРС(Объект);
		 
	ЗаполнитьСоответствиеТиповЗамечаний();	 

	НастроитьФормуИОбновитьРеквизиты(ЭтотОбъект);
		
	НастроитьДоступностьРеквизитовФормы(ЭтотОбъект);
	
	УстановитьСвойстваЭлементов();
	
	/// Временно, до обновления правил обмена, удалить код и поставить галку выбора типа	
	ДопустимыйТип = Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"); 
	
	Если Не ЗначениеЗаполнено(Объект.ФИООтветственныйРешение) Тогда
		Объект.ФИООтветственныйРешение = ДопустимыйТип.ПривестиЗначение(Объект.ФИООтветственныйРешение);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ФИООтветственныйПредупреждающиеДействия) Тогда		
		Объект.ФИООтветственныйПредупреждающиеДействия = ДопустимыйТип.ПривестиЗначение(Объект.ФИООтветственныйПредупреждающиеДействия);
	КонецЕсли;
	///
	
	ЗаполнитьЗначениеДополнительныхРеквизитовЗамечания();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	//СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	//Конец СтандартныеПодсистемы.РаботаСФайлами
		
	ДополнительныеПараметры = рарусСУБСервер.ПараметрыПриСозданииНаСервере();
	ДополнительныеПараметры.Форма = ЭтотОбъект;
	ИспользоватьКоманду = рарусСУБСервер.ПолучитьПризнакОтображенияКомандыСменыСтатусов(Объект.Статус);
	ДополнительныеПараметры.ИспользоватьКоманду = ИспользоватьКоманду;	
	ДополнительныеПараметры.МестоРазмещенияКоманд =  Элементы.ПодменюСтатус;
	
	рарусСУБСервер.РазместитьКомандуОтменыСтатусаНаФорме(ДополнительныеПараметры);
	
	Если Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Отправлен 
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Получен
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.ОтправленНаСудно
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Закрыт Тогда  
		
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ЗоныОтветственности.Количество() = 0 
		И Не Объект.ТребуетсяРешениеКомпании Тогда	
		ПересчитатьДокументНаКлиенте();		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	Если Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Отправлен 
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Получен	
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.ОтправленНаСудно
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Закрыт Тогда  
		
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьСписокЖурналДокументов");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Закрыть(Объект.Ссылка);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличныхЧастей

&НаКлиенте
Процедура ДокументыПоЗамечаниюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ДокументыПоЗамечанию.ТолькоПросмотр Тогда
		
		ТекущаяСтрока = Элементы.ДокументыПоЗамечанию.ТекущиеДанные;

		ПараметрыОткрытия = Новый Структура("Ключ", ТекущаяСтрока.ДокументОтражающийДефект);
		
		Если ТипЗнч(ТекущаяСтрока.ДокументОтражающийДефект) = Тип("ДокументСсылка.впЗаявкаНаСнабжение") Тогда
			ФормаИмя = "Документ.впЗаявкаНаСнабжение.Форма.ФормаДокумента";
		Иначе
			ФормаИмя = "Документ.впВыявленныеДефекты.Форма.ФормаДокумента";
		КонецЕсли;
				
		ОткрытьФорму(ФормаИмя, ПараметрыОткрытия); 
			
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗоныОтветственностиПриИзменении(Элемент)
	
	
	ТекущаяСтрока = Элементы.ЗоныОтветственности.ТекущиеДанные;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		Если ПустаяСтрока(ТекущаяСтрока.ИдентификаторСтроки) Тогда
			ТекущаяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗоныОтветственностиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Копирование Тогда
		
		ТекущаяСтрока = Элементы.ЗоныОтветственности.ТекущиеДанные;
		
		Если ТекущаяСтрока <> Неопределено Тогда			
			ТекущаяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;						
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСменыСтатуса(Команда)

	рарусСУБКлиент.ПриИзмененииСменыСтатуса(ЭтотОбъект, Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуВзаимодействияСБерегом(Команда)
	
	рарусСУБКлиент.ПриИзмененииСтатусаВзаимодействияСБерегом(ЭтотОбъект, Команда.Имя);
	   
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	
	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда) Экспорт
	
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды() Экспорт
	
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТребуетсяРешениеКомпанииПереключательПриИзменении(Элемент)
	
	РешениеКомпании = ?(ОпределитьРешениеКомпании(РешениеКомпанииПереключатель), Истина, Ложь);
	
	ОбработатьРезультатВыбораРешенияКомпании(РешениеКомпании);
	
	НастроитьФормуИОбновитьРеквизиты(ЭтотОбъект);
	
	НастроитьДоступностьРеквизитовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗамечанияПриИзменении(Элемент)
	
	НастроитьДоступностьРеквизитовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КорректирующиеДействияПриИзменении(Элемент)

	Если Не Объект.ТребуетсяРешениеКомпании Тогда
		
		Отбор = Новый Структура("ЗанаОтветственности", ПредопределенноеЗначение("Справочник.рарусЗоныОтветственности.Экипаж"));

		НайденныеСтроки = Объект.ЗоныОтветственности.НайтиСтроки(Отбор);
		
		Для Каждого СтрокаТч Из НайденныеСтроки Цикл
			Объект.ЗоныОтветственности.Удалить(Объект.ЗоныОтветственности.Индекс(СтрокаТЧ));	
		КонецЦикла;
		
		ЗаполнитьТабличнуюЧастьПодразделениями();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуютсяПредупреждающиеДействияПриИзменении(Элемент)
	
	НастроитьДоступностьРеквизитовФормы(ЭтотОбъект);
	НастроитьФормуИОбновитьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаВыполненияПриИзменении(Элемент)
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФормуИОбновитьРеквизиты(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Форма.КонтролирующийОрганВходитВРМРС Тогда
		Объект.ТребуетсяРешениеКомпании = Истина;
	КонецЕсли;
		
	Если Объект.ТребуетсяРешениеКомпании Тогда
		
		Форма.РешениеКомпанииПереключатель = "1";	
		
		Элементы.ГруппаСтраницаРешениеКомпании.Заголовок =  НСтр("ru = 'Требуется подключение ресурсов Компании';
		                                                     |en = 'Company connection required'");
	Иначе
		
		Форма.РешениеКомпанииПереключатель = "0";	

   		Элементы.ГруппаСтраницаРешениеКомпании.Заголовок =  НСтр("ru = 'Не требуется подключение ресурсов Компании';
		                                                     |en = 'Company connection required'");
 
		
	КонецЕсли;            
	
	Если Объект.ТребуютсяПредупреждающиеДействия Тогда
		
		Элементы.ГруппаСтраницаПредупреждающиеДействия.Заголовок = НСтр("ru = 'Требуются предупреждающие действия';
		                                                          |en = 'Preventive action required'");	
	Иначе
		
		Элементы.ГруппаСтраницаПредупреждающиеДействия.Заголовок = НСтр("ru = 'Предупреждающие действия не требуются';
		                                                                     |en = 'warning not actions'");		
	КонецЕсли;
	
			
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваЭлементов()
	
	МассивЭлементов = Новый Массив();
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КодЗамечаний", "АвтоОтметкаНезаполненного", ИспользуютсяКоды);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КодУстраненияЗамечания", "АвтоОтметкаНезаполненного", ИспользуютсяКоды);
		
	Если ПолномочияАудитора Или КонтролирующийОрганВходитВРМРС Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КорректирующиеДействия", "АвтоОтметкаНезаполненного", Ложь);	
	КонецЕсли;
	
	Если Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Черновик Тогда
		
		МассивЭлементов.Добавить("ОписаниеНесоответствия");
		МассивЭлементов.Добавить("ПричинаНесоответствия");
		МассивЭлементов.Добавить("КорректирующиеДействия");
		МассивЭлементов.Добавить("СсылкаНаДокумент");
		
		Для Каждого Элемент Из МассивЭлементов Цикл 
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Элемент, "АвтоОтметкаНезаполненного", Ложь);
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ОбработатьРезультатВыбораРешенияКомпании(РешениеКомпании)
	
	Если РешениеКомпании Тогда
		
		Объект.ТребуетсяРешениеКомпании = Истина;
			
		Если Объект.ЗоныОтветственности.Количество() > 0 Тогда 			
			ПоложительноеРешениеКомпании();
		КонецЕсли;
			
	Иначе
		
		Если ЗначениеЗаполнено(Объект.КорректирующиеДействия) Тогда
			
			Объект.ТребуетсяРешениеКомпании = Ложь;
			
			ЗаполнитьТабличнуюЧастьПодразделениями();			
		Иначе
			
			РешениеКомпанииПереключатель = "0";
	
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нужно заполнить поле ""корректирующие действия"" на странице: ""замечания"".';
																	|en = 'You must fill in the Corrective Action field on the page: Remarks'"));
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПоложительноеРешениеКомпании();
	
	ТекстВопроса = "Подразделения будут очищены. Продолжить?";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПоложительноеРешениеКомпанииЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура ПоложительноеРешениеКомпанииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда	
		Объект.ЗоныОтветственности.Очистить();
	Иначе
		Объект.ТребуетсяРешениеКомпании = Ложь;	
		НастроитьФормуИОбновитьРеквизиты(ЭтотОбъект);
		//РешениеКомпанииПереключатель = "0";
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьРешениеКомпании(РешениеКомпании)
	
	Если Число(РешениеКомпании) = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции


&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьДоступностьРеквизитовФормы(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.Вопрос.ТолькоПросмотр = Объект.Статус <> ПредопределенноеЗначение("Перечисление.vftСтатусыДокументовСообщений.Черновик");
		
	//ТипЗамечанияНесоответствие = Объект.ТипЗамечания = ПредопределенноеЗначение("Перечисление.рарусТипыЗамечания.Несоответствие");
	
	Если Форма.ПолномочияАудитора Тогда
		Если Объект.Статус <> ПредопределенноеЗначение("Перечисление.vftСтатусыДокументовСообщений.Закрыт") Тогда			
			Элементы.ПовторяющеесяЗамечания.ТолькоПросмотр = Ложь;				
		КонецЕсли;
	КонецЕсли;
		
	ВидимостьЭлементовПКД = Ложь;
	
	Если Форма.КонтролирующийОрганВходитВРМРС Тогда
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ТипЗамечаний", Объект.ТипЗамечания);	
		НайденнаяСтрока = Форма.СоответствиеТипыЗамечаний.НайтиСтроки(СтруктураОтбора);
		
		Если НайденнаяСтрока.Количество() > 0 И НайденнаяСтрока[0].ЗначениеТипа Тогда
			ВидимостьЭлементовПКД = Истина;		
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ПКДОтправлен.Видимость                 = ВидимостьЭлементовПКД;
	Элементы.ДатаПКД.Видимость                      = ВидимостьЭлементовПКД;
	Элементы.ОтчетОВыполненииПКДОтправлен.Видимость = ВидимостьЭлементовПКД;
	Элементы.ДатаОтправкиОтчета.Видимость           = ВидимостьЭлементовПКД;

	ВидимостьСтраницыДонесенияОбУстранении = Истина;
	Если Объект.Статус = ПредопределенноеЗначение("Перечисление.vftСтатусыДокументовСообщений.Получен") Тогда		
		ВидимостьСтраницыДонесенияОбУстранении = Ложь;	
	КонецЕсли;
	
	Если Объект.Статус = ПредопределенноеЗначение("Перечисление.vftСтатусыДокументовСообщений.ОтправленНаСудно") Тогда						
		ВидимостьСтраницыДонесенияОбУстранении = Ложь;                                                                                  
	КонецЕсли;
	
	Элементы.ДействияПринятыеДляУстранения.ТолькоПросмотр      =  ВидимостьСтраницыДонесенияОбУстранении;
	Элементы.ДатаУстранения.ТолькоПросмотр                     =  ВидимостьСтраницыДонесенияОбУстранении;
	Элементы.ДополнительныйКомментарийДонесение.ТолькоПросмотр =  ВидимостьСтраницыДонесенияОбУстранении;
		
	СтатусЧерновик =  Объект.Статус = ПредопределенноеЗначение("Перечисление.vftСтатусыДокументовСообщений.Черновик");
	
	Элементы.Дата.ТолькоПросмотр = Не СтатусЧерновик;
		
	ТолькоПросмотрПереключателяРешениеКомпании = Ложь;
	
	Если Форма.КонтролирующийОрганВходитВРМРС Тогда
		ТолькоПросмотрПереключателяРешениеКомпании = Истина;		
	Иначе
		Если Не СтатусЧерновик Тогда 
		ТолькоПросмотрПереключателяРешениеКомпании = Истина;	
		КонецЕсли;	
	КонецЕсли;
	
	Элементы.РешениеКомпанииПереключатель.ТолькоПросмотр = ТолькоПросмотрПереключателяРешениеКомпании; 
	Элементы.КорректирующиеДействия.ТолькоПросмотр =  ТолькоПросмотрПереключателяРешениеКомпании;
	
	ПолномочияАудитора = Форма.ПолномочияАудитора;
	
	Элементы.ТребуютсяПредупреждающиеДействия.ТолькоПросмотр = Не ПолномочияАудитора;
	
	РешениеКомпании = Объект.ТребуетсяРешениеКомпании;
	ПредупреждающиеДействия = Объект.ТребуютсяПредупреждающиеДействия;
		
	ПросмотрСтраницыПодключенияКомпании = Истина;
	ПросмотрСтраницыПредупреждающиеДействия = Истина;
	
	Если СтатусЧерновик Тогда
		Если ПолномочияАудитора Тогда				
			Если РешениеКомпании Тогда
				ПросмотрСтраницыПодключенияКомпании = Ложь;	
			КонецЕсли;
			Если ПредупреждающиеДействия Тогда
				ПросмотрСтраницыПредупреждающиеДействия = Ложь;	
			КонецЕсли;			
		КонецЕсли;
	КонецЕсли;
	
	// Страница "Подключение компании"	
	//Элементы.ГруппаЗоныОтветственности.ТолькоПросмотр =  ПросмотрСтраницыПодключенияКомпании;
	
	Элементы.ЗоныОтветственностиЗанаОтветственности.ТолькоПросмотр =  ПросмотрСтраницыПодключенияКомпании;
	Элементы.ЗоныОтветственностиКорректирующиеДействия.ТолькоПросмотр =  ПросмотрСтраницыПодключенияКомпании;
	Элементы.ЗоныОтветственностиПланируемыеСрокиУстранения.ТолькоПросмотр =  ПросмотрСтраницыПодключенияКомпании;
	Элементы.ЗоныОтветственностиДобавить.Доступность = Не ПросмотрСтраницыПодключенияКомпании;
	Элементы.ЗоныОтветственностиУдалить.Доступность =  Не ПросмотрСтраницыПодключенияКомпании;
	
	Элементы.ГруппаРешениеБлокировка.ТолькоПросмотр   = ПросмотрСтраницыПодключенияКомпании; 
	
	// Страница "Предупреждающих действия"	
	Элементы.МерыПоПредотвращениюПовторенияНесоответствия.ТолькоПросмотр  = ПросмотрСтраницыПредупреждающиеДействия;
	Элементы.ОтветственныйЗаПредупреждающиеДействия.ТолькоПросмотр        = ПросмотрСтраницыПредупреждающиеДействия;
	Элементы.ПланируемыеСрокиВыполнения.ТолькоПросмотр                    = ПросмотрСтраницыПредупреждающиеДействия;
	//Элементы.ДатаВыполнения.ТолькоПросмотр                                = ПросмотрСтраницыПредупреждающиеДействия;
	//Элементы.ДолжностьОтветственныйПредупреждающиеДействия.ТолькоПросмотр = ПросмотрСтраницыПредупреждающиеДействия;
	//Элементы.ФИООтветственныйПредупреждающиеДействия.ТолькоПросмотр       = ПросмотрСтраницыПредупреждающиеДействия;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьДокументНаКлиенте()
	ЗаполнитьТабличнуюЧастьПодразделениями();	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧастьПодразделениями()
	
	СтрокаТаблицы  = Объект.ЗоныОтветственности.Добавить();
	СтрокаТаблицы.ЗанаОтветственности    = ПредопределенноеЗначение("Справочник.рарусЗоныОтветственности.Экипаж");
	СтрокаТаблицы.КорректирующиеДействия = Объект.КорректирующиеДействия;
	СтрокаТаблицы.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСоответствиеТиповЗамечаний()
	
	СоответствиеТипов = Новый Соответствие();
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.Несоответствие, Истина);
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.Замечание, Ложь);
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.Наблюдение, Ложь);
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.ЗначительноеНесоответствие, Истина);
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.Недостаток, Ложь);
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.СерьезныйНедостаток, Истина);
	СоответствиеТипов.Вставить(Перечисления.рарусТипыЗамечания.СущественныйНедостаток, Истина);
	
	СоответствиеТипыЗамечаний.Очистить();
	
	Для Каждого ЭлСоответствия Из СоответствиеТипов Цикл
		
		СтрокаТаблицыСоответствий = СоответствиеТипыЗамечаний.Добавить();
		СтрокаТаблицыСоответствий.ТипЗамечаний = ЭлСоответствия.Ключ;
		СтрокаТаблицыСоответствий.ЗначениеТипа = ЭлСоответствия.Значение;
		
	КонецЦикла;
			
Конецфункции

&НаСервере
Процедура ЗаполнитьЗначениеДополнительныхРеквизитовЗамечания();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Судно) 
		И Объект.ЗоныОтветственности.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 			
		"ВЫБРАТЬ
		|	рарусДополнительныеДанныеЗамечаний.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	рарусДополнительныеДанныеЗамечаний.ДолжностьОтветственного КАК ДолжностьОтветственного,
		|	рарусДополнительныеДанныеЗамечаний.ФИООтветственного КАК ФИООтветственного,
		|	рарусДополнительныеДанныеЗамечаний.ДатаВыполненияТабЧасть КАК ДатаВыполненияТабЧасть,
		|	рарусДополнительныеДанныеЗамечаний.ФИО КАК ФИО,
		|	рарусДополнительныеДанныеЗамечаний.ФИООтветственногоЗаПредупреждающиеДействия КАК ФИООтветственногоЗаПредупреждающиеДействия,
		|	рарусДополнительныеДанныеЗамечаний.ДатаВыполнения КАК ДатаВыполнения,
		|	рарусДополнительныеДанныеЗамечаний.ФиоОтветственногоЗаОтметкуОВыполнении КАК ФиоОтветственногоЗаОтметкуОВыполнении,
		|	рарусДополнительныеДанныеЗамечаний.ДолжностьОтветственныйПредупреждающиеДействия КАК ДолжностьОтветственныйПредупреждающиеДействия,
		|	рарусДополнительныеДанныеЗамечаний.Подразделение КАК Подразделение,
		|	рарусДополнительныеДанныеЗамечаний.НомСтроки КАК НомСтроки,
		|	рарусДополнительныеДанныеЗамечаний.ЗамечаниеЗакрыто КАК ЗамечаниеЗакрыто,
		|	рарусДополнительныеДанныеЗамечаний.ФиоОтветственногоЗаЗакрытиеЗамечания КАК ФиоОтветственногоЗаЗакрытиеЗамечания,
		|	рарусДополнительныеДанныеЗамечаний.ОтчетОВыполненииПКДОтправлен КАК ОтчетОВыполненииПКДОтправлен,
		|	рарусДополнительныеДанныеЗамечаний.ДатаОтправкиОтчета КАК ДатаОтправкиОтчета
		|ИЗ
		|	РегистрСведений.рарусДополнительныеДанныеЗамечаний КАК рарусДополнительныеДанныеЗамечаний
		|ГДЕ
		|	рарусДополнительныеДанныеЗамечаний.Замечание = &Замечание
		|	И рарусДополнительныеДанныеЗамечаний.Судно = &Судно";
		
		Запрос.УстановитьПараметр("Замечание", Объект.Ссылка);
		Запрос.УстановитьПараметр("Судно", Объект.Судно);
		
		Выборка = Запрос.Выполнить();
		
		ТаблицаРезультатов = Выборка.Выгрузить();
		
		Если  ТаблицаРезультатов.Количество() > 0 Тогда
			
			////////////////////////
			// Заполним реквизиты шапки			
			Если Объект.ДатаВыполнения <> ТаблицаРезультатов[0].ДатаВыполнения  Тогда
				
				Объект.ДатаВыполнения = ТаблицаРезультатов[0].ДатаВыполнения;
				
			КонецЕсли;
			
			Если Объект.ФИООтветственныйПредупреждающиеДействия <> ТаблицаРезультатов[0].ФИООтветственногоЗаПредупреждающиеДействия Тогда
				
				Объект.ФИООтветственныйПредупреждающиеДействия = ТаблицаРезультатов[0].ФИООтветственногоЗаПредупреждающиеДействия;
				
			КонецЕсли;
			
			Если Объект.ДолжностьОтветственныйПредупреждающиеДействия <> ТаблицаРезультатов[0].ДолжностьОтветственныйПредупреждающиеДействия Тогда
				
				Объект.ДолжностьОтветственныйПредупреждающиеДействия = ТаблицаРезультатов[0].ДолжностьОтветственныйПредупреждающиеДействия;
				
			КонецЕсли;
			
			Если Объект.ФиоОтветственногоЗаОтметкуОВыполнении <> ТаблицаРезультатов[0].ДолжностьОтветственныйПредупреждающиеДействия Тогда
				
				Объект.ФиоОтветственногоЗаОтметкуОВыполнении = ТаблицаРезультатов[0].ФиоОтветственногоЗаОтметкуОВыполнении;
				
			КонецЕсли;
					
			Объект.ЗамечаниеЗакрыто = ТаблицаРезультатов[0].ЗамечаниеЗакрыто;
			Объект.ФиоОтветственногоЗаЗакрытиеЗамечания = ТаблицаРезультатов[0].ФиоОтветственногоЗаЗакрытиеЗамечания;
			Объект.ОтчетОВыполненииПКДОтправлен = ТаблицаРезультатов[0].ОтчетОВыполненииПКДОтправлен;
			Объект.ДатаОтправкиОтчета = ТаблицаРезультатов[0].ДатаОтправкиОтчета;
						
			///////////////////////
			// Заполнить табличную часть 
			Для Каждого СтрокаТЧ Из Объект.ЗоныОтветственности Цикл
				
				ДанныеЗаполненыПоИдентификаторуСтроки = Ложь;
				
				Если Не ПустаяСтрока(СтрокаТЧ.ИдентификаторСтроки) Тогда
					
					НайденнаяСтрока = ТаблицаРезультатов.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаТЧ.ИдентификаторСтроки)); 			
					
					Если НайденнаяСтрока.Количество() > 0 Тогда			
						СтрокаТЧ.ДолжностьОтветственного = НайденнаяСтрока[0].ДолжностьОтветственного;
						СтрокаТЧ.ФИООтветственного	= НайденнаяСтрока[0].ФИООтветственного;	
						СтрокаТЧ.ДатаВыполнения	= НайденнаяСтрока[0].ДатаВыполненияТабЧасть;	
						СтрокаТЧ.ФИО =  НайденнаяСтрока[0].ФИО;	
						
						ДанныеЗаполненыПоИдентификаторуСтроки = Истина;
						Продолжить;
					КонецЕсли;
					
				КонецЕсли;	
					
				Если Не ДанныеЗаполненыПоИдентификаторуСтроки Тогда
					
					ОтборПоСтроке = Новый Структура;
					ОтборПоСтроке.Вставить("НомСтроки", СтрокаТЧ.НомерСтроки);
					ОтборПоСтроке.Вставить("Подразделение", СтрокаТЧ.ЗанаОтветственности);
					
					НайденнаяСтрока = ТаблицаРезультатов.НайтиСтроки(ОтборПоСтроке);
					
					Если НайденнаяСтрока.Количество() > 0 Тогда	
						
						СтрокаТЧ.ДолжностьОтветственного = НайденнаяСтрока[0].ДолжностьОтветственного;
						СтрокаТЧ.ФИООтветственного	= НайденнаяСтрока[0].ФИООтветственного;	
						СтрокаТЧ.ДатаВыполнения	= НайденнаяСтрока[0].ДатаВыполненияТабЧасть;	
						СтрокаТЧ.ФИО = НайденнаяСтрока[0].ФИО;		
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
