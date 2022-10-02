## 1. Introduction

### 1.1. Dataset

The dataset contains information sourced from two different projects in open source software
development (OSS), PyTorch and TensorFlow. The data is derived from GitHub, a centralised
platform where users can contribute with the development of the two softwares/libraries, and
is divided as:

**- gitData:** Data on the repositories itself, containing fields such as messages, post dates,
    project name, types of changes and number of lines added or deleted.
**- gitIssues:** Contribution-related information about the issues flagged and handled in the
    two projects. Contains, for instance, fields such as body (writing description of the issue
    flagged), user name, comments, who handled the issue and who it is assigned to, as in OSS
    the teams who oversee such projects can have a number of different members.

### 1.2. Objectives

The goal of this project is to understand the relationship between fields in both datasets,
cleaning, structuring and processing the data in order to help us gain insight into the progression
of both projects, leveraging the extensive records of information in the repositories.
Furthermore, we can also better understand how different developers interact with each other,
collaborating in such projects and managing the contributions of different users. To aid in this
task, we utilise both Python and Database Management System concepts, through the use of
PostgreSQL and PGAdmin4. To interact with the databases in Python, we also utilised the
‘psycopg2’ and ‘PySpark’ libraries.


## 2. Data preprocessing

### 2.1. Import CSV Files in PostgreSQL

The datasets utilised for this project were both considerably large, amounting to over 8GB in
total. Hence, the process of loading the data into the created database had to be done
programmatically. We then attempted two different methods in order to load the data, seeking
to evaluate which one was the most efficient.

### 2.1.1 SQL Method

Firstly, the ‘gitHubData’ database was created:

```
Figure 1. Create database
```
Then, two tables, containing each one of the two CSV files of each dataset were created, using the
copy command to import the data. The datatypes of each column were selected based on prior
exploratory analysis conducted, allowing us to select the most appropriate, according to the
information contained. For instance, limiting the number of characters in user_names or
project_name to minimise the storage requirements in the database (A1).

Using this approach, we can leverage PGAdmin’s interface to more easily create the tables and
import the data. However, we found during our project that the process of importing a large file
such as gitData to be both time-consuming and computationally-intensive, requiring it to be
done in batches for example.

### 2.1.2 Python Method

To improve on the processing times compared to PGAdmin, we utilised the psycopg2 library in
python to import the data. Firstly, it is necessary to establish a connection with the localhost
database. Using Python and its libraries reduced the importing time of the file in a single batch
from hours to just under 5 minutes. Hence, in our final script, we have decided to solely utilise
python to interact with the database when importing the files. Appendix 2 contains parts of the
Python code described.


## 3. Data structuring

Succeeding the initial importing of data into the database, it is necessary to normalise it to
remove anomalies. This is done in order to transform the data into 3NF. Moreover, the data is
restructured aiming to remove duplication and eliminate potential anomalies like Delete, Update
and Insertion.
Further structuring is conducted by creating sub tables with specific information contained in
each of the two main ones, in order to provide more insights and allowing us to group
complementary data together. A3 illustrates the tables within the databases and its properties.

## 4. Descriptive Statistics

The different groupings and structuring of the dataset allows for the manipulation of data in
order to gain insights into OSS development and the progression of the two projects. Through
different queries, summarisations and metrics within the tables created, we sought to analyse
how users interact with the projects, the nature of their interactions and identify further trends
across time, based on the exchange between users.

### 4.1 Issues trend

By counting the number of issues raised for each project, we find that the “tensorflow” project
has gained more attention with 337,836 comments, while “pytorch” accounts for “37,306”.

```
Figure 2. Total number of comments for each project - “Tensorflow” and “PyTorch”
```
Extracting the yearly and monthly data, along with the number of issues raised/registered by git
users in the repositories of each project, we are able to understand how the development has
progressed. OSS development is highly reliant on the collaboration of users in order to achieve
continuous improvement and, as it grows in popularity or its use-cases become more
widespread, it is clear to see the that overtime there is an upward trend in the number of issues
raised, as the number of people interacting with the software engages exponentially. In the case


