///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет соответствие ИНН требованиям.
//
// Параметры:
//  ИНН                - Строка - проверяемый индивидуальный номер налогоплательщика.
//  ЭтоЮридическоеЛицо - Булево - признак, является ли владелец ИНН юридическим лицом.
//  ТекстСообщения     - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция ИННСоответствуетТребованиям(Знач ИНН, ЭтоЮридическоеЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ИНН      = СокрЛП(ИНН);
	ДлинаИНН = СтрДлина(ИНН);

	Если ЭтоЮридическоеЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца ИНН.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ИНН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'ИНН должен состоять только из цифр.'");
	КонецЕсли;

	Если  ЭтоЮридическоеЛицо И ДлинаИНН <> 10 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'ИНН юридического лица должен состоять из 10 цифр.'");
	ИначеЕсли НЕ ЭтоЮридическоеЛицо И ДлинаИНН <> 12 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
			+ НСтр("ru = 'ИНН физического лица должен состоять из 12 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда

		Если ЭтоЮридическоеЛицо Тогда

			КонтрольнаяСумма = 0;

			Для Индекс = 1 По 9 Цикл

				Если Индекс = 1 Тогда
					Множитель = 2;
				ИначеЕсли Индекс = 2 Тогда
					Множитель = 4;
				ИначеЕсли Индекс = 3 Тогда
					Множитель = 10;
				ИначеЕсли Индекс = 4 Тогда
					Множитель = 3;
				ИначеЕсли Индекс = 5 Тогда
					Множитель = 5;
				ИначеЕсли Индекс = 6 Тогда
					Множитель = 9;
				ИначеЕсли Индекс = 7 Тогда
					Множитель = 4;
				ИначеЕсли Индекс = 8 Тогда
					Множитель = 6;
				ИначеЕсли Индекс = 9 Тогда
					Множитель = 8;
				КонецЕсли;

				Цифра = Число(Сред(ИНН, Индекс, 1));
				КонтрольнаяСумма = КонтрольнаяСумма + Цифра * Множитель;

			КонецЦикла;
			
			КонтрольныйРазряд = (КонтрольнаяСумма %11) %10;

			Если КонтрольныйРазряд <> Число(Сред(ИНН, 10, 1)) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ИНН не совпадает с рассчитанным.'");
			КонецЕсли;

		Иначе

			КонтрольнаяСумма11 = 0;
			КонтрольнаяСумма12 = 0;

			Для Индекс = 1 По 11 Цикл

				// Расчет множителя для 11-го и 12-го разрядов.
				Если Индекс = 1 Тогда
					Множитель11 = 7;
					Множитель12 = 3;
				ИначеЕсли Индекс = 2 Тогда
					Множитель11 = 2;
					Множитель12 = 7;
				ИначеЕсли Индекс = 3 Тогда
					Множитель11 = 4;
					Множитель12 = 2;
				ИначеЕсли Индекс = 4 Тогда
					Множитель11 = 10;
					Множитель12 = 4;
				ИначеЕсли Индекс = 5 Тогда
					Множитель11 = 3;
					Множитель12 = 10;
				ИначеЕсли Индекс = 6 Тогда
					Множитель11 = 5;
					Множитель12 = 3;
				ИначеЕсли Индекс = 7 Тогда
					Множитель11 = 9;
					Множитель12 = 5;
				ИначеЕсли Индекс = 8 Тогда
					Множитель11 = 4;
					Множитель12 = 9;
				ИначеЕсли Индекс = 9 Тогда
					Множитель11 = 6;
					Множитель12 = 4;
				ИначеЕсли Индекс = 10 Тогда
					Множитель11 = 8;
					Множитель12 = 6;
				ИначеЕсли Индекс = 11 Тогда
					Множитель11 = 0;
					Множитель12 = 8;
				КонецЕсли;

				Цифра = Число(Сред(ИНН, Индекс, 1));
				КонтрольнаяСумма11 = КонтрольнаяСумма11 + Цифра * Множитель11;
				КонтрольнаяСумма12 = КонтрольнаяСумма12 + Цифра * Множитель12;

			КонецЦикла;

			КонтрольныйРазряд11 = (КонтрольнаяСумма11 %11) %10;
			КонтрольныйРазряд12 = (КонтрольнаяСумма12 %11) %10;

			Если КонтрольныйРазряд11 <> Число(Сред(ИНН,11,1)) ИЛИ КонтрольныйРазряд12 <> Число(Сред(ИНН,12,1)) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ИНН не совпадает с рассчитанным.'");
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие КПП требованиям.
// Согласно приложению к приказу ФНС России от 29.06.2012 N ММВ-7-6/435@
// "Об утверждении Порядка и условий присвоения, применения, а также изменения
// идентификационного номера налогоплательщика".
//
// Параметры:
//  КПП            - Строка - проверяемый код причины постановки на учет.
//  ТекстСообщения - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция КППСоответствуетТребованиям(Знач КПП, ТекстСообщения) Экспорт

	Ошибки = Новый Массив;
	КПП = СокрЛП(КПП);
	
	Если СтрДлина(КПП) <> 9 Тогда
		Ошибки.Добавить(НСтр("ru = 'КПП должен состоять из 9 символов.'"));
	Иначе
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Лев(КПП, 4)) Тогда
			Ошибки.Добавить(НСтр("ru = 'Первые 4 символа КПП (код налогового органа) должны быть цифрами.'"));
		КонецЕсли;
		
		ДопустимыеСимволы = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		Для НомерСимвола = 5 По 6 Цикл
			Символ = Сред(КПП, НомерСимвола, 1);
			Если СтрНайти(ДопустимыеСимволы, Символ) = 0 Тогда
				Ошибки.Добавить(НСтр("ru = 'Символы 5-6 КПП (причина постановки на учет) должны быть цифрами и/или заглавными буквами латинского алфавита от A до Z.'"));
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Прав(КПП, 3)) Тогда
			Ошибки.Добавить(НСтр("ru = 'Последние 3 символа КПП (порядковый номер постановки на учет) должны быть цифрами.'"));
		КонецЕсли;
	КонецЕсли;
	
	ТекстСообщения = СтрСоединить(Ошибки, Символы.ПС);
	
	Возврат Ошибки.Количество() = 0;

