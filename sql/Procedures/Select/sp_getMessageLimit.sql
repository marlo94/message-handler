/*----------------------------------------------------------------------------
| Routine : sp_getMessageLimit
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns the X Last messages created with the message type language and the user who created it.
|
| Parameters :
| ------------
|  INT : in_limit        : Limit of last created messages
|
|  OUT :  out_result     : Outputs all message languages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessageLimit;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessageLimit(
  IN  in_limit   INT,
  OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
SET GROUP_CONCAT_MAX_LEN = 10000;
    SELECT SUBSTRING_INDEX(GROUP_CONCAT(CONCAT_WS('~', dtText, tblLanguage.dtName, tblMessage.fiType,tblMessageLanguage.dtCreateDate)ORDER BY tblMessageLanguage.dtCreateDate DESC SEPARATOR '$$'),'$$',in_limit)
    FROM tblMessage, tblMessageLanguage, tblLanguage
    WHERE tblMessage.idMessage = tblMessageLanguage.fiMessage
          AND tblLanguage.idLanguage = tblMessageLanguage.fiLanguage
    INTO out_result;
  END //

DELIMITER ;
