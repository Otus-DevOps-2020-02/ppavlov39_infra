# ppavlov39_infra

[![Build Status](https://travis-ci.com/Otus-DevOps-2020-02/ppavlov39_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2020-02/ppavlov39_infra)

ppavlov39 Infra repository

<h2>SSH</h2>

Для подключения к хосту, расположенному за внутри периметра, можно использовать следующие команды:<br>
$ssh bastion -t ssh someinternalhost<br>
$ssh -o ProxyCommand="ssh -W %h:%p bastion" someinternalhost<br>
$ssh -J bastion someinternalhost<br>
Где:<br><ul>
    <li> bastion - хост используменый как промежуточный для доступа ко внутренним узалам;</li>
    <li> someinternalhost - целевой хост, недоступный из внешней сети;</li>
</ul>
Для подключения к целевому хосту, используя команду "ssh someinternalhost" необходимо в директории ~/.ssh/ создать файл "config", в котором должно быть следующее:<br>
<pre>Host bastion
     HostName <bastion_host_address>
     User <ssh_user>
     ForwardAgent yes
<P>
Host someinternalhost
    HostName someinternalhost
    ProxyJump bastion
</pre>
<P>
<h2>VPN</h2>

Адрес WEB-интерфейса VPN-сервера, с подключенным SSL-сертификатом от Let's Encrypt: https://35.214.205.69.xip.io<P>
<P>
<pre>
bastion_IP = 35.214.205.69
someinternalhost_IP = 10.164.0.3
</pre>

<P>
<h2>Развертывание тестового приложениея в Google Cloud </h2>
<b>Данные для подключения к тестовому серверу:</b><br>
<pre>
testapp_IP = 34.90.120.26
testapp_port = 9292
</pre>
<P>
<B>Автоматическое развертывание приложения при создании ВМ</B><br>
Был написан скрипт для автоматического создания ВМ с развернутым и запущенным приложением.<br>
Код скрипта находится в файле setup_scritp.sh, в корневой директории проекта.<br>
Для создания ВМ с запуском скрипта необходимо выполнить следующую команду (коря проета):<br>
<pre>
gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --metadata-from-file startup-script=./setup_scritp.sh --restart-on-failure
</pre>
<P>
Содержимое setup_scritp.sh:<br>
<pre>
#!/bin/bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xd68fa50fea312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
apt update
apt install -y mongodb-org
systemctl enable mongod && sudo systemctl start mongod
apt install -y ruby-full ruby-bundler build-essential

useradd appuser -s /bin/bash -m -G sudo
echo "appuser:asdadjhsdjhsdfkjhsdjf" | sudo chpasswd
su -c 'cd /home/appuser && git clone -b monolith https://github.com/express42/reddit.git' appuser
cd /home/appuser/reddit/ && sudo bundle install
chown appuser:appuser -R /home/appuser

su -c 'cd /home/appuser/reddit && puma -d'
</pre>
<P>
<B>Настройка Firewall</B><br>
Для того, чтобы порт, на котором работает приложение, был доступен из вне, нужно выполнить команду:<br>
<pre>
gcloud compute firewall-rules create default-puma-server --allow tcp:9292
</pre>

<h2>Packer</h2>
<b>В этой работе сделано:</b>
<ul>
  <li>Написан шаблон для Packer. Протестирована работа ВМ созданной на его основе;</li>
  <li>В шаблон добавлено использование переменных, которые вынесены в отдельный файл;</li>
  <li>Файл с переменными включен в .gitignore;</li>
  <li>Дополнительно написан шаблон для образа reddit-full, в котором реализовано создание образа с развернутым приложением, запускающимся вместе в ВМ. В качестве базового образа используется ранее созданный reddit-base;</li>
  <li>В файл "config-scripts/create-reddit-vm.sh" помещена команда создающая новый инстанс из ранее собранного образа, с уже развернутым приложением и настроенным его автозапуском (reddit-full).
  <pre>gcloud compute instances create reddit-app-test --image-family reddit-full --machine-type=f1-micro</pre>
  </li>
</ul>

<h2>Terraform-1</h2>
<b>В этой работе сделано:</b>
<ul>
  <li>Изучены основы работы с Terraform;</li>
  <li>Написан конфигурационный файл для Terraform, описывающий развертывание ВМ в GCP;</li>
  <li>Созданы файлы для использования переменных в основном конфигурационном файле и файл для получения определненных выходных данных при работе Terraform;</li>
  <li>Настроено правило межсетевого экрана для доступа к разворачиваемому приложению;</li>
  <li>Настроены провижинеры для выполнения команд на удаленной ВМ;</li>
  <li>Настроено добавление SSH-ключей нескольких пользователей в метаданные проекта;<br>При этом стоит обратить внимание, что, <b>если в метаданных проекта были установлены какие-либо SSH-ключи, то они будут удалены;</b></li>
</ul>

<h2>Terraform-2</h2>
<b>В этой работе сделано:</b>
<ul>
  <li>Добавлено ресурс для упраления доступом по SSH;</li>
  <li>Созданы два отдельных шаблона и образа, отдельный для БД и отдельный для приложения;</li>
  <li>Конфигурация разбита на три модуля: прилоежние, БД и брандмауэр</li>
  <li>С целью уменьшения количества кода, созданы конфигурации для двех окружений (stage и prod);</li>
  <li>Добавлен параметр для управления типом создаваемой ВМ;</li>

<h2>Ansible-1</h2>
<b>В этой работе сделано:</b>
<ul>
  <li>Установлен и сконфигурирован Ansible;</li>
  <li>Выполнено знакомство с базовыми функциями Ansible;</li>
  <li>Опробованы в работе различные модули и варианты используемых Inventory-файлов;</li>
  <li>Написан простой Playbook;</li>
  <li>Написан скрипт для опробирования динамического инвентори, генерирующий инвентори из захардкоженной в нем информации;</li>
  <li>В дирректории с файлами Ansible созданы три файла инвентори: в ini-формате, в формате YAML и в формате json.</li>

<h2>Ansible-2</h2>
<b>В этой работе сделано:</b>
<ul>
  <li>Были опробованы варианты организации прейбуков Ansible в виде одного файла, как содежащего один общий сценарий, так с разбиением на несколько сценариев для отдельных задач, а также вариант с использованием скольких плейбуков, включаемых в один общий;</li>
  <li>Выполнено знакомство с шаблонами, переменными и хендлерами;</li>
  <li>Настроены отдельные плейбуки для настройки сервера под приложение, БД и деплоя самого приложения;</li>
  <li>Был изменен провижининг в конфигах Packer для подготовики образов с использования скриптов на использование плейбуков Ansible;</li>

