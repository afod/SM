#Область ПодключаемаяКоманда

&НаКлиенте
Процедура ВыполнитьКомандуОтправкиОбъекта(СсылкаНаИсточник, СтруктураПараметровКоманды) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтруктураПараметровКоманды.Источник, "СформированСМ")
		И СтруктураПараметровКоманды.Источник.СформированСМ = Ложь Тогда
		ПоказатьПредупреждение(, "Документ сформирован в береговой системе, обратная отправка не предусмотрена", 10,"Внимание!");  
		Возврат;
	КонецЕсли;
	
	СтруктураПараметровКоманды.Вставить("СсылкаНаИсточник", СсылкаНаИсточник);
	ЭтоКапитан = рарусОбщегоНазначенияВызовСервера.ЭтоКапитан();
	ТекущийСтатусОтправлено = ТекущийСтатусОбъектаОтправлено(СсылкаНаИсточник);
	Если ТекущийСтатусОтправлено
		И ЭтоКапитан Тогда
		ОповещениеОбОтвете = Новый ОписаниеОповещения("ВыполнитьКомандуОтправкиОбработкаОтвета", ЭтотОбъект, СтруктураПараметровКоманды);
		ПоказатьВопрос(ОповещениеОбОтвете, "Документ уже отправлен в береговую систему, повторная отправка может привести к потере изменений. Отправить повторно?", РежимДиалогаВопрос.ДаНет,10,КодВозвратаДиалога.Нет,"Повторная отправка", КодВозвратаДиалога.Нет);  
	ИначеЕсли ТекущийСтатусОтправлено Тогда
		ПоказатьПредупреждение(, "Недостаточно прав на повторную отправку документа", 10,"Внимание!");
		Возврат;
	Иначе
		ВыполнитьКомандуОтправки(СтруктураПараметровКоманды)
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуОтправкиОбработкаОтвета(Ответ, Параметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполнитьКомандуОтправки(Параметры)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКомандуОтправки(СтруктураПараметровКоманды)
	рарусИмущественныйУчетВызовСервера.УстановитьСтатусЗарегистрированоКОтправке(СтруктураПараметровКоманды.СсылкаНаИсточник);
	ОповеститьОбИзменении(СтруктураПараметровКоманды.СсылкаНаИсточник);
	СтруктураПараметровКоманды.Форма.Закрыть();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекущийСтатусОбъектаОтправлено(СсылкаНаИсточник)
	Возврат РегистрыСведений.рарусСостоянияОтправкиОбъектов.ТекущийСтатусОбъекта(СсылкаНаИсточник) = ПредопределенноеЗначение("Перечисление.рарусСостояниеОтправкиОбъекта.Отправлен")
КонецФункции

#КонецОбласти