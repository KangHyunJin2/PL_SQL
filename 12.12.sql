SET SERVEROUTPUT ON;
/*
2. ġȯ���� (&)�� ����ϸ� ���ڸ� �Է��ϸ� �ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½�
    2 * 1 = 2
    2 * 2 = 4
        :
        :
    2 * 9 = 18
    
    �Է� : ��
    ��� : Ư�� ���� (�� * ���ϴ� �� = ���)
    
    => ���ϴ� �� : 1 ���� 9 ������ ������
*/

-- �⺻ LOOP 
DECLARE
    -- �� : ����Ÿ, ġȯ������ �Է�
    a1 NUMBER := &��;
    a2 NUMBER := 1;
BEGIN
    -- �ݺ��� ����
    LOOP
        -- ��� : �� * ���ϴ� �� = (�� * ���ϴ� ��)
        DBMS_OUTPUT.PUT_LINE(a1 || ' * ' || a2 || ' = ' || (a1 * a2));
        -- �̶� ���ϴ� ���� 1���� 9���� 1�� ���� => �ݺ������� ����
        a2 := a2 +1;
        EXIT WHEN a2 > 9; -- ��ȯ�Ǵ� ���ڸ� ����� �Ѵ�
    -- �ݺ��� ����
    END LOOP;
END;
/


-- �⺻ LOOP
DECLARE
    v_dan NUMBER := &��;
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
    v_dan NUMBER(1,0) := &��;
BEGIN
    FOR v_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
    END LOOP;
END;
/


-- WHILE LOOP
DECLARE
    v_dan NUMBER := &��;
    v_num NUMBER := 1;
BEGIN
    WHILE v_num <= 9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num || ' = ' || v_dan * v_num);
        v_num := v_num + 1;
    END LOOP;
END;
/

/*
3. ������ 2~9���� ��µǵ��� �Ͻÿ�.

4. ������ 1~9 ���� ��µǵ��� �Ͻÿ�
    (��, Ȧ���� ���)
    
    MOD(������ �մ� ���� , ������ ��) => ������
*/

-- �ϳ� ���־��µ� 
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

-- CONTINUE; ��Ƽ��
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
    WHILE v_num < 10 LOOP -- Ư�� ���� 1~9 ���� ���ϴ� LOOP ��
        v_dan := 2;
        WHILE v_dan < 10 LOOP -- Ư�� ���� 2~9 ���� �ݺ��ϴ� LOOP ��
            DBMS_OUTPUT.PUT(v_dan || ' X ' || v_num ||  ' = ' || (v_dan * v_num) || ' ');
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num + 1;
    END LOOP;
END;
/

-- WHILE LOOP ��
DECLARE
    v_dan NUMBER(2,0) :=2;
    v_num NUMBER(2,0) :=1;
    v_msg VARCHAR2(1000);
BEGIN
    WHILE v_num < 10 LOOP -- Ư�� ���� 1~9 ���� ���ϴ� LOOP ��
        v_dan := 2;
        WHILE v_dan < 10 LOOP -- Ư�� ���� 2~9 ���� �ݺ��ϴ� LOOP ��
            v_msg := v_dan || ' X ' || v_num ||  ' = ' || (v_dan * v_num) || ' ';
            DBMS_OUTPUT.PUT(RPAD(v_msg, 12 , ' '));
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(' ');
        v_num := v_num + 1;
    END LOOP;
END;
/

--3�� ���� �ݺ��� �⺻ LOOP
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

-- 3�� ���� �ݺ��� FOR LOOP
DECLARE
BEGIN
    FOR dan IN 2..9 LOOP
        FOR num IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num || ' = ' || (dan * num));
        END LOOP;
    END LOOP;
END;
/

-- 4�� Ȧ���ܸ� ������
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

-- 4�� Ȧ���ܸ� ���
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


