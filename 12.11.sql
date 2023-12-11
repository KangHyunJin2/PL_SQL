SET  SERVEROUTPUT ON;

-- ORDER BY�� ������������ ���̾�����, ���� PL SQL ���� �� �����ϰ� �� �ʿ䰡 ����
-- more ehan requested number, no data found ������  > �� �Ƿ����� where ���� �����ϴ¼� �ۿ�����
DECLARE
    v_eid NUMBER;
    v_ename employees.first_name%TYPE;
    v_job VARCHAR2(1000);
BEGIN
    SELECT employee_id, first_name, job_id
    INTO v_eid, v_ename, v_job
    FROM employees
    WHERE employee_id = 100;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('���� :' || v_job);
END;
/

--ġȯ���� ��ü�ȴٴ� �� (�̰� ���� ������)
-- ġȯ������ DECALRE �� �갡 ������ �Ҷ� ������ �Ѵ�
-- ġȯ���� �Ҷ� ���ڸ� �Է��ϰԵǸ� �ν� ���� ġȯ������ ������ ������ ���� ������ ��ȯ�� �Ͼ�� �ʴ´� ���ڸ� �Է��� ��쿡�� Ȧ����ǥ�� ���̴��� �ۿ��� Ȧ����ǥ�� ���̴���
DECLARE
    v_eid employees.employee_id%TYPE := &�����ȣ;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT  first_name || ', ' || last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
END;
/

-- Ư�� ����� �Ŵ����� �ش��ϴ� �����ȣ�� ��� : (Ư�� ����� ġȯ������ ����ؼ� �Է�)
SELECT manager_id, first_name , last_name, manager_id
from employees
where employee_id = 102;

DECLARE
    v_eid employees.employee_id%TYPE := &�����ȣ;
    v_mgr employees.manager_id%TYPE;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT  manager_id, first_name || ', ' || last_name
    INTO v_mgr, v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('�Ŵ��� :' || v_mgr);
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
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
    WHERE employee_id = &�����ȣ;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);

    DBMS_OUTPUT.PUT_LINE( '��� ��� :' || SQL%ROWCOUNT );
    -- �ʿ信 ���� ���� ��� NVL ó���� ����� �Ѵ�
    UPDATE employees
    SET salary = (NVL(salary,0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    DBMS_OUTPUT.PUT_LINE( '���� ��� :' || SQL%ROWCOUNT );
END;
/

rollback;
select *
from employees

where department_id = 100;

DELETE FROM employees where employee_id = 1000;

SELECT * FROM employees WHERE employee_id = 1000;

--ROWCOUNT ���� ��� ��� �������� �ʾ����� ���� DELETE �� UPDATE ������ �߸��Ǿ� �˷��ٶ� ���� ���
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('�ش� ������� �������� �ʽ��ϴ�');
    END IF;
END;
/

/*
    1. �����ȣ�� �Է��� ���
    �����ȣ, ����̸�, �μ��̸���
    ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
    �����ȣ�� ġȯ������ ���� �Է¹޽��ϴ�.
    
    �Է� : �����ȣ                              > table : employees
    ��� : �����ȣ, ����̸� ,�μ��̸�      > table : employeee + departments
                                                    > ���� : department_id
*/

-- ���� �Ѱ�
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_dname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_name
    INTO v_eid, v_ename, v_dname
    FROM employees e 
    join departments d on (e.department_id = d.department_id)
    WHERE e.employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�μ��̸� :' || v_dname);
END;
/

-- 2��°���
DECLARE
    v_empid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
 --   v_dept_id employees.department_id%TYPE; -- select�� 2������..
    v_deptname departments.department_name%TYPE;

BEGIN
    SELECT employee_id , first_name, department_id
    INTO v_empid, v_ename, v_deptid
    FROM employees
    WHERE employees_id = &�����ȣ;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || v_empid);
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�μ��̸� :' || v_deptname);
END;
/

/*
    2. �����ȣ�� �Է��� ���
    ����̸�, �޿�, ������
    ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
    �����ȣ�� ġȯ������ ����ϰ�
    ������ �Ʒ��� ������ ������� �����Ͻÿ�.
    (�޿� * 12 + ( NVL(�޿�,0) * NVL(Ŀ�̼�, 0) * 12))
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
    WHERE employee_id = &�����ȣ;
    
    -- v_annual := v_sal * 12 + NVL(v_sal,0) * NVL(v_comm,0) * 12; -- �̰͵� �ϳ��� ��� SELECT ������ ���� ó���� �ʿ�� ����
    
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� :' || v_sal);
    DBMS_OUTPUT.PUT_LINE('���� :' || v_comm);
END;
/

-- �⺻ IF ��
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN -- TRUE�� ���� FALSE �϶��� �����ٰ����
        DBMS_OUTPUT.PUT_LINE('���������� ���ص��� �ʾҽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�..');
    END IF;
END;
/

-- IF ~ ELSE �� : �����
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id) -- �����Ͱ� ���� ��쵵 üũ �ؾ��ؼ� COUNT �� �����Ͱ� ������ NODATA FOUND ��
    INTO v_count
    FROM employees
    WHERE manager_id = &eid;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ϲ� ����Դϴ�');
    ELSE  -- �ڱ� �ڽ��� ���ǽ��� ���� 
        DBMS_OUTPUT.PUT_LINE('�����Դϴ�');
    END IF;
END;
/

-- IF ~ ELSIF ~ ELSE �� : ����
DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_hdate < 5 THEN -- �Ի����� 5�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 5�� �̸��Դϴ�.');
    ELSIF v_hdate < 10 THEN -- �Ի� 5���̻� 10�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 10�� �̸��Դϴ�.');
    ELSIF v_hdate < 15 THEN -- �Ի� 10�� �̻� 15�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 15�� �̸��Դϴ�.');
    ELSIF v_hdate < 20 THEN -- �Ի� 15���̻� 20�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 20�� �̸��Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�Ի����� 20�� �̻��Դϴ�..');
    END IF;
END;
/

SELECT employee_id, 
        TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12),
        TRUNC((sysdate-hire_date)/365) -- sysdate�� ū ������ �տ� �־��� 
FROM employees
ORDER BY 2 desc;

/*
    �����ȣ�� �Է�(ġȯ�������&)�� ���
    �Ի����� 2005�� ���� (2005�� ����)�̸� 'New employee' ���
    2005�� �����̸� 'Career employee' ���
// �Լ��� ���� ���� ����
    
    �Է� : �����ȣ
    ��� : �Ի���
    
    ���ǹ� : IF -> �Ի��� >= 2005�� 'New employee' ���
                        �ƴϸ�  'Career employee' ���
                        
*/

-- rr yy 4�ڸ��� ���Ÿ�yyyy ����  rr ������ ���ڸ���  rr yy ����������Ѵ� 
--  1) ��¥ �״�� ��



