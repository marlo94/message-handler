CREATE TABLE tblType (
  idType CHAR(4) PRIMARY KEY,
  dtCreateDate  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  dtUpdateDate  DATETIME ON UPDATE CURRENT_TIMESTAMP
)
  ENGINE = InnoDB;

CREATE TABLE tblMessage (
  idMessage     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dtDescription VARCHAR(200) NOT NULL,
  dtCreateDate  DATETIME     DEFAULT CURRENT_TIMESTAMP,
  dtUpdateDate  DATETIME ON UPDATE CURRENT_TIMESTAMP,
  fiType        CHAR(4)      NOT NULL,

  CONSTRAINT fk_Type_tblMessage
  FOREIGN KEY (fiType)
  REFERENCES tblType (idType)
    ON UPDATE CASCADE
    ON DELETE CASCADE
)
  ENGINE = InnoDB;

CREATE TABLE tblLanguage (
  idLanguage   CHAR(2)     NOT NULL PRIMARY KEY,
  dtName       VARCHAR(50) NOT NULL,
  dtCreateDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  dtUpdateDate DATETIME ON UPDATE CURRENT_TIMESTAMP
)
  ENGINE = InnoDB;


CREATE TABLE tblMessageLanguage (
  fiMessage    INT UNSIGNED        NOT NULL,
  fiLanguage   CHAR(2)             NOT NULL,
  dtText       VARCHAR(255) UNIQUE NOT NULL,
  dtCreateDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  dtUpdateDate DATETIME ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (fiMessage, fiLanguage),

  CONSTRAINT fk_Message_tblMessageLanguage
  FOREIGN KEY (fiMessage)
  REFERENCES tblMessage (idMessage)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  CONSTRAINT fk_Language_tblMessageLanguage
  FOREIGN KEY (fiLanguage)
  REFERENCES tblLanguage (idLanguage)
    ON UPDATE CASCADE
    ON DELETE CASCADE
)
  ENGINE = InnoDB;


CREATE TABLE tblTypeLanguage (
  fiType       CHAR(4)      NOT NULL,
  fiLanguage   CHAR(2)      NOT NULL,
  dtText       VARCHAR(255) NOT NULL,
  dtCreateDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  dtUpdateDate DATETIME ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (fiType, fiLanguage),

  CONSTRAINT fk_Type_tblTypeLanguage
  FOREIGN KEY (fiType)
  REFERENCES tblType (idType)
    ON UPDATE CASCADE
    ON DELETE NO ACTION,

  CONSTRAINT fk_Language_blTypeLanguage
  FOREIGN KEY (fiLanguage)
  REFERENCES tblLanguage (idLanguage)
    ON UPDATE CASCADE
    ON DELETE CASCADE
)
  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS tblChanges (
  idChanges INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  dtUser    VARCHAR(255) NOT NULL,
  dtTable   VARCHAR(255) NOT NULL,
  dtColumn  VARCHAR(255) NOT NULL,
  dtOld     VARCHAR(255) NOT NULL,
  dtNew     VARCHAR(255) NOT NULL,
  dtDate    DATETIME                 DEFAULT CURRENT_TIMESTAMP
)
  ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS tblRemovals (
  idChanges INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  dtUser    VARCHAR(255) NOT NULL,
  dtTable   VARCHAR(255) NOT NULL,
  dtRow     VARCHAR(255) NOT NULL,
  dtDate    DATETIME                 DEFAULT CURRENT_TIMESTAMP
)
  ENGINE = InnoDB;