-- RECORD Ÿ��
DECLARE
    -- �̸��� type�� �����ָ� ����
    -- ���� �ٲ�� �ٽ�
    TYPE info_rec_type IS RECORD -- �̸��� ���ڵ� Ÿ���̶��� �˰� �����ش�
        ( no NUMBER NOT NULL := 1,
          name VARCHAR2(1000) := 'NO NAME',
          birth DATE );
    -- ���� ����
    user_info info_rec_type;
BEGIN
        -- ���� �� ������ ������ ����  ����ϰ��� �ϸ� ���ο� ��ʵ带 ����ϰ��� �ϴ��� �˷������
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
        WHERE employee_id = &�����ȣ;
        
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.employee_id);
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.first_name);
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.job_id);
        DBMS_OUTPUT.PUT_LINE(emp_info_rec.hire_date);
END;
/

-- �����ȣ, �̸� , �μ��̸�
-- RECORD�� ���� �ϳ��� ��´�
DECLARE
        TYPE emp_rec_type IS RECORD                               -- ��¥ ������ Ÿ��
            ( eid employees.employee_id%TYPE,                     -- NUMBER
              ename employees.last_name%TYPE,                    -- VARCHAR2
              deptname departments.department_name%TYPE);  -- VARCHAR2
              
        emp_rec emp_rec_type;    
BEGIN
        -- ��� * �� ����Ҽ� ���� :
        SELECT employee_id , last_name, department_name
        INTO emp_rec
        FROM employees e JOIN departments d ON (e.department_id = d.department_id)  --
        WHERE employee_id = &�����ȣ;
        
        DBMS_OUTPUT.PUT_LINE('�̸� :' || emp_rec.ename);
END;
/

-- TABLE
DECLARE
        -- 1) ����
        TYPE num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        -- 2) ����
        num_list num_table_type;
BEGIN
        -- array[0] => PL/SQL ������ �̰� table(0)
        num_list (-1000) := 1;
        num_list (1234) := 2;
        num_list(11111) := 3;
        
        DBMS_OUTPUT.PUT_LINE(num_list.count);
        DBMS_OUTPUT.PUT_LINE(num_list(1234));
END;
/

DECLARE
        -- 1) ����
        TYPE num_table_type IS TABLE OF NUMBER
            INDEX BY BINARY_INTEGER;
        -- 2) ����
        num_list num_table_type;
BEGIN
        FOR i IN 1..9 LOOP
            num_list(i) := 2 * 1;
        END LOOP;
        
        FOR idx IN num_list.FIRST .. num_list.LAST LOOP
            IF num_list.EXISTS(idx) THEN -- �� �޼���� ������ true �̴�
                DBMS_OUTPUT.PUT_LINE(num_list(idx));
            END IF;
        END LOOP;
END;
/

-- ��� ���ϴ��� ã�Ƽ� ����
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
-- ������ ����
DECLARE
    v_min employees.employee_id%TYPE; -- �ּ� �����ȣ
    v_MAX employees.employee_id%TYPE; -- �ִ� �����ȣ
    v_result NUMBER(1,0);             -- ����� ���������� Ȯ��
    emp_record employees%ROWTYPE;     -- Employees ���̺��� �� �࿡ ����
    
    TYPE emp_table_type IS TABLE OF emp_record%TYPE
        INDEX BY PLS_INTEGER;
    
    emp_table emp_table_type;
BEGIN
    -- �ּ� �����ȣ, �ִ� �����ȣ
    SELECT MIN(employee_id), MAX(employee_id)
    INTO v_min, v_max
    FROM employees;
    
    FOR eid IN v_min .. v_max LOOP
        SELECT COUNT(*)         -- ���� ���� üũ
        INTO v_result
        FROM employees
        WHERE employee_id = eid;
        
        IF v_result = 0 THEN -- ����� ���ٴ� ��
            CONTINUE;
        END IF;
        
        SELECT *
        INTO emp_record
        FROM employees
        WHERE employee_id = eid;
        
        emp_table(eid) := emp_record;     
    END LOOP;
    
    FOR eid IN emp_table.FIRST .. emp_table.LAST LOOP
        IF emp_table.EXISTS(eid) THEN  -- �ݵ�� ������ �׻� ������� ���ٴ°� �����Ҽ� ���� ������ �̰� �����
            DBMS_OUTPUT.PUT(emp_table(eid).employee_id || ', ');
            DBMS_OUTPUT.PUT_LINE(emp_table(eid).last_name);
        END IF;
    END LOOP;    
