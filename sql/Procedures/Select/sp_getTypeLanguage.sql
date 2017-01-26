/*----------------------------------------------------------------------------
| Routine : sp_getMessageType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all message types in the specified language
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all message types in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/

DELIMITER //
DROP PROCEDURE IF EXISTS sp_getTypeLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getTypeLanguage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~',fiLanguage,fiType,dtText) ORDER BY fiLanguage,fiType SEPARATOR '$$')
    FROM tblTypeLanguage
    INTO out_result;

  END //

DELIMITER ;
