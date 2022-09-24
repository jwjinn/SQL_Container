-- EMP 데이터 입력--!

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'1980-12-17',800,null,20);

/*
 * INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'1980-12-17',800,null,20);

 INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,'17-DEC-1980',800,null,20);
 * 
 */
q

INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30);

INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,'1981-02-22',1250,200,30);

INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,'1981-04-02',2975,30,20);

INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,300,30);

INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,'1981-04-01',2850,null,30);

INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,'1981-06-01',2450,null,10);

INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,'1982-10-09',3000,null,20);

INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',null,'1981-11-17',5000,3500,10);

INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30);

INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,'1983-01-12',1100,null,20);

INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,'1981-10-03',950,null,30);

INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,'1981-10-3',3000,null,20);

INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,'1982-01-23',1300,null,10);


/*
 * 쿼리문을 여러개 동시에 실행시키기 위해서는 드래그 + ALT +X
 * 
 */

!----!

--Q1) 사원테이블 사원의 이름과 월급을 출력하자.
SELECT ENAME, SAL
FROM EMP;

--Q2) 사원테이블에서 전체 데이터를 출력하자.
SELECT *
FROM emp;

--Q3) 사원테이블에서 사원의 번호, 사원의 이름, 봉급을 출력해보자.
SELECT empno, ename, sal
FROM emp;

--Q4) 부서테이블에서 부서의 이름과 부서번호를 출력하자.
SELECT dname, deptno
FROM dept;

--Q5) 사원테이블에서 사원의 번호를 '사번'이라고 출력하고 사원의 이름을 '이름'이라고 출력하자.

SELECT empno AS "사번", ename AS "이름"
FROM emp;

--Q6) 테이블의 별칭을 주자 

--6-2) 사원테이블의 내용과 부서테이블의 내용중 사원의 이름과 부서번호를 출력해보자.

SELECT e.EMPNO, d.DEPTNO 
FROM DEPT d, EMP e

--Q7) 사원의 테이블에서 사원이이름과 봉급을 출력 하되 봉급은 연봉으로 출력하자.

SELECT SAL *12 AS "연봉"
FROM EMP e ;


--Q8) 사원의 테이블에서 사원이이름과 봉급을 출력 하되 "00의 봉급은  00이다"
-- || (연결문자열)

SELECT ENAME ||'의 봉급은 '||SAL||'이다.'
FROM EMP e;

--Q9) SELECT   컬럼리스트 FROM 테이블리스트 WHERE 조건문 
-- 사원테이블에서 사원의 이름이 JONES의 레코드를 전체 출력 해보자

SELECT *
FROM EMP e 
WHERE ENAME = 'JONES';

--Q10)부서테이블에서 부서번호가 10 또는  20인 내용만 출력 해보자.

SELECT *
FROM DEPT d 
WHERE DEPTNO =10 OR DEPTNO =20;

--Q11)사원테이블에서 사원의 이름, 사원의 봉급, 커미션, 봉금+커미션을  월급이라고 출력 해보자.  (4칙연산)

SELECT ENAME, SAL,COMM, sal+COMM AS "월급"
FROM EMP e;

--Q12) 사원테이블에서 사원의 이름, 사원의 봉급, 커미션, 봉금+커미션을  월급이라고 출력 해보자. nvl

SELECT ENAME, SAL, COMM, nvl(COMM,0) + SAL AS "월급" 
FROM EMP e;

--Q13) 사원테이블에서 사원의 이름, 커미션을 출력하되 커미션이 책정되지 않은 사원은 봉급으로 채워서 출력 하자.

SELECT ENAME, NVL(COMM,SAL)
FROM EMP e;

--Q14) 사원이름, 매니저를 출력하되 ABCD라는 값의 중간컬럼으로 추가하자.

SELECT ENAME, 'ABCD' ,MGR  
FROM EMP e 

--Q15) 사원이름(사원), 관리자(관리자)출력 해보자.  SCOTT(사원)

SELECT ENAME||'(사원) '|| MGR||('관리자')
FROM EMP e ;

--Q16) 중복 행 제거 job

SELECT DISTINCT JOB 
FROM EMP e;

--Q17) 부서별(DEPTNO) 담당하는 업무(JOB)를 한번씩만 조회한다.

SELECT DISTINCT JOB, DEPTNO  
FROM EMP e;

--Q18)의사열(PSEUDO COLUMNS)   : 테이블과 유사하게 QUERY가능한 열로서 변경은 할수 없다.

