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
