# Логер.

Версия 2.

# Общая идея логирования

## Логирование должно производиться максимально плотно.
Файлы логов должны быть бинарными, с индексированием для быстрой выборки по времени (с последующей фильтрацией по тэгам).
При этом сжатие налету без знания сути записываемой информации если и возможно, то нагружает центральный процессор.
Поэтому вместо записи
```c++
logError("myComponent.input") << QString("неожиданный источник сообщения: %1 вместо ожидаемого %2").arg(10).arg(11);
```
мы должны использовать запись
``` c++
log(2, 1234, 1235, 10, 11);
```,
где
	2 - идентификатор тэга "error",
	1234 - идентификатор тэга "myComponent.input",
	1235 - идентификатор сообщения для логирования,
	10 - первый аргумент для сообщения 1235,
	11 - второй аргумент для сообшения 1235

В коде логируемого приложения мы пишем не текст лога, а значение из `enum`-а. Также перечислениями пишем и тэги.

## Мы должны гарантировать логеру наличие необходимых системных ресурсов.
Так как логер - это та система, которая в случае сбоя системы, передаёт разработчику сведения о том, что послужило причиной сбоя, логер должен отставаться рабочим, даже если в системе кончилась оперативная память, закончилось место на жёстком диске, или превышено ограничение на создание нового файлового дестриптора (в таких случаях обычно только жёсткая перезагрузка машины помогает).
Поэтому сразу при старте, логер осуществляет следующие действия:
* открывает все файлы логов (и не закрывает их до самого завершения работы логера);
* если в каких-то файлах логов ещё нет индекса по времени, пишем его;
* если какие-то файлы логов ещё не достигли своего максимального размера, дополняя эти файлы мусором, доводим размер этих файлов до их максимально допустимого размера;
* при старте логера выделяем под всевозможные буферы память, и в процессе работы логера память мы больше ни выделяем, ни освобождаем, до самого завершения работы логера.

Вывод логера на экран невозможен без доступа к внешнему файлу с описанием соответствия <числовой идентификатор>-<текст на вывод>(далее, "файл перевода")

## Логер и многопоточность
Логер в одном потоке считывает логи от логируемого приложения и кладёт их в кольцевой буфер. Это операция быстрая, и система вцелом будет проще, если читающий поток логера будет один. В другом потоке логи из кольцевого буфера пишутся в файлы логов.
При переполнении кольцевого буфера (мы храним указатели в кольцевом буфере на последний записанный и на последний считанный) мы часть логов "теряем", о чём записываем в лог. Логер не будет ради записи предыдущих логов бесконечно откладывать запись последующих.

## Структура лог-файлов
Бинарный лог мы можем писать в один файл. Но мы бьём на множество файлов всилу следующих причин:

1.) После записи логов возможен запрос логов за указанный интервал времени. Логи хранятся в долговременной памяти логируемой машины. По запросу с этой машины на флешку выгружается часть логов - за тот или иной период времени. Поэтому один большой файл лога бьём на множество логов поменьше, и файл лога вырождается в директорию с файлами лога (слишком много файлов тоже файлов - файловая система начнёт тупить при первом запуске логера);
2.) Каждая директория с файлами лога хранит не всю историю логов. По исчерпании отведённого места на диске

Структура комплекса.
====================
Комплекс состоит из следующих составляющих:

1.) Непосредственно логер (app; запускалка). Перед запуском логируемого приложения выставляется переменная окружения TMHSMART_LOGGER (значение - версия логгера). Логирование осуществляется строго в лог-файлы, в стандартный вывод ничего не выводится.
2.) Библиотека записи логов. Если переменная окружения TMHSMART_LOGGER выставлена, то пишем в бинарном виде. В противном случае вывод логов разворачиваем в строковой форме.
	Если логирующее приложение запущено не через запускалку (logger), то всё логирование осуществляется в текстовом виде в консоль. К такому выводу логов можно применять tag-filter.sh из 1-й версии логгера, и в режиме реального времени менять правила фильтрации тэгов, что важно при отладке.
3.) Библиотека запроса логов.

boris here:
1.) Требования, которые необходимо заложить для того, чтобы можно было написать юнит-тест.
2.) Библиотека запроса логов: API. Помимо выдачу логов из истории, необходимо также формировать пакет данных с фрагментом логов (для выгрузки на флешку).


1.) tmhsmart-starter
2.) liblogwriter
3.) liblogreader

Проблемы текущего архитектурного решения
========================================
С одной стороны, когда мы работаем не через именованный канал, а через стандартный поток вывода, мы упрощаем конструкцию логера и билиотеки работы с ним.

С другой стороны, каждый логер (для каждого логируемого приложения) имеет свою конфигурацию. Это проблема, когда нам надо воспроизвести ситуацию, наигранную на машине в период от A до B.