--ROWNUM :SELECT 문으로 검색하게 되면 로우수를 리턴한다. 
/*        검색된 행의 일련번호이다.
           ORDER BY정렬전에 부여된다.            
           
--ROWID  : 테이블내에 특정한 행을 구별할 수 있는 id 

*/

SELECT ROWNUM, ROWID, ENAME
FROM  SCOTT.EMP;

--Q19) WHERE 절 사용  :  담당업무(JOB)가  MANAGER인 사원 정보를 출력해보자.

SELECT *
FROM EMP e
WHERE JOB ='MANAGER';

--Q20)급여가 3000 이상인 사원의번호, 사원이름, 봉급을 출력 해보자.

SELECT EMPNO, ENAME, SAL 
FROM EMP e
WHERE SAL >=3000;

--Q21)급여가 1300  에서 1700사이의 해당하는 사원의 이름, 봉급을 출력하자.

SELECT ENAME, SAL 
FROM EMP e
WHERE SAL BETWEEN 1300 AND 1700;

--Q22)급여가 1300  에서 1700사이의 해당하는 사원이 아닌  이름, 봉급을 출력하자.

SELECT ENAME, SAL 
FROM EMP e
WHERE SAL NOT BETWEEN 1300 AND 1700;

--Q24)  IN (여러값 중에 일치하는 값)  : EXPR IN(3,4,5)

   /*
            여러목록 값중에 하나와 일치하는 값을 리턴
            IN   =ANY 연산자와 같다.
            NOT IN  !=ALL 와 같다. 
   */

  -- 사원번호가 7902, 7788, 7566  인 사원의 이름과 사원번호, 입사일(0000년 00월 00일 00일) 를 출력하자.

SELECT *
FROM EMP e
WHERE EMPNO IN (7902, 7788, 7566);

  -- 사원의 이름이 S로 시작하는 사원의 이름과  봉급을 출력하자. 특수분자는 %_

SELECT ENAME, SAL 
FROM EMP e
WHERE ENAME LIKE 'S%';

--Q26).  커미션이 측정되지 않은 사원을 출력해보자. 

SELECT *
FROM EMP e
WHERE COMM IS NULL;

  --Q27) EMP 테이블에서 급여가 2800 이상이고
  --JOB이 MANAGER인 사원의 사원번호, 성명, 담당업무, 급여, 입사일자, 부서번호를 출력하자.

SELECT EMPNO, ENAME, JOB, SAL, HIREDATE, DEPTNO
FROM EMP e 
WHERE JOB ='MANAGER' AND SAL >=2800;

  --Q28)EMP 테이블에서 급여가 2800 이상이거나
  --JOB이 MANAGER인 사원의 사원번호, 성명, 담당업무, 급여, 입사일자, 부서번호를 출력한다.

SELECT EMPNO, ENAME, JOB, SAL, HIREDATE, DEPTNO
FROM EMP e 
WHERE JOB ='MANAGER' OR SAL >=2800;

  --Q29)EMP 테이블에서 JOB이 'MANAGER', 'CLERK', 'ANALYST 가 아닌
   --사원의 사원번호, 성명, 담당업무, 급여, 부서번호를 출력하자


SELECT *
FROM EMP e 
WHERE JOB NOT IN ('MANAGER', 'CLERK', 'ANALYST');

--Q30) 데이터 정렬 :  입사일 순으로 정렬해서 사원번호, 급여, 입사일자, 부서번호를 출력 해보자. 

SELECT EMPNO, SAL, HIREDATE, DEPTNO 
FROM EMP e
ORDER BY HIREDATE DESC ;

  --Q31) 함수 : 문자함수, 숫자함수, 날짜함수, 변환함수, 기타함수(윈도우함수, 분석함수)등을 말한다.

SELECT NLS_INITCAP('ijsland') "InitCap" 
FROM dual;




  -- Q32)사원테이블에서 scott의 사원 번호, 이름, 담당업무(소문자)를 출력해보자.

SELECT EMPNO, ENAME, LOWER(JOB) 
FROM EMP e
WHERE ENAME ='SCOTT';

   -- Q33) 사원의 이름과 사원번호를 하나의 컬럼에 작성하자. 단 ||하지 말자. 

