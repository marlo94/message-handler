/*----------------------------------------------------------------------------
| Routine : sp_deleteMessageLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Deletes a MessageLanguage record where the message and language match
|
| Parameters :
| ------------
|  IN  :  in_message  : The Type for the TypeLanguage
|         in_language : The Language for the TypeLanguage
|  OUT :  out_message      : Returns message if the is a error
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_deleteMessageLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_deleteMessageLanguage(
  IN in_message  INT,
  IN in_language CHAR(2),
  OUT out_errorMessage VARCHAR(255))
  SQL SECURITY DEFINER
  BEGIN
    START TRANSACTION;
    IF EXISTS(SELECT fiMessage, fiLanguage FROM tblMessageLanguage WHERE fiMessage = in_message AND fiLanguage = in_language) THEN
      -- Delete TypeLanguage
      DELETE FROM tblMessageLanguage
      WHERE fiMessage = in_message AND fiLanguage = in_language;
    ELSE
      SET out_errorMessage = CONCAT("Error: Could not find message with the ids of ", in_message ," and language with the id ", in_language);
      ROLLBACK;
    END IF;
    COMMIT;
  END//

DELIMITER ;
