///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает новую структуру параметров для загрузки данных из файла в табличную часть.
//
// Возвращаемое значение:
//   Структура - параметры для открытия формы загрузки данных в табличную часть:
//    * ПолноеИмяТабличнойЧасти - Строка   - полный путь к табличной части документа, 
//                                           в виде "ИмяДокумента.ИмяТабличнойЧасти".
//    * Заголовок               - Строка   - заголовок формы загрузки данных из файла.
//    * ИмяМакетаСШаблоном      - Строка   - имя макета с шаблоном для ввода данных.
//    * Представление           - Строка   - заголовок окна в форме загрузке данных.
//    * ДополнительныеПараметры - ЛюбойТип - Любые дополнительные сведения, которые будут переданы
//                                           в процедуру сопоставления данных.
//
Функция ПараметрыЗагрузкиДанных() Экспорт
	ПараметрыЗагрузки = Новый Структура();
	ПараметрыЗагрузки.Вставить("ПолноеИмяТабличнойЧасти");
	ПараметрыЗагрузки.Вставить("Заголовок");
	ПараметрыЗагрузки.Вставить("ИмяМакетаСШаблоном");
	ПараметрыЗагрузки.Вставить("ДополнительныеПараметры");
	ПараметрыЗагрузки.Вставить("КолонкиМакета");
	
	Возврат ПараметрыЗагрузки;
КонецФункции

// Открывает форму загрузки данных для заполнения табличной части.
//
// Параметры: 
//   ПараметрыЗагрузки   - Структура           - см. ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных.
//   ОповещениеОЗагрузке - ОписаниеОповещения  - оповещение, которое будет вызвано для добавления загруженных данных в
//                                               табличную часть.
//
Процедура ПоказатьФормуЗагрузки(ПараметрыЗагрузки, ОповещениеОЗагрузке) Экспорт
	
	ОткрытьФорму("Обработка.ЗагрузкаДанныхИзФайла.Форма", ПараметрыЗагрузки, 
		ОповещениеОЗагрузке.Модуль, , , , ОповещениеОЗагрузке);
		
КонецПроцедуры


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму загрузки данных для заполнения табличной части сопоставления ссылок в подсистеме "Варианты отчетов".
//
// Параметры: 
//   ПараметрыЗагрузки   - Структура           - см. ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных.
//   ОповещениеОЗагрузке - ОписаниеОповещения  - оповещение, которое будет вызвано для добавления загруженных данных в
//                                               табличную часть.
//
Процедура ПоказатьФормуЗаполненияСсылок(ПараметрыЗагрузки, ОповещениеОЗагрузке) Экспорт
	
	ОткрытьФорму("Обработка.ЗагрузкаДанныхИзФайла.Форма", ПараметрыЗагрузки,
		ОповещениеОЗагрузке.Модуль,,,, ОповещениеОЗагрузке);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Открывает диалог загрузки файла.
//
// Параметры:
//  ОповещениеЗавершения - ОписаниеОповещения - вызывается после успешного помещения файла.
//  ИмяФайла	         - Строка - имя файла в диалоге.
//
Процедура ДиалогЗагрузкиФайла(ОповещениеЗавершения , ИмяФайла = "") Экспорт
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Все поддерживаемые форматы файлов(*.xls;*.xlsx;*.ods;*.mxl;*.csv)|*.xls;*.xlsx;*.ods;*.mxl;*.csv|Книга Excel 97 (*.xls)|*.xls|Книга Excel 2007 (*.xlsx)|*.xlsx|Электронная таблица OpenDocument (*.ods)|*.ods|Текстовый документ c разделителями (*.csv)|*.csv|Табличный документ (*.mxl)|*.mxl'");
	ПараметрыЗагрузки.ИдентификаторФормы = ОповещениеЗавершения.Модуль.УникальныйИдентификатор;
	
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОповещениеЗавершения, ПараметрыЗагрузки, ИмяФайла);
	
КонецПроцедуры

#КонецОбласти