SELECT CONCAT(ENAME, EMPNO) 
FROM EMP e;


  /*
- LOWER(char) ? 문자열을 소문자로
- UPPER(char) ? 문자열을 대문자로
- INITCAP(char) ? 주어진 문자열의 첫 번째 문자를 대문자로 나머지 문자는 소문자로 변환시켜 준다.
- CONCAT(char1, char2) ? CONCAT 함수는 Concatenation의 약자로 두 문자를 결합
- SUBSTR(s, m ,[n]) ? 부분 문자열 추출함 . m 번째 자리부터 길이가 n개인 문자열을 반환
    ? m이음수일 경우에는 뒤에서 M번째 문자부터 반대 방향으로 n개의 문자를 반환
- INSTR(s1, s2 , m, n) ? 문자열 검색, s1의 m번째부터 s2 문자열이 나타나는 n번째 위치 반환 ? 지정한 문자열이 발견되지 않으면 0 이 반환된다

- LENGTH(s) ? 문자열의 길이를 리턴 
-CHR(n) ? ASCII값이 n에 해당되는 문자를 리턴
- ASCII (s) ? 해당 문자의 ASCII값 리턴
- LPAD(s1,n,[s2]) ? 왼쪽에 문자열을 S2를 끼어 놓는 역할,
         n은 반환되는 문자열의 전체 길이를 나타내며, S1의 문자열이 n보다 클 경우 S1을 n개 문자열 만큼 반환.
-RPAD(s1,n,[s2])  ? LPAD와반대로 오른쪽에 문자열을 끼어 놓는 역할
-LTRIM (s ,c) , RTRIM (s,c) ? 문자열 왼쪽 c문자열 제거 , 문자열 오른쪽 c문자열 제거
- TRIM ? 특정 문자를 제거 한다.   제거핛 문자를 입력하지 않으면 기본적으로 공백이 제거 된다.  리턴 값의 데이터타입은 VARCHAR2 이다.
- REPLACE(s,p,r) ? s에서 from 문자열의 각 문자를 to문자열의 각 문자로 변환한다.
- TRANSLATE (s,from,to) ? s에서 from 문자열의 각 문자를 to문자열의 각 문자로 리턴

*/

-- substr: 문자열을 자르고 싶어. <- 잘라야 하는 부분을 숫자 인자로 받는다.
SELECT ENAME, SUBSTR(ENAME,1), SUBSTR(ENAME,2), SUBSTR(ENAME,3), SUBSTR(ENAME, 2, 4), SUBSTR(ENAME, 2, 3)  
FROM EMP e;

--substr에 하나만 값이 들어간다면, 잘라야 하는 위치를 입력한다. < 포함되지 않는다.
--substr에 값이 두개가 들어간다면, 첫번째 인자 위치를 기준으로 길이가 두번째 인자만큼을 리턴한다.

--INSTR: 위치를 찾고 싶어 첫번째 인자는 시작위치, 두번째 인자는 n번째 위치를 리턴.

SELECT ENAME, INSTR(ENAME, 'S') --'S'의 위치를 리턴한다. 
FROM EMP e;

SELECT ENAME, INSTR(ENAME, 'L') -- 값이 n개면 처음만 리턴한다.
FROM EMP e;

SELECT ENAME, INSTR(ENAME, 'S', 2)
FROM EMP e;

SELECT ENAME, INSTR(ENAME, 'L', 2,1)
FROM EMP e;


SELECT LENGTH ('SDFSDFS')
FROM DUAL;

SELECT ASCII('A')
FROM DUAL;

SELECT CHR(65)
FROM DUAL;


--LPAD: LEFT에 붙인다. 첫번째 인자는 붙여서 나오는 결과적인 크기를 명시한다.

SELECT EMPNO
     , ENAME
     , DEPTNO
     , LPAD(DEPTNO, 5)      --1
     , LPAD(DEPTNO, 5, ' ') --2
     , LPAD(DEPTNO, 5, '0') --3
     , LPAD(DEPTNO, 5, 'A') --4
  FROM EMP;

 SELECT EMPNO
     , ENAME
     , DEPTNO
     , RPAD(DEPTNO, 5)      --1
     , RPAD(DEPTNO, 5, ' ') --2
     , RPAD(DEPTNO, 5, '0') --3
     , RPAD(DEPTNO, 5, 'A') --4
  FROM EMP;
 
 --좌측, 우측부터 해당 조건에 있는 문자들을 제거한다. 조건에 없는 문자를 만나기 전까지.
 -- 첫번째로 찾은 대상만 가능. -> 다 조건에 들어가게 할려면 replace or translate
 
 --Trim: 다듬다. 손질하다.
 
 SELECT ENAME ,LTRIM(ENAME, 'A')
 FROM EMP e;

--모든 S를 k로
SELECT ENAME, replace(ENAME, 'S', 'K') 
FROM EMP e; 

