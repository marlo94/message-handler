## The BTS Message Handler
### What's the Message Handler ?
This neat program is able to return messages, write messages into logs, tweet messages and write sms. It also contains shell scripts so that you can put them in a cron job.

### Platform
This app has been tested on Ubuntu 16.04.1 LTS.

### Requirements
* PHP 7.0+
* Apache 2.4.23+
* MySQL 5.7.16+
* Composer

### APIs
The Message Handler uses a few APIs:

* [jublonet/codebird-php](https://github.com/jublonet/codebird-php)
* [nezkal/TextMagicSMS](https://github.com/nezkal/TextMagicSMS)

### Examples
Returning messages:

![Alt Example of 'msg' command](images/msg_example.png?raw=true "msg command")

Also the command contains a wizard:

![Alt Example of 'msg' wizard command](images/msg_wizard_example.png?raw=true "msg wizard")
