///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция Подключены() Экспорт
	
	Если Заблокированы() Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	// Вызов на сервере гарантирует получение корректного состояния в случае,
	// когда данные регистрации информационной базы были изменены методом 
	// СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы.
	Возврат СистемаВзаимодействия.ИспользованиеДоступно();
	
КонецФункции

Функция Заблокированы() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеРегистрации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	Заблокированы = ДанныеРегистрации <> Неопределено;
	Возврат Заблокированы;
	
КонецФункции

Процедура Заблокировать() Экспорт 
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда 
		ВызватьИсключение 
			НСтр("ru = 'Обсуждения не заблокированы. Для выполнения операции требуется право администрирования данных.'");
	КонецЕсли;
	
	Если Заблокированы() Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеРегистрации = СистемаВзаимодействия.ПолучитьДанныеРегистрацииИнформационнойБазы();
	Если ТипЗнч(ДанныеРегистрации) = Тип("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия") Тогда
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
			"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия", 
			ДанныеРегистрации);
	КонецЕсли;
	СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы(Неопределено);
	
КонецПроцедуры

Процедура Разблокировать() Экспорт 
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда 
		ВызватьИсключение 
			НСтр("ru = 'Обсуждения не заблокированы. Для выполнения операции требуется право администрирования данных.'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеРегистрации = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	ОбщегоНазначения.УдалитьДанныеИзБезопасногоХранилища("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия");
	Если ТипЗнч(ДанныеРегистрации) = Тип("ДанныеРегистрацииИнформационнойБазыСистемыВзаимодействия") Тогда 
		СистемаВзаимодействия.УстановитьДанныеРегистрацииИнформационнойБазы(ДанныеРегистрации);
	КонецЕсли;
	ДанныеРегистрации = Неопределено;
	
КонецПроцедуры

Процедура ПриСозданииНаСервереПользователя(Отказ, Форма, Объект) Экспорт
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		Форма.ПредлагатьОбсуждения = Ложь;
		Возврат;
	КонецЕсли;
	
	ПредлагатьОбсуждения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПрограммы", "ПредлагатьОбсуждения", Истина);
	Форма.ПредлагатьОбсуждения = Не Отказ И Не ЗначениеЗаполнено(Объект.Ссылка) И ПредлагатьОбсуждения 
		И Не ОбсужденияСлужебныйВызовСервера.Подключены();
	Если Не Форма.ПредлагатьОбсуждения Тогда
		Возврат;
	КонецЕсли;
	
	ПодсистемаАдминистрирование = Метаданные.Подсистемы.Найти("Администрирование");
	Если ПодсистемаАдминистрирование <> Неопределено Тогда 
		ВключитьПозднее = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Включить обсуждения также можно позднее из раздела %1.'"),
			ПодсистемаАдминистрирование.Синоним);
	Иначе
		ВключитьПозднее = НСтр("ru = 'Включить обсуждения также можно позднее из настроек программы.'");
	КонецЕсли;
	
	Форма.ПредлагатьОбсужденияТекст = 
		НСтр("ru = 'Включить обсуждения?
			       |
			       |С их помощью пользователи смогут отправлять друг другу текстовые сообщения и совершать видеозвонки, создавать тематические обсуждения и вести переписку по документам.'")
			+ Символы.ПС + Символы.ПС + ВключитьПозднее;
	
КонецПроцедуры

Функция ОбсуждениеКонтекстное(Данные, Заголовок = Неопределено) Экспорт
	
	Обсуждение = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонтекстОбсуждения = Новый КонтекстОбсужденияСистемыВзаимодействия(
		ПолучитьНавигационнуюСсылку(Данные));
	
	ОтборОбсуждений = Новый ОтборОбсужденийСистемыВзаимодействия();
	ОтборОбсуждений.КонтекстноеОбсуждение = Истина;
	ОтборОбсуждений.КонтекстОбсуждения = КонтекстОбсуждения;
	
	НайденноеОбсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(ОтборОбсуждений);
	
	Если НайденноеОбсуждения.Количество() > 0 Тогда
		Возврат НайденноеОбсуждения[0];
	КонецЕсли;
	
	Если Заголовок = Неопределено Тогда 
		
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'История %1'"), Данные);
		
	КонецЕсли;
	
	Обсуждение = СистемаВзаимодействия.СоздатьОбсуждение();
	Обсуждение.Заголовок = Заголовок;
	Обсуждение.КонтекстОбсуждения = КонтекстОбсуждения;
	
	Обсуждение.Записать();
	
	Возврат Обсуждение;
	
КонецФункции

#КонецОбласти