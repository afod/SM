Функция КонтрольныйСимволEAN(ШтрихКод, Тип) Экспорт

	Четн   = 0;
	Нечетн = 0;

	КоличествоИтераций = ?(Тип = 13, 6, 4);

	Для Индекс = 1 По КоличествоИтераций Цикл
		Если (Тип = 8) И (Индекс = КоличествоИтераций) Тогда
		Иначе
			Четн   = Четн   + Сред(ШтрихКод, 2 * Индекс, 1);
		КонецЕсли;
		Нечетн = Нечетн + Сред(ШтрихКод, 2 * Индекс - 1, 1);
	КонецЦикла;

	Если Тип = 13 Тогда
		Четн = Четн * 3;
	Иначе
		Нечетн = Нечетн * 3;
	КонецЕсли;

	КонтЦифра = 10 - (Четн + Нечетн) % 10;

	Возврат ?(КонтЦифра = 10, "0", Строка(КонтЦифра));

КонецФункции
Функция ПолучитьШтрихкодПоКоду(Код) Экспорт
//для ШК в судовом модуле решили использовать 9 правых значащих цифр кода.
	// ++ rarus yukuzi 21.03.2021   // ФТ.СНБ.02. Задача_Штрихкодирование
	//Штрихкод = "200" + Прав(Формат(Код, "ЧЦ=9; ЧВН=; ЧГ="),9);
	Штрихкод=Прав("0000000000000000" + Формат(Код,"ЧГ=0"),12);
	// -- rarus yukuzi 21.03.2021
	
	Штрихкод = Штрихкод + КонтрольныйСимволEAN(ШтрихКод, 13);

	Возврат Штрихкод;

КонецФункции

