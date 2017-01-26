/*----------------------------------------------------------------------------
| Routine : sp_deleteMessage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Deletes a message by its ID
|
| Parameters :
| ------------
|  IN  :  in_messageId     : The messsage ID
|  OUT :  out_message      : Returns message if the is a error
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_deleteMessage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_deleteMessage(
  IN  in_messageId     INT,
  OUT out_message VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    START TRANSACTION;
      IF EXISTS(SELECT idMessage FROM tblMessage WHERE idMessage = in_messageId) THEN
        -- Delete Language
        DELETE FROM tblMessage WHERE idMessage = in_messageId;
      ELSE
        SET out_message = CONCAT("Error: Could not find message with the id of ", in_messageId);
        ROLLBACK;
      END IF;
    COMMIT;
  END//

DELIMITER ;
