--0921 숫자 함수, 날짜함수, 변환 함수, 서브쿼리

/*
 * 	ROUND, TRUNC_버림, MOD(M,N)_나머지, ABS, FLOOR_해당 수 보다 작거나 같은 정수 중 가장 큰 정수를 리턴, 
 * 
 *	CEIL - FLOOR의 반대, SIGN, POWER(M,N)_M의 N승
 * 
 * 
 * */

--Q1) Round를 확인해보자.

-- 두번째 인자는 2번째 자릿수까지 표현을 한다.
SELECT ROUND(4567.678) 결과1, ROUND(4567.678, 2) 결과2, ROUND(4567.678, -2) 결과4 
FROM dual;

--Q2) TRUNC를 확인해보자.

--자릿수까지 표현, 절삭을 해서
SELECT TRUNC(4567.678) 결과1, TRUNC(4567.678, 2) 결과2, TRUNC(4567.678, -2) 결과4  
FROM DUAL;


-- Q3. 사원테이블에서 급여를 30으로 나눈 나머지를 출력하자. 이름과 급여, 결과를 출력해보자.

SELECT ENAME, SAL, MOD(SAL, 30)
FROM EMP e;

--Q4) 날짜함수의 서식을 확인해보자.


-- DB의 서식들을 확인할 수 있는 명령
SELECT *
FROM NLS_SESSION_PARAMETERS;


SELECT *
FROM NLS_SESSION_PARAMETERS
WHERE PARAMETER = 'NLS_DATE_FORMAT'

--RR/MM/DD(00~49:2000년대) , DD/MON/RR(50~99 : 1990년대) 

--Q5) 날짜형식은 산술연산이 가능하다.

SELECT SYSDATE, SYSDATE +3 -- 날짜 형식을 산술연산을 진행하게 되면, 일자가 변경된다. 즉, 몇일 후???
FROM dual;

--Q6) extract 함수: 오늘날짜중 년도만 조회하고 싶다.

-- 일단 타입이 Date타입일 경우, extract(Year from sysdate)
SELECT EXTRACT (YEAR FROM sysdate)
FROM dual;

--사원테이블에서 사원의 이름, 입사일자에서 월만 조회해 보자.

SELECT ENAME, HIREDATE, TO_CHAR(HIREDATE, 'YYY-MM-DD-Dy') ,EXTRACT(MONTH FROM HIREDATE)
FROM EMP e;
-- Date타입에서 Month를 추출한다. Date타입을 CHAR 형식으로 바꾼다.


--Q7)

/*
 * MONTH_BETWEEN(D1, D2) : D1 -D2 된 개월 수 (숫자 리턴)
 * ADD_MONTHS(D1, N): D1 +N 월
 * NETXT_DAY(D1, 'CHAR'):D1보다 이수 날짜로 지정한 요일에 해당하는 날짜.
 * LAST_DAY: 해당월의 마지막 날짜를 리턴
 * 
 */

-- ADD_MONTHS: 기본적으로 Date타입에 더하게 되면, 일자가 추가되므로, 월을 추가하기 위해서는 ADD_Months를 사용해야 한다.
-- NETXT_DAY(D1, 'CHAR'): 
-- LAST_DAY: 마지막 날짜는 해당월의 

--Q7)사원테이블에서 사원의 현재까지의 근무일수가 몇주 몇일인지 조회해보자.
SELECT ENAME, HIREDATE, SYSDATE, TRUNC(SYSDATE - HIREDATE, 3)AS "total days",
TRUNC((SYSDATE - HIREDATE)/7, 0) || '주' AS "WEEK",
ROUND(MOD((sysdate-hiredate),7),0) AS "Days"
FROM emp
ORDER BY WEEk DESC ;

MOD((sysdate-hiredate),7)
MOD((SYSDATE - HIREDATE)/7)

SELECT ENAME, HIREDATE, TRUNC(SYSDATE - HIREDATE, 3) AS "total days",
TRUNC((SYSDATE - HIREDATE)/7) || '주' AS "Week",
ROUND(MOD((SYSDATE - HIREDATE), 7)) AS "Days"
FROM EMP e
ORDER BY 4 DESC;

--Q8) 사원테이블에서 10번 부서의 사원들이 현재까지의 근무 월수를 계산해서 리턴해보자. Months_between

SELECT ENAME, HIREDATE, SYSDATE, MONTHS_BETWEEN(SYSDATE, HIREDATE) 근무월수,
trunc(MONTHS_BETWEEN(SYSDATE, HIREDATE),0) 근무월수2
FROM EMP e 
WHERE DEPTNO =10
ORDER BY 4 DESC;


