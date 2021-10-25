#Если Сервер Или ТолстыйКлиентОбычноеПриложение Тогда

// Процедура записывает событие смены варианта синхронизации в журнал
//
// Параметры:
//  Узел  - ПланОбменаСсылка.Полный - Ссылка на узел плана обмена Полный, по которому записывается
//                 событие
//  Вариант - Число - установленный номер варианта синхронизации, 
//                 где 1 - Срочное (важное), 2 - Стандартный обмен, 3 - Полная синхронизация
//  Ответственный  - СправочникСсылка.Пользователи - Пользователь, сменивший вариант синхронизации
//				   - Строка - Текст описания причины смены варианта
//  Перезаписывать - Булево - Признак необходимости перезаписи события в случае присутствия записи на 
//					заданный Период по указанному Узлу
//  Период  - Дата - Период регистрации события смены варианта
//
Процедура ЗаписатьСобытие(Узел, Вариант, Ответственный, Перезаписывать = Ложь, Период = Неопределено) Экспорт
	
	Если ТипЗнч(Узел) = Тип("Строка") Тогда
		КодУзла = Узел
	Иначе
		КодУзла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел, "Код")
	КонецЕсли;
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса()
	КонецЕсли;
		
	НаборЗаписей = РегистрыСведений.рарусЛогСменыВариантаСинхронизации.СоздатьНаборЗаписей(); 

	НаборЗаписей.Отбор.КодУзла.Установить(КодУзла); 
	НаборЗаписей.Отбор.Период.Установить(Период); 

	НоваяЗапись = НаборЗаписей.Добавить(); 
	НоваяЗапись.Период = Период; 
	НоваяЗапись.КодУзла = КодУзла; 
	НоваяЗапись.Вариант = Вариант; 
	НоваяЗапись.Ответственный = Ответственный; 

	НаборЗаписей.Записать(Перезаписывать); 
	
КонецПроцедуры

#КонецЕсли