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