SELECT employee_id , hire_date
FROM employees
WHERE employee_id = 101;

DECLARE
    v_hdate DATE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
   IF v_hdate >= TO_DATE('2005-01-01', 'yyyy-MM-dd') THEN
            DBMS_OUTPUT.PUT_LINE('New employee �Ի�⵵ :' || v_hdate);
   ELSE
            DBMS_OUTPUT.PUT_LINE('Career employee �Ի�⵵ :' || v_hdate);
   END IF;
    
END;
/

-- 2) �⵵�� ��
SELECT TO_CHAR(hire_date, 'yyyy') -- TO_CHAR
FROM employees;

DECLARE
    v_year CHAR(4 char);
BEGIN
        SELECT TO_CHAR(hire_date, 'yyyy') -- TO_CHAR
        INTO v_year
        FROM employees
        WHERE employee_id = &�����ȣ;
        
        IF v_year >= '2005' THEN
               DBMS_OUTPUT.PUT_LINE('New employee �Ի�⵵ :' || v_year);
        ELSE
               DBMS_OUTPUT.PUT_LINE('Career employee �Ի�⵵ :' || v_year);
        END IF;
END;
/
    
/*
    �����ȣ�� �Է�(ġȯ�������&)�� ���
    �Ի����� 2005�� ���� (2005�� ����)�̸� 'New employee' ���
    2005�� �����̸� 'Career employee' ���
    
    ��, DBMS_OUTPUT.PUT_LINE() �� �ڵ� �� �ѹ��� �ۼ�
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
        WHERE employee_id = &�����ȣ;
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
4. �޿��� 5000�����̸� 20% �λ�� �޿�
    �޿��� 10000�����̸� 15% �λ�� �޿�
    �޿��� 15000�����̸� 10% �λ�� �޿�
    �޿��� 15001�̻��̸� �޿� �λ����
    
�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�

    �Է�: �����ȣ
    ��� : ����̸� ,�޿�
    
    ���ǹ� IF�� �� ��� => �λ�� �޿�
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
    WHERE employee_id = &�����ȣ;
    
    IF v_sal <= 5000 THEN
        DBMS_OUTPUT.PUT_LINE(v_sal + (v_sal * (20 / 100)));
    ELSIF v_sal <= 10000 THEN
        DBMS_OUTPUT.PUT_LINE(v_sal + (v_sal * (15 / 100)));
    ELSIF v_sal <= 15000 THEN
        DBMS_OUTPUT.PUT_LINE(v_sal + (v_sal * (10 / 100)));
    ELSIF v_sal >= 15001 THEN
        DBMS_OUTPUT.PUT_LINE('�޿� �λ����');
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
    WHERE employee_id = &�����ȣ;
    
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('����̸� :' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� :' || v_sal);
    DBMS_OUTPUT.PUT_LINE('�λ�ȱ޿� :' || (v_sal * (1 + v_raise/100)));
END;
/


-- 1���� 10���� �������� ���� ����� ���
-- �⺻ LOOP

DECLARE
    v_num NUMBER(2,0) :=1; -- 1~ 10
    v_sum NUMBER(2,0) :=0;     -- ���
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        v_num := v_num +1; -- < ��� ��ȯ�Ǿ�� �Ѵ� �׷��� ���ѷ����� ������ �ʴ´�
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- WHILE LOOP
DECLARE
    v_num NUMBER(2,0) :=1; -- 1~ 10
    v_sum NUMBER(2,0) :=0;     -- ���
BEGIN
    WHILE v_num <= 10 LOOP   -- �ݴ������ ī��Ű���ִ�.
        v_sum := v_sum + v_num;
        
        v_num := v_num +1;  -- �ᱹ �갡 �ʿ���
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/



-- FOR LOOP
DECLARE
    v_sum NUMBER(2,0) := 0;
    v_n NUMBER(8,0) := 99;
BEGIN
--  ���ο��� ����Ǵ� ������ �����, ���е� ���·� ���°� ����
    -- FOR v_n IN REVERSE 1..10 LOOP -- �ݵ�� �������� �ϰ������ REBERSE
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
-- 1) FOR LOOP�� �ӽú��� -> DECLARE ���� ���ǵ� �����̸��� ������ �ȵ�
-- 2) FOR LOOP�� �⺻������ �������� ����, ���� �������� ������������ ���� �޾ƿ����� �Ѵٸ� REVERSE �߰�

DECLARE
    v_n NUMBER(8,0) := 99;
BEGIN
--  ���ο��� ����Ǵ� ������ �����, ���е� ���·� ���°� ����
    -- FOR v_n IN REVERSE 1..10 LOOP -- �ݵ�� �������� �ϰ������ REBERSE
    FOR v_n IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_n);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_n);
END;
/

/*
1. ������ ���� ��µǵ��� �Ͻÿ�.
*               -- ó��° ��, * �� �ϳ�
**              -- �ι�° ��, * �� �ΰ�
***             -- ����° ��, * �� ����
****            -- �ݹ�° ��, * �� �װ�
*****           -- �ټ���° ��, * �� �ټ���
*/

