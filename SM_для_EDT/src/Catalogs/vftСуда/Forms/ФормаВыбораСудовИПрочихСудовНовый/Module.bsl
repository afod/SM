
&НаКлиенте
Процедура СписокСудовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Выбрать(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ВыбранноеЗначение = Неопределено;
	ТекСтрока = Элементы.СписокСудов.ТекущиеДанные;
	Если ТекСтрока <> Неопределено Тогда
		ВыбранноеЗначение = ТекСтрока.Ссылка;
	КонецЕсли;
	
	ЗакрытьФорму(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(ВыбранноеЗначение)
	ЭтаФорма.Закрыть(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьСписокПапок();
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьСписокПапок()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	vftСуда.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.vftСуда КАК vftСуда
	|ГДЕ
	|	vftСуда.ЭтоГруппа
	|ИТОГИ ПО
	|	Ссылка ТОЛЬКО ИЕРАРХИЯ";
	
	ВыборкаСИерархией = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	мСписокПапокСудов = РеквизитФормыВЗначение("СписокПапокСудов");
	мСписокПапокСудов.Строки.Очистить();
	//Верх родитель
	Строка=мСписокПапокСудов.Строки.Добавить();
	Строка.Ссылка="Суда";
	
	//Суда
	ВыбратьЭлементыВИерархии(ВыборкаСИерархией, Строка);
	
	//Прочие суда
	Строка=Строка.Строки.Добавить();
	Строка.Ссылка="Прочие суда";
	
	ЗначениеВРеквизитФормы(мСписокПапокСудов, "СписокПапокСудов");
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьЭлементыВИерархии(ВыборкаСИерархией, мСписокПапокСудов)
	Пока ВыборкаСИерархией.Следующий() Цикл
		Если ВыборкаСИерархией.ТипЗаписи()=ТипЗаписиЗапроса.ИтогПоИерархии Тогда
			Строка=мСписокПапокСудов.Строки.Добавить();
			Строка.Ссылка=ВыборкаСИерархией.Ссылка;
			Если ВыборкаСИерархией.Ссылка.ПометкаУдаления Тогда
				Строка.Картинка = 1;
			КонецЕсли;
			ВыбратьЭлементыВИерархии (ВыборкаСИерархией.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией,"Ссылка"),Строка);
		ИначеЕсли ВыборкаСИерархией.ТипЗаписи()=ТипЗаписиЗапроса.ИтогПоГруппировке Тогда
			Если Не ЗначениеЗаполнено(ВыборкаСИерархией.Ссылка) ИЛИ ТипЗнч(мСписокПапокСудов)=Тип("СтрокаДереваЗначений") И ВыборкаСИерархией.Ссылка=мСписокПапокСудов.Ссылка Тогда
				ВыбратьЭлементыБезИерархии(ВыборкаСИерархией.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам),мСписокПапокСудов);
			Иначе
				Строка=мСписокПапокСудов.Строки.Добавить();
				Строка.Ссылка=ВыборкаСИерархией.Ссылка;
				Если ВыборкаСИерархией.Ссылка.ПометкаУдаления Тогда
					Строка.Картинка = 1;
				КонецЕсли;
				ВыбратьЭлементыБезИерархии(ВыборкаСИерархией.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам), Строка);
			КонецЕсли;
		КонецЕсли;   
	КонецЦикла;	
КонецПроцедуры

&НаСервере
Процедура ВыбратьЭлементыБезИерархии (ВыборкаБезИерархии, Дерево)
	Пока ВыборкаБезИерархии.Следующий() Цикл
		Если Дерево.Ссылка <> ВыборкаБезИерархии.Ссылка Тогда
			Строка=Дерево.Строки.Добавить();
			Строка.Ссылка=ВыборкаБезИерархии.Ссылка;
			Если ВыборкаБезИерархии.Ссылка.ПометкаУдаления Тогда
				Строка.Картинка = 1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВывестиДинамическийСписок();
КонецПроцедуры

&НаКлиенте
Процедура СписокПапокСудовПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_СписокПапокСудовПриАктивизацииСтроки", 0.1, Истина);ВывестиДинамическийСписок();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СписокПапокСудовПриАктивизацииСтроки()
	ВывестиДинамическийСписок();      
КонецПроцедуры
   
