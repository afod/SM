
#Область ОбработчикиСобытий

//Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
//	
//	Идентификатор = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИерархияТип")).ИдентификаторПользовательскойНастройки;
//	СтрокаПараметр = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор);
//	
//	Если СтрокаПараметр <> Неопределено И ЗначениеЗаполнено(СтрокаПараметр.Значение) Тогда
//		ТекИерархия = СтрокаПараметр.Значение;
//	Иначе
//		ТекИерархия = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
//			"НастройкиТОиР",
//			"ОсновнаяСтруктураИерархии",
//			Справочники.торо_СтруктурыОР.ПустаяСсылка());
//			
//		Если СтрокаПараметр <> Неопределено Тогда
//			СтрокаПараметр.Значение = ТекИерархия;
//		КонецЕсли;
//		
//	КонецЕсли;
//	
//	торо_ОтчетыСервер.УстановитьЗапросыНаборовДанныхИерархииОР(СхемаКомпоновкиДанных, ТекИерархия, "ДатаОкончания");
//	
//	Если ТекИерархия.СтроитсяАвтоматически Тогда
//				
//		СхемаКомпоновкиДанных.НаборыДанных.Объекты.Запрос =
//		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
//		|	торо_НаработкаОбъектовРемонта.Регистратор.Организация КАК Организация,
//		|	торо_НаработкаОбъектовРемонта.ОбъектРемонта КАК ОбъектРемонта,
//		|	торо_НаработкаОбъектовРемонта.Показатель КАК ПоказательНаработки,
//		|	ВЫБОР
//		|		КОГДА торо_НаработкаОбъектовРемонта.ДатаНач = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
//		|			ТОГДА торо_НаработкаОбъектовРемонта.ОбъектРемонта.ДатаВводаВЭксплуатацию
//		|		ИНАЧЕ торо_НаработкаОбъектовРемонта.ДатаНач
//		|	КОНЕЦ КАК НачалоПериода,
//		|	торо_НаработкаОбъектовРемонта.ДатаКон КАК ОкончаниеПериода,
//		|	торо_НаработкаОбъектовРемонта.Наработка КАК Наработка,
//		|	торо_НаработкаОбъектовРемонта.Период КАК Период,
//		|	торо_ОбъектыРемонта." + ТекИерархия.РеквизитОР + " КАК ОбъектИерархии
//		|ИЗ
//		|	РегистрНакопления.торо_НаработкаОбъектовРемонта КАК торо_НаработкаОбъектовРемонта
//		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
//		|		ПО торо_НаработкаОбъектовРемонта.ОбъектРемонта = торо_ОбъектыРемонта.Ссылка
//		|ГДЕ
//		|	торо_НаработкаОбъектовРемонта.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
//		|	И НЕ торо_НаработкаОбъектовРемонта.Регистратор.Организация ЕСТЬ NULL
//		|{ГДЕ
//		|	(торо_НаработкаОбъектовРемонта.Период МЕЖДУ &ДатаНачала И &ДатаОкончания)}";

//		торо_ОтчетыКлиентСервер.УстановитьТипИерархическойГруппировкиВНастройках(КомпоновщикНастроек, "ОбъектИерархии", ТипГруппировкиКомпоновкиДанных.Иерархия);
//		
//	Иначе

//		торо_ОтчетыКлиентСервер.УстановитьТипИерархическойГруппировкиВНастройках(КомпоновщикНастроек, "ОбъектИерархии", ТипГруппировкиКомпоновкиДанных.ТолькоИерархия);

//		СхемаКомпоновкиДанных.НаборыДанных.Объекты.Запрос = 
//		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
//		|	торо_НаработкаОбъектовРемонта.Регистратор.Организация КАК Организация,
//		|	торо_НаработкаОбъектовРемонта.ОбъектРемонта КАК ОбъектРемонта,
//		|	торо_НаработкаОбъектовРемонта.Показатель КАК ПоказательНаработки,
//		|	ВЫБОР
//		|		КОГДА торо_НаработкаОбъектовРемонта.ДатаНач = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
//		|			ТОГДА торо_НаработкаОбъектовРемонта.ОбъектРемонта.ДатаВводаВЭксплуатацию
//		|		ИНАЧЕ торо_НаработкаОбъектовРемонта.ДатаНач
//		|	КОНЕЦ КАК НачалоПериода,
//		|	торо_НаработкаОбъектовРемонта.ДатаКон КАК ОкончаниеПериода,
//		|	торо_НаработкаОбъектовРемонта.Наработка КАК Наработка,
//		|	торо_НаработкаОбъектовРемонта.Период КАК Период,
//		|	торо_ОбъектыРемонта.Ссылка КАК ОбъектИерархии
//		|ИЗ
//		|	РегистрНакопления.торо_НаработкаОбъектовРемонта КАК торо_НаработкаОбъектовРемонта
//		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.торо_ОбъектыРемонта КАК торо_ОбъектыРемонта
//		|		ПО торо_НаработкаОбъектовРемонта.ОбъектРемонта = торо_ОбъектыРемонта.Ссылка
//		|ГДЕ
//		|	торо_НаработкаОбъектовРемонта.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
//		|	И НЕ торо_НаработкаОбъектовРемонта.Регистратор.Организация ЕСТЬ NULL
//		|{ГДЕ
//		|	(торо_НаработкаОбъектовРемонта.Период МЕЖДУ &ДатаНачала И &ДатаОкончания)}";
//		
//	КонецЕсли;
//	
//КонецПроцедуры

#КонецОбласти
