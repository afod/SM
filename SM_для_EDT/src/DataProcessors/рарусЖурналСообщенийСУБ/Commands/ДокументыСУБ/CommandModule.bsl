
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.рарусЖурналСообщенийСУБ.Команда.ДокументыСУБ");

	ПараметрыФормы = Новый Структура("КлючНазначенияФормы", "ДокументыСУБ");
	
	ОткрытьФорму("Обработка.рарусЖурналСообщенийСУБ.Форма.ФормаОсновная", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры
