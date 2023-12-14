SET SERVEROUTPUT ON;

/*
2.
�����ȣ�� �Է��� ���
�����ϴ� TEST_PRO ���ν����� �����Ͻÿ�.
��, �ش����� ���� ��� "�ش����� �����ϴ�." ���
��) EXECUTE TEST_PRO(176)

�Է� : �����ȣ => IN
���� : �Է¹��� �����ȣ ���� => DELETE -> employees

SELECT �� ����ó���� EXCEPTION�� ����Ѵ�

*/


CREATE PROCEDURE TEST_PRO
(p_eid IN employees.employee_id%TYPE)
IS
    e_no_emp EXCEPTION;
BEGIN
    DELETE FROM employees
    WHERE employee_id = p_eid; -- �Է¹��� ���̵� ������ �����ϸ�ȴ�
    
    
    IF SQL%ROWCOUNT = 0 THEN
        --DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');
        RAISE e_no_emp;
    END IF;
EXCEPTION
    WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('�ش����� �����ϴ�.');
END;
/

/*
3.
������ ���� PL/SQL ����� ������ ��� 
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) EXECUTE yedam_emp(176)
������) TAYLOR -> T*****  <- �̸� ũ�⸸ŭ ��ǥ(*) ���

�Է� : �����ȣ -> IN 
���� : 1) SELECT (����̸� �ʿ��ؼ�)
      2) �ش� �̸��� ���� ���� : SUBSTR, LENGTH(�����ʿ�), RPAD(�ƽ�Ÿ ����)
      3) ���
*/

CREATE PROCEDURE yadam_emp
(p_eid IN test_employee.employee_id%TYPE) -- �Ű�����
IS
    v_ename employees.last_name%TYPE;
    v_result v_ename%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename         -- v_ �� ���ξ�
    FROM employees
    WHERE employee_id = p_eid;
    
    v_result := RPAD(SUBSTR(v_ename,1,1), LENGTH(v_ename), '*');
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ' -> ' || v_result);
END;
/

