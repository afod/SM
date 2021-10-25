
Функция СформироватьТабДок(Документ) Экспорт
	
	Таб   =   новый ТабличныйДокумент;
	
	Макет = Отчеты.рарусОтчетОРейсообороте.ПолучитьМакет("ОтчетОРейсообороте");
	
	Таб.Очистить();
	Таб.ОбластьПечати			= Неопределено;
	Таб.ЧерноБелаяПечать			= Истина;
	Таб.АвтоМасштаб				= Истина;
	Таб.ОриентацияСтраницы		= ОриентацияСтраницы.Портрет;
	Таб.ОтображатьСетку			= Ложь;
	Таб.ОтображатьЗаголовки		= Ложь;
	Таб.ОтображатьГруппировки	= Ложь;
	Таб.ТолькоПросмотр			= Истина;
	Таб.Вывести(Макет);
	

	// ++ rarus Чернавин Г.К 18.06.2020 № 22279
	//Таб.Области.НомерОтчета.Текст = "Отчет о рейсообороте №"+Формат(Документ.Номер,"ЧГ = 0");
	НомерДокумента = Документы.vftРейс.НомерБезПрефикса(Документ.Номер);
	Таб.Области.НомерОтчета.Текст = "Отчет о рейсообороте №"+Формат(НомерДокумента,"ЧГ = 0");
	// -- rarus Чернавин Г.К 18.06.2020
	Таб.Области.НаименованиеТеплохода.Текст = "Теплоход """+СокрЛП(Документ.Судно.Наименование)+"""";
	
	// Заполняем отчет из данных документа
	Для Каждого Эл из Метаданные.Документы.vftРейс.Реквизиты Цикл
		Если Лев(Эл.Имя,3) = "ОР_" Тогда
			Таб.Области[Эл.Имя].Значение = Документ[Эл.Имя];
		КонецЕсли;
	КонецЦикла;
	
	Таб.ВерхнийКолонтитул.НачальнаяСтраница = 1;
	Таб.ВерхнийКолонтитул.ТекстСправа = "Стр.[&НомерСтраницы] из [&СтраницВсего]";
	Таб.ВерхнийКолонтитул.Выводить = Истина;
	
	Таб.НижнийКолонтитул.НачальнаяСтраница = 1;
	Таб.НижнийКолонтитул.ТекстСправа = "Отчет сформирован [&Дата] [&Время]";
	Таб.НижнийКолонтитул.Выводить = Истина;
	
	Возврат Таб
	
КонецФункции
