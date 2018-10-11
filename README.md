# yamarketr - пакет для работы с Партнёрским API Яндекс.Маркета на языке R


## Краткое описание

Данный пакет предназначен для получения данных из Яндекс.Маркета с помощью языка R. 

Данный пакет позволит получить доступ к следующей информации:



*   Список кампаний (магазинов)
*   Баланс кампаний
*   Расход по периодам
*   Список ошибок
*   Список логинов

На очереди работа над функциями:



*   [Расход по предложениям](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-stats-offers-docpage/)
*   [Параметры кампании](https://tech.yandex.ru/market/partner/doc/dg/reference/get-campaigns-id-settings-docpage/)
*   [Точки продаж](https://tech.yandex.ru/market/partner/doc/dg/reference/outlet-methods-docpage/)
*   [Список предложений для модели (конкурентная аналитика в карточках)](https://tech.yandex.ru/market/partner/doc/dg/reference/content-methods-docpage/)

Функции пакета постепенно будут добавляться и расширяться в описании будет указаны статус разработки и планируемые изменения.


## Установка пакета yandexmarketr

Установка пакета осуществляется из репозитория GitHub, для этого сначала требуется установить и подключить пакет devtools.


```
install.packages("devtools")
library(devtools)
```


После чего можно устанавливать пакет yandexmarketr.


```
install_github('mrykinpavel/yandexmarketr')
```



## Функции пакета


### getCampaigns(token, client_id)

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
   <td>Статус Кампании
<p>
Возможные значения:<ul>

<li>1 — кампания включена.
<li>2 — кампания выключена.
<li>3 — кампания включается.
<li>4 — кампания выключается.</li></ul>

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

<li>2 — выключен.
<li>4 — выключается.

<p>
Код причины.
<p>
Возможные значения:<ul>

<li>5 — проверяется.
<li>6 — требуется проверка.
<li>7 — выключен или выключается менеджером.
<li>9 — выключен или выключается из-за финансовых проблем.
<li>11 — выключен или выключается из-за ошибок в прайс-листе.
<li>12 — выключен или выключается пользователем.
<li>13 — выключен или выключается за неприемлемое качество.
<li>15 — выключен или выключается из-за обнаружения дублирующих витрин.
<li>16 — выключен или выключается из-за прочих проблем качества.
<li>20 — выключен или выключается по расписанию.
<li>21 — выключен или выключается, так как сайт магазина временно недоступен.
<li>24 — выключен или выключается за недостаток информации о магазине.
<li>25 — выключен или выключается из-за неактуальной информации.

<p>
Параметр выводится только для формата XML и является атрибутом параметра reason. Для формата JSON выводится код причины в виде числа.</li></ul>
</li></ul>

   </td>
  </tr>
</table>



<!-- GD2md-html version 1.0β13 -->
