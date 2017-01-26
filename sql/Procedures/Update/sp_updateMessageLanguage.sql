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