/*----------------------------------------------------------------------------
| Routine : sp_getLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all languages
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all languages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getLanguage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~', idLanguage, dtName) SEPARATOR '$$')
    FROM tblLanguage
    INTO out_result;

  END //

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_getMessage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all messages
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all messages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~',idMessage,dtDescription,fiType) ORDER BY idMessage SEPARATOR '$$')
    FROM tblMessage
    INTO out_result;

  END //

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_getMessageLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all messages in the specified language
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all message languages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessageLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessageLanguage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~',fiLanguage,fiMessage,dtText) ORDER BY fiLanguage,fiMessage SEPARATOR '$$')
    FROM tblMessageLanguage
    INTO out_result;

  END //

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_getMessageLimit
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns the X Last messages created with the message type language and the user who created it.
|
| Parameters :
| ------------
|  INT : in_limit        : Limit of last created messages
|
|  OUT :  out_result     : Outputs all message languages in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessageLimit;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessageLimit(
  IN  in_limit   INT,
  OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
SET GROUP_CONCAT_MAX_LEN = 10000;
    SELECT SUBSTRING_INDEX(GROUP_CONCAT(CONCAT_WS('~', dtText, tblLanguage.dtName, tblMessage.fiType,tblMessageLanguage.dtCreateDate)ORDER BY tblMessageLanguage.dtCreateDate DESC SEPARATOR '$$'),'$$',in_limit)
    FROM tblMessage, tblMessageLanguage, tblLanguage
    WHERE tblMessage.idMessage = tblMessageLanguage.fiMessage
          AND tblLanguage.idLanguage = tblMessageLanguage.fiLanguage
    INTO out_result;
  END //

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_getMessageOutput
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with the message attached with a current TimeStamp
|
| Parameters :
| ------------
|  IN :         in_languageID    : The language ID
|               in_messageID     : The Message ID
|
|  OUT :        out_result     : Outputs a message in csv format with a timestamp and messagetype
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getMessageOutput;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getMessageOutput(
  IN  in_languageID  CHAR(3),
  IN  in_messageID INT,
  OUT out_result   TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~', CURRENT_TIMESTAMP(), tblTypeLanguage.dtText, tblMessageLanguage.dtText)
                        SEPARATOR '$$')
    FROM tblMessageLanguage, tblTypeLanguage, tblMessage
    WHERE tblMessage.fiType = fiType
          AND tblMessageLanguage.fiLanguage = in_languageID
          AND tblTypeLanguage.fiLanguage = in_languageID
          AND tblMessageLanguage.fiMessage = in_messageID
          AND tblMessageLanguage.fiMessage = tblMessage.idMessage
    INTO out_result;
  END //

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_getType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all message types
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all message type
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_getType;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getType(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~', idType) SEPARATOR '$$')
    FROM tblType
    INTO out_result;

  END //

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_getMessageType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Returns a String with all message types in the specified language
|
| Parameters :
| ------------
|  OUT :  out_result     : Outputs all message types in csv format
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/

DELIMITER //
DROP PROCEDURE IF EXISTS sp_getTypeLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_getTypeLanguage(OUT out_result TEXT)
  SQL SECURITY DEFINER
  BEGIN
    SELECT GROUP_CONCAT(CONCAT_WS('~',fiLanguage,fiType,dtText) ORDER BY fiLanguage,fiType SEPARATOR '$$')
    FROM tblTypeLanguage
    INTO out_result;

  END //

DELIMITER ;
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
/*----------------------------------------------------------------------------
| Routine : sp_createType
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Add a new Message Type
|
| Parameters :
| ------------
|  IN  :  in_type           : The MessageType ID
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

DROP PROCEDURE IF EXISTS sp_createType;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_createType(
  IN  in_type          CHAR(4),
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
      -- Creation of Type
      INSERT INTO tblType
      SET idType = in_type;
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
/*----------------------------------------------------------------------------
| Routine : sp_updateLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Updates a language to the table tblLanguage
|
| Parameters :
| ------------
|  IN  :  in_languageID     : The abbreviation(ID) for the new language
|         in_language       : The name of the new language
|
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_updateLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_updateLanguage(
  IN  in_languageID    CHAR(2),
  IN  in_language      VARCHAR(50)
)
  SQL SECURITY DEFINER
  BEGIN
    -- Update of Language
    UPDATE tblLanguage
    SET idLanguage = in_abbreviation,
      dtName       = in_language
    WHERE idLanguage = in_languageID;

  END//

DELIMITER ;
/*----------------------------------------------------------------------------
| Routine : sp_updateMessage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Updates a message to the table tblMessage
|
| Parameters :
| ------------
|  IN  :  in_messageID      : The Message ID
|         in_type           : The MessageType Foreign Key
|         in_description    : The Message Description
|         in_user           : The User who created that message
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_updateMessage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_updateMessage(
  IN in_messageID   INT,
  IN in_description VARCHAR(200),
  IN in_type        CHAR(4),
  IN in_user        INT
)
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblMessage
    SET dtDescription = in_description,
      fiType          = in_type,
      fiUser          = in_user
    WHERE idMessage = in_messageID;

  END//
/*----------------------------------------------------------------------------
| Routine : sp_updateMessageLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-05-2016
|
| Description : Updates a Message in the selected language to the table tblMessageLanguage
|
| Parameters :
| ------------
|  IN  :  in_message        : The Message ID
|         in_language       : The Language ID
|         in_text           : The Text for the Message in the selected language
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_updateMessageLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_updateMessageLanguage(
  IN in_message  INT,
  IN in_language CHAR(2),
  IN in_text     VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblMessageLanguage
    SET fiMessage = in_message,
      fiLanguage  = in_language,
      dtText      = in_text;
  END//
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
/*----------------------------------------------------------------------------
| Routine : sp_updateTypeLanguage
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 04-05-2016
|
| Description : Update a Type with the chosen language
|
| Parameters :
| ------------
|  IN  :  in_type           : The MessageType
|         in_language       : The MessageType Language
|         in_text           : The MessageTypeText for the selected Language
|---------------------------------------------------------------------------*/
DELIMITER //

