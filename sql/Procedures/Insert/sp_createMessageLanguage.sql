/*----------------------------------------------------------------------------
| Routine : sp_createMessageLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Adds a new Message in the selected language to the table tblMessageLanguage
|
| Parameters :
| ------------
|  IN  :  in_message        : The Message ID
|         in_language       : The Language ID
|         in_text           : The Text for the Message in the selected language
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

DROP PROCEDURE IF EXISTS sp_createMessageLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_createMessageLanguage(
  IN  in_message       INT,
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

    IF NOT EXISTS( SELECT idMessage FROM tblMessage WHERE idMessage = in_message) THEN



    -- Creation of Type
    INSERT INTO tblMessageLanguage
    SET fiMessage = in_message,
      fiLanguage  = in_language,
      dtText      = in_text;
    END IF;

    -- ERROR-Treatment
    CASE out_errorID
      WHEN 1452
      THEN SET out_errorMessage = "Insert: Foreign key ERROR !";
      WHEN 1062
      THEN SET out_errorMessage = "Insert: Duplicate key ERROR !";
    ELSE
      BEGIN
        SET out_errorMessage = CONCAT("Insert-status: New Error ", out_errorID);
      END;
    END CASE;
  END//