SELECT ENAME, MONTHS_BETWEEN(SYSDATE, HIREDATE) 근무월수,
TRUNC(MONTHS_BETWEEN(SYSDATE, HIREDATE)) AS 근무월수2 
FROM EMP e 
WHERE DEPTNO = 10
ORDER BY 3 DESC;

--둘 다, Date타입일 경우, 자유롭게 사용할 수 있다. 위와 같은 함수들을

SELECT MONTHS_BETWEEN(TO_DATE('02-02-1995','MM-DD-YYYY'), TO_DATE('01-01-1995','MM-DD-YYYY') ) FROM DUAL; 

--문자 형식을 데이트 타입으로 변경우, Monts_between함수를 사용.

--Q9) 사원테이블에서 10번, 30번 부서의 사원들의 입사일로부터 5개월이 지난 후 날자를 계산해서 출력해보자. ADD_MONTHs

SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE, 5) "5Months Later" 
FROM EMP e
WHERE DEPTNO IN (10, 30);

--Q10) 사원테이블에서 10번 부서 사원들의 입사일로부터 돌아오는 금요일을 계산해서 리턴하자

SELECT ENAME, HIREDATE, NEXT_DAY(HIREDATE,6) -- 1이 일, 6은 금
FROM EMP e
WHERE DEPTNO = 10;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 1), NEXT_DAY(SYSDATE, 2) 
FROM dual;


--Q11)  다음 문장의 실행 결과를 알아보자.
--날짜에 사용하면 지정형식 모델에 따라 함수가 반올림되거나 버려지므로 날짜를 가장 가까운 연도 또는 달로 반올림할 수 있다.
/*
ROUND : 일을 반올림 할때 정오를 넘으면 다음날 자정을 리턴하고, 넘지 않으면 그날 자정을 리턴한다. 
        월 : 15일 이상이면 다음달 1을 출력 / 넘지 않으면  현재 달 1을 리턴
        년도: 6월을 넘으면 다음해 1월1일 리턴 / 넘지 않으면 현재 1월 1일 리턴
        
TRUNC : 일을 절삭하면 그날 자정출력, 월을 절삭 그 달 1을출력, 년도를 절삭하면 금년 1월1일 리턴          

*/


SELECT   to_char(sysdate, 'YY/MM/DD HH24:MI:SS') normal, 
         to_char(trunc(sysdate), 'YY/MM/DD HH24:MI:SS') trunc, 
         to_char(round(sysdate), 'YY/MM/DD HH24:MI:SS') round 
         FROM  dual;


SELECT to_char(hiredate, 'YY/MM/DD HH24:MI:SS') hiredate, 
to_char(round(hiredate,'dd'), 'YY/MM/DD') round_dd, 
to_char(round(hiredate,'MM'), 'YY/MM/DD') round_mm, --0일은 존재하지 않으니까 1일로.
to_char(round(hiredate,'YY'), 'YY/MM/DD') round_yy
FROM  SCOTT.EMP     
WHERE  ENAME='SCOTT';

--RR/MM/DD(00 ~ 49:2000년대), DD/MON/RR(50 ~ 90 : 1900년대)
SELECT TO_CHAR(TO_DATE('98','RR'),'YYYY') test1, --두자리를 입력할 경우, RR로 할때는 1900년대
TO_CHAR(TO_DATE('05','RR'),'YYYY') test2, 
TO_CHAR(TO_DATE('98','YY'),'YYYY') test3, --두자리를 입력했는데, 2000년대를 원하면 YY
TO_CHAR(TO_DATE('05','YY'),'YYYY') test4 
FROM  dual;

--위는 "RR"은 1900년대, "YY" 2000년대

--Q12)  다음 문장의 실행 결과를 알아보자.
-- CHAR, VARCHAR2 데이터 타입을 TIMESTAMP WITH TIME ZONE 데이터 타입으로 리턴  

SELECT   to_timestamp_tz ('2004-8-20 1:30:00 -3:00', 'YYYY-MM-DD HH:MI:SS TZH:TZM')
FROM dual;

SELECT to_timestamp('2004-8-20 1:30:00', 'YYYY-MM-DD HH:MI:SS') 
FROM dual;-- CHAR, VARCHAR2 데이터 타입을 TIMESTAMP데이터 타입으로 리턴 

