SET  SERVEROUTPUT ON;

-- ORDER BY는 서브쿼리에서 많이쓰였음, 굳이 PL SQL 에서 는 복잡하게 쓸 필요가 없다
-- more ehan requested number, no data found 에러는  > 내 실력으로 where 절을 조절하는수 밖에없음
DECLARE
    v_eid NUMBER;
    v_ename employees.first_name%TYPE;
    v_job VARCHAR2(1000);
BEGIN
    SELECT employee_id, first_name, job_id
    INTO v_eid, v_ename, v_job
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('업무 :' || v_job);
END;
/

--치환변수 대체된다는 뜻 (이거 많이 쓸거임)
-- 치환변수는 DECALRE 절 얘가 컴파일 할때 동작을 한다
-- 치환변수 할때 문자를 입력하게되면 인식 못함 치환변수는 들어오는 변수에 대한 데이터 변환이 일어나지 않는다 문자를 입력할 경우에는 홀따옴표를 붙이던가 밖에서 홀따옴표를 붙이던가
DECLARE
    v_eid employees.employee_id%TYPE := &사원번호;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT  first_name || ', ' || last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
END;
/

-- 특정 사원의 매니저에 해당하는 사원번호를 출력 : (특정 사원은 치환변수를 사용해서 입력)
SELECT manager_id, first_name , last_name, manager_id
from employees
where employee_id = 102;

DECLARE
    v_eid employees.employee_id%TYPE := &사원번호;
    v_mgr employees.manager_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT  manager_id, first_name || ', ' || last_name
    INTO v_mgr, v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('매니저 :' || v_mgr);
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
END;
/

-- INSERT, UPDATE
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := 0.1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &사원번호;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);

    DBMS_OUTPUT.PUT_LINE( '등록 결과 :' || SQL%ROWCOUNT );
    -- 필요에 따라서 널인 경우 NVL 처리를 해줘야 한다
    UPDATE employees
    SET salary = (NVL(salary,0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    DBMS_OUTPUT.PUT_LINE( '수정 결과 :' || SQL%ROWCOUNT );
END;
/

rollback;
select *
from employees

where department_id = 100;

DELETE FROM employees where employee_id = 1000;

SELECT * FROM employees WHERE employee_id = 1000;

--ROWCOUNT 실제 사용 경우 수정되지 않았을때 보통 DELETE 와 UPDATE 정보가 잘못되어 알려줄때 많이 사용
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사업번호;
    
    IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('해당 사워원은 존재하지 않습니다');
    END IF;
END;
/

/*
    1. 사원번호를 입력할 경우
    사원번호, 사원이름, 부서이름을
    출력하는 PL/SQL을 작성하시오.
    사원번호는 치환변수를 통해 입력받습니다.
    
    입력 : 사원번호                              > table : employees
    출력 : 사원번호, 사원이름 ,부서이름      > table : employeee + departments
                                                    > 조건 : department_id
*/

-- 내가 한거
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_name
    INTO v_eid, v_ename, v_dname
    FROM employees e 
    join departments d on (e.department_id = d.department_id)
    WHERE e.employee_id = &사원번호;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('부서이름 :' || v_dname);
END;
/

-- 2번째방법
DECLARE
    v_empid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
 --   v_dept_id employees.department_id%TYPE; -- select문 2개쓸때..
    v_deptname departments.department_name%TYPE;

BEGIN
    SELECT employee_id , first_name, department_id
    INTO v_empid, v_ename, v_deptid
    FROM employees
    WHERE employees_id = &사원번호;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptid;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || v_empid);
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('부서이름 :' || v_deptname);
END;
/

/*
    2. 사원번호를 입력할 경우
    사원이름, 급여, 연봉을
    출력하는 PL/SQL을 작성하시오.
    사원번호는 치환변수를 사용하고
    연봉은 아래의 공식을 기반으로 연산하시오.
    (급여 * 12 + ( NVL(급여,0) * NVL(커미션, 0) * 12))
*/

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 200;

DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    -- v_comm employees.commission_pct%TYPE;
    v_comm NUMBER;
BEGIN
    SELECT last_name, salary, (salary * 12 + (NVL(salary,0) * NVL(commission_pct,0) * 12))   -- , commisstion_pct
    INTO v_ename, v_sal , v_comm
    FROM employees
    WHERE employee_id = &사원번호;
    
    -- v_annual := v_sal * 12 + NVL(v_sal,0) * NVL(v_comm,0) * 12; -- 이것도 하나의 방법 SELECT 문으로 모든걸 처리할 필요는 없다
    
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 :' || v_sal);
    DBMS_OUTPUT.PUT_LINE('연봉 :' || v_comm);
END;
/

-- 기본 IF 문
BEGIN
    DELETE FROM employees
    WHERE employee_id = &사원번호;
    
    IF SQL%ROWCOUNT = 0 THEN -- TRUE는 실행 FALSE 일때는 버린다고생각
        DBMS_OUTPUT.PUT_LINE('정상적으로 실해되지 않았습니다.');
        DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다..');
    END IF;
END;
/

-- IF ~ ELSE 문 : 팀장급
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id) -- 데이터가 없는 경우도 체크 해야해서 COUNT 씀 데이터가 없으면 NODATA FOUND 뜸
    INTO v_count
    FROM employees
    WHERE manager_id = &eid;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('일반 사원입니다');
    ELSE  -- 자기 자신의 조건식은 없다 
        DBMS_OUTPUT.PUT_LINE('팀장입니다');
    END IF;
