SET SERVEROUTPUT ON;

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)

입력 : 사원번호 => IN
연산 : 입력받은 사원번호 삭제 => DELETE -> employees

SELECT 의 예외처리는 EXCEPTION을 써야한다

*/


CREATE PROCEDURE TEST_PRO
(p_eid IN employees.employee_id%TYPE)
IS
    e_no_emp EXCEPTION;
BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid; -- 입력받은 아이디 값으로 삭제하면된다
    
    
    IF SQL%ROWCOUNT = 0 THEN
        --DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
        RAISE e_no_emp;
    END IF;
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력

입력 : 사원번호 -> IN 
연산 : 1) SELECT (사원이름 필요해서)
      2) 해당 이름의 포맷 변경 : SUBSTR, LENGTH(길이필요), RPAD(아스타 기준)
      3) 출력
*/

CREATE PROCEDURE yadam_emp
(p_eid IN test_employee.employee_id%TYPE) -- 매개변수
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename         -- v_ 는 접두어
    FROM employees
    WHERE employee_id = p_eid;
    
    v_result := RPAD(SUBSTR(v_ename,1,1), LENGTH(v_ename), '*');
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ' -> ' || v_result);
END;
/

/*4.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)

입력 : 사원번호,급여 증가치(비율)
연산 : 사원의 급여를 갱신 = 급여 증가치(비율), UPDATE문
      UPDATE employees
      SET salary = salary + (salary * (급여증가치/ 100)) => 급여증가치가 정수일때
      SET salary = salary + (salary * (급여증가치) => 급여증가치가 실수일때
      WHERE 사원번호 = 사원번호;
*/
CREATE OR REPLACE PROCEDURE y_update
(p_eid IN test_employee.employee_id%TYPE,
 p_sal IN NUMBER)
IS
    e_emp_no EXCEPTION;
BEGIN
    UPDATE test_employee
    SET salary = salary + (salary * (p_sal / 100))
    -- SET salary = salary * (1 + (p_sal/100))
    WHERE employee_id = p_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_emp_no;
    END IF;
    
EXCEPTION
    WHEN e_emp_no THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/
EXECUTE y_update(150, 50);
SELECT * FROM test_employee WHERE employee_id = 150;
rollback;

/*
5.
다음과 같이 테이블을 생성하시오.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
5-1.
부서번호를 입력하면 사원들 중에서 입사년도가 2005년 이전 입사한 사원은 yedam01 테이블에 입력하고,
입사년도가 2005년(포함) 이후 입사한 사원은 yedam02 테이블에 입력하는 y_proc 프로시저를 생성하시오.


입력 : 부서번호
연산 : 해당 사원 -> 앞서 만든 테이블에 INSERT 하라는 뜻 궁극적으로
        1) SELECT -> CURSOR -- 하나의 데이터가지고 여러건을 가져올수있는 커서
        2) IF문 , 입사년도
            2-1) 입사년도 < 2005년 ) yedam01 테이블 INSERT
            2-2) 입사년도 >= 2005년 ) yedam02 테이블 INSERT
        TO_DATE는 같은 포맷을 써야한다

5-2.
1. 단, 부서번호가 없을 경우 "해당부서가 없습니다" 예외처리 (사용자 정의 내용이 필요함) 부서번호가 없다는건 커서가 순환을 다 돌았을때 ROWCOUNT 가 없다는 건데
2. 단, 해당하는 부서에 사원이 없을 경우 "해당부서에 사원이 없습니다" 예외처리
*/
create table yedam01
(y_id number(10),
 y_name varchar2(20));
 
create table yedam02
(y_id number(10),
 y_name varchar2(20));

