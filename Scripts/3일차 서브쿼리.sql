

--Q1) jones 보다 많은 월급을 받은 사원의 이름과 봉급을 출력하자.

SELECT ENAME, SAL 
FROM EMP e
WHERE SAL > (
SELECT SAL 
FROM EMP e
WHERE ENAME ='JONES'
);

--Q2) 사원번호가 7839인 사원과 같은 직업을 가진 사원들의 이름과 직업을 출력하자

SELECT ENAME, JOB 
FROM EMP e
WHERE JOB = (
	SELECT JOB 
	FROM EMP e
	WHERE EMPNO = 7839
);


--Q3) 7566 사원보다 급여를 많이 받는 사람의 이름, 급여를 출력 해보자.
SELECT ENAME, SAL 
FROM EMP e
WHERE SAL > (
	SELECT SAL 
	FROM EMP e
	WHERE EMPNO = 7566
);

--Q4) 사원의 봉급의 평균보다 적은 사원의 사원번호, 이름, 직업, 부서번호를 출력하자.

SELECT ENAME, JOB, DEPTNO 
FROM EMP e
WHERE SAL < (
SELECT AVG(SAL) 
FROM EMP e 
);

--Q5) 사원번호가 7521인 사원과 직업이 같고 봉급이 7934인 사원보다 많은 사원의 이름, 직업, 입사일, 봉급을 출력하자.

SELECT ENAME, JOB, HIREDATE 
FROM EMP e
WHERE (JOB  = (
SELECT JOB  
FROM EMP e 
WHERE EMPNO =7521
)) AND SAL >(
SELECT SAL 
FROM EMP e 
WHERE EMPNO =7934
);

--Q6) 직업중에서 가장 적은 평균급여를 받는 직업을 출력하자/!!!!!!

SELECT job, AVG(sal)
FROM EMP e 
GROUP BY JOB 
HAVING AVG(sal) =( -- GROUP BY 결과에 조건을 건다 having
	SELECT  min(AVG(sal))
	FROM EMP e2
	GROUP BY job
);


SELECT JOB, AVG(SAL) 
FROM EMP e
GROUP BY JOB
HAVING AVG(SAL) = (
SELECT min(AVG(SAL))
FROM EMP e2
GROUP BY JOB 
) 

--Q7) 사원의 20번인 봉급 부서번호의 최소 봉급보다 많은 부서번호를 출력하자.

SELECT DEPTNO, MIN(SAL) 
FROM EMP e 
GROUP BY DEPTNO
HAVING MIN(SAL) > (SELECT MIN(SAL) FROM EMP e2 WHERE DEPTNO = 20); 


--Q8) 부서별 최소, 봉급과 같은 월급을 받는 사원의 부서번호와 이름을 출력하자.

SELECT ENAME, DEPTNO 
FROM EMP e
WHERE SAL = ANY (
SELECT MIN(SAL) 
FROM EMP e
GROUP BY DEPTNO 
);


/*
 * 다중 행 (Multiple-Row) 서브쿼리 – 하나 이상의 행을 리턴 하는 서브쿼리를 다중 행 서브쿼리라고 한다. –
 * 복수 행 연산자(IN, ANY, ALL)를 사용한다.
 * IN : 목록에 있는 임의의 값과 동일하면 참
 * ANY : 서브쿼리에서 리턴된 각각의 값과 비교하여 하나라도 참이면 참 ( =ANY는IN과 동일) - any는 하나라도 조건을 받아야한다.
 * 		EX) < ANY = 최대값보다 적음 , >ANY 최소값보다 큼 = (IN)
 * ALL : 서브쿼리에서 리턴된 모든 값과 비교하여 모두 참이어야 참
 * 		EX) < ALL = 최소값보다 적음 , >ALL 최대값 보다 큼 *NOT 연산자는 IN, ANY, ALL 연산자와 함께 사용될 수 있다. 
 * 
 * 
 */

--q9) 업무가 salesman인 사람보다 급여를 많이 받는 사원의 이름, 그병 직업을 출력

SELECT ENAME, SAL, JOB 
FROM EMP e 
WHERE SAL > ANY (
	SELECT SAL 
	FROM EMP e 
	WHERE JOB ='SALESMAN'
)

