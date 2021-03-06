REM
REM CREATE_PROC_DEMO_MERGE.SQL
REM

REM
REM A procedure to MERGE demographic data
REM

CREATE OR REPLACE PROCEDURE DEMO_MERGE
IS
BEGIN

  MERGE INTO MRG_TARGET MT
    USING CENSUS_EXT_FL2125_VW CDE
    ON (MT.YR || LTRIM(MT.AGE) = CDE.C_YEAR || LTRIM(CDE.C_AGE))
    WHEN MATCHED THEN
      UPDATE SET
           MT.AMIND_HISP_MALE   = CDE.C_PROJ_AMIND_HISP_MALE
         , MT.AMIND_HISP_FEMALE = CDE.C_PROJ_AMIND_HISP_FEMALE
         , MT.STATUS            = 'REVISED'         
    WHEN NOT MATCHED THEN 
      INSERT 
        (  MT.MRG_TARGET_ID
         , MT.YR
         , MT.AGE
         , MT.AMIND_NON_HISP_MALE
         , MT.AMIND_NON_HISP_FEMALE
         , MT.AMIND_HISP_MALE
         , MT.AMIND_HISP_FEMALE
         , MT.STATUS)
      VALUES
        (  SEQ_MTI.NEXTVAL
         , CDE.C_YEAR
         , CDE.C_AGE
         , CDE.C_PROJ_AMIND_NON_HISP_MALE
         , CDE.C_PROJ_AMIND_NON_HISP_FEMALE
         , CDE.C_PROJ_AMIND_HISP_MALE
         , CDE.C_PROJ_AMIND_HISP_FEMALE
         , 'NEW')
  LOG ERRORS INTO MRG_TARGET_ERRLOG ('Bad') REJECT LIMIT UNLIMITED;

EXCEPTION

  WHEN OTHERS THEN
    CATCH_MESSAGE(SQLCODE, SUBSTR(SQLERRM, 1, 200), 'PROC MERGE_DEMO');

END;
/
