<?php
include "vendor/jublonet/codebird-php/src/codebird.php";
include "vendor/textmagic-sms-api-php/TextMagicAPI.php";

function msg($language, $messageID, $timestamp = false)
{
	$pdo = getPDO();
	$stmt = $pdo->prepare("CALL sp_msg(?,?,?,@result);");
	$stmt->bindParam(1, $language, PDO::PARAM_STR);
	$stmt->bindParam(2, $messageID, PDO::PARAM_INT);
	$stmt->bindParam(3, $timestamp, PDO::PARAM_BOOL);
	$stmt->execute();

	return $pdo->query("select @result;")->fetch(PDO::FETCH_ASSOC)['@result'];
}

function msg_log($path, $language, $messageID)
{
	$data = msg("$language", "$messageID", true);
	file_put_contents($path, $data . "\n", FILE_APPEND);
}

function msg_twitter($language, $messageID, $timestamp)
{
	$json = getConfig("twitter");

	\Codebird\Codebird::setConsumerKey("$json->consumer_key", "$json->consumer_secret");
	$cb = \Codebird\Codebird::getInstance();
	$cb->setToken("$json->oauth_access_token", "$json->oauth_access_token_secret");

	$params = array(
		'status' => msg($language, $messageID, $timestamp)
	);
	$cb->statuses_update($params);
}

function msg_sms($language, $messageID, $phones)
{
	$json = getConfig("sms");
	$api = new TextMagicAPI(array(
		"username" => $json->textmagic->api_username,
		"password" => $json->textmagic->api_password
	));

	$text = msg($language, $messageID);
	$api->send($text, $phones, true);
}

function getConfig($param = null)
{
	if ($param == null) {
		return json_decode(file_get_contents("config/config.json"));
	} else {
		return json_decode(file_get_contents("config/config.json"))->$param;
	}
}

function getPDO()
{
	$json = getConfig("database");
	return new PDO(key($json) . ":host={$json->mysql->host};dbname={$json->mysql->dbname};charset={$json->mysql->charset};", $json->mysql->username, $json->mysql->password);
}


