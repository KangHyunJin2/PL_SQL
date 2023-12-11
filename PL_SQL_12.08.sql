-- 얘는 DB MS 에 내부설정을 일시적으로 변경 DM MS 출력 ㅂ분에서 출력을 ON 하겠다 앞으로 PL SQL에 쓰는 프로시져가있는데 그게 정상적으로 돌아가려면 이 설정이 ON이 되어있어야함
-- OFF 로하면 실행은됨 근데 데이터를 보내지 않음
SET SERVEROUTPUT ON;


BEGIN
    DBMS_OUTPUT.PUT_LINE('HI');
END;
/

-- DECLARE 는 선언문이라 무조건 위에
-- CONSTANT 는 상수라 값이 바뀌지않음
--나 이전에 선언한 건만 불러서 올수 있음
--v_literal := 1234; 상수 값을 바꾸려고 했을때 오류나는거 연습
-- DECLARE 에서는 반드시 (값) 이 필요하다 예외는 DATE 
DECLARE
    v_today DATE;
    v_literal CONSTANT NUMBER(39) := 10;
    v_count NUMBER(3,0) := v_literal + 100;
    v_msg VARCHAR2(100 CHAR) NOT NULL := '안녕, PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE('v_count');
END;
/ -- 블럭별로 끊는 역할


BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(systate, 'yyyy"년"MM"월"dd"일"'));
    -- 이렇게 단독으로 들어가는 함수, 그런함수는 의미가 없다 그룹함수는 이렇게 쓸수없다는 예시
    COUNT(1);
END;
/



BEGIN
    INSERT INTO employee (empid, empname)
    values(1000,'Hong');
END;
/
-- 블럭이 종료된 다고 트랙젝션이 종료되는 것이 아니다 트렌젝션은 동작하고 있음


DECLARE
    v_sal NUMBER := 1000;
    v_comm NUMBER := v_sal * 0;
    v_msg VARCHAR2(1000) := '초기화||';
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
        v_msg := v_msg || '내부 블록 ||';
        DBMS_OUTPUT.PUT_LINE('연봉 :' || v_annual);
        END;
  --      v_annual := v_annual + 1000; <-- 얘가 에러 발생시키는 원인 이유는 전연변수 지역변수 느낌으로 이해하기
        v_msg := v_msg || '바깥 블록';
        DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
