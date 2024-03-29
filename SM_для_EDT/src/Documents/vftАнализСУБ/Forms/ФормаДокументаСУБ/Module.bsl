#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
		
	НастроитьФормуИОбновитьРеквизиты();

	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	//Конец СтандартныеПодсистемы.РаботаСФайлами

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
			
	ДополнительныеПараметры = рарусСУБСервер.ПараметрыПриСозданииНаСервере();
	ДополнительныеПараметры.Форма = ЭтотОбъект;
	ИспользоватьКоманду = рарусСУБСервер.ПолучитьПризнакОтображенияКомандыСменыСтатусов(Объект.Статус);
	ДополнительныеПараметры.ИспользоватьКоманду = ИспользоватьКоманду;	
	ДополнительныеПараметры.МестоРазмещенияКоманд =  Элементы.ПодменюСтатус;
	
	рарусСУБСервер.РазместитьКомандуОтменыСтатусаНаФорме(ДополнительныеПараметры);
		
	Если Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Отправлен 
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Получен
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

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	СобытияФорм.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
	Если Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Отправлен 
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Получен
		Или Объект.Статус = Перечисления.vftСтатусыДокументовСообщений.Закрыт Тогда  		
		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
  	Оповестить("ОбновитьЖурналДокументов");
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
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
    ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

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

// СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуИОбновитьРеквизиты()
	
	Если Объект.ОбщаяЭффективностьСудовойСУБ Тогда		
		ОбщаяЭффективность = "1";		
	Иначе		
		ОбщаяЭффективность = "0";	
	КонецЕсли;
	
	ОбновитьЭлементыТабличнойЧастиОтветов();
	
КонецПроцедуры

#КонецОбласти

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура ОбщаяЭффективностьПриИзменении(Элемент)
	
	Эффективность = ?(ОпределитьЭффективность(ОбщаяЭффективность), Истина, Ложь);
	
	ОбработатьРезультатВыбораЭффективности(Эффективность);

КонецПроцедуры

&НаКлиенте
Процедура НетПредложенияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Предложения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если  ТекущиеДанные.НетПредложения Тогда
			Элементы.Предложения.ТекущиеДанные.Предложение = "";
		КонецЕсли;
		
		ТекущиеДанные.ЕстьПредложение 	= ?(ЗначениеЗаполнено(ТекущиеДанные.Предложение),2,0);
		ТекущиеДанные.ЕстьОтвет 		= ?(ЗначениеЗаполнено(ТекущиеДанные.ОтветКомпании),2,0);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредложениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Предложения.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено  Тогда
		
		ТекущиеДанные.ЕстьПредложение 	= ?(ЗначениеЗаполнено(ТекущиеДанные.Предложение),2,0);
		ТекущиеДанные.НетПредложения 	= ?(ЗначениеЗаполнено(ТекущиеДанные.Предложение),Ложь,Истина);
		ТекущиеДанные.ЕстьОтвет 		= ?(ЗначениеЗаполнено(ТекущиеДанные.ОтветКомпании),2,0);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ОбработатьРезультатВыбораЭффективности(Эффективность)
	
	Объект.ОбщаяЭффективностьСудовойСУБ = Эффективность;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьЭффективность(ОбщаяЭффективность)
	
	Если Число(ОбщаяЭффективность) = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбновитьЭлементыТабличнойЧастиОтветов()
	
	Для Каждого СтрокаТаблицы из Объект.Предложения Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Предложение) тогда
			СтрокаТаблицы.ЕстьПредложение = 2;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ОтветКомпании) тогда
			СтрокаТаблицы.ЕстьОтвет = 2;
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти
