
//Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза)
//	
//	// ОбменДанными
//	ОбменДаннымиСобытия.ПриОтправкеДанных(ЭлементДанных, ОтправкаЭлемента, Ссылка, "ОбменПолный", СозданиеНачальногоОбраза);
//	// Конец ОбменДанными
//	
//	// Пользователи
//	ПользователиСобытия.ПриОтправкеДанных(ЭлементДанных, ОтправкаЭлемента);
//	// Конец Пользователи
//	
//КонецПроцедуры

//Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента)
//	
//	// Пользователи
//	ПользователиСобытия.ПриОтправкеДанных(ЭлементДанных, ОтправкаЭлемента);
//	// Конец Пользователи
//	
//КонецПроцедуры

//Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
//	
//	// Пользователи
//	ПользователиСобытия.ПриПолученииДанных(ЭлементДанных);
//	// Конец Пользователи
//	
//	// ДополнительныеОтчетыИОбработки
//	//ДополнительныеОтчетыИОбработкиСобытия.ПриПолученииДанных(ЭлементДанных);
//	// Конец ДополнительныеОтчетыИОбработки
//	
//КонецПроцедуры

//Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
//	
//	// Пользователи
//	ПользователиСобытия.ПриПолученииДанных(ЭлементДанных);
//	// Конец Пользователи
//	
//	// ДополнительныеОтчетыИОбработки
//	//ДополнительныеОтчетыИОбработкиСобытия.ПриПолученииДанных(ЭлементДанных);
//	// Конец ДополнительныеОтчетыИОбработки
//	
//КонецПроцедуры
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
	
КонецПроцедуры

Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад)
	
	ПриПолученииДанныхФайла(ЭлементДанных);
	
КонецПроцедуры

Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента)
	
КонецПроцедуры

Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза)
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
		
		ПослеЗагрузкиДанных();
		
	КонецЕсли;
	
	// ++ rarus makole 2020-11-02 [БСО.СМ.007.04]
	// При создании нового узла автоматически заполнять настройки синхронизации с судном
	Если Ссылка = ПредопределенноеЗначение("ПланОбмена.Полный.ПустаяСсылка") Тогда
		ДополнительныеСвойства.Вставить("ЗаполнитьНастройкиПоУмолчанию", Истина)
	КонецЕсли;
	// -- rarus makole 2020-11-02 [БСО.СМ.007.04]
	
КонецПроцедуры
		
Процедура ПриЗаписи(Отказ)
	
	// ++ rarus makole 2020-11-02 [БСО.СМ.007.04]
	// При создании нового узла автоматически заполнять настройки синхронизации с судном
	Если ДополнительныеСвойства.Свойство("ЗаполнитьНастройкиПоУмолчанию") Тогда
		рарусСинхронизацияССудном.ЗаполнитьНастройкиОбменаССудномПоУмолчанию(Код)
	КонецЕсли;	
	// -- rarus makole 2020-11-02 [БСО.СМ.007.04]
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Переопределяет стандартное поведение при загрузке данных;
//
Процедура ПриПолученииДанныхФайла(ЭлементДанных)
	
	
КонецПроцедуры

Процедура ПослеЗагрузкиДанных()
	
КонецПроцедуры // ПослеЗагрузкиДанных()

Функция ПолучитьРеглЗаданияЭтойИБ(ЭлементДанных, ИмяРеквизита) 
	
	Если Не ОбщегоНазначения.СсылкаСуществует(ЭлементДанных.Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РеглЗаданияЭтойИБ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ЭлементДанных.Ссылка, ИмяРеквизита);
		
	
	Возврат ИдентификаторСуществующегоРегламентногоЗадания(РеглЗаданияЭтойИБ);
	
КонецФункции

// Функция проверяет существование регламентного задания по переданному идентификатору.
//
// Параметры:
//   Идентификатор - строка - идентификатор регламентного задания.
//
// Возвращаемое значение:
//   Идентификатор - если регламентное задание найдено,
//   Неопределено  - если регламентное задание не найдено.
//
Функция ИдентификаторСуществующегоРегламентногоЗадания(Идентификатор)
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Отбор = Новый Структура("Идентификатор", Идентификатор);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	// Проверяем, что задание найдено.
	Если Задания.Количество() <> 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции


#КонецОбласти

#КонецЕсли