/*4.
�������� ���, �޿� ����ġ�� �Է��ϸ� Employees���̺� ���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���. 
���� �Է��� ����� ���� ��쿡�� ��No search employee!!����� �޽����� ����ϼ���.(����ó��)
����) EXECUTE y_update(200, 10)

�Է� : �����ȣ,�޿� ����ġ(����)
���� : ����� �޿��� ���� = �޿� ����ġ(����), UPDATE��
      UPDATE employees
      SET salary = salary + (salary * (�޿�����ġ/ 100)) => �޿�����ġ�� �����϶�
      SET salary = salary + (salary * (�޿�����ġ) => �޿�����ġ�� �Ǽ��϶�
      WHERE �����ȣ = �����ȣ;
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
������ ���� ���̺��� �����Ͻÿ�.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
5-1.
�μ���ȣ�� �Է��ϸ� ����� �߿��� �Ի�⵵�� 2005�� ���� �Ի��� ����� yedam01 ���̺� �Է��ϰ�,
�Ի�⵵�� 2005��(����) ���� �Ի��� ����� yedam02 ���̺� �Է��ϴ� y_proc ���ν����� �����Ͻÿ�.


�Է� : �μ���ȣ
���� : �ش� ��� -> �ռ� ���� ���̺� INSERT �϶�� �� �ñ�������
        1) SELECT -> CURSOR -- �ϳ��� �����Ͱ����� �������� �����ü��ִ� Ŀ��
        2) IF�� , �Ի�⵵
            2-1) �Ի�⵵ < 2005�� ) yedam01 ���̺� INSERT
            2-2) �Ի�⵵ >= 2005�� ) yedam02 ���̺� INSERT
        TO_DATE�� ���� ������ ����Ѵ�

5-2.
1. ��, �μ���ȣ�� ���� ��� "�ش�μ��� �����ϴ�" ����ó�� (����� ���� ������ �ʿ���) �μ���ȣ�� ���ٴ°� Ŀ���� ��ȯ�� �� �������� ROWCOUNT �� ���ٴ� �ǵ�
2. ��, �ش��ϴ� �μ��� ����� ���� ��� "�ش�μ��� ����� �����ϴ�" ����ó��
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
    v_deptno departments.department_id%TYPE; -- ����� ���� 
    
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
        IF TO_CHAR(emp_rec.hire_date, 'yyyy') < '2005' THEN -- �⵵�� �������� ������ �̰ž���
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
        DBMS_OUTPUT.PUT_LINE('�ش�μ��� ����� �����ϴ�.');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('�ش�μ��� �������� �ʽ��ϴ�.');
END;
/

EXECUTE y_proc(80);
SELECT * FROM yedam01;
SELECT * FROM yedam02;

-- FUNCTION
CREATE  FUNCTION plus
(p_x IN NUMBER,
 p_y NUMBER)
RETURN NUMBER --�ݵ�� ��������� BEGIN �ʿ�
IS
    v_result NUMBER;
BEGIN
    v_result := p_x + p_y;
    RETURN v_result; --�ݵ�� ���������
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '�����Ͱ� �������� �ʽ��ϴ�';  -- RETURN �ݵ�� ������� �Ѵ� ��� �ѹ�Ÿ���̱⶧���� �� ������ ������� �ʴ´�. �̰� �����Ϸ��� Ÿ���� VARCHAR2 �ιٲ����
    WHEN TOO_MANY_ROWS THEN
        RETURN '�����Ͱ� �䱸�� �ͺ��� �����ϴ�.'; -- RETURN �ݵ�� ������� �Ѵ�
END;
/

-- 1) ��� ���ο��� ����
DECLARE
    v_sum NUMBER;
BEGIN
    v_sum := plus(10,20); -- v_sum�� ���� ���ν������� �ɸ���
    -- plus >> PL/SQL
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- 2) EXECUTE : �Լ��� ����Ҷ� DBMS_OUTPUT.PUT_LINE �̰� ����� �˼��ִ�.
EXECUTE DBMS_OUTPUT.PUT_LINE(plus(10,20));

-- 3) SQL�� : DML�� ���ο��� ������� �ʴ°� �����͸� SQL ���� ó���� �����ϸ� �̷��� ����
SELECT plus(10,20) FROM dual;

-- 1 ~ n ���� ������ ���� ��ȯ�ϴ� �Լ�
CREATE OR REPLACE FUNCTION y_factorial
(p_n NUMBER)
RETURN NUMBER -- RETURN Ÿ���� �����ϸ� ������ ����
IS
    v_sum NUMBER := 0;
BEGIN
    FOR idx IN 1..p_n LOOP
        v_sum := v_sum + idx;
    END LOOP;
    
    RETURN v_sum;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1; -- ���� ������ NUMBER Ÿ�԰� ���ƾ��Ѵ� �׷��� ���ڷ� ����
    WHEN TOO_MANY_ROWS THEN
        RETURN -2;
END;
/

EXECUTE  DBMS_OUTPUT.PUT_LINE(y_factorial(10));

/*
�����ȣ�� �Է��ϸ�
last_name + first_name �� ��µǴ�
y_yedam �Լ��� �����Ͻÿ�

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174))
��� ��) Abel Ellen

SELECT employee_id, y_yedam(employee_id)
FROM employees;

�Է� : �����ȣ
���� : �����ȣ => last_name , first_name / SELECT
��� : FULLNAME
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
    
    
    RETURN v_enamefirst || ' ' || v_enamelast; -- �ݵ�� ���������
END;
/
EXECUTE DBMS_OUTPUT.PUT_LINE(y_yedam(174));

SELECT employee_id, y_yedam(employee_id)
FROM employees;

/*
2.
�����ȣ�� �Է��� ��� ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�.
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �̻��̸� �޿� �״�� ���
����) SELECT last_name, salary, YDINC(employee_id)
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
�����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
->������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) SELECT last_name, salary, YD_FUNC(employee_id)
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
������ ���� ��µǴ� subname �Լ��� �ۼ��Ͻÿ�.
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
�μ���ȣ�� �Է��ϸ� �ش� �μ��� å���� �̸��� ����ϴ� y_dept �Լ��� �����Ͻÿ�.
(��, JOIN�� ���)
(��, ������ ���� ��� ����ó��(exception)
 �ش� �μ��� ���ų� �μ��� å���ڰ� ���� ��� �Ʒ��� �޼����� ���
    
    �ش� �μ��� ���� ��� -> �ش� �μ��� �������� �ʽ��ϴ�.
	�μ��� å���ڰ� ���� ��� -> �ش� �μ��� å���ڰ� �������� �ʽ��ϴ�.	)

����) EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(110))
���) Higgins
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
        RETURN '�ش� �μ��� �������� �ʽ��ϴ�.';
    WHEN e_no_emp THEN
        RETURN '�ش� �μ��� å���ڰ� �������� �ʽ��ϴ�.';
END;
/

EXECUTE DBMS_OUTPUT.PUT_LINE(y_dept(700));

SELECT department_id, y_dept(department_id)
FROM   departments;