&НаКлиенте
Процедура ВывестиДинамическийСписок()
	
	ЭлементыСписокПапокСудов = СписокПапокСудов.ПолучитьЭлементы();	
	Если ЭлементыСписокПапокСудов.Количество() Тогда
		Элементы.СписокПапокСудов.Развернуть(ЭлементыСписокПапокСудов[0].ПолучитьИдентификатор());
	КонецЕсли;
	
	ТекДанные = Элементы.СписокПапокСудов.ТекущиеДанные;
	Родитель = ПредопределенноеЗначение("Справочник.vftСуда.ПустаяСсылка");
	
	Если ТекДанные <> Неопределено Тогда
		Родитель = ТекДанные.Ссылка;	
	КонецЕсли;
	
	ЭтоВерхнийРодитель = Родитель = "Суда";
	ЭтоПрочиеСуда = ТипЗнч(Родитель) = Тип("Строка") И НЕ ЭтоВерхнийРодитель;
	
	УстановитьТекстЗапроса(ЭтоВерхнийРодитель, ЭтоПрочиеСуда, Родитель);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстЗапроса(ЭтоВерхнийРодитель, ЭтоПрочиеСуда, Родитель)
	
	Если ЭтоВерхнийРодитель Тогда
		СписокСудов.ТекстЗапроса = "ВЫБРАТЬ
		|	СправочникvftСуда.Ссылка КАК Ссылка,
		|	СправочникvftСуда.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникvftСуда.Родитель КАК Родитель,
		|	СправочникvftСуда.ЭтоГруппа КАК ЭтоГруппа,
		|	СправочникvftСуда.Код КАК Код,
		|	СправочникvftСуда.Наименование КАК Наименование,
		|	СправочникvftСуда.Предопределенный КАК Предопределенный,
		|	СправочникvftСуда.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА СправочникvftСуда.ПометкаУдаления
		|			ТОГДА 4
		|		КОГДА СправочникvftСуда.Предопределенный
		|			ТОГДА 5
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК Картинка
		|ИЗ
		|	Справочник.vftСуда КАК СправочникvftСуда
		|ГДЕ
		|	НЕ СправочникvftСуда.ЭтоГруппа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СправочникрарусПрочиеСуда.Ссылка,
		|	СправочникрарусПрочиеСуда.ПометкаУдаления,
		|	СправочникрарусПрочиеСуда.Ссылка,
		|	ЛОЖЬ,
		|	СправочникрарусПрочиеСуда.Код,
		|	СправочникрарусПрочиеСуда.Наименование,
		|	СправочникрарусПрочиеСуда.Предопределенный,
		|	СправочникрарусПрочиеСуда.ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА СправочникрарусПрочиеСуда.ПометкаУдаления
		|			ТОГДА 4
		|		КОГДА СправочникрарусПрочиеСуда.Предопределенный
		|			ТОГДА 5
		|		ИНАЧЕ 3
		|	КОНЕЦ
		|ИЗ
		|	Справочник.рарусПрочиеСуда КАК СправочникрарусПрочиеСуда";
		СписокСудов.ОсновнаяТаблица = "";
	
	ИначеЕсли ЭтоПрочиеСуда Тогда
		СписокСудов.ТекстЗапроса = "ВЫБРАТЬ
		|	СправочникрарусПрочиеСуда.Ссылка КАК Ссылка,
		|	СправочникрарусПрочиеСуда.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникрарусПрочиеСуда.Ссылка КАК Родитель,
		|	ЛОЖЬ КАК ЭтоГруппа,
		|	СправочникрарусПрочиеСуда.Код КАК Код,
		|	СправочникрарусПрочиеСуда.Наименование КАК Наименование,
		|	СправочникрарусПрочиеСуда.Предопределенный КАК Предопределенный,
		|	СправочникрарусПрочиеСуда.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА СправочникрарусПрочиеСуда.ПометкаУдаления
		|			ТОГДА 4
		|		КОГДА СправочникрарусПрочиеСуда.Предопределенный
		|			ТОГДА 5
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК Картинка
		|ИЗ
		|	Справочник.рарусПрочиеСуда КАК СправочникрарусПрочиеСуда";
	    СписокСудов.ОсновнаяТаблица = "Справочник.рарусПрочиеСуда";
	Иначе
	
		СписокСудов.ТекстЗапроса = "ВЫБРАТЬ
		|	СправочникvftСуда.Ссылка КАК Ссылка,
		|	СправочникvftСуда.ПометкаУдаления КАК ПометкаУдаления,
		|	СправочникvftСуда.Родитель КАК Родитель,
		|	СправочникvftСуда.ЭтоГруппа КАК ЭтоГруппа,
		|	СправочникvftСуда.Код КАК Код,
		|	СправочникvftСуда.Наименование КАК Наименование,
		|	СправочникvftСуда.Предопределенный КАК Предопределенный,
		|	СправочникvftСуда.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
		|	ВЫБОР
		|		КОГДА СправочникvftСуда.ПометкаУдаления
		|			ТОГДА 4
		|		КОГДА СправочникvftСуда.Предопределенный
		|			ТОГДА 5
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК Картинка
		|ИЗ
		|	Справочник.vftСуда КАК СправочникvftСуда
		|ГДЕ
		|	НЕ СправочникvftСуда.ЭтоГруппа
		|	И СправочникvftСуда.Ссылка В ИЕРАРХИИ(&Родитель)";
	    СписокСудов.ОсновнаяТаблица = "Справочник.vftСуда";
		СписокСудов.Параметры.УстановитьЗначениеПараметра("Родитель", Родитель);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьСписокВыбораСудов" Тогда
		ПодготовитьСписокПапок();
		ВывестиДинамическийСписок();
	КонецЕсли;
КонецПроцедуры




