Функция РезультатВМассивФайлов(Результат) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") тогда
		Возврат Результат;
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(Результат);
	
	Возврат Массив;
		
КонецФункции

Процедура ЗаполнитьПредставлениеФайлаСтроки(СтрокаДанных, ПрисоединенныеФайлыСтрок) Экспорт
	
	СтрокиФайлов = НайтиСтрокиФайлов(СтрокаДанных, ПрисоединенныеФайлыСтрок);		

	Если СтрокиФайлов.Количество() тогда
		СтрокаДанных.ФайлСтрокой = СтрШаблон("Прикреплено файлов: %1", СтрокиФайлов.Количество());
		СтрокаДанных.ФайлУдалить = Истина;
	Иначе	
		СтрокаДанных.ФайлСтрокой = "Выбрать файл";
		СтрокаДанных.ФайлУдалить = Ложь;
	КонецЕсли;

КонецПроцедуры

Функция НайтиСтрокиФайлов(СтрокаДанных, ПрисоединенныеФайлыСтрок) Экспорт
		
	СтрокиФайлов = ПрисоединенныеФайлыСтрок.НайтиСтроки(Новый Структура("ИдентификаторФайлов", СтрокаДанных.ИдентификаторФайлов));
	
	МассивФайлов = Новый Массив;
	Для Каждого Строка Из СтрокиФайлов цикл
		
		МассивФайлов.Добавить(Строка.Файл);
		
	КонецЦикла;	
	
	ДанныеФайла = рарусРаботаСФайламиСтрокВызовСервера.ДанныеФайла(МассивФайлов);
	
	СтрокиФайловИспользуемые = Новый Массив;
	
	Для Каждого Строка Из СтрокиФайлов цикл
		
		Если ДанныеФайла.Получить(Строка.Файл) <> Неопределено тогда
			
			Если Не ДанныеФайла[Строка.Файл].ПометкаУдаления тогда
				
				СтрокиФайловИспользуемые.Добавить(Строка);
				
			КонецЕсли;	
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат СтрокиФайловИспользуемые;
	
КонецФункции