КонецФункции

// Проверяет соответствие ОГРН требованиям.
//
// Параметры:
//  ОГРН               - Строка - проверяемый основной государственный регистрационный номер.
//  ЭтоЮридическоеЛицо - Булево - признак, является ли владелец ОГРН юридическим лицом.
//  ТекстСообщения     - Строка - текст сообщения о найденных ошибках.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция ОГРНСоответствуетТребованиям(Знач ОГРН, ЭтоЮридическоеЛицо, ТекстСообщения) Экспорт

	СоответствуетТребованиям = Истина;
	ТекстСообщения = "";

	ОГРН = СокрЛП(ОГРН);
	ДлинаОГРН = СтрДлина(ОГРН);
	
	Если ЭтоЮридическоеЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца ОГРН.'");
		Возврат Ложь;
	КонецЕсли;

	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ОГРН) Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'ОГРН должен состоять только из цифр.'")
	КонецЕсли;

	Если ЭтоЮридическоеЛицо И ДлинаОГРН <> 13 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ОГРН юридического лица должен состоять из 13 цифр.'");
	ИначеЕсли НЕ ЭтоЮридическоеЛицо И ДлинаОГРН <> 15 Тогда
		СоответствуетТребованиям = Ложь;
		ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
		               + НСтр("ru = 'ОГРН физического лица должен состоять из 15 цифр.'");
	КонецЕсли;

	Если СоответствуетТребованиям Тогда

		Если ЭтоЮридическоеЛицо Тогда

			КонтрольныйРазряд = Прав(Формат(Число(Лев(ОГРН, 12)) % 11, "ЧН=0; ЧГ=0"), 1);

			Если КонтрольныйРазряд <> Прав(ОГРН, 1) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ОГРН не совпадает с рассчитанным.'");
			КонецЕсли;

		Иначе

			КонтрольныйРазряд = Прав(Формат(Число(Лев(ОГРН, 14)) % 13, "ЧН=0; ЧГ=0"), 1);

			Если КонтрольныйРазряд <> Прав(ОГРН, 1) Тогда
				СоответствуетТребованиям = Ложь;
				ТекстСообщения = ТекстСообщения + ?(ЗначениеЗаполнено(ТекстСообщения), Символы.ПС, "")
				               + НСтр("ru = 'Контрольное число для ОГРН не совпадает с рассчитанным.'");
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат СоответствуетТребованиям;

КонецФункции 