-- �⺻ LOOP  
DECLARE
    v_str VARCHAR2(100) := '*';
    v_idx NUMBER := 0;
BEGIN
    LOOP
     EXIT WHEN v_idx > 4;
     DBMS_OUTPUT.PUT_LINE(v_str);
        v_str :=v_str || '*';
        v_idx := v_idx +1; -- < ��� ��ȯ�Ǿ�� �Ѵ� �׷��� ���ѷ����� ������ �ʴ´�    
    END LOOP;
END;
/

-- �⺻ LOOP 2��° ���
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


-- WHILE LOOP��
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


--WHILE LOOP 2��° ���
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

-- WHILE LOOP ������ �ذ��ϱ�

DECLARE
    v_tree VARCHAR2(6 char) := '*';
BEGIN
       WHILE LENGTH (v_tree) <= 5 LOOP
       DBMS_OUTPUT.PUT_LINE(v_tree);
            v_tree := v_tree || '*';
            
        END LOOP;
END;
/

-- �� �⺻ LOOP ��
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


-- 2��° ��� num �� ���������� ���� ���ο��� ���� ������ ������ �ȴ�
-- num �Ҵ翬���ڷ� �ؼ� ���� �����Ҽ� ����
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

-- ���� �ݺ��� ��
BEGIN
    FOR line IN 1..5 LOOP -- ���� , ��
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

