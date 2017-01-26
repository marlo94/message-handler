/*----------------------------------------------------------------------------
| Routine : sp_getMessageLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all messages in the specified language
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all message languages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessageLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessageLanguage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~',fiLanguage,fiMessage,dtText) ORDER BY fiLanguage,fiMessage SEPARATOR '$$')
    FROM tblMessageLanguage
    INTO out_result;

  END //

DELIMITER ;
