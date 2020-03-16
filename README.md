# ppavlov39_infra
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
<pre>Host bastion<br>
     HostName <bastion_host_address><br>
     User <ssh_user><br>
     ForwardAgent yes<br>
<P>
Host someinternalhost<br>
    HostName someinternalhost<br>
    ProxyJump bastion
</pre><P>
<h2>VPN</h2>

Адрес WEB-интерфейса VPN-сервера, с подключенным SSL-сертификатом от Let's Encrypt: https://35.214.205.69.xip.io<P>

bastion_IP = 35.214.205.69<br>
someinternalhost_IP = 10.164.0.3<br>
