Процедура ПередНачаломИзмененияСтроки(Форма, Элемент, Отказ) Экспорт
	
	Форма.НеобходимаПричина = рарусХранениеВерсийВызовСервера.НеобходимаПричинаРедактирования(
		Форма.Объект.Ссылка, 
		Элемент.ТекущийЭлемент.Имя
		);
	
КонецПроцедуры	

Процедура ПриИзменении(Форма, Элемент) Экспорт
	
	Форма.НеобходимаПричина = рарусХранениеВерсийВызовСервера.НеобходимаПричинаРедактирования(
		Форма.Объект.Ссылка, 
		Элемент.ТекущийЭлемент.Имя
		);
	
КонецПроцедуры	
	
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование) Экспорт
	
	Если НоваяСтрока тогда
		
		Элемент.ТекущиеДанные.ВерсияСтрокиЗаблокирована = Ложь;	
		Элемент.ТекущиеДанные.НеобходимаПричина = Ложь;
		Элемент.ТекущиеДанные.ПричинаВерсии = "";
		Элемент.ТекущиеДанные.ПризнакДобавленияКартинка = -1;
		
		Для Каждого Строка из Форма.ЭлементыФормыХраненияВерсия цикл
			
			Элемент.ТекущиеДанные[Строка.ИмяРеквизита] = Неопределено;
			
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	
	
Процедура ПриОкончанииРедактированияСтроки(Форма, Элемент, НоваяСтрока, ОтменаРедактирования) Экспорт
	
	Если ОтменаРедактирования тогда
		
		Форма.НеобходимаПричина = Ложь;
		
	КонецЕсли;
	
	Если Форма.НеобходимаПричина тогда
		
		Если Элемент.ТекущиеДанные.ВерсияСтрокиЗаблокирована тогда
			
			Элемент.ТекущиеДанные.НеобходимаПричина = Истина;
			
			ВвестиПричнуПоСтроке(Элемент);
		
		КонецЕсли;
		
	КонецЕсли;	
	
	Форма.НеобходимаПричина = Ложь;
	
КонецПроцедуры

Процедура ВвестиПричнуПоСтроке(Элемент)
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВводПричиныЗавершение", ЭтотОбъект, Элемент.ТекущиеДанные);
	ПоказатьВводСтроки(ОписаниеОповещения, Элемент.ТекущиеДанные.ПричинаВерсии ,"Укажите причину изменения", ,Истина);

КонецПроцедуры

Процедура Выбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	
	Если ЭтоЭлементВводаПричины(Поле) тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено тогда
			
			Если ТекущиеДанные.НеобходимаПричина тогда
				
				СтандартнаяОбработка = Ложь;
				
				ВвестиПричнуПоСтроке(Элемент);
				
			КонецЕсли;	
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(ЭтотОбъект, Элемент, Отказ) Экспорт

	Если Элемент.ТекущиеДанные.ВерсияСтрокиЗаблокирована тогда
		
		Отказ = Истина;
		
		ПоказатьПредупреждение(, "Позиция уже была отправлена на берег и не может быть удалена. 
		|Необхоимо использовать признак Отмены в строке"); 
		
	КонецЕсли;	

КонецПроцедуры
 
Функция ЭтоЭлементВводаПричины(Поле) Экспорт
	
	Возврат СтрНайти(ВРег(Поле.Имя), ВРег("ПричинаНеУказанаКартинка"));
	
КонецФункции 

Процедура ВводПричиныЗавершение(Результат, ТекущиеДанные) Экспорт
	
	Если Не ПустаяСтрока(Результат) тогда
		
		ТекущиеДанные.ПричинаВерсии = Результат;	
		ТекущиеДанные.ПричинаНеУказанаКартинка = Ложь;
		
	ИначеЕсли Результат = Неопределено Тогда
		
		// нажата кнопка Отмена
		
		Если ПустаяСтрока(ТекущиеДанные.ПричинаВерсии) тогда
			ТекущиеДанные.ПричинаНеУказанаКартинка = Истина;
		КонецЕсли;	

	Иначе	
		
		ТекущиеДанные.ПричинаВерсии = Результат;
		ТекущиеДанные.ПричинаНеУказанаКартинка = Истина;
		
	КонецЕсли;	
	
КонецПроцедуры