DROP PROCEDURE IF EXISTS sp_updateTypeLanguage;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_updateTypeLanguage(
  IN  in_type          CHAR(4),
  IN  in_language      CHAR(2),
  IN  in_text          VARCHAR(255)
)
  SQL SECURITY DEFINER
  BEGIN
    UPDATE tblTypeLanguage
    SET fiType = in_type,
      fiLanguage = in_language,
      dtText = in_text;
  END//
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
/*----------------------------------------------------------------------------
| Routine : sp_msg
| Author(s)  : (c) BTSi Yvan Martins Lourenço
| CreateDate : 11-01-2017
|
| Description : Returns a String with the message selected
|
| Parameters :
| ------------
|  IN :         in_languageID    : The language ID
|               in_messageID     : The Message ID
|               in_timeStamp     : Select if you want to display a timestamp or not
|
|  OUT :        out_result     : Outputs a string
|
| stdReturnValues :
| -----------------
|   stdReturnParameter   : out_result
|---------------------------------------------------------------------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS sp_msg;

CREATE DEFINER = CURRENT_USER
PROCEDURE sp_msg(
  IN  in_languageID  CHAR(3),
  IN  in_messageID 	 INT,
  IN  in_timeStamp   BOOLEAN,
  OUT out_result     TEXT)
  SQL SECURITY DEFINER
  BEGIN
    IF in_timeStamp = '1' THEN
      SELECT CONCAT("[",CURRENT_TIMESTAMP(),"] ", tblTypeLanguage.dtText ,": ", tblMessageLanguage.dtText)
      FROM tblMessageLanguage, tblTypeLanguage, tblMessage
      WHERE tblTypeLanguage.fiType = tblMessage.fiType
            AND tblMessageLanguage.fiLanguage = in_languageID
            AND tblTypeLanguage.fiLanguage = in_languageID
            AND tblMessageLanguage.fiMessage = in_messageID
            AND tblMessageLanguage.fiMessage = tblMessage.idMessage
      INTO out_result;
    ELSE
      SELECT CONCAT(tblTypeLanguage.dtText,": ", tblMessageLanguage.dtText)
      FROM tblMessageLanguage, tblTypeLanguage, tblMessage
      WHERE tblTypeLanguage.fiType = tblMessage.fiType
            AND tblMessageLanguage.fiLanguage = in_languageID
            AND tblTypeLanguage.fiLanguage = in_languageID
            AND tblMessageLanguage.fiMessage = in_messageID
            AND tblMessageLanguage.fiMessage = tblMessage.idMessage
      INTO out_result;
    END IF;
  END //

DELIMITER ;
DELIMITER //
DROP TRIGGER IF EXISTS tr_tblLanguage_au;
CREATE TRIGGER tr_tblLanguage_au
AFTER UPDATE ON tblLanguage
FOR EACH ROW
  BEGIN
    IF NEW.idLanguage <> OLD.idLanguage
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblLanguage", "idLanguage", OLD.idLanguage, NEW.idLanguage);
    END IF;
    IF NEW.dtName <> OLD.dtName
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblLanguage", "dtName", OLD.dtName, NEW.dtName);
    END IF;
    IF NEW.dtCreateDate <> OLD.dtCreateDate
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblLanguage", "dtCreateDate", OLD.dtCreateDate, NEW.dtCreateDate);
    END IF;
  END //

DROP TRIGGER IF EXISTS tr_tblMessage_au;
CREATE TRIGGER tr_tblMessage_au
AFTER UPDATE ON tblMessage
FOR EACH ROW
  BEGIN
    IF NEW.idMessage <> OLD.idMessage
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessage", "idMessage", OLD.idMessage, NEW.idMessage);
    END IF;
    IF NEW.dtDescription <> OLD.dtDescription
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessage", "dtDescription", OLD.dtDescription, NEW.dtDescription);
    END IF;
    IF NEW.fiType <> OLD.fiType
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessage", "fiType", OLD.fiType, NEW.fiType);
    END IF;

    IF NEW.dtCreateDate <> OLD.dtCreateDate
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessage", "dtCreateDate", OLD.dtCreateDate, NEW.dtCreateDate);
    END IF;
  END //

DROP TRIGGER IF EXISTS tr_tblMessageLanguage_au;
CREATE TRIGGER tr_tblMessageLanguage_au
AFTER UPDATE ON tblMessageLanguage
FOR EACH ROW
  BEGIN
    IF NEW.fiMessage <> OLD.fiMessage
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessageLanguage", "fiMessage", OLD.fiMessage, NEW.fiMessage);
    END IF;
    IF NEW.fiLanguage <> OLD.fiLanguage
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessageLanguage", "fiLanguage", OLD.fiLanguage, NEW.fiLanguage);
    END IF;
    IF NEW.dtText <> OLD.dtText
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessageLanguage", "dtText", OLD.dtText, NEW.dtText);
    END IF;
    IF NEW.dtCreateDate <> OLD.dtCreateDate
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblMessageLanguage", "dtCreateDate", OLD.dtCreateDate, NEW.dtCreateDate);
    END IF;
  END //

DROP TRIGGER IF EXISTS tr_tblType_au;
CREATE TRIGGER tr_tblType_au
AFTER UPDATE ON tblType
FOR EACH ROW
  BEGIN
    IF NEW.idType <> OLD.idType
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblType", "idType", OLD.idType, NEW.idType);
    END IF;
    IF NEW.dtCreateDate <> OLD.dtCreateDate
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblType", "dtCreateDate", OLD.dtCreateDate, NEW.dtCreateDate);
    END IF;
  END //

DROP TRIGGER IF EXISTS tr_tblTypeLanguage_au;
CREATE TRIGGER tr_tblTypeLanguage_au
AFTER UPDATE ON tblTypeLanguage
FOR EACH ROW
  BEGIN
    IF NEW.fiType <> OLD.fiType
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblTypeLanguage", "fiType", OLD.fiType, NEW.fiType);
    END IF;
    IF NEW.fiLanguage <> OLD.fiLanguage
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblTypeLanguage", "fiLanguage", OLD.fiLanguage, NEW.fiLanguage);
    END IF;
    IF NEW.dtText <> OLD.dtText
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblTypeLanguage", "dtText", OLD.dtText, NEW.dtText);
    END IF;
    IF NEW.dtCreateDate <> OLD.dtCreateDate
    THEN
      INSERT INTO tblChanges (dtUser, dtTable, dtColumn, dtOld, dtNew) VALUES
        (USER(), "tblTypeLanguage", "dtCreateDate", OLD.dtCreateDate, NEW.dtCreateDate);
    END IF;
  END //

DROP TRIGGER IF EXISTS tr_tblLanguage_ad;
CREATE TRIGGER tr_tblLanguage_ad
AFTER DELETE ON tblLanguage
FOR EACH ROW
  BEGIN
    INSERT INTO tblRemovals (dtUser, dtTable, dtRow) VALUES
      (USER(), "tblLanguage", CONCAT(OLD.idLanguage, " | ", OLD.dtName, " | ", OLD.dtCreateDate));
  END //

DROP TRIGGER IF EXISTS tr_tblMessage_ad;
CREATE TRIGGER tr_tblMessage_ad
AFTER DELETE ON tblMessage
FOR EACH ROW
  BEGIN
    INSERT INTO tblRemovals (dtUser, dtTable, dtRow) VALUES
      (USER(), "tblMessage",
       CONCAT(OLD.idMessage, " | ", OLD.dtDescription, " | ", OLD.dtCreateDate, " | ", OLD.fiType));
  END //

DROP TRIGGER IF EXISTS tr_tblMessageLanguage_ad;
CREATE TRIGGER tr_tblMessageLanguage_ad
AFTER DELETE ON tblMessageLanguage
FOR EACH ROW
  BEGIN
    INSERT INTO tblRemovals (dtUser, dtTable, dtRow) VALUES
      (USER(), "tblMessageLanguage",
       CONCAT(OLD.fiLanguage, " | ", OLD.fiMessage, " | ", OLD.dtText, " | ", OLD.dtCreateDate));
  END //

DROP TRIGGER IF EXISTS tr_tblType_ad;
CREATE TRIGGER tr_tblType_ad
AFTER DELETE ON tblType
FOR EACH ROW
  BEGIN
    INSERT INTO tblRemovals (dtUser, dtTable, dtRow) VALUES
      (USER(), "tblType", CONCAT(OLD.idType, " | ", OLD.dtCreateDate));
  END //

DROP TRIGGER IF EXISTS tr_tblTypeLanguage_ad;
CREATE TRIGGER tr_tblTypeLanguage_ad
AFTER DELETE ON tblTypeLanguage
FOR EACH ROW
  BEGIN
    INSERT INTO tblRemovals (dtUser, dtTable, dtRow) VALUES
      (USER(), "tblTypeLanguage",
       CONCAT(OLD.fiType, " | ", OLD.fiLanguage, " | ", OLD.dtText, " | ", OLD.dtCreateDate));
  END //
DELIMITER ;
INSERT INTO tblType (idType) VALUES
  ('ERRO'),
  ('WARN'),
  ('INFO'),
  ('SUCC');

INSERT INTO tblMessage (dtDescription, fiType) VALUES
  ('User entered wrong Username or Password', 'ERRO'),
  ('If the file is not found', 'ERRO'),
  ('Weak password', 'WARN'),
  ('Informs the user what pizza day it is.', 'INFO'),
  ('Announces a success upload.', 'SUCC');

INSERT INTO tblLanguage (idLanguage, dtName) VALUES
  ('lb', 'Luxembourgish'),
  ('pt', 'Portuguese'),
  ('de', 'German'),
  ('fr', 'French'),
  ('en', 'English');

INSERT INTO tblMessageLanguage (fiMessage, fiLanguage, dtText) VALUES
  (1, 'en', 'The email and password you entered do not match.'),
  (1, 'fr', 'Votre Email ou mot de passe ne corresponde pas.'),
	(1, 'pt', 'O nome de utilizador e a palavra-passe não coincidem.'),
  (2, 'en', 'File not found.'),
  (2, 'fr', 'Fichier introuvable.'),
  (2, 'pt', 'Aarquivo não encontrado.'),
	(3, 'en', 'This password is too weak.'),
	(3, 'fr', 'Mots de passe trop faible.'),
	(3, 'pt', 'A senha é demasiada fraca.');

INSERT INTO tblTypeLanguage (fiType, fiLanguage, dtText) VALUES
  ('ERRO', 'en', 'Error'),
  ('ERRO', 'fr', 'Erreur'),
  ('ERRO', 'de', 'Fehler'),
  ('ERRO', 'lb', 'Fehler'),
  ('ERRO', 'pt', 'Erro'),
  ('WARN', 'en', 'Warning'),
  ('WARN', 'fr', 'Avertissement'),
  ('WARN', 'de', 'Achtung'),
  ('WARN', 'lb', 'Opgepasst'),
  ('WARN', 'pt', 'Atenção'),
  ('INFO', 'en', 'Information'),
  ('INFO', 'fr', 'Information'),
  ('INFO', 'de', 'Information'),
  ('INFO', 'lb', 'Informatioun'),
  ('INFO', 'pt', 'Informação'),
  ('SUCC', 'en', 'Success'),
  ('SUCC', 'fr', 'Succès'),
  ('SUCC', 'de', 'Erfolg'),
  ('SUCC', 'lb', 'Succès'),
  ('SUCC', 'pt', 'Sucesso');
