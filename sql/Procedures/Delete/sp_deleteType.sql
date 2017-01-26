/*----------------------------------------------------------------------------
| Routine : sp_deleteType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Deletes a message type by its ID
|
| Parameters :
| ------------
|  IN  :  in_messageTypeId     : the Message Type
|  OUT :  out_message      : Returns message if the is a error
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_deleteType;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_deleteType(
  IN  in_messageTypeId      INT,
  OUT out_message VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    START TRANSACTION;
      IF EXISTS(SELECT idType FROM tblType WHERE idType = in_messageTypeId) THEN
        -- Delete Message Type
        DELETE FROM tblType WHERE idType = in_messageTypeId;
      ELSE
        SET out_message = CONCAT("Error: Could not find Type with the id of ", in_output);
        ROLLBACK;
      END IF;
    COMMIT;
  END//

DELIMITER ;
