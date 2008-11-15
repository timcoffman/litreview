USE litreview_dev ;

SET @now = NOW() ;

DROP TABLE IF EXISTS import ;
CREATE TABLE import ( 
	PubId VARCHAR(64) not null primary key, 
	DuplicateOf VARCHAR(64) null, 
	Source VARCHAR(16) not null, 
	Author VARCHAR(512) not null, 
	Date VARCHAR(16) not null, 
	Title VARCHAR(512) not null, 
	Journal VARCHAR(512) not null, 
	Keyword TEXT null, 
	Abstract TEXT not null, 
	OfInterest_U1 VARCHAR(32) null, 
	OfInterest_U2 VARCHAR(32) null, 
	Tags_U1_R1 VARCHAR(32) null, Reason_U1_R1 VARCHAR(64) null, ReasonOther_U1_R1 VARCHAR(256) null, 
	Tags_U2_R1 VARCHAR(32) null, Reason_U2_R1 VARCHAR(64) null, ReasonOther_U2_R1 VARCHAR(256) null, 
	Tags_U1_R2 VARCHAR(32) null, Reason_U1_R2 VARCHAR(64) null, ReasonOther_U1_R2 VARCHAR(256) null, 
	Tags_U2_R2 VARCHAR(32) null, Reason_U2_R2 VARCHAR(64) null, ReasonOther_U2_R2 VARCHAR(256) null
	) CHARACTER SET 'utf8' ;

LOAD DATA LOCAL INFILE 'literature_review_export_mysql.csv' 
	INTO TABLE import 
	CHARACTER SET 'utf8' 
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r' 
	( 
		PubId, DuplicateOf, Source, Author, Date, Title, Journal, Keyword, Abstract, 
		OfInterest_U1, OfInterest_U2, 
		Tags_U1_R1, Reason_U1_R1, ReasonOther_U1_R1, 
		Tags_U2_R1, Reason_U2_R1, ReasonOther_U2_R1, 
		Tags_U1_R2, Reason_U1_R2, ReasonOther_U1_R2, 
		Tags_U2_R2, Reason_U2_R2, ReasonOther_U2_R2 
	) ;
SHOW WARNINGS ;

SET @pid = (SELECT p.id FROM projects p WHERE title = 'Workflow' ) ;

DELETE drr FROM document_review_reasons drr
	LEFT JOIN document_reviews dr ON drr.document_review_id = dr.id
	LEFT JOIN documents d ON dr.document_id = d.id
	LEFT JOIN document_sources ds ON d.document_source_id = ds.id
        WHERE ds.project_id = @pid
	;

DELETE dr FROM document_reviews dr 
	LEFT JOIN documents d ON dr.document_id = d.id 
	LEFT JOIN document_sources ds ON d.document_source_id = ds.id 
	WHERE ds.project_id = @pid 
	;

DELETE d FROM documents d 
	LEFT JOIN document_sources ds ON d.document_source_id = ds.id 
	WHERE ds.project_id = @pid 
	;
DELETE ds FROM document_sources ds WHERE ds.project_id = @pid ;

DELETE r FROM reasons r 
	LEFT JOIN review_stages rs ON r.review_stage_id = rs.id 
	LEFT JOIN projects p on rs.project_id = @pid 
	;

DELETE sr FROM stage_reviewers sr 
	LEFT JOIN review_stages rs ON sr.review_stage_id = rs.id 
	LEFT JOIN projects p on rs.project_id = @pid 
	;

DELETE rs FROM review_stages rs WHERE rs.project_id = @pid ;

DELETE m FROM managers m WHERE m.project_id = @pid ;

DELETE p FROM projects p WHERE p.id = @pid ;



INSERT INTO projects (title, description, created_at) VALUES ('Workflow','Workflow',@now) ;
SET @pid = (SELECT p.id FROM projects p WHERE title = 'Workflow' ) ;

SET @uid1 = (SELECT u.id FROM users u WHERE nickname = 'Kim' ) ;
SET @uid2 = (SELECT u.id FROM users u WHERE nickname = 'Lori' ) ;

INSERT INTO managers (project_id,user_id,created_at) VALUES (@pid, @uid1, @now) ;