END;
/

-- IF ~ ELSIF ~ ELSE 문 : 연차
DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_hdate < 5 THEN -- 입사한지 5년 미만
        DBMS_OUTPUT.PUT_LINE('입사한 지 5년 미만입니다.');
    ELSIF v_hdate < 10 THEN -- 입사 5년이상 10년 미만
        DBMS_OUTPUT.PUT_LINE('입사한 지 10년 미만입니다.');
    ELSIF v_hdate < 15 THEN -- 입사 10년 이상 15년 미만
        DBMS_OUTPUT.PUT_LINE('입사한 지 15년 미만입니다.');
    ELSIF v_hdate < 20 THEN -- 입사 15년이상 20년 미만
        DBMS_OUTPUT.PUT_LINE('입사한 지 20년 미만입니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('입사한지 20년 이상입니다..');
    END IF;
END;
/

SELECT employee_id, 
        TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12),
        TRUNC((sysdate-hire_date)/365) -- sysdate는 큰 수여서 앞에 둬야함 
FROM employees
ORDER BY 2 desc;

/*
    사원번호를 입력(치환변수사용&)할 경우
    입사일이 2005년 이후 (2005년 포함)이면 'New employee' 출력
    2005년 이전이면 'Career employee' 출력
// 함수로 쓰기 가장 좋다
    
    입력 : 사원번호
    출력 : 입사일
    
    조건문 : IF -> 입사일 >= 2005년 'New employee' 출력
                        아니면  'Career employee' 출력
                        
*/

-- rr yy 4자리를 쓸거면yyyy 쓰고  rr 쓰려면 두자리를  rr yy 구분해줘야한다 
--  1) 날짜 그대로 비교



SELECT employee_id , hire_date
FROM employees
WHERE employee_id = 101;

DECLARE
    v_hdate DATE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &사원번호;
    
   IF v_hdate >= TO_DATE('2005-01-01', 'yyyy-MM-dd') THEN
            DBMS_OUTPUT.PUT_LINE('New employee 입사년도 :' || v_hdate);
   ELSE
            DBMS_OUTPUT.PUT_LINE('Career employee 입사년도 :' || v_hdate);
   END IF;
    
END;
/

-- 2) 년도만 비교
SELECT TO_CHAR(hire_date, 'yyyy') -- TO_CHAR
FROM employees;

DECLARE
    v_year CHAR(4 char);
BEGIN
        SELECT TO_CHAR(hire_date, 'yyyy') -- TO_CHAR
        INTO v_year
        FROM employees
        WHERE employee_id = &사원번호;
        
        IF v_year >= '2005' THEN
               DBMS_OUTPUT.PUT_LINE('New employee 입사년도 :' || v_year);
        ELSE
               DBMS_OUTPUT.PUT_LINE('Career employee 입사년도 :' || v_year);
        END IF;
END;
/
    
