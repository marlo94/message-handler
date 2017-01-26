/*----------------------------------------------------------------------------
| Routine : sp_msg
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-01-2017
|
| Description : Returns a String with the message selected
|
| Parameters :
| ------------
|  IN :         in_languageID    : The language ID
|               in_messageID     : The Message ID
|               in_timeStamp     : Select if you want to display a timestamp or not
|
|  OUT :        out_result     : Outputs a string
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_msg;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_msg(
  IN  in_languageID  CHAR(3),
  IN  in_messageID 	 INT,
  IN  in_timeStamp   BOOLEAN,
  OUT out_result     TEXT)
  SQL SECURITY DEFINER
  BEGIN
    IF in_timeStamp = '1' THEN
      SELECT CONCAT("[",CURRENT_TIMESTAMP(),"] ", tblTypeLanguage.dtText ,": ", tblMessageLanguage.dtText)
      FROM tblMessageLanguage, tblTypeLanguage, tblMessage
      WHERE tblTypeLanguage.fiType = tblMessage.fiType
            AND tblMessageLanguage.fiLanguage = in_languageID
            AND tblTypeLanguage.fiLanguage = in_languageID
            AND tblMessageLanguage.fiMessage = in_messageID
            AND tblMessageLanguage.fiMessage = tblMessage.idMessage
      INTO out_result;
    ELSE
      SELECT CONCAT(tblTypeLanguage.dtText,": ", tblMessageLanguage.dtText)
      FROM tblMessageLanguage, tblTypeLanguage, tblMessage
      WHERE tblTypeLanguage.fiType = tblMessage.fiType
            AND tblMessageLanguage.fiLanguage = in_languageID
            AND tblTypeLanguage.fiLanguage = in_languageID
            AND tblMessageLanguage.fiMessage = in_messageID
            AND tblMessageLanguage.fiMessage = tblMessage.idMessage
      INTO out_result;
    END IF;
  END //

DELIMITER ;