SELECT sysdate, sysdate+to_yminterval('01-03') "15Months later"--1년하고 3개월후 
FROM  dual;  ---- CHAR, VARCHAR2 데이터 타입을 INTERVAL YEAR TO MONTH 데이터 타입으로 리턴 

--interval: '01-03': 년, 월이런 형식으로
-- y(year)m(month)interval


SELECT  sysdate, sysdate+to_dsinterval('003 17:00:00') as "3days 17hours later" -- DAY SECOND: SECOND형식을 저런 식으로
FROM dual;


--Q13)  다음 문장의 실행 결과를 알아보자.
--EMP 테이블의 사원이름,  매니저 번호, 매니저번호가 null이면 ‘대표’ 로 표시하고, 매니저번호가 있으면 '프로'으로 표시.
-- NVL: Null일 경우에의 if

SELECT ENAME, MGR, NVL2(MGR, MGR|| '프로', '대표') 
FROM EMP e;
-- null이 아니면 좌측, null이면 우측

--Q14) EMP 테이블의 사원이름 , 업무, 업무가 'CLERK‘ 인 경우 NULL로 나오도록 리턴.

SELECT ENAME, JOB, NULLIF(JOB, 'CLERK') AS result
FROM EMP e;

--if먼저 생각해야됨, CLERK이면 null

--Q15)EMP테이블에서 이름, 커미션,봉급, 보너스가 null 아닌 경우 커미션을, 보너스가 null인 경우엔 봉급을,
--모두 null인 경우엔 50으로 리턴.

SELECT ename, comm,sal, COALESCE(comm,sal,50) result 
FROM SCOTT.EMP;

--COALESCE: 컬럼을 합치는데 사용한다. null이 먼저 아닌 값을 리턴한다. 둘다 null일 경우에 리턴되는 값을 적시한다.

--Q16) decode함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라.

SELECT  ename, sal, DECODE(SIGN(sal-1000),-1,'A', DECODE(SIGN(sal-2500),-1,'B','C')) grade 
FROM  SCOTT.EMP;

--Decode: Switch문을 하면 될듯.
SELECT  ename, sal, DECODE(SIGN(sal-1000),-1,'A', DECODE(SIGN(sal-2500),-1,'B','C')) grade 
FROM  SCOTT.EMP;


--Q17)case 함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라. 

SELECT ENAME, SAL,
	CASE WHEN SAL < 1000
		THEN 'A'
	WHEN SAL >= 1000 AND SAL <2500
		THEN 'B'
	ELSE 'C' END  AS grade
FROM EMP e;

-- case문. when then end

--Q17)case 함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라. 

SELECT ENAME, SAL,
	CASE WHEN SAL < 1000
		THEN 'A'
	WHEN SAL >= 1000 & SAL < 2500
		THEN 'B'
	ELSE 'C' END AS grade;
FROM EMP e 


--Q18) Rollup, CUBE : 그룹핑한 결과를 상호 참조열에 따라 상위집계를 내는 작업.

/*
 * ROLLUP : 정규 그룹화 행, 하위 총합을 포함해서 결과 집합을 리턴.
 * - 데이터 보고서 작성, 집합에서 통계 및 요약정보를 추출하는데 사용.
 * - group by 절에 () 이용해서 지정된 열 목록을 따라 오른쪽에서 왼쪽 방향으로 하나씩 그룹을 만든다. 그 다음 그룹함수를 생성한 그룹에 적용한다.
 * - 총계를 산출하라면 N+1 개의 select문을 union all로 지정한다.
 * 
 * CUBE: rollup 결과를 교차 도표화 행을 포함 하는 결과 집합을 리턴.
 * 		-group by 확장 기능이다.
 * 		-집계 함수를 사용하게 되면 결과 집합에 추가 행이 만들어 진다.
 * 		-group by 절에 N개의 열이 있을 경우 상위 집계 조합수는 2의 N승 계이다.
 * 
 *  Rollup은 하위 총합의 조합 중에 일부를 합을 내지만, CUBE는 모든 그룹의 합과 총계를 나타낸다.
 */

-- 사원 테이블에서 부서별, 급여의 합 조회시 rollup집계를 해보자


SELECT DEPTNO, COUNT(*), sum(SAL) -- 하위 총합 결과를 가져온다. -> 카운팅도 다 가져온다.
FROM EMP e
GROUP BY ROLLUP (DEPTNO);

/*
 *	10	3	8750
	20	5	10875
	30	6	9400
		14	29025 
 */

--group by를 하는데, 해당 결과에 총계를 한다. 위 같은경우네느 count와 sum에 대해서.



