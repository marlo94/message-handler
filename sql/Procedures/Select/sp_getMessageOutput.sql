/*----------------------------------------------------------------------------
| Routine : sp_getMessageOutput
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with the message attached with a current TimeStamp
|
| Parameters :
| ------------
|  IN :         in_languageID    : The language ID
|               in_messageID     : The Message ID
|
|  OUT :        out_result     : Outputs a message in csv format with a timestamp and messagetype
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessageOutput;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessageOutput(
  IN  in_languageID  CHAR(3),
  IN  in_messageID INT,
  OUT out_result   TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~', CURRENT_TIMESTAMP(), tblTypeLanguage.dtText, tblMessageLanguage.dtText)
                        SEPARATOR '$$')
    FROM tblMessageLanguage, tblTypeLanguage, tblMessage
    WHERE tblMessage.fiType = fiType
          AND tblMessageLanguage.fiLanguage = in_languageID
          AND tblTypeLanguage.fiLanguage = in_languageID
          AND tblMessageLanguage.fiMessage = in_messageID
          AND tblMessageLanguage.fiMessage = tblMessage.idMessage
    INTO out_result;
  END //

DELIMITER ;
