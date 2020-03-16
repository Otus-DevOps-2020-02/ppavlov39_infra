# ppavlov39_infra
ppavlov39 Infra repository

<h2>SSH</h2>

Для подключения к хосту, расположенному за внутри периметра, можно использовать следующие команды:
$ssh bastion -t ssh someinternalhost
$ssh -o ProxyCommand="ssh -W %h:%p bastion" someinternalhost
$ssh -J bastion someinternalhost
Где:
    - bastion - хост используменый как промежуточный для доступа ко внутренним узалам;
    - someinternalhost - целевой хост, недоступный из внешней сети;

Для подключения к целевому хосту, используя команду "ssh someinternalhost" необходимо в директории ~/.ssh/ создать файл "config", в котором должно быть следующее:
Host bastion
     HostName <bastion_host_address>
     User <ssh_user>
     ForwardAgent yes

Host someinternalhost
    HostName someinternalhost
    ProxyJump bastion

<h2>VPN</h2>

Адрес WEB-интерфейса VPN-сервера, с подключенным SSL-сертификатом от Let's Encrypt: https://35.214.205.69.xip.io

bastion_IP = 35.214.205.69
someinternalhost_IP = 10.164.0.3