SELECT DEPTNO, COUNT(*), sum(SAL) -- 하위 총합 결과를 가져온다. -> 카운팅도 다 가져온다.
FROM EMP e
GROUP BY(DEPTNO);

/*
 * 	30	6	9400
	20	5	10875
	10	3	8750
 * 
 */


--Q19) 사원 테이블에서 부서별, 직업별 급여의 합 조회시 Rollup집계를 내보자.

SELECT DEPTNO, JOB, COUNT(*), SUM(SAL)
FROM EMP e
GROUP BY ROLLUP (DEPTNO, JOB);

-- DEPTNO, JOB별 별로 나눌려면 일단, 하나부터 시작해야 한다. 
-- 일단 좌측에 있는 값부터 시작한다.

--group by를 하나 씩, 돌려질때마다, 총계가 시작된다.
-- rollup은 좌측에 있는 값을 기준으로만 나온다.


SELECT DEPTNO, JOB , MGR , sum(SAL) 
FROM EMP e 
GROUP BY ROLLUP (DEPTNO, JOB, MGR);


--Q20) 사원 테이블 CUBE

SELECT DEPTNO, COUNT(*), sum(SAL)
FROM EMP e
GROUP BY CUBE  (DEPTNO);

SELECT DEPTNO, COUNT(*), sum(SAL)
FROM EMP e
GROUP BY (DEPTNO);


SELECT DEPTNO, JOB ,COUNT(*), sum(SAL) -- 위에 모든 총계들을 미리 보여준다.
FROM EMP e
GROUP BY CUBE  (DEPTNO, JOB); -- 2* 2 = 4 개의 그룹화를 계산한다.

--CUBE를 하게되면 여하튼 오른값을 기준으로 한 것도 출력된다.
--Rollup에서 좀더 구체적인

--Q21) Grouping sets : Group by 뒤에 선언되는 함수_여러개를 그룹화 할 수 있다.
--(Deptno, job, mgr), (deptno, mgr), (job, mgr))

--case1: 그룹 합집합 union all
SELECT DEPTNO, JOB ,MGR , AVG(SAL) 
FROM EMP e 
GROUP BY DEPTNO , JOB ,MGR 
	UNION all
SELECT DEPTNO, NULL , MGR , AVG(SAL) 
FROM EMP e 
GROUP BY DEPTNO,MGR 
	UNION all
SELECT NULL ,JOB ,MGR , AVG(SAL) 
FROM EMP e 
GROUP BY JOB ,MGR ;


--case2: 그룹 grouping sets

SELECT DEPTNO, JOB ,MGR , AVG(SAL) 
FROM EMP e 
GROUP BY GROUPING SETS ((DEPTNO , JOB ,MGR), (DEPTNO, MGR), (JOB, MGR)); 


--Q22) 조합 열

SELECT DEPTNO, JOB , MGR ,sum(SAL) 
FROM EMP e 
GROUP BY ROLLUP (DEPTNO, (JOB, MGR));


--Q24) 분석함수: max, min, count, LGA, LEAD, RANK, RATIO_TO_REPORT, ROW_NUMBER, SUM, AVG등(집계함수)
/*
 * [형식] 톄이블에서 몇줄에서 몇줄까지 그룹핑해서 정렬한 다음 분석함수의 결과를 리턴하는 함수
 * 		테이블 -> 선택 행 -> 그룹핑 -> 정렬 -> 집계 리턴
 * select
 * 			분석함수 (ARGS) OVER(
 * 										[partition by] 쿼리 결과를 그룹으로 묶는다.
 * 										[order by] 각 그룹의 정렬 _ 행의 검색 순서 ASC/DESC/NULL/FIRST/LAST
 * 												ex) DESC NULL FIRST | ASC NULL LAST
 *
 * 										[windowing 절] ROWS| RANGE [BETWEEN AND]
 *								)
 * From 테이블명
 *
 */	

-- group by를 진행하게 되면, group by 대상 + aggregate function을 제외하고는 사용을 할 수 없다. select에

-- 사원번호, 사원의 이름, 부서번호, 봉급, 부서내에서 급여가 많은 사원부터 순위를 출력하자.

SELECT  EMPNO, ENAME, DEPTNO, SAL,
RANK() over(PARTITION BY DEPTNO
ORDER BY SAL DESC) "순 위"
FROM EMP e;


SELECT EMPNO, ENAME, DEPTNO, SAL,
DENSE_Rank() over(PARTITION BY DEPTNO
	ORDER BY SAL DESC) "순 위"
FROM EMP e;

