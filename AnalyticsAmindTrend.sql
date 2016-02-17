REM
REM DEMO_SOH_ANALYTICS_AMIND_TREND.SQL
REM

REM
REM Using PARTITION BY and LAG to compare data across rows 
REM within PARTITION BY sets.
REM (LAG references data in a previous row).
REM Show projected population for American Indian Non Hispanic Males
REM and for each year, find the age at which the population will increase the most
REM from one age to another.  
REM So for example, if the population is steady from age 0 to 40 and then suddenly
REM doubles at age 41 and remains steady, then show the amount by which the
REM population will increase at age 41
REM
REM Note: throw out ages 0 and 85.  
REM   Age 0 isn't an increase, it is a start.
REM   Age 85 is really "85 and up" and should be omitted.
REM

TTITLE LEFT   "Demonstration" RIGHT "Page " SQL.PNO SKIP 1 -
       CENTER "Projected Population, 2021-2025, Florida" SKIP 1 -
       CENTER "Source Data: CENSUS.GOV file FL2125.DAT," SKIP 2 -
       CENTER "American Indian Non-Hispanic Males" SKIP 1 -
       CENTER "For each year and age, display population," SKIP 1 -
       CENTER "the decrease/increase (trend) from previous year population, " SKIP 1 -
       CENTER "that year's age projected to experience " SKIP 1 -
       CENTER "the sharpest increase in population, and" SKIP 1 -
       CENTER "and that age's projected population for the year"
COLUMN MRG_TARGET_ID  HEADING 'MRG|TARGET|ID'            FORMAT 9999
COLUMN YR             HEADING 'YEAR'                     FORMAT 9999
COLUMN AGE            HEADING 'AGE'                      FORMAT 999
COLUMN ANHM           HEADING 'PROJ|AMIND|NON HISP|MALE' FORMAT 999999999
COLUMN TREND          HEADING 'TREND'                    FORMAT 999999999
COLUMN BIGGEST_UP_AGE HEADING 'BIGGEST|UP AGE'           FORMAT 999999999
COLUMN BIGGEST_UP_AMT HEADING 'BIGGEST|UP AMT'           FORMAT 999999999

SELECT MRG_TARGET_ID
     , YR
     , AGE
     , AMIND_NON_HISP_MALE ANHM
     , TREND
     , MAX(AGE) KEEP (DENSE_RANK LAST ORDER BY TREND) OVER (PARTITION BY YR) BIGGEST_UP_AGE
     , MAX(TREND) OVER (PARTITION BY YR) BIGGEST_UP_AMT
FROM (SELECT MRG_TARGET_ID
           , YR
           , AGE
           , AMIND_NON_HISP_MALE
           , AMIND_NON_HISP_MALE - (LAG(AMIND_NON_HISP_MALE) OVER (ORDER BY YR, AGE)) TREND
           , LAG(AMIND_NON_HISP_MALE) OVER (ORDER BY YR, AGE) LAG
      FROM   MRG_TARGET
      ORDER BY YR, AGE)
WHERE AGE NOT IN (0,85);

TTITLE OFF
CLEAR COLUMNS
