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
