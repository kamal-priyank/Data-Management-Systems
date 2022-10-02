--- DMM695 Data Management System Group 13 --

--- Task 1: Clean, Manipulate, and Structure Database ---

--- Attemp 1:  "gitdata" and "gitissue" database: Failed

--- (Please do not run the following code of Attemp 1: this is just to view what we did.)

CREATE DATABASE "gitHubData"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;


CREATE TABLE IF NOT EXISTS public.gitissue(
    "id" smallint ,
	project_id int ,
    title text ,
    state_issue character varying(6) ,
    body text ,
    user_id character varying(100) ,
    repository text ,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    closed_at timestamp without time zone,
    assigned_users character varying(100) ,
    labels text ,
    reactions character varying(65000) ,
    n_comments smallint,
    closed_by character varying(100) ,
    comment_id integer,
    comment_created_at timestamp without time zone,
    commented_updated_at timestamp without time zone,
    comment_user_id character varying(100) ,
    comment_text text ,
	primary key("id",project_id),
	foreign key(user_id) References users(user_id),
	foreign key(project_id) References Projects(project_id)
);

COPY gitssues("id", title, state_issue, body, user_name, user_id, repository, created_at, 
updated_at,closed_at,assigned_users,labels,reactions,n_comments, closed_by,comment_id,comment_created_at,
commented_updated_at,comment_user_id, comment_user, comment_text,project_name)
FROM 'C:/Users/My-PC/Desktop/Data Management Systems (SMM695)/gitIssues.csv'
DELIMITER ',' CSV HEADER;

CREATE TABLE IF NOT EXISTS public.gitdata(
	"id" SMALLINT,
	hash VARCHAR(250),
	msg TEXT,
	author_name VARCHAR(100),
	committer_name VARCHAR(100),
	author_date TIMESTAMP WITHOUT TIME ZONE,
	author_timezone VARCHAR(15),
	committer_date TIMESTAMP WITHOUT TIME ZONE,
	committer_timezone VARCHAR(15),
	branches TEXT,
	in_main_branch VARCHAR(5),
	merge_comm VARCHAR(5),
	parents TEXT,
	project_name VARCHAR(100),
	deletion_comm_num INT,
	insertion_comm_num INT,
	lines_total INT,
	file_num SMALLINT,
	old_path TEXT,
	new_path TEXT,
	filename TEXT,
	change_type VARCHAR(8),
	diff TEXT,
	diff_parsed TEXT,
	deleted_lines INT,
	source_code TEXT,
	source_code_before TEXT,
	nloc FLOAT,
	complexity TEXT,
	token_count FLOAT
);

COPY "data"(
	"id", hash, msg, author_name, committer_name, 
	author_date, author_timezone, committer_date, committer_timezone, 
	branches, in_main_branch, merge_comm, parents, project_name, 
	deletion_comm_num, insertion_comm_num, lines_total, file_num, 
	old_path, new_path, filename, change_type, diff, diff_parsed, 
	deleted_lines, source_code, source_code_before, nloc, complexity, token_count)
FROM 'C:/Users/My-PC/Desktop/Data Management Systems (SMM695)/gitData.csv'
DELIMITER ',' CSV HEADER;


--- Attempt 2:  Upload database using Python: Success

---(Please check python notebook.)



--- Create "projects" table

CREATE TABLE IF NOT EXISTS public.projects (
	project_id int PRIMARY KEY,
	project_name varchar(250)
);
 
INSERT INTO Projects VALUES(1,'pytorch');
INSERT INTO Projects VALUES(2,'tensorflow');

--- Create "users" table

CREATE TABLE IF NOT EXISTS public.users(
	user_id varchar(100) PRIMARY KEY,
	user_name varchar(100) 
);

INSERT INTO Users SELECT DISTINCT comment_user_id, comment_user FROM public.gitissue;

INSERT INTO Users SELECT DISTINCT user_id,_user FROM public.gitissue 
WHERE user_id NOT IN (SELECT DISTINCT comment_user_id FROM public.gitissue);

--- Create "comments" table

CREATE TABLE IF NOT EXISTS public.comments(
    comment_id integer NOT NULL,
    comment_user_id text,
	comment_user text,
    comment_text text,
    comment_created_at timestamp without time zone,
    comment_updated_at timestamp without time zone,
    CONSTRAINT comment_pkey PRIMARY KEY (comment_id)
);

