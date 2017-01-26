/*----------------------------------------------------------------------------
| Routine : sp_createTypeLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 14-05-2016
|
| Description : Add a new Type with the chosen language
|
| Parameters :
| ------------
|  IN  :  in_type           : The MessageType
|         in_language       : The MessageType Language
|         in_text           : The MessageTypeText for the selected Language
|
|  OUT :  out_errorID       : Indicate the status-code of the execution
|         out_errorMessage  : A textual explication of the error
|
| stdReturnValues :
| -----------------
|   stdReturnParameter  : out_errorMessage , out_errorID
|   stdReturnValuesUsed :    0 : Successfully executed
|                         1062 : Duplicate Error
|                         1452 : Foreign Key Error
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_createTypeLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_createTypeLanguage(
  IN  in_type          CHAR(4),
  IN  in_language      CHAR(2),
  IN  in_text          VARCHAR(255),
  OUT out_errorID      INT,
  OUT out_errorMessage VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN

    -- Declaration of named conditions
    DECLARE foreignKey_error CONDITION FOR 1452;
    DECLARE duplicateKey_error CONDITION FOR 1062;

    -- Declaration of handlers
    DECLARE CONTINUE HANDLER FOR foreignKey_error SET out_errorID = 1452;
    DECLARE CONTINUE HANDLER FOR duplicateKey_error SET out_errorID = 1062;

    -- Initialisation of the out-parameters
    SET out_errorID = 0;
    SET out_errorMessage = "Insert: Successful";
    START TRANSACTION;
      -- Creation of Type
      INSERT INTO tblTypeLanguage
      SET fiType = in_type,
        fiLanguage = in_language,
        dtText = in_text;
    COMMIT;
    -- ERROR-Treatment
    CASE out_errorID
      WHEN 1452
        THEN SET out_errorMessage = "Insert: Foreign key ERROR !";
        ROLLBACK;
      WHEN 1062
        THEN SET out_errorMessage = "Insert: Duplicate key ERROR !";
        ROLLBACK;
    ELSE
      BEGIN
        SET out_errorMessage = CONCAT("Insert-status: New Error", out_errorID);
      END;
    END CASE;
  END//
