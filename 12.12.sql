SET SERVEROUTPUT ON;
/*
2. 치환변수 (&)를 사용하면 숫자를 입력하면 해당 구구단이 출력되도록 하시오.
예) 2 입력시
    2 * 1 = 2
    2 * 2 = 4
        :
        :
    2 * 9 = 18
    
    입력 : 단
    출력 : 특정 포맷 (단 * 곱하는 수 = 결과)
    
    => 곱하는 수 : 1 에서 9 사이의 정수값
*/

-- 기본 LOOP 
DECLARE
    -- 단 : 숫자타, 치환변수로 입력
    a1 NUMBER := &단;
    a2 NUMBER := 1;
BEGIN
    -- 반복문 시작
    LOOP
        -- 출력 : 단 * 곱하는 수 = (단 * 곱하는 수)
        DBMS_OUTPUT.PUT_LINE(a1 || ' * ' || a2 || ' = ' || (a1 * a2));
        -- 이때 곱하는 수는 1부터 9까지 1씩 증가 => 반복문으로 제어
        a2 := a2 +1;
        EXIT WHEN a2 > 9; -- 변환되는 숫자를 끊어야 한다
    -- 반복문 종료
    END LOOP;
END;
/


-- 기본 LOOP
DECLARE
    v_dan NUMBER := &단;
    v_num NUMBER := 1;
BEGIN
    LOOP
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
    END LOOP;
END;
/

-- FOR LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
BEGIN
    FOR v_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
    END LOOP;
END;
/


-- WHILE LOOP
DECLARE
    v_dan NUMBER := &단;
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

/*
3. 구구단 2~9까지 출력되도록 하시오.

4. 구구단 1~9 까지 출력되도록 하시오
    (단, 홀수단 출력)
    
    MOD(가지고 잇는 숫자 , 나누는 수) => 나머지
*/

-- 하나 더있었는데 
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF MOD(v_dan, 2) <> 0 THEN -- !=
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num ||  ' = ' || (v_dan * v_num) || ' ');
            END LOOP;
            DBMS_OUTPUT.PUT('');
        END IF;
    END LOOP;
END;
/

-- CONTINUE; 컨티뉴
BEGIN
    FOR v_dan IN 1..9 LOOP
        IF MOD(v_dan, 2) <> 0 THEN -- !=
            CONTINUE;
        END IF;
        
            FOR v_num IN 1..9 LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num ||  ' = ' || (v_dan * v_num) || ' ');
            END LOOP;
            DBMS_OUTPUT.PUT('');
        
    END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    v_dan NUMBER(2,0) :=2;
    v_num NUMBER(2,0) :=1;
BEGIN
    WHILE v_num < 10 LOOP -- 특정 단의 1~9 까지 곱하는 LOOP 문
        v_dan := 2;
        WHILE v_dan < 10 LOOP -- 특정 단을 2~9 까지 반복하는 LOOP 문
            DBMS_OUTPUT.PUT(v_dan || ' X ' || v_num ||  ' = ' || (v_dan * v_num) || ' ');
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num + 1;
    END LOOP;
END;
/

-- WHILE LOOP 문
DECLARE
    v_dan NUMBER(2,0) :=2;
    v_num NUMBER(2,0) :=1;
    v_msg VARCHAR2(1000);
BEGIN
    WHILE v_num < 10 LOOP -- 특정 단의 1~9 까지 곱하는 LOOP 문
        v_dan := 2;
        WHILE v_dan < 10 LOOP -- 특정 단을 2~9 까지 반복하는 LOOP 문
            v_msg := v_dan || ' X ' || v_num ||  ' = ' || (v_dan * v_num) || ' ';
            DBMS_OUTPUT.PUT(RPAD(v_msg, 12 , ' '));
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_num := v_num + 1;
    END LOOP;
END;
/

--3번 이중 반복문 기본 LOOP
DECLARE
    v_dan NUMBER := 2;
    v_num NUMBER := 1;
BEGIN
    LOOP
            v_num := 1;
                LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
                v_num := v_num + 1;
                EXIT WHEN v_num > 9; 
                
                END LOOP;
            v_dan := v_dan + 1;
            EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- 3번 이중 반복문 FOR LOOP
DECLARE
BEGIN
    FOR dan IN 2..9 LOOP
        FOR num IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
    END LOOP;
END;
/

-- 4번 홀수단만 나오게
DECLARE
    v_dan NUMBER := 1;
    v_num NUMBER := 1;
    
BEGIN
    LOOP
            v_num := 1;
                LOOP
                DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
                v_num := v_num + 1;
                EXIT WHEN v_num > 9; 
                
                END LOOP;
            v_dan := v_dan + 2;
            EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- 4번 홀수단만 출력
DECLARE
BEGIN
    FOR dan IN 1..9 LOOP
    IF MOD(dan , 2) = 1 THEN
        FOR num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
    END IF;

    END LOOP;
END;
/