INSERT INTO review_stages (project_id,sequence,name,description,gate_function, created_at) VALUES ( @pid, 1, 'Round 1', 'Round 1', 'ANY', @now ) ;
INSERT INTO review_stages (project_id,sequence,name,description,gate_function, created_at) VALUES ( @pid, 2, 'Round 2', 'Round 2', 'ANY', @now ) ;

SET @rsid1 = (SELECT rs.id FROM review_stages rs WHERE sequence = 1 AND project_id = @pid ) ;
SET @rsid2 = (SELECT rs.id FROM review_stages rs WHERE sequence = 2 AND project_id = @pid ) ;

INSERT INTO document_sources (project_id,name, created_at) 
	SELECT DISTINCT @pid, i.Source, @now 
	FROM import i
	;
INSERT INTO documents (document_source_id,pub_ident,title,authors,journal,when_published,abstract, created_at) 
	SELECT ds.id, i.PubId, i.Title, i.Author, i.Journal, i.Date, i.Abstract, @now 
	FROM import i, document_sources ds 
	WHERE ds.name = i.Source
	AND ds.project_id = @pid 
	;
UPDATE documents d
	LEFT JOIN import i ON d.pub_ident = i.PubId
	LEFT JOIN documents dd ON i.DuplicateOf = dd.pub_ident
	SET d.duplicate_of_document_id = dd.id
	;

INSERT INTO stage_reviewers (review_stage_id,user_id, created_at) VALUES( @rsid1, @uid1, @now ) ;
INSERT INTO stage_reviewers (review_stage_id,user_id, created_at) VALUES( @rsid2, @uid1, @now ) ;
INSERT INTO stage_reviewers (review_stage_id,user_id, created_at) VALUES( @rsid1, @uid2, @now ) ;
INSERT INTO stage_reviewers (review_stage_id,user_id, created_at) VALUES( @rsid2, @uid2, @now ) ;

SET @srid11 = (SELECT sr.id FROM stage_reviewers sr WHERE sr.review_stage_id = @rsid1 AND user_id = @uid1 ) ;
SET @srid12 = (SELECT sr.id FROM stage_reviewers sr WHERE sr.review_stage_id = @rsid2 AND user_id = @uid1 ) ;
SET @srid21 = (SELECT sr.id FROM stage_reviewers sr WHERE sr.review_stage_id = @rsid1 AND user_id = @uid2 ) ;
SET @srid22 = (SELECT sr.id FROM stage_reviewers sr WHERE sr.review_stage_id = @rsid2 AND user_id = @uid2 ) ;

DROP TABLE IF EXISTS import_reviews ;
CREATE TABLE import_reviews (
	review_stage_id INT NOT NULL,
	stage_reviewer_id INT NOT NULL,
	document_id INT NOT NULL,
	Tags VARCHAR(32) null,
	Reason VARCHAR(64) null,
	ReasonOther VARCHAR(256) null,
	PRIMARY KEY ( stage_reviewer_id, document_id )
	) CHARACTER SET 'utf8' ;

INSERT INTO import_reviews (review_stage_id,stage_reviewer_id,document_id,Tags,Reason,ReasonOther) SELECT DISTINCT @rsid1, @srid11, d.id, i.Tags_U1_R1, i.Reason_U1_R1, i.ReasonOther_U1_R1 FROM import i JOIN documents d ON i.PubId = d.pub_ident ;
INSERT INTO import_reviews (review_stage_id,stage_reviewer_id,document_id,Tags,Reason,ReasonOther) SELECT DISTINCT @rsid2, @srid12, d.id, i.Tags_U1_R2, i.Reason_U1_R2, i.ReasonOther_U1_R2 FROM import i JOIN documents d ON i.PubId = d.pub_ident ;
INSERT INTO import_reviews (review_stage_id,stage_reviewer_id,document_id,Tags,Reason,ReasonOther) SELECT DISTINCT @rsid1, @srid21, d.id, i.Tags_U2_R1, i.Reason_U2_R1, i.ReasonOther_U2_R1 FROM import i JOIN documents d ON i.PubId = d.pub_ident ;
INSERT INTO import_reviews (review_stage_id,stage_reviewer_id,document_id,Tags,Reason,ReasonOther) SELECT DISTINCT @rsid2, @srid22, d.id, i.Tags_U2_R2, i.Reason_U2_R2, i.ReasonOther_U2_R2 FROM import i JOIN documents d ON i.PubId = d.pub_ident ;

