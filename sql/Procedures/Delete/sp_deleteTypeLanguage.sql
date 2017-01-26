/*----------------------------------------------------------------------------
| Routine : sp_deleteTypeLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Deletes a LanguageType record where the type and language match
|
| Parameters :
| ------------
|  IN  :  in_type     : The Type for the TypeLanguage
|         in_language : The Language for the TypeLanguage
|  OUT :  out_message      : Returns message if the is a error
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_deleteTypeLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_deleteTypeLanguage(
  IN in_type     CHAR(4),
  IN in_language CHAR(2),
  OUT out_message VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    START TRANSACTION;
      IF EXISTS(SELECT fiType,fiLanguage FROM tblTypeLanguage
      WHERE fiType = in_type AND fiLanguage = in_language) THEN
        -- Delete TypeLanguage
        DELETE FROM tblTypeLanguage
        WHERE fiType = in_type AND fiLanguage = in_language;
      ELSE
        SET out_message = CONCAT("Error: Could not find type with the ids of ", in_type ," and language with the id ", in_language);
        ROLLBACK;
      END IF;
    COMMIT;
  END//

DELIMITER ;
