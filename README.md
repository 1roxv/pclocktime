# PCLockTime
____
## Parental Control for Windows 7-10

You can control the time that you spent at the computer. It can be used both for children and for yourself.

Features:

* Сontrol by Telegram
* Entering in the settings with a hidden password
* Setting the default amount of time
* Adding and subtracting time for the current day
* Does not depend on the system clock
* Minimal consumption of PC resources
* No admin rights required

Сontrol by Telegram:

* You need to create a bot by @BotFather
* Create a group and add the created bot there
* Give the bot permission to read messages
* Specify in the program settings bot_token (with the prefix bot) and group chat_id in the program settings (find out the chat_id here https://api.telegram.org/botXXX:XXX/getUpdates)

For work, you need to "compile" BAT files with any bat to exe converter (for example, converter by Fatih Kodak). You can do without conversion, but you will need to make edits to the code.
Timer (timer.rs) is written in Rust, compile via cargo.
In dependencies: curl, bc, grep, head, tail.

____
## Родительский контроль для Windows 7-10

Вы можете контролировать время проведенное за компьютером. Можно использовать как для детей, так и для себя.

Возможности:
* Управление через Telegram
* Вход в настройки по скрытому паролю
* Установка количества времени по-умолчанию
* Добавление и убавление времени на текущий день
* Не зависит от системных часов
* Минимальное потребление ресурсов ПК
* Не требуются права администратора

Управление через Telegram:
* Нужно создать бота через @BotFather
* Создать группу и добавить туда созданного бота
* Дать боту права на чтение сообщений
* В настройках программы указать bot_token (с приставкой bot) и chat_id группы (узнать chat_id здесь https://api.telegram.org/botXXX:XXX/getUpdates)

Для работы нужно "скомпилировать" BAT файлы любым bat to exe конвертером (например от Fatih Kodak). Можно обойтись без конвертации, но нужно будет внести правки в код.  
Timer (timer.rs) написан на Rust, соответсвенно компилировать через cargo.  
В зависимостях: curl, bc, grep, head, tail.

<a href="url"><img src="https://github.com/iroxville/pclocktime/blob/main/pic1.jpg" align="left" height="260" width="500" ></a>

<a href="url"><img src="https://github.com/iroxville/pclocktime/blob/main/pic2.jpg" align="left" height="500" width="240" ></a>
