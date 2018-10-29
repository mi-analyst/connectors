# yamarketr - пакет для работы с Партнёрским API Яндекс.Маркета на языке R


## Краткое описание

Данный пакет предназначен для получения данных из Яндекс.Маркета с помощью языка R. 

Данный пакет позволит получить доступ к следующей информации:



*   [Список кампаний (магазинов)](https://github.com/mrykin/yamarketr/blob/master/README.md#загрузка-списка-кампаний-магазинов)
*   [Баланс кампаний](https://github.com/mrykin/yamarketr#загрузка-текущего-баланса-магазинов)
*   [Расход по периодам](https://github.com/mrykin/yamarketr#загрузка-расхода-магазинов-за-выбранный-период)
*   [Список логинов](https://github.com/mrykin/yamarketr#загрузка-списка-логинов-прикреплённых-к-кампании-магазину)
*   Список ошибок (инструкция в разработке)

На очереди работа над функциями:

*   [Расход по предложениям](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-stats-offers-docpage/)
*   [Параметры кампании](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-settings-docpage/)
*   [Точки продаж](https://tech.yandex.ru/market/partner/doc/dg/reference/outlet-methods-docpage/)
*   [Список предложений для модели (конкурентная аналитика в карточках)](https://tech.yandex.ru/market/partner/doc/dg/reference/content-methods-docpage/)

Функции пакета постепенно будут добавляться и расширяться в описании будет указаны статус разработки и планируемые изменения.


## Установка пакета yamarketR

Установка пакета осуществляется из репозитория GitHub, для этого сначала требуется установить и подключить пакет devtools.


```
install.packages("devtools")
library(devtools)
```


После чего можно устанавливать пакет yamarketR.


```
install_github('mrykinpavel/yamarketr')
```



## Авторизация в API Яндекс Маркет


Вы можете в любой момент пройти аутентификацию в API Яндекс Маркет, однако это не обязательно, т.к. при запуске любой функции пакета, которая требует аутентификации будет запущен поиск файла с токеном доступа. Если файл не будет найден, то автоматически будет запущен процесс авторизации и запроса токена.

Перед выполнением аутентификации рекомендую заранее создать папку для сохранения токенов и далее объявлять её рабочей директорией перед запуском функций пакета.


### Создание папки


```
# Задаём адрес директории (папки) для токенов
path <- "C:/Tokens/yamarketR"
# Создаём директорию если её нет
dir.create(path, recursive=TRUE)
```


Теперь перед началом работы с функциями пакета необходимо объявить созданную папку "рабочей", это позволит избежать необходимости повторно проходить авторизацию


### Задать "рабочую" папку

Чтобы объявить папку "рабочей" - выполните функцию:


```
# Устанавливаем рабочую директорию
setwd("C:/Tokens/yamarketR")
```



### Пример кода для прохождения авторизации

Если вы всё же хотите заранее пройти аутентификацию - выполните следующую функцию:


```
yamarketAuth(Login = "Ваш логин в Яндексе", NewUser = FALSE, TokenPath = "путь к папке для сохранения токена")
```


### Обновление токена

При каждом обращении к API проверяется количество дней до того как используемый токен станет просроченным, если остаётся менее 30 дней токен автоматически будет обновлён, и файл с учётными данными перезаписан.

**Аргументы функции yamarketAuth**



*   **Login** - имя пользователя или электронный адрес на Яндексе, с которого есть доступ к нужному вам рекламному аккаунту
*   **NewUser** - логическое выражаение TRUE или FALSE, признак того, что у пользователя обязательно нужно запросить разрешение на доступ к аккаунту (даже если пользователь уже разрешил доступ данному приложению). Получив этот параметр, Яндекс.OAuth предложит пользователю разрешить доступ приложению и выбрать нужный аккаунт Яндекса. Параметр полезен, например, если вы хотите переключиться на другой аккаунт. По умолчанию установлено значение FALSE.
*   **TokenPath** - путь к папке, в которой будут сохраняться учётные данные, по умолчанию это рабочая директория, но можно указывать любой путь, как абсолютный например "C:/Tokens/yamarketR", так и относительный "tokens", при использовании относительного пути в рабочей директории будет создана папка с установленным вами названием, и в неё будут сохраняться файлы с расширением .RData в которых хранятся учётные данные.


## Аргументы, общие для всех функций

Во всех функции пакета существуют общие аргументы, в дальнейшем эти аргументы рассматриваться в описании функций не будут.



*   Campaigns - data.frame, полученный в результате выполнения функции getCampaigns со списком всех магазинов аккаунта, ID конкретного магазина или вектор, содержащий ID нескольких магазинов, для которых необходимо получить данные.
*   Login - Логин яндекса, под которым есть доступ к нужным магазинам. В этот вектор необходимо указывать логин в случае если необходимо подключаться к разным аккаунтам. В противном случае при каждом запросе к новому аккаунту - токен будет перезатираться. При указании логина в рабочей директории будет создан отдельный файл под каждый логин, в котором будут хранится нужные для работы учётные данные.
*   TokenPath - Путь к папке в которой хранятся все файлы с учётными данными, по умолчанию все функции пакета пытаются найти нужный файл с хранящимися учётными данными в текущей рабочей директории, но вы можете указывать абсолютный или условный путь к совершенно любой папке на вашем ПК, в которой вы хотите хранить все учётные данные ваших аккаунтов Яндекс Директ. Пример условного пути TokenPath = "market_token", в таком случае в рабочей директории будет создана папка market_token в которую и будут сохраняться все учётные данные, указав этот путь во всех функциях пакета вам не понадобится повторно запрашивать токены.


## Функции пакета

## Загрузка списка кампаний (магазинов)
### `getCampaigns(Login = NULL, TokenPath = getwd())`

Данная функция возвращает data.frame со списком всех кампаний доступных в аккаунте которому был выдан токен для доступа к API.

Структура data.frame, возвращаемого функцией `getCampaigns`:


<table>
  <tr>
   <td>Поле
   </td>
   <td>Тип данных
   </td>
   <td>Описание
   </td>
  </tr>
  <tr>
   <td>id
   </td>
   <td>int
   </td>
   <td>Идентификатор кампании. В интерфейсе он выводится в формате 11-******. В API же используется часть после дефиса. Количество знаков после дефиса может отличаться и зависит от того, как давно вы зарегистрировали кампанию.
   </td>
  </tr>
  <tr>
   <td>domain
   </td>
   <td>chr
   </td>
   <td>URL-адрес кампании
   </td>
  </tr>
  <tr>
   <td>state
   </td>
   <td>factor
   </td>
   <td>Статус магазина
<p>
Возможные значения:<ul>

<li>включен.
<li>выключен.
<li>включается.
<li>выключается.</li></ul>

   </td>
  </tr>
  <tr>
   <td>stateReasons
   </td>
   <td>chr
   </td>
   <td>Список причин, объясняющих статус магазина.
<p>
Выводится, если параметр state имеет значения:<ul>

<li>выключен.
<li>выключается.
</li></ul>
<p>
Код причины.
<p>
Возможные значения:<ul>

<li>проверяется.
<li>требуется проверка.
<li>выключен или выключается менеджером.
<li>выключен или выключается из-за финансовых проблем.
<li>выключен или выключается из-за ошибок в прайс-листе.
<li>выключен или выключается пользователем.
<li>выключен или выключается за неприемлемое качество.
<li>выключен или выключается из-за обнаружения дублирующих витрин.
<li>выключен или выключается из-за прочих проблем качества.
<li>выключен или выключается по расписанию.
<li>выключен или выключается, так как сайт магазина временно недоступен.
<li>выключен или выключается за недостаток информации о магазине.
<li>выключен или выключается из-за неактуальной информации.

<p>
Параметр выводится только для формата XML и является атрибутом параметра reason. Для формата JSON выводится код причины в виде числа.
</li></ul>

   </td>
  </tr>
</table>


## Загрузка текущего баланса магазинов
### `getBalance(Campaigns = NULL, Login = NULL, TokenPath = getwd())`

[Ссылка на официальную документацию.](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-balance-docpage/) \
Данная функция возвращает data.frame со списком всех кампаний доступных в аккаунте которому был выдан токен для доступа к API.

Структура data.frame, возвращаемого функцией `getCampaigns`:


<table>
  <tr>
   <td>Поле
   </td>
   <td>Тип данных
   </td>
   <td>Описание
   </td>
  </tr>
  <tr>
   <td>id
   </td>
   <td>int
   </td>
   <td>Идентификатор кампании. В интерфейсе он выводится в формате 11-******. В API же используется часть после дефиса. Количество знаков после дефиса может отличаться и зависит от того, как давно вы зарегистрировали кампанию.
   </td>
  </tr>
  <tr>
   <td>balance
   </td>
   <td>num
   </td>
   <td>Текущий баланс магазина.
<p>
Все расчеты производятся в условных единицах (у. е.). В Маркете установлен постоянный курс, который составляет:<ul>

<li>для России — 30 рублей (включая НДС);
<li>для иностранных партнеров — 0,41 доллара.

<p>
Подробнее по <a href="https://yandex.ru/support/partnermarket/about/placement-cost.html">ссылке</a>.</li></ul>

   </td>
  </tr>
  <tr>
   <td>daysLeft
   </td>
   <td>int
   </td>
   <td>Прогнозируемое количество дней, оставшихся до полного израсходования средств.
   </td>
  </tr>
  <tr>
   <td>recommendedPayment
   </td>
   <td>num
   </td>
   <td>Рекомендованная сумма платежа, в условных единицах.
   </td>
  </tr>
</table>

## Загрузка расхода магазинов за выбранный период
### `getCosts(Campaigns, fromDate = format(Sys.Date()-8, "%d-%m-%Y"), toDate = format(Sys.Date()-1, "%d-%m-%Y"), Login = NULL, TokenPath = getwd(), places = 0, model = 0, fetchBy = "daily")`

[Ссылка на официальную документацию.](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-stats-main-docpage/) \
Данная функция возвращает data.frame со расходами магазинов, указанных в переменной Campaigns за последние 7 дней.

Структура data.frame, возвращаемого функцией `getCosts:`


<table>
  <tr>
   <td>Поле
   </td>
   <td>Тип данных
   </td>
   <td>Описание
   </td>
  </tr>
  <tr>
   <td>date
   </td>
   <td>int
   </td>
   <td>Дата, за которую был зафиксирован расход
   </td>
  </tr>
  <tr>
   <td>id
   </td>
   <td>int
   </td>
   <td>Идентификатор кампании. В интерфейсе он выводится в формате 11-******. В API же используется часть после дефиса. Количество знаков после дефиса может отличаться и зависит от того, как давно вы зарегистрировали кампанию.
   </td>
  </tr>
  <tr>
   <td>placeGroup
   </td>
   <td>int
   </td>
   <td>Места размещения при заданной в запросе группировке по местам размещения (параметр входных данных places=1).
<p>
Возможные значения:<ul>

<li>поиск Яндекс.Маркета.
<li>карточки товаров.
    
   Примечание. Значение не выводится, если во входных данных задан параметр model = 1. 

<p>
<li>Яндекс.Маркет, кроме карточек товаров.

<li>поиск Яндекса, Яндекс.Картинки, сторонние сайты и сервисы.
<p>

   Если во входных данных указан параметр fields=model, дополнительные значения идентификатора места размещения непосредственно на карточке товара:
<li>предложение по умолчанию.
<li>блок «Топ-6».
<li>остальные места на карточке.
<p>
<li>иное - выводится, когда ни одна из других групп не подходит

<p>
Если группировка по местам размещения не задана в запросе, значение параметра равно 0.</li></ul>
   </td>
  </tr>
  <tr>
   <td>clicks
   </td>
   <td>int
   </td>
   <td>Количество кликов.
<p>
Выводится за день, неделю или месяц (в зависимости от значения параметра fetchBy).
   </td>
  </tr>
  <tr>
   <td>spending
   </td>
   <td>num
   </td>
   <td>Расход по кликам в условных единицах с учетом НДС.
<p>
Выводится за день, неделю или месяц (в зависимости от значения параметра fetchBy).
   </td>
  </tr>
  <tr>
   <td>shows
   </td>
   <td>int
   </td>
   <td>Количество показов предложения.
<p>
Выводится за день, неделю или месяц (в зависимости от значения параметра fetchBy).
   </td>
  </tr>
</table>


**Аргументы:**



*   **fromDate**, **toDate** - начальная и конечная даты отчётного периода, по умолчанию последние 7 дней. \
Формат: ДД-ММ-ГГГ ("15-03-2018")
*   **places** - Признак группировки по местам размещения:

    1 — группировать.


    0 — не группировать.


    По умолчанию места размещения не группируются.

*   **model** - подробная информация о месте размещения предложения на карточке модели. \
Ограничение. Значение model работает, только если во входных данных задан параметр places со значением: 1 
*   **fetchBy** = "daily" - признак группировки по дням, неделям, месяцам ("daily", "weekly", "monthly")

## Загрузка списка логинов, прикреплённых к кампании (магазину)
### `getLogins(Campaigns, howmuch = NULL, Login = NULL, TokenPath = getwd())`

[Ссылка на официальную документацию.](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-logins-docpage/) \
Данная функция возвращает список логинов, которые прикреплены к выбранным магазинам. Может использоваться для группировки магазинов одного клиента.

Структура data.frame, возвращаемого функцией `getLogins:`


<table>
  <tr>
   <td>Поле
   </td>
   <td>Тип данных
   </td>
   <td>Описание
   </td>
  </tr>
  <tr>
   <td>date
   </td>
   <td>int
   </td>
   <td>Дата, за которую был зафиксирован расход
   </td>
  </tr>
  <tr>
   <td>id
   </td>
   <td>int
   </td>
   <td>Идентификатор кампании. В интерфейсе он выводится в формате 11-******. В API же используется часть после дефиса. Количество знаков после дефиса может отличаться и зависит от того, как давно вы зарегистрировали кампанию.
   </td>
  </tr>
  <tr>
   <td>logins
   </td>
   <td>chr
   </td>
   <td>логин или список логинов, можно регулировать кол-во выводимых логинов с помощью параметра <strong>howmuch</strong>
   </td>
  </tr>
</table>


**Атрибуты:**



*   **howmuch** - атрибут определяет количество логинов, которые нужно вывести. \
По умолчанию - возвращаются все логины у которых есть доступ к магазину. \
Ограничение задаётся с помощью чисел 1, 2, 3 и т.д.