/*
    사원번호를 입력(치환변수사용&)할 경우
    입사일이 2005년 이후 (2005년 포함)이면 'New employee' 출력
    2005년 이전이면 'Career employee' 출력
    
    단, DBMS_OUTPUT.PUT_LINE() 은 코드 상 한번만 작성
*/

SELECT TO_CHAR(hire_date, 'yyyy') -- TO_CHAR
FROM employees;

DECLARE
    v_year CHAR(4 char);
    v_data VARCHAR2(1000) := 'Career employee';
BEGIN
        SELECT TO_CHAR(hire_date, 'yyyy') -- TO_CHAR
        INTO v_year
        FROM employees
        WHERE employee_id = &사원번호;
        /*
        IF v_year >= '2005' THEN
               v_data := 'New employee';
        ELSE
               v_data := 'Career employee';
        END IF;   
        DBMS_OUTPUT.PUT_LINE(v_data);
        */
         IF v_year >= '2005' THEN
               v_data := 'New employee';
        END IF;
         DBMS_OUTPUT.PUT_LINE(v_data);
END;
/

/*
4. 급여가 5000이하이면 20% 인상된 급여
    급여가 10000이하이면 15% 인상된 급여
    급여가 15000이하이면 10% 인상된 급여
    급여가 15001이상이면 급여 인상없음
    
사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오

    입력: 사원번호
    출력 : 사원이름 ,급여
    
    조건문 IF문 의 결과 => 인상된 급여
*/
SELECT last_name, salary, (salary * (salary * 2))
FROM employees
WHERE employee_id = 103;

DECLARE
    v_name employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
BEGIN
    SELECT last_name, salary
    INTO v_name , v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_sal <= 5000 THEN
        DBMS_OUTPUT.PUT_LINE(v_sal + (v_sal * (20 / 100)));
    ELSIF v_sal <= 10000 THEN
        DBMS_OUTPUT.PUT_LINE(v_sal + (v_sal * (15 / 100)));
    ELSIF v_sal <= 15000 THEN
        DBMS_OUTPUT.PUT_LINE(v_sal + (v_sal * (10 / 100)));
    ELSIF v_sal >= 15001 THEN
        DBMS_OUTPUT.PUT_LINE('급여 인상없음');
    END IF;
        DBMS_OUTPUT.PUT_LINE(v_name);
        DBMS_OUTPUT.PUT_LINE(v_sal);
END;
/


DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_raise NUMBER := 0;
BEGIN
    SELECT last_name , salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &사원번호;
    
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원이름 :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('급여 :' || v_sal);
    DBMS_OUTPUT.PUT_LINE('인상된급여 :' || (v_sal * (1 + v_raise/100)));
END;
/


-- 1에서 10까지 정수값을 더한 결과를 출력
-- 기본 LOOP

DECLARE
    v_num NUMBER(2,0) :=1; -- 1~ 10
    v_sum NUMBER(2,0) :=0;     -- 결과
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num +1; -- < 얘는 변환되어야 한다 그래야 무한루프에 빠지지 않는다
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- WHILE LOOP
DECLARE
    v_num NUMBER(2,0) :=1; -- 1~ 10
    v_sum NUMBER(2,0) :=0;     -- 결과
BEGIN
    WHILE v_num <= 10 LOOP   -- 반대범위를 카르키고있다.
        v_sum := v_sum + v_num;
        
        v_num := v_num +1;  -- 결국 얘가 필요함
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/



-- FOR LOOP
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_n NUMBER(8,0) := 99;
BEGIN
--  내부에서 선언되는 변수는 사라짐, 구분된 형태로 쓰는게 좋다
    -- FOR v_n IN REVERSE 1..10 LOOP -- 반드시 역순으로 하고싶으면 REBERSE
    --FOR v_n IN 1..10 LOOP
    FOR num IN 1..10 LOOP
        v_sum := v_sum + num;
        DBMS_OUTPUT.PUT_LINE(v_n);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_n);
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP
-- 1) FOR LOOP의 임시변수 -> DECLARE 절에 정의된 변수이름과 같으면 안됨
-- 2) FOR LOOP는 기본적으로 오름차순 정렬, 같은 범위에서 내림차순으로 값을 받아오고자 한다면 REVERSE 추가

