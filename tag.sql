USE litreview_dev ;

SET @now = NOW() ;

DROP TABLE IF EXISTS import_tags ;
CREATE TABLE import_tags ( 
	PubId VARCHAR(64) not null primary key
	) CHARACTER SET 'utf8' ;

LOAD DATA LOCAL INFILE 'data_collection_identifiers.csv' 
	INTO TABLE import_tags 
	CHARACTER SET 'utf8' 
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r' 
	( 
		PubId
	) ;
SHOW WARNINGS ;

SET @pid = (SELECT p.id FROM projects p WHERE title = 'Workflow' ) ;

DELETE dt from document_tags dt
	LEFT JOIN tags t ON dt.tag_id = t.id
	WHERE t.created_for_project_id = @pid ;

DELETE t from tags t
	WHERE t.created_for_project_id = @pid ;


SET @uid1 = (SELECT u.id FROM users u WHERE nickname = 'Kim' ) ;

INSERT INTO tags (words, created_by_user_id, created_for_project_id, created_at)
	VALUES( 'dc-set', @uid1, @pid, @now ) ;

SET @tid = (SELECT t.id FROM tags t WHERE t.words = 'dc-set' AND t.created_by_user_id = @uid1 AND t.created_for_project_id = @pid ) ;

INSERT INTO document_tags (tag_id, document_id, created_at, applied_by_user_id)
	SELECT @tid, d.id, @now, @uid1
	FROM import_tags it
	LEFT JOIN documents d ON it.PubId = d.pub_ident ;