// Проверяет соответствие кода ОКПО требованиям стандартов.
//
// Параметры:
//  ПроверяемыйКод         - Строка - проверяемый код ОКПО;
//  ЭтоЮридическоеЛицо     - Булево - признак, является ли владелец кода ОКПО юридическим лицом;
//  ТекстСообщения         - Строка - текст сообщения о найденных ошибках в проверяемом коде ОКПО.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция КодПоОКПОСоответствуетТребованиям(Знач ПроверяемыйКод, ЭтоЮридическоеЛицо, ТекстСообщения = "") Экспорт
	
	ПроверяемыйКод = СокрЛП(ПроверяемыйКод);
	ТекстСообщения = "";
	ДлинаКода = СтрДлина(ПроверяемыйКод);

	Если ЭтоЮридическоеЛицо = Неопределено Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Не определен тип владельца кода ОКПО.'");
		Возврат Ложь;
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПроверяемыйКод) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО должен состоять только из цифр.'") + Символы.ПС;
	КонецЕсли;

	Если ЭтоЮридическоеЛицо И ДлинаКода <> 8 Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО юридического лица должен состоять из 8 цифр.'") + Символы.ПС;
	ИначеЕсли Не ЭтоЮридическоеЛицо И ДлинаКода <> 10 Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Код ОКПО физического лица должен состоять из 10 цифр.'") + Символы.ПС;
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстСообщения) Тогда
		ТекстСообщения = СокрЛП(ТекстСообщения);
		Возврат Ложь;
	КонецЕсли;
	
	Если Не КодКлассификатораВерный(ПроверяемыйКод) Тогда
		ТекстСообщения = НСтр("ru = 'Контрольное число для кода по ОКПО не совпадает с рассчитанным.'");
		Возврат Ложь
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции 

// Проверяет номер страхового свидетельства на соответствие требованиям ПФР.
//
// Параметры:
//  СтраховойНомер - Строка - страховой номер ПФР. Строка должна быть ведена по шаблону "999-999-999 99".
//  ТекстСообщения - Строка - текст сообщения об ошибке ввода страхового номера.
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция СтраховойНомерПФРСоответствуетТребованиям(Знач СтраховойНомер, ТекстСообщения) Экспорт
	
	ТекстСообщения = "";
	
	СтрокаЦифр = СтрЗаменить(СтраховойНомер, "-", "");
	СтрокаЦифр = СтрЗаменить(СтрокаЦифр, " ", "");
	
	Если ПустаяСтрока(СтрокаЦифр) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер не заполнен'");
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(СтрокаЦифр) < 11 Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер задан неполностью'");
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаЦифр) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = 'Страховой номер должен состоять только из цифр.'");
		Возврат Ложь;
	КонецЕсли;
	
	КонтрольноеЧисло = Число(Прав(СтрокаЦифр, 2));
	
	Если Число(Лев(СтрокаЦифр, 9)) > 1001998 Тогда
		Всего = 0;
		Для Сч = 1 По 9 Цикл
			Всего = Всего + Число(Сред(СтрокаЦифр, 10 - Сч, 1)) * Сч;
		КонецЦикла;
		Остаток = Всего % 101;
		Остаток = ?(Остаток = 100, 0, Остаток);
		Если Остаток <> КонтрольноеЧисло Тогда
			ТекстСообщения = ТекстСообщения + НСтр("ru = 'Контрольное число для страхового номера не совпадает с рассчитанным.'");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Проверка контрольного ключа в номере лицевого счета (9-й разряд номера счета),
