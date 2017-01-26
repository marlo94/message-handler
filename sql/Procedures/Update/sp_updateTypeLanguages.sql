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