CREATE OR REPLACE PROCEDURE y_proc
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, hire_date
        FROM employees
        WHERE department_id = p_deptno;
        
    emp_rec emp_cursor%ROWTYPE;
    v_deptno departments.department_id%TYPE; -- 사용자 정의 
    
    e_no_emp EXCEPTION;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM departments
    WHERE department_id = p_deptno;
    
    OPEN emp_cursor;
    
    LOOP
        FETCH emp_cursor INTO emp_rec;
        EXIT WHEN emp_cursor%NOTFOUND;
        
        --IF hire_date <= TO_DATE('04-12-31', 'yy-MM-dd')THEN
        IF TO_CHAR(emp_rec.hire_date, 'yyyy') < '2005' THEN -- 년도만 기준으로 쓸꺼면 이거쓰고
            INSERT INTO yedam01
            VALUES (emp_rec.employee_id, emp_rec.last_name);
        ELSE
            INSERT INTO yedam02
            VALUES (emp_rec.employee_id, emp_rec.last_name);
        END IF;
    END LOOP;
    
    IF emp_cursor%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    CLOSE emp_cursor;
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당부서에 사원이 없습니다.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당부서는 존재하지 않습니다.');
END;
/

EXECUTE y_proc(80);
SELECT * FROM yedam01;
SELECT * FROM yedam02;

-- FUNCTION
CREATE  FUNCTION plus
(p_x IN NUMBER,
 p_y NUMBER)
RETURN NUMBER --반드시 돌려줘야함 BEGIN 쪽에
IS
    v_result NUMBER;
BEGIN
    v_result := p_x + p_y;
    RETURN v_result; --반드시 돌려줘야함
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '데이터가 존재하지 않습니다';  -- RETURN 반드시 돌려줘야 한다 얘는 넘버타입이기때문에 이 구문은 실행되지 않는다. 이걸 실행하려면 타입을 VARCHAR2 로바꿔야함
    WHEN TOO_MANY_ROWS THEN
        RETURN '데이터가 요구한 것보다 많습니다.'; -- RETURN 반드시 돌려줘야 한다
END;
/

-- 1) 블록 내부에서 실행
DECLARE
    v_sum NUMBER;
BEGIN
    v_sum := plus(10,20); -- v_sum을 뺴면 프로시저에서 걸린다
    -- plus >> PL/SQL
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 2) EXECUTE : 함수를 사용할때 DBMS_OUTPUT.PUT_LINE 이걸 써줘야 알수있다.
EXECUTE DBMS_OUTPUT.PUT_LINE(plus(10,20));

-- 3) SQL문 : DML을 내부에서 사용하지 않는거 데이터를 SQL 에서 처리가 가능하면 이렇게 쓴다
SELECT plus(10,20) FROM dual;

-- 1 ~ n 까지 누적된 값을 반환하는 함수
CREATE OR REPLACE FUNCTION y_factorial
(p_n NUMBER)
RETURN NUMBER -- RETURN 타입을 무시하면 오류가 난다
IS
    v_sum NUMBER := 0;
BEGIN
    FOR idx IN 1..p_n LOOP
        v_sum := v_sum + idx;
    END LOOP;
    
    RETURN v_sum;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- 위에 데이터 NUMBER 타입과 같아야한다 그래서 숫자로 정의
    WHEN TOO_MANY_ROWS THEN
        RETURN -2;
END;
/

EXECUTE  DBMS_OUTPUT.PUT_LINE(y_factorial(10));

/*
사원번호를 입력하면
last_name + first_name 이 출력되는
y_yedam 함수를 생성하시오

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
출력 예) Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM employees;

입력 : 사원번호
연산 : 사원번호 => last_name , first_name / SELECT
출력 : FULLNAME
*/

CREATE FUNCTION y_yedam
(p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name || ' ' || first_name
    INTO v_ename
    FROM employees
    WHERE employee_id = p_eid;
    
    RETURN v_ename;
END;
/


SELECT employee_id, last_name || ' ' || first_name full_name
FROM employees
WHERE employee_id = 100;

CREATE OR REPLACE FUNCTION y_yedam
(p_eid IN employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_enamefirst employees.first_name%TYPE;
    v_enamelast employees.last_name%TYPE;
BEGIN
    SELECT last_name , first_name
    INTO v_enamefirst , v_enamelast
    FROM employees
    WHERE employee_id = p_eid;
    
    
    RETURN v_enamefirst || ' ' || v_enamelast; -- 반드시 돌려줘야함
END;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174));

