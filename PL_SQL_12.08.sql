-- ��� DB MS �� ���μ����� �Ͻ������� ���� DM MS ��� ���п��� ����� ON �ϰڴ� ������ PL SQL�� ���� ���ν������ִµ� �װ� ���������� ���ư����� �� ������ ON�� �Ǿ��־����
-- OFF ���ϸ� �������� �ٵ� �����͸� ������ ����
SET SERVEROUTPUT ON;


BEGIN
    DBMS_OUTPUT.PUT_LINE('HI');
END;
/

-- DECLARE �� �����̶� ������ ����
-- CONSTANT �� ����� ���� �ٲ�������
--�� ������ ������ �Ǹ� �ҷ��� �ü� ����
--v_literal := 1234; ��� ���� �ٲٷ��� ������ �������°� ����
-- DECLARE ������ �ݵ�� (��) �� �ʿ��ϴ� ���ܴ� DATE 
DECLARE
    v_today DATE;
    v_literal CONSTANT NUMBER(39) := 10;
    v_count NUMBER(3,0) := v_literal + 100;
    v_msg VARCHAR2(100 CHAR) NOT NULL := '�ȳ�, PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_count');
END;
/ -- ������ ���� ����


BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(systate, 'yyyy"��"MM"��"dd"��"'));
    -- �̷��� �ܵ����� ���� �Լ�, �׷��Լ��� �ǹ̰� ���� �׷��Լ��� �̷��� �������ٴ� ����
    COUNT(1);
END;
/



BEGIN
    INSERT INTO employee (empid, empname)
    values(1000,'Hong');
END;
/
-- ���� ����� �ٰ� Ʈ�������� ����Ǵ� ���� �ƴϴ� Ʈ�������� �����ϰ� ����


DECLARE
    v_sal NUMBER := 1000;
    v_comm NUMBER := v_sal * 0;
    v_msg VARCHAR2(1000) := '�ʱ�ȭ||';
BEGIN
      INSERT INTO employee (empid, empname)
      values(1000,'Hong');
      COMMIT;
      DECLARE
        v_sal NUMBER := 9999;
        v_comm NUMBER := v_sal * 0.2;
        v_annual NUMBER;
    BEGIN
      INSERT INTO employee (empid, empname)
      values(1000,'Hong');
      COMMIT;
        BEGIN
        v_annual := (v_sal + v_comm) * 12;
        v_msg := v_msg || '���� ��� ||';
        DBMS_OUTPUT.PUT_LINE('���� :' || v_annual);
        END;
  --      v_annual := v_annual + 1000; <-- �갡 ���� �߻���Ű�� ���� ������ �������� �������� �������� �����ϱ�
        v_msg := v_msg || '�ٱ� ���';
        DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