-- RECORD 타입
DECLARE
    -- 이름에 type을 적어주면 좋다
    -- 블럭이 바뀌면 다시
    TYPE info_rec_type IS RECORD -- 이름을 레코드 타입이란걸 알게 적어준다
        ( no NUMBER NOT NULL := 1,
          name VARCHAR2(1000) := 'NO NAME',
          birth DATE );
    -- 변수 선언
    user_info info_rec_type;
BEGIN
        -- 변수 명만 던지면 오류가 난다  출력하고자 하면 내부에 어떤필드를 출력하고자 하는지 알려줘야함
        -- DBMS_OUTPUT.PUT_LINE(user_info);
        DBMS_OUTPUT.PUT_LINE(user_info.no);
        user_info.birth := sysdate;
        DBMS_OUTPUT.PUT_LINE(user_info.birth);
END;
/

DECLARE
        emp_info_rec employees%ROWTYPE;
BEGIN
        SELECT *
        INTO emp_info_rec
        FROM employees
        WHERE employee_id = &사원번호;
        
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.employee_id);
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.first_name);
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.job_id);
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.hire_date);
END;
/

-- 사원번호, 이름 , 부서이름
-- RECORD는 변수 하나에 담는다
DECLARE
        TYPE emp_rec_type IS RECORD                               -- 진짜 데이터 타입
            ( eid employees.employee_id%TYPE,                     -- NUMBER
              ename employees.last_name%TYPE,                    -- VARCHAR2
              deptname departments.department_name%TYPE);  -- VARCHAR2
              
        emp_rec emp_rec_type;    
BEGIN
        -- 얘는 * 을 사용할수 없다 :
        SELECT employee_id , last_name, department_name
        INTO emp_rec
        FROM employees e JOIN departments d ON (e.department_id = d.department_id)  --
        WHERE employee_id = &사원번호;
        
        DBMS_OUTPUT.PUT_LINE('이름 :' || emp_rec.ename);
END;
/

-- TABLE
DECLARE
        -- 1) 정의
        TYPE num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        -- 2) 선언
        num_list num_table_type;
BEGIN
        -- array[0] => PL/SQL 버전은 이거 table(0)
        num_list (-1000) := 1;
        num_list (1234) := 2;
        num_list(11111) := 3;
        
        DBMS_OUTPUT.PUT_LINE(num_list.count);
        DBMS_OUTPUT.PUT_LINE(num_list(1234));
END;
/

DECLARE
        -- 1) 정의
        TYPE num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        -- 2) 선언
        num_list num_table_type;
BEGIN
        FOR i IN 1..9 LOOP
            num_list(i) := 2 * 1;
        END LOOP;
        
        FOR idx IN num_list.FIRST .. num_list.LAST LOOP
            IF num_list.EXISTS(idx) THEN -- 이 메서드는 있으면 true 이다
                DBMS_OUTPUT.PUT_LINE(num_list(idx));
            END IF;
        END LOOP;
END;
/

-- 어떤걸 원하는지 찾아서 쓰는
DECLARE
        TYPE emp_table_type IS TABLE OF employees%ROWTYPE
            INDEX BY BINARY_INTEGER;
            
        emp_table emp_table_type;
        emp_rec employees%ROWTYPE;
BEGIN
        FOR eid IN 100..110 LOOP
            SELECT *
            INTO emp_rec
            FROM employees
            WHERE employee_id = eid;
            
            emp_table(eid) := emp_rec;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(emp_table(100).employee_id);
        DBMS_OUTPUT.PUT_LINE(emp_table(100).last_name);
END;
/

DECLARE
        TYPE emp_table_type IS TABLE OF employees%ROWTYPE
            INDEX BY BINARY_INTEGER;
            
        emp_table emp_table_type;
        emp_rec employees%ROWTYPE;
        
        firstEmployeeId NUMBER := 0;
        lastEmployeeId NUMBER := 0;
        
BEGIN
        SELECT MIN(employee_id), MAX(employee_id)
        INTO firstEmployeeId, lastEmployeeId
        FROM employees;
        
        FOR eid IN firstEmployeeId .. lastEmployeeId LOOP
            SELECT *
            INTO emp_rec
            FROM employees
            WHERE employee_id = eid;
            
            emp_table(eid) := emp_rec;
        END LOOP;
            
        FOR idx IN emp_table.First .. emp_table.LAST LOOP
            IF emp_table.EXISTS(idx) THEN
            DBMS_OUTPUT.PUT(emp_table(idx).employee_id || '  ');
            DBMS_OUTPUT.PUT_LINE(emp_table(idx).last_name);
            END IF;
        END LOOP;
END;
/
-- 교수님 버전
DECLARE
    v_min employees.employee_id%TYPE; -- 최소 사원번호
    v_MAX employees.employee_id%TYPE; -- 최대 사원번호
    v_result NUMBER(1,0);             -- 사원의 존재유무를 확인
    emp_record employees%ROWTYPE;     -- Employees 테이블의 한 행에 대응
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    -- 최소 사원번호, 최대 사원번호
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)         -- 존재 여부 체크
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN -- 사원이 없다는 말
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;     
    END LOOP;
    
    FOR eid IN emp_table.FIRST .. emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN  -- 반드시 들어가야함 항상 빈공간이 없다는걸 보장할수 없기 때문에 이걸 써야함
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).last_name);
        END IF;
    END LOOP;    
