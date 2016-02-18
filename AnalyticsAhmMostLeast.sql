REM
REM ANALYTICS_AHM_MOST_LEAST.SQL
REM

REM
REM For population projections
REM Asian Hispanic Males
REM For each year of projected population
REM Show the projected highest populated
REM    - age
REM    - population
REM Also the project lowest populated
REM    - age
REM    - population
REM

TTITLE LEFT   "In Work" RIGHT "Page " SQL.PNO SKIP 1 -
       CENTER "Projected Population, 2021-2025, Florida" SKIP 1 -
       CENTER "Source Data: CENSUS.GOV file FL2125.DAT," SKIP 2 -
       CENTER "Asian Hispanic Males" SKIP 1 -
       CENTER "For each year and age, display" SKIP 1 -
       CENTER "projected population, " SKIP 1 -
       CENTER "that year's highest populated age and population," SKIP 1 -
       CENTER "and that year's lowest populated age and population"
COLUMN ST            HEADING 'STATE|USPS|ABBR'      FORMAT A4
COLUMN CD            HEADING 'CODE'                 FORMAT A4
COLUMN C_YEAR        HEADING 'YEAR'                 FORMAT 9999
COLUMN C_AGE         HEADING 'AGE'                  FORMAT 999
COLUMN AHM           HEADING 'PROJ|ASIAN|HISP|MALE' FORMAT 999999999
COLUMN MOST_POP_AGE  HEADING "MOST|POP|AGE"         FORMAT 999
COLUMN MOST_POP      HEADING 'MOST|POP'             FORMAT 999999999
COLUMN LEAST_POP_AGE HEADING 'LEAST|POP|AGE'        FORMAT 999
COLUMN LEAST_POP     HEADING 'LEAST|POP'            FORMAT 999999999

SELECT C_STATE_USPS_ABBREVIATION  ST
     , C_PROJECTION_SERIES_CODE   CD
     , C_YEAR
     , C_AGE
     , C_PROJ_ASIAN_HISP_MALE     AHM
     , MAX(C_AGE) KEEP (DENSE_RANK LAST ORDER BY C_PROJ_ASIAN_HISP_MALE) OVER () MOST_POP_AGE
     , MAX(C_PROJ_ASIAN_HISP_MALE) OVER (PARTITION BY C_YEAR) MOST_POP
     , MIN(C_AGE) KEEP (DENSE_RANK FIRST ORDER BY C_PROJ_ASIAN_HISP_MALE) OVER () LEAST_POP_AGE
     , MIN(C_PROJ_ASIAN_HISP_MALE) OVER (PARTITION BY C_YEAR) LEAST_POP
FROM   CENSUS_EXT_FL2125
WHERE  C_PROJECTION_SERIES_CODE = 'A'
ORDER BY C_YEAR, C_AGE;

TTITLE OFF
CLEAR COLUMNS
