#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтаФорма, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Объект.Ссылка.Пустая() Тогда
		ОбновитьОстаткиНоменклатурыНаСкладе();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	
	ОбновитьОстаткиНоменклатурыНаСкладе();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	ПроверитьСообщитьВключенИмущественныйУчет();
	
	ОбновитьОстаткиНоменклатурыНаСкладе();
	// ++ rarus makole 2021-03-30
	УстановитьДоступностьРедактированияИСтатусОтправки();	
	// ++ rarus makole 2021-03-30
	
	// ++ rarus makole 2021-06-10 [РАIT-0023374]
	// Учёт номенклатуры разного качества 
	ИспользуетсяКачествоТоваров = рарусИмущественныйУчетВызовСервера.ИспользуетсяКачествоТоваров();
	// -- rarus makole 2021-06-10 [РАIT-0023374]
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбновитьОстаткиНоменклатурыНаСкладе();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбновитьОстаткиНоменклатурыНаСкладе();
	
КонецПроцедуры

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	
	ОбновитьОстаткиНоменклатурыНаСкладе();
	ПроверитьСообщитьВключенИмущественныйУчет();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПриИзменении(Элемент)
	
	ОбновитьОстаткиНоменклатурыНаСкладе();
	
	ТекДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ТекДанные.КоличествоВыдано = Мин(ТекДанные.КоличествоВыдано, ТекДанные.КоличествоНаСкладе);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	// ++ rarus makole 2021-06-30  [РАIT-0023374]
	ВыдаетсяЭкипажу = НоменклатураВыдаётсяЭкипажу(ВыбранноеЗначение);
	Если ИспользуетсяКачествоТоваров
		И (НЕ ВыдаетсяЭкипажу ИЛИ НЕ ЭтоНоваяНоменклатура(ВыбранноеЗначение)) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, СтрШаблон("Номенклатура %1 не может быть выбрана в документ. Выберите номенклатуру с качеством ""Новый"" и категорией, выдаваемой экипажу", Строка(ВыбранноеЗначение)),,"Номенклатура не может быть выбрана!");
	ИначеЕсли НЕ ИспользуетсяКачествоТоваров 
		И НЕ ВыдаетсяЭкипажу Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьПредупреждение(, СтрШаблон("Номенклатура %1 не может быть выбрана в документ. Выберите номенклатуру с категорией, выдаваемой экипажу", Строка(ВыбранноеЗначение)),,"Номенклатура не может быть выбрана!");
	КонецЕсли;
	// -- rarus makole 2021-06-30  [РАIT-0023374]
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОтбору(Команда)
	
	ЗаполнитьПоОтборуНаСервере();
	
КонецПроцедуры

