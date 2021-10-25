#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	РаботаСФайлами.ОпределитьФормуПрисоединенногоФайла(
			Справочники.впОбъектыРемонтаПрисоединенныеФайлы, 
			ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

// ++ rarus makole 2020-12-04 [БСО.ПРОТОКОЛ Р-58 03.12.2020]
// Функция возвращает связанную с объектом информацию, обязательную к выгрузке
//
// Параметры:
//  СсылкаНаОбъект  - СправочникСсылка.впОбъектыРемонтаПрисоединенныеФайлы - ссылка на объект, связанные объекты которого требуется вернуть
//
// Возвращаемое значение:
//   Массив   - Массив структур с ключами "ИмяТипа, Отбор", где ИмяТипа - Строка, представляет полное имя
//				объекта метаданных, Отбор - структура с ключами, соответствующими основному отбору
//
Функция СвязанныеДанные(СсылкаНаОбъект) Экспорт
	
	МассивСвязанных = Новый Массив;
	
	СтруктураОтбора = Новый Структура("Файл", СсылкаНаОбъект);
	СтруктураСведения = Новый Структура("ИмяТипа, Отбор", "РегистрСведений.СведенияОФайлах", СтруктураОтбора);
	МассивСвязанных.Добавить(СтруктураСведения);
	  
	СтруктураОтбора = Новый Структура("ОбъектСФайлами", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект,"ВладелецФайла"));
	СтруктураНаличие = Новый Структура("ИмяТипа, Отбор", "РегистрСведений.НаличиеФайлов", СтруктураОтбора);
	МассивСвязанных.Добавить(СтруктураНаличие);
	  
	Возврат МассивСвязанных;
	  
КонецФункции // -- rarus makole 2020-12-04 [БСО.ПРОТОКОЛ Р-58 03.12.2020]