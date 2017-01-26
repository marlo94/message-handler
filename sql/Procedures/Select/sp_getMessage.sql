/*----------------------------------------------------------------------------
| Routine : sp_getMessage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all messages
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all messages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~',idMessage,dtDescription,fiType) ORDER BY idMessage SEPARATOR '$$')
    FROM tblMessage
    INTO out_result;

  END //

DELIMITER ;