--Q10) FORD, BLAKE와 매니저 및 부서번호가 같은 사언의 정보를 출력 해보자.

SELECT *
FROM EMP e
WHERE (DEPTNO, MGR) = ANY (
	SELECT DEPTNO, MGR  
	FROM EMP e 
	WHERE (ENAME IN ('FORD', 'BLAKE'))
);


--Q11) 소속된 부서번호의 평균 봉급보다 많은 봉급을 받는 사원의 이름, 급여, 부서번호, 입사일, 직업을 출력해보자.
SELECT *
FROM EMP e
WHERE DEPTNO = 10;


SELECT AVG(SAL) 
FROM EMP e
WHERE DEPTNO = 10;

--평균 월급보다 많이 받는 사원은?
--Q11) 소속된 부서번호의 평균 봉급보다 많은 봉급을 받는 사원의 이름, 급여, 부서번호, 입사일, 직업을 출력해보자.

SELECT ENAME, SAL, DEPTNO, JOB 
FROM EMP e
WHERE SAL > (SELECT AVG(SAL)
FROM EMP e2
WHERE DEPTNO = e.DEPTNO);


--상호 연관 서브쿼리: 상의 질의 즉 주 쿼리에 있는 테이블의 열을 참조하는 것을 말한다.
--1) 메인 쿼리에의 하나의 row에서 서브쿼리가 한번씩 실행된다.
--2) 테이블에서 행을 먼저 읽어서 각 행의 값을 관련된 데이터와 비교 한다.
--3) 주 쿼리에서 각 서브쿼리의 행에 대해 다른 결과를 리턴할 때 사용한다.
--4) 각 행의 값에 따라 응답이 달라지는 다중 질의의 값을 리턴받을 때 사용한다.
--5) 서브쿼리에서 메인쿼리의 칼럼명을 사용할 수 있지만, 메인에서는 서브쿼리의 칼럼명을 사용할 수 없다.

--Q12) 인라인 뷰(inline ): from 절에 서브쿼리 11번을 바꿔보자.

SELECT E.ENAME, E.DEPTNO, E.JOB
FROM (SELECT ENAME, JOB, DEPTNO
		FROM EMP
		WHERE JOB ='MANAGER') E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;

--case1
SELECT ENAME, SAL, DEPTNO, JOB 
FROM EMP e
WHERE SAL > (SELECT AVG(SAL)
FROM EMP e2
WHERE DEPTNO = e.DEPTNO);

--case2
SELECT E.ENAME, E.SAL, E.DEPTNO, E.HIREDATE, D.AVGSAL
FROM EMP E, (SELECT DEPTNO , AVG(SAL) AVGSAL FROM EMP E GROUP BY DEPTNO) D 
WHERE E.DEPTNO = D.DEPTNO AND E.SAL > D.AVGSAL; 

--case3
SELECT E.ENAME, E.SAL, E.DEPTNO, E.HIREDATE, E.JOB, D.AVGSAL 
FROM EMP E, (SELECT DEPTNO , AVG(SAL) AVGSAL FROM EMP E GROUP BY DEPTNO) D 
WHERE E.DEPTNO = D.DEPTNO AND E.SAL > D.AVGSAL; 

SELECT E.ENAME, E.DEPTNO, E.JOB
 FROM (SELECT ENAME, JOB, DEPTNO 
        FROM EMP 
        WHERE  JOB ='MANAGER') E, DEPT D
 WHERE  E.DEPTNO  = D.DEPTNO ;



--스칼라(Scalar) 서브쿼리
-- 하나의 행에서 하나의 열 값만 리턴하는 서브 쿼리를 스칼라 서브쿼리라고 한다.
-- 스칼라 서브 쿼리의 값은 서브 쿼리의 select 목록에 있는 항목 값이다.
-- 서브쿼리가 0개의 행을 리턴하면, 스칼라 서브쿼리의 값은 null이다.
-- 서브쿼리가 2개 이상의 행을 리턴하면 오류가 리턴된다.
-- Select(Group by는 제외), INSERT의 values 목록, DECODE의 CASE조건문, UPDATE SET문


