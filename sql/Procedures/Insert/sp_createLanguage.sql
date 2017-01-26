/*----------------------------------------------------------------------------
| Routine : sp_createLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Adds a new language to the table tblLanguage
|
| Parameters :
| ------------
|  IN  :  in_abbreviation   : The abbreviation for the new language
|         in_language       : The name of the new language
|
|  OUT :  out_errorID       : Indicate the status-code of the execution
|         out_errorMessage  : A textual explication of the error
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : out_errorMessage , out_errorID
|   stdReturnValuesUsed :    0 : Successfully executed
|                         1062 : Duplicate Error
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_createLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_createLanguage(
  IN  in_abbreviation  CHAR(2),
  IN  in_language      VARCHAR(50),
  OUT out_errorID      INT,
  OUT out_errorMessage VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    -- Declaration of named conditions
    DECLARE duplicateKey_error CONDITION FOR 1062;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR duplicateKey_error SET out_errorID = 1062;

    -- Initialisation of the out-parameters
    SET out_errorID = 0;
    SET out_errorMessage = "Insert: Successful";
    START TRANSACTION;
      -- Creation of Language
      INSERT INTO tblLanguage
      SET idLanguage = in_abbreviation,
        dtName       = in_language;
    COMMIT;
    -- ERROR-Treatment
    CASE out_errorID
      WHEN 1062
      THEN SET out_errorMessage = "Insert: Duplicate key ERROR !";
      ROLLBACK;
    ELSE
      BEGIN
        SET out_errorMessage = CONCAT("Insert-status: New Error", out_errorID);
      END;
    END CASE;
  END//

DELIMITER ;
