/*----------------------------------------------------------------------------
| Routine : sp_getLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all languages
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all languages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getLanguage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~', idLanguage, dtName) SEPARATOR '$$')
    FROM tblLanguage
    INTO out_result;

  END //

DELIMITER ;
