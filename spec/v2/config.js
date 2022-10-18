{
	"printToTty": true,
	"binaryEnvVar": "binaryLog", // через эту переменную окружения логер должен передать файловый дескриптор, в который программа должна писать бинарные логи
	"directory": "/var/log/myserver",
	"baseFileName": "2021-11-30", // будет добавлено '.log.1'. Предлагается в именах файлов отражать дату последнего сливания логов с объекта на внешний носитель
	"compressing": false,
	"tags":[
		[
			//"debug", // комментирование должно поддерживаться. Вот такое вот отклонение от канонов JSON-а.
			"+error",
			"+warning",
			//"+info"
			{
			   "tag": "+info",
				"directory": "", // не переопределяется родительская директория, а дописывается (поддиректория родительской). Если не указано или указана пустая строка, то пишется в родительскую директорию (которая указана в предыдущем наборе тэгов или до описания тэгов)
				"baseFileName": "" // дописывается через точку к родительскому базовому имени (если то было указано),
				"fileSizeLimit": "20M",
				"directorySizeLimit": "2G", // сразу по прочтении конфигурации вычисляется в число файлов, и внутри также соблюдается ограничение на число файлов.
				"compress": "none", // Варианты: none, gzip, lzip.
				"binary": true
			}
		],
		[
			"MpAsdcClientFsm",
			"RestClientFsm",
			"*Fsm", // упрощённый регэксп, только звёздочка и поддерживается
			"Converter",
			"+dataChanges" // '+' в начале означает вывод на экран, сам символ плюса в тэг не входит
		]
	]
}


/*
Случай сжатия
=============
Мы задаём ограничение на объём файлов и на объём занимаемого места (логов вцелом).
Если мы используем опцию сжатия, то мы также должны задать ограничение на размер архива.
Под объёмом файлов понимается размер файла до запаковки в архив.
*/