DECLARE
    v_n NUMBER(8,0) := 99;
BEGIN
--  내부에서 선언되는 변수는 사라짐, 구분된 형태로 쓰는게 좋다
    -- FOR v_n IN REVERSE 1..10 LOOP -- 반드시 역순으로 하고싶으면 REBERSE
    FOR v_n IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_n);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_n);
END;
/

/*
1. 다음과 같이 출력되도록 하시오.
*               -- 처번째 줄, * 가 하나
**              -- 두번째 줄, * 가 두개
***             -- 세번째 줄, * 가 세개
****            -- 넷번째 줄, * 가 네개
*****           -- 다섯번째 줄, * 가 다섯개
*/

-- 기본 LOOP  
DECLARE
    v_str VARCHAR2(100) := '*';
    v_idx NUMBER := 0;
BEGIN
    LOOP
     EXIT WHEN v_idx > 4;
     DBMS_OUTPUT.PUT_LINE(v_str);
        v_str :=v_str || '*';
        v_idx := v_idx +1; -- < 얘는 변환되어야 한다 그래야 무한루프에 빠지지 않는다    
    END LOOP;
END;
/

-- 기본 LOOP 2번째 방법
DECLARE
    v_tree VARCHAR2(6 char) := '';
    v_line NUMBER (1, 0) := 1;
BEGIN
        LOOP
            v_tree := v_tree || '*';
            DBMS_OUTPUT.PUT_LINE(v_tree);
            
            v_line := v_line +1;
            EXIT WHEN v_line > 5;
        END LOOP;
END;
/


-- WHILE LOOP문
DECLARE
    v_str VARCHAR2(100) := '*';
    v_idx NUMBER := 0;
BEGIN
    WHILE  v_idx < 5 LOOP
    DBMS_OUTPUT.PUT_LINE(v_str);
    v_idx := v_idx +1;
    v_str := v_str || '*';
    END LOOP;
END;
/


--WHILE LOOP 2번째 방법
DECLARE
    v_tree VARCHAR2(6 char) := '';
    v_line NUMBER (1, 0) := 1;
BEGIN
       WHILE v_line <= 5 LOOP
            v_tree := v_tree || '*';
            DBMS_OUTPUT.PUT_LINE(v_tree);
            
            v_line := v_line +1;
        END LOOP;
END;
/

-- WHILE LOOP 렝스로 해결하기

DECLARE
    v_tree VARCHAR2(6 char) := '*';
BEGIN
       WHILE LENGTH (v_tree) <= 5 LOOP
       DBMS_OUTPUT.PUT_LINE(v_tree);
            v_tree := v_tree || '*';
            
        END LOOP;
END;
/

-- 얘 기본 LOOP 임
DECLARE
    v_str VARCHAR2(100) := '*';
    v_idx NUMBER := 0;
BEGIN
    LOOP
        EXIT WHEN v_idx >= 5;
        DBMS_OUTPUT.PUT_LINE(v_str);
        v_idx := v_idx +1;
        v_str := v_str || '*';
        
    END LOOP;
END;
/


-- 2번째 방법 num 은 문법적으로 쓰고 내부에서 선언만 하지만 않으면 된다
-- num 할당연산자로 해서 값을 변경할수 없다
DECLARE
    v_tree VARCHAR2(6 char) := '';
BEGIN
       FOR num in 1..5 LOOP
            v_tree := v_tree || '*';
            DBMS_OUTPUT.PUT_LINE(v_tree);
        END LOOP;
END;
/


DBMS_OUTPUT.PUT();
DBMS_OUTPUT.PUT_LINE();

-- 이중 반복문 문
BEGIN
    FOR line IN 1..5 LOOP -- 라인 , 줄
        FOR star IN 1..line LOOP -- *
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

DECLARE
    v_line NUMBER(1,0) := 1;
    v_star NUMBER(1,0) := 1;
BEGIN
    LOOP
        v_star := 1;
    
            LOOP
                DBMS_OUTPUT.PUT('*');
                v_star := v_star + 1;
                EXIT WHEN v_star > v_line; 
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_line := v_line + 1;
        EXIT WHEN v_line > 5;
    END LOOP;
END;
/