INSERT INTO document_reviews (document_id, stage_reviewer_id, disposition, when_assigned, when_reviewed, created_at)
	SELECT ir.document_id, ir.stage_reviewer_id, LEFT(ir.Tags,1), @now, @now, @now
	FROM import_reviews ir
	WHERE ir.Tags IS NOT NULL AND CHAR_LENGTH(REPLACE(ir.Tags,CHAR(11),'')) != 0
	;

DROP TABLE IF EXISTS import_reasons ;
CREATE TABLE import_reasons (
	review_stage_id INT NOT NULL,
	stage_reviewer_id INT NOT NULL,
	created_by_stage_reviewer_id INT NULL, 
	document_id INT NOT NULL,
	Reason VARCHAR(256) NOT NULL,
	UNIQUE KEY ( stage_reviewer_id, document_id, created_by_stage_reviewer_id, Reason )
	) CHARACTER SET 'utf8' ;

DROP PROCEDURE IF EXISTS split_document_reviews ;
DELIMITER $$
CREATE PROCEDURE split_document_reviews() 
BEGIN 
	DECLARE done INT DEFAULT 0 ; 
	DECLARE pos INT ;
	DECLARE rsid, srid, did INT ; 
	DECLARE s VARCHAR(256) ; 
	DECLARE rn VARCHAR(64) ; 
	DECLARE rno VARCHAR(256) ; 
	DECLARE c CURSOR FOR SELECT ir.review_stage_id, ir.stage_reviewer_id, ir.document_id, ir.Reason, ir.ReasonOther FROM import_reviews ir ; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1 ; 
	OPEN c ; 
	REPEAT FETCH c INTO rsid, srid, did, rn, rno ; 
		REPEAT 
			SET s = SUBSTRING_INDEX(rn,CHAR(11),1) ; 
			IF NOT(s IS NULL OR CHAR_LENGTH(s) = 0) THEN 
				INSERT INTO import_reasons (review_stage_id,stage_reviewer_id, created_by_stage_reviewer_id, document_id, Reason) VALUES (rsid,srid,NULL,did,s) ; 
			END IF ; 
			SET rn = SUBSTRING(rn,CHAR_LENGTH(s)+2) ; 
		UNTIL CHAR_LENGTH(rn) = 0 END REPEAT ; 
		REPEAT 
			SET s = SUBSTRING_INDEX(rno,CHAR(11),1) ; 
			IF NOT(s IS NULL OR CHAR_LENGTH(s) = 0) THEN 
				INSERT INTO import_reasons (review_stage_id,stage_reviewer_id, created_by_stage_reviewer_id, document_id, Reason) VALUES (rsid,srid,srid,did,s) ; 
			END IF ; 
			SET rno = SUBSTRING(rno,CHAR_LENGTH(s)+2) ; 
		UNTIL CHAR_LENGTH(rn) = 0 END REPEAT ; 
	UNTIL done END REPEAT ; 
	CLOSE c ; 
END $$
DELIMITER ;

CALL split_document_reviews() ;

INSERT INTO reasons (review_stage_id,created_by_stage_reviewer_id,title, description,created_at)
	SELECT DISTINCT ir.review_stage_id, ir.created_by_stage_reviewer_id, ir.Reason, ir.Reason, @now
	FROM import_reasons ir
	;


INSERT INTO document_review_reasons (document_review_id, reason_id, created_at)
	SELECT dr.id, r.id, @now
	FROM import_reasons ir
	JOIN document_reviews dr ON ir.document_id = dr.document_id AND ir.stage_reviewer_id = dr.stage_reviewer_id
	JOIN reasons r ON ir.Reason = r.title AND ir.review_stage_id = r.review_stage_id AND r.created_by_stage_reviewer_id IS NULL
	WHERE ir.created_by_stage_reviewer_id IS NULL
	;

INSERT INTO document_review_reasons (document_review_id, reason_id, created_at)
	SELECT dr.id, r.id, @now
	FROM import_reasons ir
	JOIN document_reviews dr ON ir.document_id = dr.document_id AND ir.stage_reviewer_id = dr.stage_reviewer_id
	JOIN reasons r ON ir.Reason = r.title AND ir.review_stage_id = r.review_stage_id AND ir.created_by_stage_reviewer_id = r.created_by_stage_reviewer_id
	WHERE ir.created_by_stage_reviewer_id IS NOT NULL
	;

