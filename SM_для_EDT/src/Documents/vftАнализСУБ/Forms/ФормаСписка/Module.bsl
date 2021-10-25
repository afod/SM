
&НаКлиенте
Процедура Настройки(Команда)
	
	ИнвертироватьПанельНастройки();
	УстановитьВидимостьПанелиНастроек();
	
КонецПроцедуры

&НаКлиенте 
Процедура ИнвертироватьПанельНастройки()
	
	ПанельНастроек = НЕ ПанельНастроек;
	Элементы.КнопкаНастройки.Пометка = ПанельНастроек;
	
КонецПроцедуры

&НаКлиенте 
Процедура УстановитьВидимостьПанелиНастроек()
	
	Элементы.ГруппаНастройки.Видимость = ПанельНастроек;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПанельНастроек = ЛОЖЬ;
	УстановитьВидимостьПанелиНастроек();
	vftОбщиеПроцедурыДокументовКлиент.УстановитьУсловноеОформление(Список);	
	vftОбщиеПроцедурыДокументовКлиент.УстановитьПараметрГруппаСудов(Список,ОтборГруппаСудов);
КонецПроцедуры

&НаКлиенте
Процедура ОтборГруппаСудовПриИзменении(Элемент)
	vftОбщиеПроцедурыДокументовКлиент.УстановитьПараметрГруппаСудов(Список,ОтборГруппаСудов);
КонецПроцедуры

&НаКлиенте
Процедура ОтборГруппаСудовОчистка(Элемент, СтандартнаяОбработка)
	vftОбщиеПроцедурыДокументовКлиент.УстановитьПараметрГруппаСудов(Список,ОтборГруппаСудов);
КонецПроцедуры