//rarus_AfoD 31.08.2021 < 
&НаКлиенте
Процедура ПодобратьТовары(Команда)
	
	ПараметрыФормыЗаголовок =  НСтр("ru = 'Подбор товаров'");
	ОтборПоТипуНоменклатуры 		= рарусНоменклатураКлиентСервер.ОтборПоТовару();
	ОтборПоКатегорииНоменклатуры 	= ОтборПоКатегориямВыдаваемымЭкипажуНаСервере();
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Заголовок",                                 ПараметрыФормыЗаголовок);
	ПараметрыФормы.Вставить("Дата",                                      ТекущаяДата());
	ПараметрыФормы.Вставить("Документ",                                  Объект.Ссылка);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования",				 "ПростойПодборНоменклатуры");
	ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры",                   Новый ФиксированныйМассив(ОтборПоТипуНоменклатуры));
	ПараметрыФормы.Вставить("ОтборПоКатегорииНоменклатуры",              Новый ФиксированныйМассив(ОтборПоКатегорииНоменклатуры));
	ПараметрыФормы.Вставить("Судно",                   					 СудноПоСкладу(Объект.Склад));
	
	ОткрытьФорму("Обработка.впПодборНоменклатуры.Форма", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОтборПоКатегориямВыдаваемымЭкипажуНаСервере() Экспорт
	
	Возврат рарусНоменклатураСервер.НоменклатураПоКатегориямВыдаваемымЭкипажу();
	
КонецФункции


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.Имяформы = "Обработка.впПодборНоменклатуры.Форма.Форма" Тогда
		
		ОбработкаВыбораПодборНаКлиенте(ВыбранноеЗначение);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПодборНаКлиенте(ВыбранноеЗначение)
	
	ТаблицаТоваров = ОбработкаВыбораПодборНаСервере(ВыбранноеЗначение);
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ВыдаетсяЭкипажу = НоменклатураВыдаётсяЭкипажу(СтрокаТовара.Номенклатура);
		Если ИспользуетсяКачествоТоваров
			И (НЕ ВыдаетсяЭкипажу ИЛИ НЕ ЭтоНоваяНоменклатура(СтрокаТовара.Номенклатура)) Тогда
			Сообщить(СтрШаблон("Номенклатура %1 не может быть выбрана в документ. Выберите номенклатуру с качеством ""Новый"" и категорией, выдаваемой экипажу", Строка(СтрокаТовара.Номенклатура)));
			Продолжить;
		ИначеЕсли НЕ ИспользуетсяКачествоТоваров 
			И НЕ ВыдаетсяЭкипажу Тогда
			Сообщить(СтрШаблон("Номенклатура %1 не может быть выбрана в документ. Выберите номенклатуру с категорией, выдаваемой экипажу", Строка(СтрокаТовара.Номенклатура)));
			Продолжить;
		КонецЕсли;
		
		ТекущаяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
		ПриИзмененииНоменклатурыСтроки(ТекущаяСтрока);
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработкаВыбораПодборНаСервере(АдресТоваровВХранилище)
	
	ТаблицаТоваров = Новый Массив;
	ТаблицаТоваровВХранилище = ПолучитьИзВременногоХранилища(АдресТоваровВХранилище);
	Для каждого СтрокаТаблицаТоваровВХранилище Из ТаблицаТоваровВХранилище Цикл
		
		ТаблицаТоваров.Добавить(Новый Структура("Номенклатура, КоличествоВыдано", СтрокаТаблицаТоваровВХранилище.Номенклатура, СтрокаТаблицаТоваровВХранилище.Количество));
		
	КонецЦикла; 
	
	Возврат ТаблицаТоваров;
	
КонецФункции
//rarus_AfoD 31.08.2021 > 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы_ПодключаемыеКоманды

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

#КонецОбласти

&НаСервере
Процедура ЗаполнитьПоОтборуНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Период = Новый МоментВремени(ТекущаяДатаСеанса());
	Иначе
		Период = Объект.Ссылка.МоментВремени();
	КонецЕсли;
	
	ТаблицаРезультата = ОстаткиПоОтбору(Период, Объект.Склад, Объект.Отбор).Выгрузить();
	Объект.Товары.Загрузить(ТаблицаРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОстаткиПоСтроке(СтруктураСтроки)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Период = Новый МоментВремени(ТекущаяДатаСеанса())
	Иначе
		Период = Объект.Ссылка.МоментВремени()
	КонецЕсли;
	
	РезультатПоНоменклатуре = ОстаткиПоОтбору(Период, Объект.Склад, , СтруктураСтроки.Номенклатура);
	ВыборкаПоНоменклатуре = РезультатПоНоменклатуре.Выбрать();
	Если ВыборкаПоНоменклатуре.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, ВыборкаПоНоменклатуре);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОстаткиПоОтбору(Период, Склад, Отбор = Неопределено, Номенклатура = Неопределено)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	рарусИмуществоНаСудахОстатки.Номенклатура КАК Номенклатура,
	|	рарусИмуществоНаСудахОстатки.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	рарусИмуществоНаСудахОстатки.КоличествоОстаток КАК КоличествоНаСкладе,
	|	0 КАК КоличествоВыдано
	|ИЗ
	|	РегистрНакопления.рарусИмуществоНаСудах.Остатки(
	|			&Период,
	|			Статус = ЗНАЧЕНИЕ(Перечисление.рарусСтатусыИмуществаНаСудне.НаСкладе)
	|				И Склад = &Склад
	|				И (&ПоВсейНоменклатуре
	|					ИЛИ Номенклатура В (&Номенклатура))
	|				И (&ПоВсемКатегориямНоменклатуры
	// ++ rarus makole 2021-06-30
	|						И Номенклатура.Категория В
	|							(ВЫБРАТЬ
	|								рарусКатегорииНоменклатуры.Ссылка КАК Ссылка
	|							ИЗ
	|								Справочник.рарусКатегорииНоменклатуры КАК рарусКатегорииНоменклатуры
	|							ГДЕ
	|								рарусКатегорииНоменклатуры.ПометкаУдаления = ЛОЖЬ
	|								И рарусКатегорииНоменклатуры.ВыдаетсяЭкипажу = ИСТИНА)
	// -- rarus makole 2021-06-30
	|					ИЛИ Номенклатура.Категория = &КатегорияНоменклатуры)) КАК рарусИмуществоНаСудахОстатки
	|ГДЕ
	|	рарусИмуществоНаСудахОстатки.КоличествоОстаток <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ПоВсейНоменклатуре", НЕ ЗначениеЗаполнено(Номенклатура));
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ПоВсемКатегориямНоменклатуры", НЕ ЗначениеЗаполнено(Отбор));
	Запрос.УстановитьПараметр("КатегорияНоменклатуры", Отбор);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	ПриИзмененииНоменклатурыСтроки(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииНоменклатурыСтроки(ТекущаяСтрока)
	
	СтруктураСтроки = Новый Структура("Номенклатура, 
									|ЕдиницаИзмерения, 
									|КоличествоНаСкладе, 
									|КоличествоВыдано");
	СтруктураСтроки.Номенклатура = ТекущаяСтрока.Номенклатура;
	ЗаполнитьОстаткиПоСтроке(СтруктураСтроки);
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтруктураСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиНоменклатурыНаСкладе()
	
	НоменклатураДокумента = Объект.Товары.Выгрузить(, "Номенклатура").ВыгрузитьКолонку("Номенклатура");
	
	Остатки = ОстаткиПоОтбору(Объект.Дата, Объект.Склад, , НоменклатураДокумента).Выгрузить();
	Остатки.Индексы.Добавить("Номенклатура");
	ОтборПоНоменклатуре = Новый Структура("Номенклатура");
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		ЗаполнитьЗначенияСвойств(ОтборПоНоменклатуре, СтрокаТЧ);
		СтрокиОстатков = Остатки.НайтиСтроки(ОтборПоНоменклатуре);
		Если СтрокиОстатков.Количество() > 0 Тогда
			ОстатокНаСкладе = СтрокиОстатков[0].КоличествоНаСкладе;
		Иначе
			ОстатокНаСкладе = 0;
		КонецЕсли; 
		СтрокаТЧ.КоличествоНаСкладе = ОстатокНаСкладе;
	КонецЦикла; 
	
КонецПроцедуры

// ++ rarus makole 2021-01-29 
&НаСервереБезКонтекста
Функция ИмущественныйУчетНеВключен(ДатаДок, Склад)
	
	Судно = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "Судно");
	Период = ?(ДатаДок = Дата('00010101'), НачалоДня(ТекущаяДатаСеанса()), НачалоДня(ДатаДок));
	ПараметрыФО = Новый Структура("Период, Судно", Период, Судно);
	
	Возврат Не рарусИмущественныйУчетСервер.ИспользоватьИмущественныйУчет(ПараметрыФО);
	
КонецФункции

&НаКлиенте
Процедура ПроверитьСообщитьВключенИмущественныйУчет()
	Если ЗначениеЗаполнено(Объект.Склад)
		И ИмущественныйУчетНеВключен(Объект.Дата, Объект.Склад) Тогда
		ПоказатьПредупреждение(, "Для судна выбранного склада не включен имущественный учёт. Движения сформированы не будут!",,"Внимание!");
	КонецЕсли;
КонецПроцедуры
// -- rarus makole 2021-01-29 

// ++ rarus makole 2021-03-30
&НаКлиенте
Процедура УстановитьДоступностьРедактированияИСтатусОтправки()
	
	Если НЕ vftОбщегоНазначенияВызовСервера.ЭтоГлавныйУзел() Тогда
		ТолькоПросмотр = Не ДоступноРедактирование(Объект.Ссылка) ИЛИ НЕ Объект.СформированСМ;
		Элементы.НадписьСтатус.Видимость = Истина;
		НадписьСтатус = ТекущийСтатусОтправки(Объект.Ссылка);
		Если НадписьСтатус = ПредопределенноеЗначение("Перечисление.рарусСостояниеОтправкиОбъекта.ЗарегистрированКОтправке") Тогда
			ПодключитьОбработчикОжидания("ПроверитьМодифицированность", 2, Ложь)
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоступноРедактирование(Ссылка)
	Возврат рарусСинхронизацияССудном.ОбъектМожноРедактироватьПоСтатусуОтправки(Ссылка);
КонецФункции

&НаСервереБезКонтекста
Функция ТекущийСтатусОтправки(Ссылка)
	Возврат РегистрыСведений.рарусСостоянияОтправкиОбъектов.ТекущийСтатусОбъекта(Ссылка);
КонецФункции

&НаКлиенте
Процедура ПроверитьМодифицированность() Экспорт
	// Пользователь может начать редактировать зарегистрированный документ, вернём его в статус "Черновик"
	// и удалим регистрацию
	Если Модифицированность Тогда
		рарусИмущественныйУчетВызовСервера.УстановитьСтатусЧерновик(Объект.Ссылка);
		НадписьСтатус = ПредопределенноеЗначение("Перечисление.рарусСостояниеОтправкиОбъекта.Черновик");
		// ++ rarus makole 2021-04-21 [Задача № 28685]
		ОповеститьОбИзменении(Объект.Ссылка);
		// -- rarus makole 2021-04-21 [Задача № 28685]
	КонецЕсли;
КонецПроцедуры
// -- rarus makole 2021-03-30

// ++ rarus makole 2021-06-30 [РАIT-0023374]
&НаСервереБезКонтекста
Функция НоменклатураВыдаётсяЭкипажу(ВыбранноеЗначение)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВыбранноеЗначение, "Категория, Категория.ВыдаетсяЭкипажу");
	
	Если ЗначениеЗаполнено(Реквизиты.Категория) Тогда
		Возврат Реквизиты.КатегорияВыдаетсяЭкипажу;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоНоваяНоменклатура(ВыбранноеЗначение)
	
	КачествоНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыбранноеЗначение, "Качество");
	Если ЗначениеЗаполнено(КачествоНоменклатуры) Тогда
		Если КачествоНоменклатуры = Перечисления.ГрадацииКачества.Новый Тогда
			Возврат ИСТИНА;
		Иначе 
			Возврат ЛОЖЬ;
		КонецЕсли;
	Иначе
		Возврат ЛОЖЬ;
	КонецЕсли;
	
КонецФункции
// ++ rarus makole 2021-06-30 [РАIT-0023374]

&НаСервереБезКонтекста
Функция СудноПоСкладу(Склад)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "Судно");
КонецФункции

#КонецОбласти

#Область Штрихкодирование
// ++ rarus yukuzi 25.02.2021   // ФТ.СНБ.02. Задача_Штрихкодирование
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
 рарусШтрихкодированиеКлиент.ВыполнитьКомандуШтрихкодирование(ЭтаФорма, ПолучитьИмяРеквизита(Команда.ИспользуемаяТаблица.Имя), Команда);
	
КонецПроцедуры
&НаСервере
Функция ПолучитьИмяРеквизита(ТаблицаФормыИмя)
Возврат рарусШтрихкодирование.ПолучитьИмяРеквизита(Элементы[ТаблицаФормыИмя].ПутьКДанным);
КонецФункции 
// -- rarus yukuzi 25.02.2021
#КонецОбласти