SELECT employee_id, y_yedam(employee_id)
FROM employees;

/*
2.
사원번호를 입력할 경우 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오.
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 이상이면 급여 그대로 출력
실행) SELECT last_name, salary, YDINC(employee_id)
     FROM   employees;
*/
CREATE OR REPLACE FUNCTION ydinc
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_sal employees.salary%TYPE;
BEGIN
    SELECT salary
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
    
    IF v_sal <= 5000 THEN
        v_sal := v_sal + (v_sal * (20 / 100));
    ELSIF v_sal <= 10000 THEN
        v_sal := v_sal + (v_sal * (15 / 100));
    ELSIF v_sal <= 20000 THEN
        v_sal := v_sal + (v_sal * (10 / 100));
    ELSIF v_sal >= 20000 THEN
        v_sal := v_sal;
    END IF;
    RETURN v_sal;
END;
/
SELECT last_name, salary, YDINC(employee_id)
FROM employees;


/*

3.
사원번호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
->연봉계산 : (급여+(급여*인센티브퍼센트))*12
실행) SELECT last_name, salary, YD_FUNC(employee_id)
     FROM   employees;
     
*/
CREATE OR REPLACE FUNCTION yd_func
(p_eid employees.employee_id%TYPE)
RETURN NUMBER
IS
    v_sal NUMBER;
BEGIN
    SELECT (salary + (salary * NVL(commission_pct, 0))) * 12 comm
    INTO v_sal
    FROM employees
    WHERE employee_id = p_eid;
    
    
    RETURN v_sal;
END;
/

SELECT last_name, salary, YD_FUNC(employee_id)
FROM   employees;


/*
4. 
SELECT last_name, subname(last_name)
FROM   employees;

LAST_NAME     SUBNAME(LA
------------ ------------
King         K***
Smith        S****
...
예제와 같이 출력되는 subname 함수를 작성하시오.
*/
CREATE OR REPLACE FUNCTION subname
(p_name employees.last_name%TYPE)
RETURN VARCHAR2
IS

BEGIN
    
    RETURN RPAD(SUBSTR(p_name,1,1), LENGTH(p_name), '*') ;
END;
/

SELECT last_name, subname(last_name)
FROM   employees;

/*
5. 
부서번호를 입력하면 해당 부서의 책임자 이름를 출력하는 y_dept 함수를 생성하시오.
(단, JOIN을 사용)
(단, 다음과 같은 경우 예외처리(exception)
 해당 부서가 없거나 부서의 책임자가 없는 경우 아래의 메세지를 출력
    
    해당 부서가 없는 경우 -> 해당 부서가 존재하지 않습니다.
	부서의 책임자가 없는 경우 -> 해당 부서의 책임자가 존재하지 않습니다.	)

실행) EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(110))
출력) Higgins
SELECT department_id, y_dept(department_id)
FROM   departments;
*/

CREATE OR REPLACE FUNCTION y_dept
(p_deptno departments.department_id%TYPE)
RETURN VARCHAR2
IS
    e_no_emp EXCEPTION;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT *
        INTO 
        FROM DEPARTMENTS
        WHERE dpartment_id = p_deptno;
    
    SELECT e.last_name
    INTO v_ename
    FROM employees e JOIN departments d ON (e.employee_id = d.manager_id)
    WHERE d.department_id = p_deptno;

    RETURN v_ename;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '해당 부서가 존재하지 않습니다.';
    WHEN e_no_emp THEN
        RETURN '해당 부서의 책임자가 존재하지 않습니다.';
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(700));

SELECT department_id, y_dept(department_id)
FROM   departments;