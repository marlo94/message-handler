/*----------------------------------------------------------------------------
| Routine : sp_deleteLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Deletes a message type by its ID
|
| Parameters :
| ------------
|  IN  :  in_languageId     : The Language ID
|  OUT :  out_message       : Returns message if the is a error
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_deleteLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_deleteLanguage(
  IN  in_languageId CHAR(2),
  OUT out_message   VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    START TRANSACTION;
    IF EXISTS(SELECT idLanguage
              FROM tblLanguage
              WHERE idLanguage = in_languageId)
    THEN
      -- Delete Language
      DELETE FROM tblLanguage
      WHERE idLanguage = in_languageId;
    ELSE
      SET out_message = CONCAT("Error: Could not find language with the id of ", in_languageId);
      ROLLBACK;
    END IF;
    COMMIT;
  END//

DELIMITER ;