// алгоритм установлен документом:
// "ПОРЯДОК РАСЧЕТА КОНТРОЛЬНОГО КЛЮЧА В НОМЕРЕ ЛИЦЕВОГО СЧЕТА"
// (утвержден ЦБ РФ 08.09.1997 N 515).
//
// Параметры:
//  НомерСчета - Строка - номер банковского счета.
//  БИК - Строка - БИК банка в котором открыт счет.
//  ЭтоБанк - Булево - если Истина, то проверяется банковский счет, иначе проверяется как счет РКЦ 
//                     (у РКЦ корреспондентский счет не заполняется).
//
// Возвращаемое значение:
//  Булево - Истина, если соответствует.
//
Функция КонтрольныйКлючЛицевогоСчетаСоответствуетТребованиям(НомерСчета, БИК, ЭтоБанк = Истина)Экспорт
	
	НомерСчетаСтрока = СокрЛП(НомерСчета);
	
	// При наличии алфавитного значения в 6-ом разряде лицевого 
	// счета (в случае использования клиринговой валюты) данный символ 
	// заменяется на соответствующую цифру:
	Разряд6 = Сред(НомерСчетаСтрока, 6, 1); 
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Разряд6) Тогда
		АлфавитныеЗначения6гоРазряда = СтрРазделить("А,В,С,Е,Н,К,М,Р,Т,Х", ",", Ложь);
		Цифра = АлфавитныеЗначения6гоРазряда.Найти(Разряд6);	
		Если Цифра = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
		Разряд6 = Строка(Цифра);
	КонецЕсли;
	
	// Для расчета контрольного ключа используется совокупность двух 
	// реквизитов - условного номера РКЦ (если лицевой счет открыт в РКЦ) 
	// или кредитной организации (если лицевой счет открыт в кредитной 
	// организации) и номера лицевого счета.
	Если ЭтоБанк Тогда
		УсловныйНомерКО = Прав(БИК, 3);
	Иначе
		УсловныйНомерКО = "0" + Сред(БИК, 5, 2 );
	КонецЕсли;
	
	НомерСчетаСтрока = УсловныйНомерКО + Лев(НомерСчетаСтрока,5) + Разряд6 + Сред(НомерСчетаСтрока, 7);
	
	Если СтрДлина(НомерСчетаСтрока) <> 23 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерСчетаСтрока) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВесовыеКоэффициенты = "71371371371371371371371";
	КонтрольнаяСумма = 0;
	Для Разряд = 1 По 23 Цикл
		Произведение = Число(Сред(НомерСчетаСтрока, Разряд, 1)) * Число(Сред(ВесовыеКоэффициенты, Разряд, 1));
		МладшийРазряд = Число(Прав(Строка(Произведение), 1));
		КонтрольнаяСумма = КонтрольнаяСумма + МладшийРазряд;
	КонецЦикла;
	
	// При получении суммы, кратной 10 (младший разряд равен 0), значение 
	// контрольного ключа считается верным.
	
	Возврат Прав(Строка(КонтрольнаяСумма), 1) = "0";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет правильность кода по контрольному числу (последняя цифра в коде).
//
// ПР 50.1.024-2005 «Основные положения и порядок проведения работ по разработке, ведению и применению общероссийских
// классификаторов», приложение В.
//
// Контрольное число рассчитывается следующим образом:
// 1. Разрядам кода в общероссийском классификаторе, начиная со старшего разряда, присваивается набор весов,
// соответствующий натуральному ряду чисел от 1 до 10. Если разрядность кода больше 10, то набор весов повторяется.
// 2. Каждая цифра кода умножается на вес разряда и вычисляется сумма полученных произведений.
// 3. Контрольное число для кода представляет собой остаток от деления полученной суммы на модуль «11».
// 4. Контрольное число должно иметь один разряд, значение которого находится в пределах от 0 до 9.
// Если получается остаток, равный 10, то для обеспечения одноразрядного контрольного числа необходимо провести
// повторный расчет, применяя вторую последовательность весов, сдвинутую на два разряда влево (3, 4, 5,…). Если в
// случае повторного расчета остаток от деления вновь сохраняется равным 10, то значение контрольного числа
// проставляется равным «0».
//
// Параметры:
//  ПроверяемыйКод - Строка - код для проверки.
//
// Возвращаемое значение:
//  Булево - Истина, если верный.
//
Функция КодКлассификатораВерный(ПроверяемыйКод)
	
	СуммаПроизведений = 0;
	Для Позиция = 1 По СтрДлина(ПроверяемыйКод)-1 Цикл
		Цифра = Число(Сред(ПроверяемыйКод, Позиция, 1));
		Вес = (Позиция - 1) % 10 + 1;
		СуммаПроизведений = СуммаПроизведений + Цифра * Вес;
	КонецЦикла;

	КонтрольнаяЦифра = СуммаПроизведений % 11;
	Если КонтрольнаяЦифра = 10 Тогда
		СуммаПроизведений = 0;
		Для Позиция = 1 По СтрДлина(ПроверяемыйКод)-1 Цикл
			Цифра = Число(Сред(ПроверяемыйКод, Позиция, 1));
			Вес = (Позиция + 1) % 10 + 1;
			СуммаПроизведений = СуммаПроизведений + Цифра * Вес;
		КонецЦикла;
		КонтрольнаяЦифра = СуммаПроизведений % 11;
	КонецЕсли;
	
	КонтрольнаяЦифра = КонтрольнаяЦифра % 10;
	
	Возврат Строка(КонтрольнаяЦифра) = Прав(ПроверяемыйКод, 1);

КонецФункции

#КонецОбласти