INSERT INTO comments SELECT DISTINCT comment_id,comment_user_id,comment_user,comment_text,comment_created_at,comment_updated_at FROM public.gitissue
INSERT INTO comments SELECT DISTINCT comment_id,comment_user_id, comment_user, comment_text, comment_created_at, comment_updated_at 
FROM public.gitissue WHERE comment_id NOT IN (SELECT DISTINCT comment_id FROM public.gitissue);

--- Create "issues" table

CREATE TABLE IF NOT EXISTS public.issues(
    "id" int,
	project_id int,
    title text,
    state character varying(6),
    body text ,
    user_id character varying(100),
    repository text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    closed_at timestamp without time zone,
    assignees character varying(100) ,
    labels text,
    reactions character varying(65000),
    n_comments smallint,
    closed_by character varying(100),
    comment_id integer,
	PRIMARY KEY("id", project_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (project_id) REFERENCES projects(project_id),
	FOREIGN KEY (comment_id)REFERENCES comments(comment_id)
);

INSERT INTO issues SELECT DISTINCT "id", (SELECT project_id FROM projects WHERE projects.project_name = public.gitissue.project), 
										 title, state, body, user_id, repository,
										 created_at, updated_at, closed_at, assignees, labels,
										 reactions, n_comments, closed_by, comment_id
										 FROM public.gitissue WHERE project IN (SELECT project_name FROM projects);

--- Create "commits" table

CREATE TABLE IF NOT EXISTS public.commits(
    "id" int,
	project_id int,
    hash character varying(250),
    msg text,
    author_name varchar(100),
	committer_name varchar(100),
    author_date timestamp without time zone,
    author_timezone character varying(15) ,
    committer_date timestamp without time zone,
    committer_timezone character varying(15) ,
    branches text ,
    in_main_branch character varying(5) ,
    merge character varying(5) ,
    parents text ,
    deletions integer,
    insertions integer,
    lines integer,
    files smallint,
    old_path text,
    new_path text,
    filename text,
    change_type varchar(100),
    diff text,
    diff_parsed text,
    deleted_lines integer,
    source_code text ,
    source_code_before text ,
    nloc double precision,
    complexity text,
    token_count double precision,
	PRIMARY KEY ("id", project_id),
	FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO public.commits SELECT DISTINCT "id", (SELECT project_id FROM projects WHERE projects.project_name = public.gitdata.project_name), 
hash, msg, author_name, committer_name, author_date, author_timezone, committer_date,
committer_timezone, branches, in_main_branch, merge, parents, deletions,insertions,lines,
files, old_path, new_path, filename, change_type, diff, diff_parsed, deleted_lines,
source_code,source_code_before,nloc,complexity,token_count
FROM public.gitdata WHERE project_name IN (SELECT project_name FROM projects);

DROP TABLE gitdata, gitissue;



--- Task 2: Extract valuable descriptive insights ---

-- Group by project issues in "pytorch" and "tensorflow" to compare their popularity

SELECT project_id, SUM(n_comments) FROM issues GROUP BY 1; -- "tensorflow": 337,836 and "pytorch": 37,306

-- Extract the yearly and monthly number of issues raised/registered by git users on against each project, and issue labels

SELECT P.project_name, I.labels,
       EXTRACT(MONTH FROM I.created_at) "month",
       EXTRACT(YEAR FROM I.created_at) "year",
	   COUNT(*) AS no_of_issues
FROM public.issues I
INNER JOIN public.projects P ON I.project_id = P.project_id 
GROUP BY 1,2,3,4
ORDER BY month, year DESC;


-- Extract (author_name, project) and sort by (number of commits)

SELECT P.project_name, C.author_name, 
       COUNT(*) AS no_of_commits
FROM public.commits C
INNER JOIN public.projects P ON C.project = P.project_id 
GROUP BY project_name, author_name
ORDER BY no_of_commits DESC;

-- Extract (project name, author name), count (number of commits), and sort by (month, year)

SELECT P.project_name, C.author_name, 
       EXTRACT(MONTH FROM C.committer_date) "month",
       EXTRACT(YEAR FROM C.committer_date) "year",
       COUNT(*) AS no_of_commits
FROM public.commits C
INNER JOIN projects P ON C.project = P.project_id 
GROUP BY 1,2,3,4
ORDER BY month, year DESC;

-- Extract file with the most complicated Lines of Code (LOC)

SELECT C.author_name, C.token_count, SUM(C.nloc) AS file_complexity 
FROM commits C
GROUP BY 1,2;
