SET SERVEROUTPUT ON;

-- 2번
DECLARE
    v_dname departments.department_name%TYPE;
    v_jobid employees.job_id%TYPE;
    v_sal employees.salary%TYPE;
    v_total NUMBER;
BEGIN
    SELECT department_name, job_id , salary , (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12) AS comm
    INTO v_dname , v_jobid , v_sal , v_total
    FROM employees e JOIN departments d ON (e.department_id = d.department_id)
    WHERE employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('부서이름 :' || v_dname);
    DBMS_OUTPUT.PUT_LINE('업무 :' || v_jobid);
    DBMS_OUTPUT.PUT_LINE('급여 :' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉 :' || v_total);
END;
/

--3 번
DECLARE
     v_year CHAR(4 char);
BEGIN
    SELECT TO_CHAR(hire_date, 'yyyy')
    INTO v_year
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_year > '2015' THEN
        DBMS_OUTPUT.PUT_LINE('New employee 입사년도 :' || v_year);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee 입사년도 :' || v_year);
    END IF;
END;
/

--4번
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF MOD(v_dan, 2) <> 0 THEN
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_dan || ' = ' || v_dan * v_num);
            END LOOP;
            DBMS_OUTPUT.PUT('');
        END IF;
    END LOOP;
END;
/

--5번
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id eid, last_name || ' ' || first_name ename, salary sal
        FROM employees;
    emp_rec emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_rec;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(' '||emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(' ' ||emp_rec.sal);
    END LOOP;
    
    IF emp_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('현재 커서의 데이터는 존재하지 않습니다,');
    END IF;
    
    CLOSE emp_cursor;
END;
/

--6번
CREATE OR REPLACE PROCEDURE y_update01
(p_eid IN employees.employee_id%TYPE,
 p_sal IN NUMBER)
IS
    e_emp_no EXCEPTION;
BEGIN
    UPDATE employees
    SET salary = salary + (salary * (p_sal / 100))
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_no;
    END IF;
EXCEPTION
    WHEN e_emp_no THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

EXECUTE y_update01(100, 50);
SELECT * FROM employees WHERE employee_id = 100;
rollback;

--7 번
CREATE OR REPLACE PROCEDURE yedam_jumin
(p_ssn IN VARCHAR2)
IS
    v_result VARCHAR2(100);
    v_gender CHAR(1);
    v_birth VARCHAR2(15 char);
BEGIN
    v_gender := SUBSTR(p_ssn,7,1);
    IF v_gender IN ('1', '2') THEN
        v_birth := '19' || SUBSTR(p_ssn, 1,2) || '년'
                        || SUBSTR(p_ssn, 3,2) || '월'
                        || SUBSTR(p_ssn, 5,2) || '일' || ' 남자';
    ELSIF v_gender IN ('3','4') THEN
        v_birth := '20' || SUBSTR(p_ssn, 1,2) || '년'
                        || SUBSTR(p_ssn, 3,2) || '월'
                        || SUBSTR(p_ssn, 5,2) || '일' || ' 여자';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/
EXECUTE yedam_jumin ('0211023234567');

-- 8번
CREATE OR REPLACE FUNCTION emp_year
(p_empno IN employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_hdate DATE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = p_empno;
    
    
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(emp_year(100));

SELECT last_name
    FROM employees
    WHERE employee_id =(SELECT manager_id
                        FROM departments
                        WHERE department_name = 'IT');

-- 9번
CREATE OR REPLACE FUNCTION dept_manager
(p_deptname IN departments.department_name%TYPE)
RETURN VARCHAR2
IS  
    e_no_manager EXCEPTION;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE employee_id =(SELECT manager_id
                        FROM departments
                        WHERE department_name = p_deptname);
    
    RETURN v_ename;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '해당 부서가 존재하지 않습니다.';
    WHEN e_no_manager THEN
        RETURN '해당 부서의 책임자가 존재하지 않습니다.';
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(dept_manager('IT'));


-- 10번
SELECT name, text
FROM user_source
WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE' ,'PACKAGE BODY');

-- 11번
DECLARE
    v_str VARCHAR2(100) := '';
    v_idx NUMBER := 1;
BEGIN
    FOR idx IN reverse 1..9 LOOP
        FOR inIdx IN 1..idx LOOP
            v_str := v_str || '-';
        END LOOP ;
        DBMS_OUTPUT.PUT_LINE(RPAD(v_str, 10, '*'));
        v_str := '';
    END LOOP;
END;
/