-- Q13) 사원번호, 이름, 부서번호, 사원이 속한 부서의 평균 급여를 출력하자.

SELECT	EMPNO, ENAME, DEPTNO, SAL,
ROUND((SELECT AVG(SAL)
FROM EMP
WHERE DEPTNO = e.DEPTNO))  AS M_SAL
FROM EMP e


--Q14) 사원번호, 이름, 부서번호, 사원이 속한 부서의 평균 급여를 출력하자.
	-- 부서번호별로 정렬하자.

SELECT EMPNO, ENAME, DEPTNO, SAL
FROM EMP E
ORDER BY (SELECT DNAME
			FROM DEPT
			WHERE DEPTNO = E.DEPTNO);


		
		
--Q15)EXISTS 연산자
-- 부하사원을 가지고 있는[EMPNO = MGR] 사원의 사원의 이름, 직업, 입사일, 봉급을 출력하자.

SELECT ENAME, JOB, HIREDATE, SAL
FROM EMP E
WHERE EXISTS ( SELECT 1
FROM EMP 
WHERE E.EMPNO  = MGR 
)
ORDER BY 1;









----------------------------서브 쿼리 문제
--1. 'SMITH'보다 월급을 많이 받는 사원들의 이름과 월급을 출력하라.

SELECT *
FROM EMP e
WHERE SAL > any(
SELECT SAL 
FROM EMP e
WHERE ENAME ='SMITH'
)

--2. 10번 부서의 사원들과 같은 월급을 받는 사원들의 이름, 월급,
--   부서번호를 출력하라.

SELECT ENAME, SAL, DEPTNO 
FROM EMP e
WHERE SAL = any(
SELECT SAL 
FROM EMP e2
WHERE DEPTNO = 10
);


SELECT ENAME, DEPTNO, SAL 
FROM EMP e
WHERE DEPTNO =10;

--3. 'BLAKE'와 같은 부서에 있는 사원들의 이름과 고용일을 뽑는데
--   'BLAKE'는 빼고 출력하라.


SELECT ENAME, HIREDATE 
FROM EMP e
WHERE (DEPTNO = (
	SELECT DEPTNO 
	FROM EMP e 
	WHERE ENAME = 'BLAKE'
)) AND (e.ENAME !='BLAKE');


--4. 평균급여보다 많은 급여를 받는 사원들의 사원번호, 이름, 월급을
-- 출력하되, 월급이 높은 사람 순으로 출력하라.

SELECT EMPNO, ENAME, SAL 
FROM EMP e
WHERE SAL > (
SELECT avg(SAL)	
FROM EMP e1 
)
ORDER BY e.SAL DESC ;

--5. 이름에 'T'를 포함하고 있는 사원들과 같은 부서에서 근무하고
--   있는 사원의 사원번호와 이름을 출력하라.

SELECT EMPNO, ENAME  
FROM EMP e 
WHERE DEPTNO = ANY (
SELECT DEPTNO 
FROM EMP e 
WHERE ENAME LIKE '%T%'
);


--6 자신의 급여가 평균급여보다 많고,이름에 S자가 들어가는 사원과 동일한
--  부서에서 근무하는 모든 사원의 사원번호,이름 및 급여를 출력하시오

SELECT EMPNO, ENAME, SAL 
FROM EMP e
WHERE (SAL > (
SELECT AVG(SAL)  
FROM EMP e1))
AND DEPTNO = ANY (
SELECT DEPTNO 
FROM EMP e
WHERE ENAME LIKE '%S%'
);


--7. 30번 부서에 있는 사원들 중에서 가장 많은 월급을 받는 사원보다
--   많은 월급을 받는 사원들의 이름, 부서번호, 월급을 출력하라.
--   (단, ALL 또는 ANY 연산자를 사용할 것)

SELECT ENAME, DEPTNO, SAL 
FROM EMP e
WHERE SAL > ANY (
SELECT MAX(SAL) 
FROM EMP e
WHERE DEPTNO = 30
);


--8. 'DALLAS'에서 근무하고 있는 사원과 같은 부서에서 일하는 사원의
--   이름, 부서번호, 직업을 출력하라.