END;
/

-- CURSOR
DECLARE
    -- CURSOR 안에서는 순수한 SELECT 문 사용
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id =&부서번호;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    -- cursor OPEN
    -- select 문이 가지고 있는 결과가 메모리에 올라간다
    OPEN emp_dept_cursor;
    
    -- point가 첫번째로 이동
    -- 실제 우리에게 데이터가 넘어 오는 순간
    FETCH emp_dept_cursor INTO v_eid , v_ename;
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    
    -- close 가 된 후에는 접근하지 말기
    CLOSE emp_dept_cursor;
END;
/

SELECT employee_id, last_name
FROM employees
WHERE department_id = 50;

DECLARE
    CURSOR emp_info_cursor IS
        SELECT employee_id eid, last_name ename, hire_date hdate
        FROM employees
        WHERE department_id = &부서번호
        ORDER BY hire_date DESC;
        
    emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    -- select 한 결과를 기반으로 들고 오기 떄문에 별칭을사용해도 된다
    OPEN emp_info_cursor;
     
    LOOP
        FETCH emp_info_cursor INTO emp_rec;
        -- LOOP 문에서 ROWCOUNT을 쓰면 의미가 변한다
        EXIT WHEN emp_info_cursor%NOTFOUND OR emp_info_cursor%ROWCOUNT > 10; -- 10개 미만일때 종료될수 있게 
        -- EXIT WHEN emp_info_cursor%ROWCOUNT > 10; -- ROWCOUNT 커서에 대해서는 최대크기를 알수있는건 사실상 없다 실행하기 전까지
        DBMS_OUTPUT.PUT(emp_info_cursor%ROWCOUNT || ',');
        DBMS_OUTPUT.PUT(emp_rec.eid || ', ');
        DBMS_OUTPUT.PUT(emp_rec.ename || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
    END LOOP;
    --커서의 내부 총데이터확인 얘는 CLOSE 되기전에 정의해야한다
    IF emp_info_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('현재 커서의 데이터는 존재하지 않습니다,');
    END IF;
    
    CLOSE emp_info_cursor;
END;
/

SELECT employee_id , last_name , hire_date
FROM employees
ORDER BY hire_date DESC;


--1) 모든 사원의 사원번호, 이름, 부서이름 출력

DECLARE
    CURSOR emp_info_cursor IS
        SELECT employee_id eid, last_name ename, department_name deptname
        FROM employees e JOIN departments d ON (e.department_id = d.department_id)
        ORDER BY employee_id;
        
        emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    OPEN emp_info_cursor;
    
    LOOP
        FETCH emp_info_cursor INTO emp_rec;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(emp_rec.eid || ', ');
        DBMS_OUTPUT.PUT(emp_rec.ename || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.deptname || ', ');
    END LOOP;
    
    IF emp_info_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('현재 커서의 데이터는 존재하지 않습니다,');
    END IF;
    
    CLOSE emp_info_cursor;
    
END;
/

SELECT employee_id eid, last_name ename, department_name deptname
FROM employees e JOIN departments d ON (e.department_id = d.department_id);
        
-- 2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여,연봉 출력
-- 연봉 : (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12)

SELECT last_name, salary, (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12)
FROM employees
WHERE department_id = 50;

DECLARE
    CURSOR emp_info_cursor IS
        SELECT last_name ename, salary sal, (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12) comm
        FROM employees
        WHERE department_id IN (50, 80); -- IN 연산자는 보기 중에서 하나 선택을했을때 나오는 값
    
     emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    OPEN emp_info_cursor;
    
    LOOP
        FETCH emp_info_cursor INTO emp_rec;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT(emp_rec.ename || ', ');
        DBMS_OUTPUT.PUT(emp_rec.sal || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.comm);
      
    END LOOP;
    CLOSE emp_info_cursor;
END;
/

DECLARE
    CURSOR emp_info_cursor IS
        SELECT last_name , salary , commission_pct
        FROM employees
        WHERE department_id IN (50, 80) -- IN 연산자는 보기 중에서 하나 선택을했을때 나오는 값
        ORDER BY department_id;
     
     
     v_eid employees.employee_id%TYPE;
     v_sal employees.salary%TYPE;
     v_comm employees.commission_pct%TYPE;
     v_annual v_sal%TYPE;
BEGIN
    OPEN emp_info_cursor;
    LOOP
        FETCH emp_info_cursor INTO v_eid, v_sal, v_comm;
        EXIT WHEN emp_info_cursor%NOTFOUND;
        
        v_annual := NVL(v_sal,0) * 12 NVL(v_sal, 0) * NVL(v_comm,0) * 12;
        
        DBMS_OUTPUT.PUT(v_eid || ',' || v_sal || ',' || v_annual);
    END LOOP;
    CLOSE emp_info_cursor;
END;
/
