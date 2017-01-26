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
