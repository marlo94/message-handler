/*----------------------------------------------------------------------------
| Routine : sp_getType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all message types
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all message type
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getType;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getType(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~', idType) SEPARATOR '$$')
    FROM tblType
    INTO out_result;

  END //

DELIMITER ;
