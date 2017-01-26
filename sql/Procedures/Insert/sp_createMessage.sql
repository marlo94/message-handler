/*----------------------------------------------------------------------------
| Routine : sp_createMessage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Adds a new message to the table tblMessage
|
| Parameters :
| ------------
|  IN  :  in_type           : The MessageType Foreign Key
|         in_description    : The Message Description
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
|                         1032 :
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_createMessage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_createMessage(
  IN  in_description   VARCHAR(200),
  IN  in_type          CHAR(4),
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
      -- Creation of Message
      INSERT INTO tblMessage
      SET dtDescription = in_description,
        fiType          = in_type;
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