Процедура ВыполнитьЗаполнениеШтрихкодов() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.рспбКодMDG КАК КодMDG
	|ПОМЕСТИТЬ втНоменклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	НЕ Номенклатура.рспбКодMDG = """"
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втНоменклатура.Ссылка КАК Ссылка,
	|	втНоменклатура.КодMDG КАК КодMDG
	|ИЗ
	|	втНоменклатура КАК втНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.рарусШтрихкодыНоменклатуры КАК рарусШтрихкодыНоменклатуры
	|		ПО втНоменклатура.Ссылка = рарусШтрихкодыНоменклатуры.Номенклатура
	|ГДЕ
	|	рарусШтрихкодыНоменклатуры.Номенклатура ЕСТЬ NULL";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаписатьШтрихкод(ВыборкаДетальныеЗаписи.КодMDG,ВыборкаДетальныеЗаписи.Ссылка );
		
	КонецЦикла;


КонецПроцедуры
Процедура ЗаписатьШтрихкод(КодMDG, Номенклатура)

	Штрихкод = ПолучитьШтрихкодПоКоду(КодMDG);
	НовыйШтрихкод = РегистрыСведений.рарусШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
	НовыйШтрихкод.Номенклатура = Номенклатура; 
	НовыйШтрихкод.Штрихкод = Штрихкод;
	Попытка
		НовыйШтрихкод.Записать();
	Исключение
		ОписаниеОшибки = НСтр("ru = 'При записи штрихкода произошла ошибка.
		|Запись штрихкода не выполнена.
		|Дополнительное описание:
		|%ДополнительноеОписание%';
		|en = 'An error occurred while writing barcode.
		|Barcode is not written.
		|Additional description:
		|%ДополнительноеОписание%'");
		ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%ДополнительноеОписание%", ИнформацияОбОшибке().Описание);
		
	КонецПопытки;


КонецПроцедуры
Процедура ЗаполнениеШтрихкодовПоКодамMDG() Экспорт
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.рарусЗаполнениеШтрихкодовПоКодамMDG);
	Если не vftОбщегоНазначения.ЭтоГлавныйУзел() Тогда
		ВызватьИсключение НСтр("ru = 'Регламентное задание доступно только в главном узле.'");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("рарусИспользоватьШтрихкодирование") тогда

		ВыполнитьЗаполнениеШтрихкодов();	
	КонецЕсли;	
			
КонецПроцедуры
Функция ПолучитьНоменклатуруПоШтрихкодам(ТаблицаШтрихкоды) Экспорт
	
		
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаШтрихкоды.Штрихкод КАК СТРОКА(200)) КАК Штрихкод,
	|	ТаблицаШтрихкоды.Количество КАК Количество
	|ПОМЕСТИТЬ ТаблицаШтрихкоды
	|ИЗ
	|	&ТаблицаШтрихкоды КАК ТаблицаШтрихкоды
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Штрихкод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаШтрихкоды.Штрихкод КАК Штрихкод,
	|	ТаблицаШтрихкоды.Количество КАК Количество,
	|	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура,
	|	ШтрихкодыНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	ТаблицаШтрихкоды КАК ТаблицаШтрихкоды
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.рарусШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО (ШтрихкодыНоменклатуры.Штрихкод = ТаблицаШтрихкоды.Штрихкод)";
	
	Запрос.УстановитьПараметр("ТаблицаШтрихкоды", ТаблицаШтрихкоды);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	НеизвестныеШтрихкоды = Новый Массив;
	
	//ТаблицаНоменклатура = УстановкаЦенСервер.СоздатьТаблицуНоменклатуры();
	ТаблицаНоменклатура=Новый ТаблицаЗначений;
	ТаблицаНоменклатура.Колонки.Добавить("Номенклатура");
	ТаблицаНоменклатура.Колонки.Добавить("Количество");
	ТаблицаНоменклатура.Колонки.Добавить("ЕдиницаИзмерения");
	// ++ rarus yukuzi 25.02.2021   // ФТ.СНБ.02. Задача_Штрихкодирование
	ТаблицаНоменклатура.Колонки.Добавить("КоличествоУпаковок");
	ТаблицаНоменклатура.Колонки.Добавить("КоличествоВыдано");
	ТаблицаНоменклатура.Колонки.Добавить("КоличествоНаСкладеФакт");
	// -- rarus yukuzi 25.02.2021

	
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Номенклатура) тогда
			НоваяСтрока = ТаблицаНоменклатура.Добавить();
			ЗаполнитьЗначенияСвойств( НоваяСтрока,Выборка);
			// ++ rarus yukuzi 25.02.2021   // ФТ.СНБ.02. Задача_Штрихкодирование
			НоваяСтрока.КоличествоУпаковок= НоваяСтрока.Количество;
			НоваяСтрока.КоличествоВыдано= НоваяСтрока.Количество;
			НоваяСтрока.КоличествоНаСкладеФакт= НоваяСтрока.Количество;
			// -- rarus yukuzi 25.02.2021

		Иначе
		 ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не найдена номенклатура по штрихкоду "+Выборка.Штрихкод);
		КонецЕсли;
				
	КонецЦикла;
	
		
	Возврат Новый Структура(
		"ТаблицаНоменклатура",
		ТаблицаНоменклатура);
	
КонецФункции
Функция ОбработатьШтрихкоды(ДанныеШтрихкодов) Экспорт
	   ТаблицаШтрихкодов = Новый ТаблицаЗначений;
		ТаблицаШтрихкодов.Колонки.Добавить("Штрихкод", Новый ОписаниеТипов("Строка"));
		ТаблицаШтрихкодов.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));

	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда	
		Для каждого элМассива Из ДанныеШтрихкодов Цикл
			новСтрока=ТаблицаШтрихкодов.Добавить();
			ЗаполнитьЗначенияСвойств(новСтрока,элМассива);			
		КонецЦикла;
	ИначеЕсли ТипЗнч(ДанныеШтрихкодов) = Тип("Строка")  Тогда 
		новСтрока=ТаблицаШтрихкодов.Добавить();
		// ++ rarus yukuzi 21.03.2021   // ФТ.СНБ.02. Задача_Штрихкодирование
		 ДанныеШтрихкодов=Прав("0000000000000000" + Формат(ДанныеШтрихкодов,"ЧГ=0"),13);
		// -- rarus yukuzi 21.03.2021
		
		новСтрока.Штрихкод=ДанныеШтрихкодов;
	КонецЕсли;
	
	ТаблицаШтрихкодов.Свернуть("Штрихкод","Количество"); 
	ТаблицаНоменклатура=ПолучитьНоменклатуруПоШтрихкодам(ТаблицаШтрихкодов).ТаблицаНоменклатура;	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаНоменклатура);

КонецФункции
Процедура ДобавитьЭлементыШтрихкодированияНаФорму(Форма) Экспорт
    Судно=неопределено;
	Если  ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") И Форма.Объект.Свойство("Ссылка")  тогда 
		Если Форма.Объект.Свойство("Подразделение")
			тогда
			Судно=Форма.Объект.Подразделение;
		ИначеЕсли  Форма.Объект.Свойство("Склад")
			тогда
			Судно=Форма.Объект.Склад.Судно;
		ИначеЕсли  Форма.Объект.Свойство("СкладПолучатель")
			тогда
			Судно=Форма.Объект.СкладПолучатель;
	
		КонецЕсли;
	КонецЕсли;
	Если не ЗначениеЗаполнено(Судно) тогда
		Судно=vftОбщегоНазначения.ПолучитьЗначениеПоУмолчанию("ОсновноеСудно");
	КонецЕсли;
	Если ЗначениеЗаполнено(Судно) тогда
		ПараметрыФО= Новый Структура("Период, Судно", ТекущаяДата(), Судно);
	иначе
		ПараметрыФО= Новый Структура("Период", ТекущаяДата());
	КонецЕсли;
	Если не  ПолучитьФункциональнуюОпцию("рарусИспользоватьШтрихкодирование",  ПараметрыФО) тогда
		Возврат;
	КонецЕсли;

	
	//Если не (ЗначениеЗаполнено(Судно) и ПолучитьФункциональнуюОпцию("рарусИспользоватьШтрихкодирование",  Новый Структура("Период, Судно", ТекущаяДата(), Судно))) тогда
	//	 Возврат;
	//КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
		И Форма.Объект.Свойство("Ссылка")  
		и ЕстьРеквизитТабЧастиДокумента("Номенклатура", Форма.РеквизитФормыВЗначение("Объект").Метаданные())
		Тогда
		
		МассивИменТЧ=ИменаТЧСодержащихРеквизит("Номенклатура", Форма.РеквизитФормыВЗначение("Объект").Метаданные());
		Для каждого элМассива Из МассивИменТЧ Цикл
			имяЭлементаФормы=ИмяКППоИмениТЧ(элМассива, Форма);
			ИмяКП= имяЭлементаФормы+"КоманднаяПанель";
			Если  не ИмяКП="" тогда
				РазмещениеКоманды=Форма.Элементы[ИмяКП];
				//поиск по ШК
				//ИмяКоманды = "Штрихкодирование_ПоискПоШтрихкоду";
				ИмяКоманды = "Штрихкодирование_ПоискПоШтрихкоду"+"_"+имяЭлементаФормы;

				КомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
				КомандаФормы.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду"; // универсальный обработчик
				КомандаФормы.Подсказка = "Поиск по штрихкоду";
				КомандаФормы.ИспользуемаяТаблица = Форма.Элементы[имяЭлементаФормы];
				
				ЭлементКомандыФормы = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), РазмещениеКоманды);
				ЭлементКомандыФормы.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
				ЭлементКомандыФормы.ИмяКоманды = ИмяКоманды;
				ЭлементКомандыФормы.Картинка = БиблиотекаКартинок.НовыйПоШтрихкоду;
				
				//загрузка из ТСД
				//ИмяКоманды = "Штрихкодирование_ЗагрузитьДанныеИзТСД";
				ИмяКоманды = "Штрихкодирование_ЗагрузитьДанныеИзТСД"+"_"+имяЭлементаФормы;
				
				КомандаФормы = Форма.Команды.Добавить(ИмяКоманды);
				КомандаФормы.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду"; // универсальный обработчик
				КомандаФормы.Подсказка = "Загрузка данных из ТСД";
				КомандаФормы.ИспользуемаяТаблица = Форма.Элементы[имяЭлементаФормы];

				ЭлементКомандыФормы = Форма.Элементы.Добавить(ИмяКоманды, Тип("КнопкаФормы"), РазмещениеКоманды);
				ЭлементКомандыФормы.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели;
				ЭлементКомандыФормы.ИмяКоманды = ИмяКоманды;
				ЭлементКомандыФормы.Картинка = БиблиотекаКартинок.ПодключаемоеОборудованиеТерминалСбораДанных16;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	

КонецПроцедуры

Функция ЕстьРеквизитТабЧастиДокумента(ИмяРеквизита, МетаданныеДокумента)
	ЕстьРеквизит=Ложь;
	ТабЧасти = МетаданныеДокумента.ТабличныеЧасти;
	Для каждого ТабЧасть Из ТабЧасти Цикл
		Если ТабЧасть.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
			//Возврат Ложь;
		Иначе
			ЕстьРеквизит=Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат ЕстьРеквизит;
КонецФункции 
Функция ИмяКППоИмениТЧ(ИмяТЧ, Форма)
	Для каждого ЭлФормы Из Форма.Элементы Цикл
			   Если ТипЗнч(ЭлФормы)=Тип("ТаблицаФормы") и ЭлФормы.ПутьКДанным="Объект."+ ИмяТЧ и Не ЭлФормы.ПоложениеКоманднойПанели=ПоложениеКоманднойПанелиФормы.Нет тогда
			 Возврат ЭлФормы.Имя;
		Конецесли;	
		
	КонецЦикла;	
	Возврат "";

КонецФункции // ()
Функция ПолучитьИмяРеквизита(ПутьКДанным) Экспорт
	//Выделяем имя ТЧ из пути к данным
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПутьКДанным, ".");
	Если МассивПодстрок.Количество() = 2 Тогда
		Возврат МассивПодстрок[1] ;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции 
Функция ИменаТЧСодержащихРеквизит(ИмяРеквизита, МетаданныеДокумента)
	МассивИменТЧ=Новый Массив;
	ТабЧасти = МетаданныеДокумента.ТабличныеЧасти;
	Для каждого ТабЧасть Из ТабЧасти Цикл
		Если не ТабЧасть.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
			МассивИменТЧ.Добавить(ТабЧасть.Имя);
		КонецЕсли;
	
	КонецЦикла;
	Возврат  МассивИменТЧ;
	
КонецФункции 
Функция СформироватьПечатнуюФормуЭтикетка( ТаблицаДанных, ИмяМакета, ПечатьНаТермопринтере=Ложь, ОтображатьКоличество=Ложь) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	
	// ++ rarus yukuzi 24.03.2021   // ФТ.СНБ.02. Задача_Штрихкодирование
	Если ПечатьНаТермопринтере тогда
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		ТабличныйДокумент.ПолеСверху = 2;
		ТабличныйДокумент.ПолеСлева = 2;
		ТабличныйДокумент.ПолеСнизу = 2;
		ТабличныйДокумент.ПолеСправа = 2;
		ТабличныйДокумент.АвтоМасштаб=Истина;
	КонецЕсли;	
	ТабличныйДокумент.КлючПараметровПечати = ?(ПечатьНаТермопринтере,"ПАРАМЕТРЫ_ПЕЧАТИ_ЭтикеткиШК_ПечатьНаТермопринтере", "ПАРАМЕТРЫ_ПЕЧАТИ_ЭтикеткиШК_ПечатьА4");
	// -- rarus yukuzi 24.03.2021

	Макет = УправлениеПечатью.МакетПечатнойФормы(ИмяМакета);
	ПервыйДокумент = Истина;
	МассивВыводимыхОбластей=новый Массив;
	
	//Выборка = ДанныеДляПечатиЭтикетки(МассивОбъектов, ОтображатьКоличество);
	//	МодульМенеджера=ОбщегоНазначения.МенеджерОбъектаПоСсылке(МассивОбъектов[0]);
	//	Выборка = МодульМенеджера.ДанныеДляПечатиЭтикетки(МассивОбъектов, ОтображатьКоличество);
	//
	
	//Пока Выборка.Следующий() Цикл
	Для каждого стрТЗ Из ТаблицаДанных Цикл
			
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Область = Макет.ПолучитьОбласть("Этикетка");
		
		Область.Параметры.Заполнить(стрТЗ);
		
		
		ВывестиШтрихкодВТабличныйДокумент(
		Область,
		стрТЗ.Штрихкод);
		Для Инд = 1 По стрТЗ.КоличествоПечати Цикл // Цикл по количеству экземпляров
			Если не ПечатьНаТермопринтере тогда
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(Область);

				Если ПервыйДокумент тогда
					ТабличныйДокумент.Вывести(Область);
					ПервыйДокумент=Ложь
				ИначеЕсли ТабличныйДокумент.ПроверитьПрисоединение(МассивВыводимыхОбластей) тогда
					
					ТабличныйДокумент.Присоединить(Область);
				иначеЕсли ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) тогда 
					ТабличныйДокумент.Вывести(Область);
				Иначе
					 ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					 ТабличныйДокумент.Вывести(Область);

				КонецЕсли;
			Иначе ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				   ТабличныйДокумент.Вывести(Область);

			КонецЕсли;
					
			
			
		   		
		КонецЦикла; // Цикл по количеству экземпляров
	//	
	
	КонецЦикла;
	//
		
	
	Возврат ТабличныйДокумент;
	
КонецФункции
Процедура ВывестиШтрихкодВТабличныйДокумент( Знач ОбластьМакета, Штрихкод) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Эталон = Справочники.ПодключаемоеОборудование.ПолучитьМакет("МакетДляОпределенияКоэффициентовЕдиницИзмерения");
	
	КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
	
	Рисунок=ОбластьМакета.Рисунки.КартинкаШтрихкода; 
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина",          Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе));
	ПараметрыШтрихкода.Вставить("Высота",          Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе));
	ПараметрыШтрихкода.Вставить("Штрихкод",        Штрихкод);
	
	ПараметрыШтрихкода.Вставить("ТипКода",         4); // Code128
	ПараметрыШтрихкода.Вставить("ОтображатьТекст", Истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта",    11);
	

	Рисунок.Картинка = ?(Штрихкод="", Новый Картинка(), МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода));
КонецПроцедуры

Процедура ПараметрыЗапросаПоДопреквизитам(Запрос) Экспорт
	СписокСвойствКаталожныйНомер=Новый СписокЗначений;
	СписокСвойствКаталожныйНомер.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Каталожный номер"));
	СписокСвойствКаталожныйНомер.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Оригинальный каталожный номер"));
	СписокСвойствКаталожныйНомер.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Каталожный номер (марка) приво"));
	СписокСвойствКаталожныйНомер.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Каталожный номер (множ.)"));
	
	СписокСвойствМодель=Новый СписокЗначений;
	СписокСвойствМодель.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Модель(обозначение) ЗИП"));
	
	СписокСвойствПроизводитель=Новый СписокЗначений;
	СписокСвойствПроизводитель.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Производитель"));
	СписокСвойствПроизводитель.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Производитель ЗИП"));
	СписокСвойствПроизводитель.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Производитель оборудования"));
	СписокСвойствПроизводитель.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Производитель СЗЧ"));
	СписокСвойствПроизводитель.Добавить(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Производитель СЗЧ (множ.)"));
	
	
	Запрос.УстановитьПараметр("СвойствоКаталожныйНомер", СписокСвойствКаталожныйНомер);
	Запрос.УстановитьПараметр("СвойствоМодель", СписокСвойствМодель);
	Запрос.УстановитьПараметр("СвойствоПроизводитель", СписокСвойствПроизводитель);

	

КонецПроцедуры

// ТСД
Функция Тест() Экспорт
	ТаблицаШтрихкодов = Новый ТаблицаЗначений;
	ТаблицаШтрихкодов.Колонки.Добавить("Штрихкод", Новый ОписаниеТипов("Строка"));
	ТаблицаШтрихкодов.Колонки.Добавить("Количество", Новый ОписаниеТипов("Число"));
	новСтр=ТаблицаШтрихкодов.Добавить();
	новСтр.Штрихкод="2001000208029";
	новСтр.Количество=8;
	новСтр=ТаблицаШтрихкодов.Добавить();
	новСтр.Штрихкод="2001000388066";
	новСтр.Количество=3;
	РезультатВыполнения=новый Структура;
	РезультатВыполнения.Вставить("Результат", Истина);
	РезультатВыполнения.Вставить("ТаблицаТоваров", ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаШтрихкодов));
	
	Возврат РезультатВыполнения;
	

КонецФункции // ()