of PyTorch and TensorFlow, it can also indicate a relationship between the number of issues
with the more widespread use of machine-learning technologies and its different use cases.

```
Figure 3. Issues trend for each project by month and year
```
### 4.2 User engagement

By querying the created ‘Project’ and ‘Commits’ tables, joining the information contained in
them, it is possible to retrieve the number of commits, or code additions/editing done by
individual users, also according to the two different projects. By sorting the data into descending
order, we are able to see the top contributors to each of the projects, with the most prevalent
users amounting to over 1000 commits over the time-period. By conducting further external
research, meaning not only utilising the data contained in the dataset, we can also understand
for instance the professional profile of these contributors, with many being academic
researchers or senior engineers in major technology firms.

```
Figure 4. User engagement to GitHub
```
Again, depicting how users are key drivers not only in the development of these tools, but also
to the actual deployment of the technologies industry-wide. We can identify, for example, Apple
or Meta employees amongst the biggest contributors in the TensorFlow project — an initiative
that was idealised and first implemented by researchers at one of its biggest competitors, Google.


### 4.3 User engagement timeline

Elaborating on the impact of individual contributors in the projects, we sought to group data
once again by the number of commits from each user, while adding a temporal component to the
data. The goal is to understand how different users approach the task, responsibility or interest
of engaging with the projects.

```
Figure 5. User engagement timeline
```
## Figure 6. User engagement by file complexity


## 5. Insightful data analysis (using PySpark)

The jdbc driver was used to connect Pyspark to the local Postgre server in order to retrieve the
data that was formatted in sql using pgadmin, and the required ables were then imported as
dataframes and pre-processed to derive insightful information.

The data was cleaned to eliminate all null values, and only the columns necessary for analysis
were retained from the commit data. The stringindexer was used to index the project id and
change type columns in order to execute one hot coding on both of them, yielding our local
variables while treating all other features as explanatory variables.

The cleaned data frame is then divided into train and test sets in order to execute linear and
logistic regression independently, providing us with useful information such as accuracy and
RMSE values.

Using PySpark, the package provides easy interaction with data stored in PostgreSQL. The
following graphs are produced according to the descriptive statistics part.

```
Figure 7. PyTorch and Tensorflow issues by year
```

```
Figure 8. Commits of PyTorch and Tensorflow projects
```
```
Figure 9. Histograms of actions of commits
```
The above chart displays the histogram data of the numerical variable deletions, insertions, files,
lines, nloc, deleted lines from the sql data base's commit table.

Fitting the linear regression of commit on users’ actions, such as ‘deletions’, ‘insertion’, ‘lines’,
‘token_count’, ‘deleted_lines’, ‘nloc’, ‘files’, ‘project _id_idx’, ‘change_type_idx’. The model has high
accuracy, however, ROC only reaches 0.46.


## R-squared adj 0.

## Table 1. Linear Regression Results

- 1. Introduction
   - 1.1. Dataset
   - 1.2. Objectives
- 2. Data preprocessing
   - 2.1. Import CSV Files in PostgreSQL
   - 2.1.1 SQL Method
   - 2.1.2 Python Method
- 3. Data structuring
- 4. Descriptive Statistics
   - 4.1 Issues trend
   - 4.2 User engagement
   - 4.3 User engagement timeline
- 5. Insightful data analysis (using PySpark)
- Accuracy 0.
- Area Under ROC 0.
- False Positive Rate by Label 0.93, 0.
- Precision by Label 0.74, 0.
- Tot. Iteration
- R-squared adj 0.
- RMSE 0.
- Intercept 0.
- Coefficients - 3.9e-05, -5.6e-06, 2e-05, -0.0012, -0.
- p-value 0.0, 0.0, 0.0, 0.


## Appendix

## 1. Create table SQL code



## 2. Python process for importing data (psychopg2)

## More details provided in Python code notebook.


## 3. Database tables and properties

