SELECT
	dr11.disposition u1r1,
	dr12.disposition u1r2,
	dr21.disposition u2r1,
	dr22.disposition u2r2,
	COUNT(d.id)
	FROM document_tags dt
	LEFT JOIN tags t ON dt.tag_id = t.id
	LEFT JOIN projects p ON t.created_for_project_id = p.id
	LEFT JOIN documents d ON dt.document_id = d.id
	LEFT JOIN document_reviews dr11 ON dr11.document_id = d.id AND dr11.stage_reviewer_id = 399
	LEFT JOIN document_reviews dr12 ON dr12.document_id = d.id AND dr12.stage_reviewer_id = 400
	LEFT JOIN document_reviews dr21 ON dr21.document_id = d.id AND dr21.stage_reviewer_id = 401
	LEFT JOIN document_reviews dr22 ON dr22.document_id = d.id AND dr22.stage_reviewer_id = 402
	WHERE t.words = 'dc-set' AND p.title = 'Workflow'
	GROUP BY
		dr11.disposition,
		dr12.disposition,
		dr21.disposition,
		dr22.disposition
	;