SELECT ENAME, e.DEPTNO, JOB  
FROM EMP e
WHERE e.DEPTNO  = ANY  (
SELECT DEPTNO 
FROM DEPT d
WHERE LOC = 'DALLAS'
);


 --9. SALES 부서에서 일하는 사원들의 부서번호, 이름, 직업을 출력하라.


SELECT DEPTNO, ENAME, JOB 
FROM EMP e 
WHERE e.DEPTNO = ANY (
SELECT d.DEPTNO 
FROM DEPT d
WHERE DNAME ='SALES'
);

--10. 'KING'에게 보고하는 모든 사원의 이름과 급여를 출력하라.
--     (KING에게 보고하는 사원이란 mgr이 KING인 사원을 의미함)

SELECT e.ENAME, SAL  
FROM EMP e
WHERE e.MGR = (
SELECT EMPNO 
FROM EMP e2
WHERE ENAME ='KING'
);


--11. 커미션을 받는 사원과 부서번호, 월급이 같은 사원의
--    이름, 월급, 부서번호를 출력하라.


SELECT *
FROM EMP e
WHERE e.COMM IS NOT NULL ;


--12. 30번 부서 사원들과 월급과 커미션이 같지 않은
--    사원들의 이름, 월급, 커미션을 출력하라.(30번 부서 제외)

SELECT ENAME, SAL, COMM 
FROM EMP e
WHERE (SAL, COMM) !=  ALL (
SELECT SAL, COMM
FROM EMP e
WHERE DEPTNO =30
);


--13. 사원번호, 이름, 월급, 그리고 월급누적을 출력하라.
--        사원번호  이름   월급   월급누적
        
SELECT E.EMPNO, E.ENAME, E.SAL, SUM(D.SAL)
FROM EMP E, (SELECT EMPNO, SAL FROM EMP) D
WHERE E.EMPNO >= D.EMPNO
GROUP BY E.EMPNO, E.ENAME , E.SAL
ORDER BY 1;


-----------------------조인
-- 여러개의 테이블의 데이터가 필요한 경우 사용
-- 관계형 데이터 베이스에서 기본.
-- 기준 테이블에서 다른 테이블이 있는 ROW를 찾아 오는 것

-- ORACLE 조인: EQUI, NON-EQUI, SELF, OUTER
-- ANSI 조인: CROSS, JOIN, OUTER, NATURAL

--Q1) INNER JOIN을 햬보자.
--SALESMAN의 사원번호, 이름, 봉급, 부서명, 근무위치를 출력해보자.


--Oracle Join
SELECT EMPNO, ENAME, SAL, d.DNAME, d.LOC
FROM EMP e, DEPT d
WHERE e.DEPTNO  = d.DEPTNO;

--ANSI: 동일한 칼럼을 지정할 때에는 using(칼럼명)/ 다른 컬럼의 값을 지정할 때에는 on (칼럼A = 칼럼B)

--e.deptno d.deptno가 컬럼명은 같으니.
SELECT EMPNO, ENAME, SAL, DNAME, LOC
FROM EMP JOIN DEPT  using(DEPTNO);

/*
 * JOIN = INNER JOIN = 두개의 테이블에서 TRUE 값만 출력. false, null 추출되지 않는다.
 * 
 * 
 */

--sample

CREATE TABLE M(
	M1 VARCHAR(10),
	M2 VARCHAR(10)
);

INSERT INTO M VALUES('A', '1');
INSERT INTO M VALUES('B', '1');
INSERT INTO M VALUES('C', '3');
INSERT INTO M VALUES(null, '3');
   

SELECT *
FROM X;



CREATE TABLE S(
	S1 VARCHAR(10),
	S2 VARCHAR(10)
);

INSERT INTO S VALUES('A', 'X');
INSERT INTO S VALUES('B', 'Y');
INSERT INTO S VALUES(null, 'Z');

CREATE TABLE X(
	X1 VARCHAR(10),
	X2 VARCHAR(10)
);


INSERT INTO X values('A', 'DATA');

--Q2) M, S두 테이블의 M1, S1컬럼을 조인해보자.
--ORACLE JOIN

SELECT *
FROM M,S
WHERE M1 = S1;


--ANSI
SELECT *
FROM M JOIN S ON (M1 = S1);




