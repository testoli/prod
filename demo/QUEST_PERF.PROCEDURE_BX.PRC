CREATE OR REPLACE PROCEDURE QUEST_PERF.PROCEDURE_BX
IS
  N_ID  NUMBER;
  N_SALARY NUMBER;
  V_NAME VARCHAR2(30);
  V_ADDRESS VARCHAR2(100);
  V_DEPT VARCHAR2(3);
  D_DATE DATE;
  X_GRANTEE VARCHAR2(200);
  X_privilege VARCHAR2(200);
  X_grantable VARCHAR2(200);
  /*Kommentar*/
  X_test varchar2(29);
BEGIN
  BEGIN
SELECT SAL_EMP_ID, 
       SAL_EFFECT_DATE, 
       SAL_SALARY 
  INTO N_ID, 
       D_DATE, 
       N_SALARY 
  FROM EMP_SAL_HIST 
 WHERE SAL_EMP_ID < 11000 
    OR (SAL_EMP_ID IN (73736, 73737) 
        AND SAL_SALARY > 50000);
  EXCEPTION
    WHEN OTHERS THEN
    begin
    /* Use Intelligence 5 to tune following SQL   */
      SELECT EMP_ID, 
       EMP_NAME, 
       EMP_ADDRESS, 
       EMP_DEPT, 
       EMP_SALARY 
  INTO N_ID, 
       V_NAME, 
       V_ADDRESS, 
       V_DEPT, 
       N_SALARY 
  FROM EMPLOYEE 
 WHERE EMP_ID IN (SELECT SAL_EMP_ID 
                    FROM EMP_SAL_HIST 
                   WHERE SAL_SALARY BETWEEN 500000 AND 501000);
      exception
        when others then 
          null;
    end;
    
  END;
  
  SELECT SYSDATE
    INTO D_DATE
    FROM DUAL;
    
 SELECT grantee, 
       privilege, 
       grantable 
  INTO X_grantee, 
       X_privilege, 
       X_grantable 
  FROM sys.all_tab_privs 
 where table_schema = 'QSO' 
   and table_name = 'EMPLOYEE' 
   and grantor = 'QSO' 
   AND grantee in (select username 
                     from sys.all_users);

END;
/
