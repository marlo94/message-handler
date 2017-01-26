/*----------------------------------------------------------------------------
| Routine : sp_updateType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Updates a Message Type
|
| Parameters :
| ------------
|  IN  :  in_type           : The MessageType ID
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_updateType;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_updateType(
  IN  in_type          CHAR(4)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Creation of Type
    UPDATE tblType
    SET idType = in_type
    WHERE idType = in_type;

  END//
DELIMITER ;