--Q25) CUME_DIST(): 누적된 분산 정도를 출력. - 그룹핑 -> 정렬 -> 그룹별 상대적인 위치(누적된 분산정도)

SELECT ENAME, SAL,
		CUME_DIST () over(
		ORDER BY SAL) "누적 분산"
FROM EMP e
WHERE  DEPTNO = 20;

--Q26) NTITLE(n): 버킷 분할

SELECT ENAME, SAL,
		NTILE(4)over(
		ORDER BY SAL) RES_NTITLE
FROM EMP e;


SELECT ENAME, SAL, NTILE(4) over(
ORDER BY SAL) res_ntitle 
FROM EMP e;

--Q27) 사원이름, 부서번호, 봉급, 전체 봉급의 합계, 부서별 봉급 합계를 출력해보자.

SELECT ENAME, DEPTNO, SAL, 
sum(SAL) over() "TOTAL_SUM",
sum(SAL) over(PARTITION BY DEPTNO) "DEPT_SUM"
FROM EMP e;

--Q28) 사원이름, 직업, 봉급, 직업별 평균, 직업 중에 최대 급여를 출력

SELECT ENAME, JOB, SAL,
AVG(SAL) over(PARTITION BY JOB),
MAX(SAL) over(PARTITION BY JOB) 
FROM EMP e

--Q29) 사원의 이름, 부서번호, 봉급의 합계를 더한 결과를 , 누적합계를 출력 해보자.

SELECT ENAME, DEPTNO, SAL,
SUM(SAL) over(ORDER BY SAL ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) "sum1",
sum(SAL) OVER (ORDER BY SAL ROWS UNBOUNDED PRECEDING ) "Sum2" 
FROM EMP e;

--Following은 result 테이블 기준으로 아래를 의미한다. 1 Following의 의미는 아래로 한칸
-- unbounded preceding 내 행기준으로 위로 간다. -> 즉 합계를 만든다.

--https://learnsql.com/blog/sql-window-functions-rows-clause/1.png 이미지 주소


--Q30) RATIO_TO_REPORT를 이용해서 해당 구간을 차지하는 비율을 리턴해보자.
--사원의 월급을 50000으로 증가했을때 기존 비율을 적용했을 경우 각 사원은 얼마를 받을 수 있을지 추출하자.

SELECT ENAME, SAL, RATIO_TO_REPORT(SAL) over()AS "비율" 
FROM EMP e;

SELECT ENAME, SAL, RATIO_TO_REPORT(SAL) over() AS "비율",
TRUNC(RATIO_TO_REPORT(SAL) over()* 50000) "받게 될 봉급" 
FROM EMP e;

--Q31) LAG: 그룹핑 내에서 상대적 로우를 참조한다. - 상위를 가져온다. 
-- 상대적으로 상위에 위치한 로우 (오름차순의 경우 로우의 정렬 컬럼의 값보다 작은 값을 갖는 로우,
-- 내림차순의 경우 기준 로우의 정렬 컬럼 값보다 큰 값을 갖는 로우를 참조하기 위해 사용된다.)

SELECT ENAME, DEPTNO, SAL, LAG(SAL, 1, 0 ) over(ORDER  BY SAL) AS "NEXT_SAL",-- 자기자 - 
LAG(SAL, 1, SAL) over(ORDER BY SAL) AS "NEXT_SAL02",
LAG(SAL, 1, SAL) over(PARTITION BY DEPTNO ORDER BY SAL) AS "NEXT_SAL03"
FROM EMP e;

--LAG는 이전 값을 가져온다. LAG(SAL, 1, 0): sal 기준에서 하나 전,  없으면 0을 리턴.


--Q32) LEAD: 그룹핑 내에서 상대적 로우를 참조한다. - 하위를 가져온다. 
-- 상대적으로 상위에 위치한 로우 (오름차순의 경우 로우의 정렬 컬럼의 값보다 큰 값을 갖는 로우,
-- 내림차순의 경우 기준 로우의 정렬 컬럼 값보다 작은 값을 갖는 로우를 참조하기 위해 사용된다.)


SELECT ENAME, DEPTNO, SAL, LEAD(SAL, 1, 0 ) over(ORDER  BY SAL) AS "NEXT_SAL",-- 자기자 - 
LEAD(SAL, 1, SAL) over(ORDER BY SAL) AS "NEXT_SAL02",
LEAD(SAL, 1, SAL) over(PARTITION BY DEPTNO ORDER BY SAL) AS "NEXT_SAL03"
FROM EMP e;