END;
/

-- CURSOR
DECLARE
    -- CURSOR �ȿ����� ������ SELECT �� ���
    CURSOR emp_dept_cursor IS
        SELECT employee_id, last_name
        FROM employees
        WHERE department_id =&�μ���ȣ;
        
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    -- cursor OPEN
    -- select ���� ������ �ִ� ����� �޸𸮿� �ö󰣴�
    OPEN emp_dept_cursor;
    
    -- point�� ù��°�� �̵�
    -- ���� �츮���� �����Ͱ� �Ѿ� ���� ����
    FETCH emp_dept_cursor INTO v_eid , v_ename;
    DBMS_OUTPUT.PUT_LINE(v_eid);
    DBMS_OUTPUT.PUT_LINE(v_ename);
    
    -- close �� �� �Ŀ��� �������� ����
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
        WHERE department_id = &�μ���ȣ
        ORDER BY hire_date DESC;
        
    emp_rec emp_info_cursor%ROWTYPE;
BEGIN
    -- select �� ����� ������� ��� ���� ������ ��Ī������ص� �ȴ�
    OPEN emp_info_cursor;
     
    LOOP
        FETCH emp_info_cursor INTO emp_rec;
        -- LOOP ������ ROWCOUNT�� ���� �ǹ̰� ���Ѵ�
        EXIT WHEN emp_info_cursor%NOTFOUND OR emp_info_cursor%ROWCOUNT > 10; -- 10�� �̸��϶� ����ɼ� �ְ� 
        -- EXIT WHEN emp_info_cursor%ROWCOUNT > 10; -- ROWCOUNT Ŀ���� ���ؼ��� �ִ�ũ�⸦ �˼��ִ°� ��ǻ� ���� �����ϱ� ������
        DBMS_OUTPUT.PUT(emp_info_cursor%ROWCOUNT || ',');
        DBMS_OUTPUT.PUT(emp_rec.eid || ', ');
        DBMS_OUTPUT.PUT(emp_rec.ename || ', ');
        DBMS_OUTPUT.PUT_LINE(emp_rec.hdate);
    END LOOP;
    --Ŀ���� ���� �ѵ�����Ȯ�� ��� CLOSE �Ǳ����� �����ؾ��Ѵ�
    IF emp_info_cursor%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���� Ŀ���� �����ʹ� �������� �ʽ��ϴ�,');
    END IF;
    
    CLOSE emp_info_cursor;
END;
/

SELECT employee_id , last_name , hire_date
FROM employees
ORDER BY hire_date DESC;


--1) ��� ����� �����ȣ, �̸�, �μ��̸� ���

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
        DBMS_OUTPUT.PUT_LINE('���� Ŀ���� �����ʹ� �������� �ʽ��ϴ�,');
    END IF;
    
    CLOSE emp_info_cursor;
    
END;
/

SELECT employee_id eid, last_name ename, department_name deptname
FROM employees e JOIN departments d ON (e.department_id = d.department_id);
        
-- 2) �μ���ȣ�� 50�̰ų� 80�� ������� ����̸�, �޿�,���� ���
-- ���� : (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12)

SELECT last_name, salary, (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12)
FROM employees
WHERE department_id = 50;

DECLARE
    CURSOR emp_info_cursor IS
        SELECT last_name ename, salary sal, (salary * 12 + NVL(salary,0) * NVL(commission_pct,0) * 12) comm
        FROM employees
        WHERE department_id IN (50, 80); -- IN �����ڴ� ���� �߿��� �ϳ� ������������ ������ ��
    
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
        WHERE department_id IN (50, 80) -- IN �����ڴ� ���� �߿��� �ϳ� ������������ ������ ��
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