--translate
SELECT TRANSLATE('hello world!!!', 'hw', 'HW')
  FROM dual
  
  -- Q34)DEPT 테이블에서 컬럼의 첫 글자들만 대문자로 변화하여 모든 정보를 출력하여라.
  
  SELECT DEPTNO, INITCAP(DNAME), LOC  
  FROM DEPT d; 
  
  -- Q35)EMP 테이블에서 이름의 첫글자가 'K'보고 크고 'Y'보다 작은 사원의 사원번호, 이름, 업무, 급여, 부서번호를 조회한다.
        --단, 이름순으로 정렬하여라.
 
 SELECT *
 FROM EMP e
 WHERE SUBSTR(ENAME,1,1) >'K'; 

       
SELECT *
FROM EMP e 
WHERE SUBSTR(ENAME,1,1) BETWEEN 'K' AND 'Y';

  -- Q36)EMP 테이블에서 부서가 20번인 사원의 사원번호, 이름, 이름의 자릿수, 급여, 급여의 자릿수를 조회한다.LENGTH사용

SELECT EMPNO, ENAME, LENGTH(ENAME), SAL, LENGTH(SAL)
FROM EMP e
WHERE DEPTNO =20;

   -- Q37)EMP 테이블에서 이름 중 'L'자의 위치를 조회한다.
  --                  EX) ALLEN   2   2   3   0

SELECT ENAME, INSTR(ENAME, 'L', 1, 1) 
FROM emp;


  --- Q38) EMP 테이블에서 10번 부서의 사원에 대하여 담당 업무 중 좌측에 'A'를 삭제하고 급여 중 좌측의 1을 삭제하여 출력하여라.

SELECT JOB, SAL, LTRIM(JOB, 'A'), LTRIM(SAL, 1) 
FROM EMP e 
WHERE DEPTNO =10;

  --- Q39) REPACE함수를 사용하여 사원이름에 SC문자열을 *?로 변경해서 조회.

SELECT ENAME, REPLACE(ENAME, 'SC', '*?')
FROM EMP e; 

   --Q40)TRANSLATE함수를 사용하여 사원이름에 SC문자열을 *?로 변경해서 조회한다.

SELECT ENAME, TRANSLATE(ENAME, )
FROM EMP e

--Q41). 사원 테이블에서 입사일로 집계함수를 출력 해보자.

SELECT min(HIREDATE), MAX(HIREDATE), MEDIAN(HIREDATE), COUNT(HIREDATE), COUNT(*)  
FROM EMP

---Q43) 직업별 인원수를 출력 해보자.

--group by는 ~별로. 니까 해당 대상을 제외하고는 select에 aggregate function만 있어야 한다.

SELECT JOB , COUNT(*) 
FROM EMP e
GROUP BY JOB;

--Q44) 사원테이블에서 부서별로 봉급으로, 가장 큰 값, 작은값, 중간값, 평균, 합계를 구해보자.

SELECT DEPTNO, MAX(SAL), MIN(SAL), MEDIAN(SAL), AVG(SAL), SUM(SAL)  
FROM EMP e
GROUP BY DEPTNO;

--Q45) 각 부서별로 봉급으로, 가장 큰 값, 작은 값, 중간값, 평균, 합계를 구해보자.
-- 단 급여의 합이 많은 순으로 정렬을 하자.

SELECT DEPTNO, MAX(SAL), MIN(SAL), MEDIAN(SAL), AVG(SAL), SUM(SAL)  
FROM EMP e
GROUP BY DEPTNO
ORDER BY SUM(SAL); 

--Q46) 직업, 부서별 월급의 합을 출력 해보자.

SELECT SUM(SAL) 
FROM EMP e
GROUP BY (JOB, DEPTNO);

--Q47) 사원 테이블에서 부서인원이 4명보다 많은 부서의 부서번호, 인원수, 급여의 합을 출력 해보자.

SELECT DEPTNO, count(*), sum(sal)
FROM emp
GROUP BY deptno
HAVING count(*) >4;

--Q48) 사원테이블에서 급여가 최대 2500 이상인 부서에 대해서 부서번호, 평균, 급여합계를 구하자.

SELECT  DEPTNO, AVG(SAL), SUM(SAL)  
FROM EMP e 
GROUP BY DEPTNO
HAVING MAX(SAL) > 2500 ;

--Q49)  업무별 급여의 평균이 3000 이상이 업무에 대해서 평균급여, 급여의 합계를 구하자.

SELECT JOB , AVG(SAL), SUM(SAL)  
FROM EMP e
GROUP BY JOB  
HAVING AVG(SAL) > 3000;

--Q50 부서별 평균 급여 중 최대값을 조회해보자

SELECT ROUND(MAX(AVG(SAL))) 
FROM EMP e
GROUP BY DEPTNO;