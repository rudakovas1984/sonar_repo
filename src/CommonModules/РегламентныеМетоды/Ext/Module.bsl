
Процедура alphavantage_обмен() Экспорт 
	
	Попытка
		
		alphavantage_apikey = Константы.alphavantage_apikey.Получить();
		
		//url = 'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=demo'
		
		Шаблон_HTTPRequest = "/query?function=TIME_SERIES_DAILY&symbol=IBM&apikey=" + alphavantage_apikey;
		
		Соединение = Новый HTTPСоединение("www.alphavantage.co", 443, "", "",, 30, Новый ЗащищенноеСоединениеOpenSSL());
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	company.Ссылка КАК Ссылка,
		|	company.symbol КАК symbol
		|ИЗ
		|	Справочник.company КАК company
		|ГДЕ
		|	company.ЗагружатьДанные";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл 
			
			Текст_HTTPRequest = СтрЗаменить(Шаблон_HTTPRequest, "IBM", Выборка.symbol);
			
			Запрос = Новый HTTPRequest(Текст_HTTPRequest);
			Ответ = Соединение.Получить(Запрос);
			
			Если Ответ.КодСостояния <> 200 Тогда 
				Сообщить("Ошибка: " + Ответ.КодСостояния + ", тело: " + Ответ.ПолучитьТелоКакСтроку());
				Прервать;
			КонецЕсли;
			
			СтрокаJSON = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
			Данные = ПрочитатьJSON(ЧтениеJSON, Истина);
			ЧтениеJSON.Закрыть();
			
			Last_Refreshed = Данные["Meta Data"]["3. Last Refreshed"];
			Time_Series = Данные["Time Series (Daily)"][Last_Refreshed];
			
			МенеджерЗаписи = РегистрыСведений.TIME_SERIES_DAILY.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период = Дата(СтрЗаменить(Last_Refreshed, "-", ""));
			МенеджерЗаписи.company = Выборка.Ссылка;
			МенеджерЗаписи.open = Число(Time_Series["1. open"]);
			МенеджерЗаписи.high = Число(Time_Series["2. high"]);
			МенеджерЗаписи.low = Число(Time_Series["3. low"]);
			МенеджерЗаписи.close = Число(Time_Series["4. close"]);
			МенеджерЗаписи.volume = Число(Time_Series["5. volume"]);
			МенеджерЗаписи.Записать(Истина);
			
			ВызватьПаузу(1000);
			
		КонецЦикла;
		
	Исключение
		Сообщить("Произошла ошибка: " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры
