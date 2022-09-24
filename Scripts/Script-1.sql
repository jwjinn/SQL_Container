--0921 숫자 함수, 날짜함수, 변환 함수, 서브쿼리

/*
 * 	ROUND, TRUNC_버림, MOD(M,N)_나머지, ABS, FLOOR_해당 수 보다 작거나 같은 정수 중 가장 큰 정수를 리턴, 
 * 
 *	CEIL - FLOOR의 반대, SIGN, POWER(M,N)_M의 N승
 * 
 * 
 * */

--Q1. ROUND를 확인해보자.

SELECT ROUND(4567.678) 결과1, ROUND(4567.678,2) 결과2, ROUND(4567.678,-2) 결과4
FROM DUAL;

-- Q2. TRUNC를 확인해보자.

SELECT TRUNC(4567.678) 결과1, TRUNC(4567.678,2) 결과2, TRUNC(4567.678,-2) 결과4
FROM DUAL;


-- Q3. 사원테이블에서 급여를 30으로 나눈 나머지를 출력하자. 이름과 급여, 결과를 출력해보자.

SELECT ENAME, sal, MOD (sal, 30) AS "결 과"
FROM EMP e ;

--Q4) 날짜함수의 서식을 확인해보자.
SELECT VALUE
FROM NLS_SESSION_PARAMETERS --초기 데이터 베이스 포맷을 관리하는 테이블
WHERE PARAMETER ='NLS_DATE_FORMAT'; --RR/MM/DD(00~49:2000년대) , DD/MON/RR(50~99 : 1990년대) 

SELECT PARAMETER, VALUE
FROM NLS_SESSION_PARAMETERS;


--NLS_ISO_CURRENCY	KOREA: 한국 날짜를 기준으로 날짜 세팅.

--7바이트 내부 표현을 하게된다. 시간, 날짜 값이 상수로 리턴된다.
--CENTURY, YEAR, MONTH, DAY, HOURS, MINUTS, SECONDS

/*
 * 2011년 6월 7일 오전 3시 15분 47초 -> 07-JUN-11리턴된다.
 * century, year, month, day, hours, minuts, seoncds
 * 
 */

--Q5) 날짜형식은 산술연산이 가능하다.
SELECT SYSDATE , SYSDATE +3
FROM dual;

SELECT ENAME, TO_CHAR(HIREDATE, 'YYYY_MM_DD_Dy'), HIREDATE +3
FROM EMP e 
WHERE deptno = 20;


--Q6) extract 함수: 오늘날짜중 년도만 조회하고 싶다.
SELECT EXTRACT(YEAR FROM sysdate) FROM dual;

--사원테이블에서 사원의 이름, 입사일자에서 월만 조회해 보자.
SELECT ENAME, HIREDATE, TO_CHAR(HIREDATE, 'YYYY-MM-DD-Dy'), EXTRACT (MONTH FROM HIREDATE)
FROM EMP e;


--Q7)

/*
 * MONTH_BETWEEN(D1, D2) : D1 -D2 된 개월 수 (숫자 리턴)
 * ADD_MONTHS(D1, N): D1 +N 월
 * NETXT_DAY(D1, 'CHAR'):D1보다 이수 날짜로 지정한 요일에 해당하는 날짜.
 * LAST_DAY: 해당월의 마지막 날짜를 리턴
 * 
 */

SELECT ENAME, HIREDATE, To_ch  
FROM EMP e

--Q7)사원테이블에서 사원의 현재까지의 근무일수가 몇주 몇일인지 조회해보자.

SELECT ENAME, HIREDATE, SYSDATE, TRUNC(SYSDATE - HIREDATE, 3)AS "total days",
TRUNC((SYSDATE - HIREDATE)/7, 0) || '주' AS "WEEK",
ROUND(MOD((sysdate-hiredate),7),0) AS "Days"
FROM emp
ORDER BY WEEk DESC ;

--round(mod((stsdate-hiredate),7),0)days


--Q8) 사원테이블에서 10번 부서의 사원들이 현재까지의 근무 월수를 계산해서 리턴해보자. Months_between

SELECT ENAME, HIREDATE, SYSDATE, MONTHS_BETWEEN(SYSDATE, HIREDATE) 근무월수,
trunc(MONTHS_BETWEEN(SYSDATE, HIREDATE),0) 근무월수2
FROM EMP e 
WHERE DEPTNO =10
ORDER BY 4 DESC;

SELECT MONTHS_BETWEEN(TO_DATE('02-02-1995','MM-DD-YYYY'), TO_DATE('01-01-1995','MM-DD-YYYY') ) FROM DUAL; 

SELECT TO_DATE('02-02-95','MM-DD-YYYY') --문자를 날짜포맷으로 변환해서 타입을 날짜로 리턴. 양식을 맞춰라.
FROM dual;

SELECT TO_DATE('1995-02-02','yyyy-mm-dd')  --문자를 날짜포맷으로 변환해서 타입을 날짜로 리턴. 양식을 맞춰라.
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') -- system날짜를 포맷서기으로 문자열로 리턴된것을 날짜로 리턴.
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD') FROM dual; 


--Q9) 사원테이블에서 10번, 30번 부서의 사원들의 입사일로부터 5개월이 지난 후 날자를 계산해서 출력해보자. ADD_MONTHs
-- 출력 예시, ENAME, HIREDATE, A_Month로 출력

SELECT ENAME, HIREDATE, ADD_MONTHS(HIREDATE,5) A_MONTH 
FROM EMP e
WHERE DEPTNO  in(10,30)
ORDER BY 2 DESC;

--Q10) 사원테이블에서 10번 부서 사원들의 입사일로부터 돌아오는 금요일을 계산해서 리턴하자

SELECT ENAME, HIREDATE, NEXT_DAY(HIREDATE, 6) 
FROM EMP e
WHERE DEPTNO  = 10;

----------------------------------------------------------------


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
to_char(round(hiredate,'MM'), 'YY/MM/DD') round_mm, 
to_char(round(hiredate,'YY'), 'YY/MM/DD') round_yy
FROM  SCOTT.EMP     
WHERE  ENAME='SCOTT';


--RR/MM/DD(00 ~ 49:2000년대), DD/MON/RR(50 ~ 90 : 1900년대)
SELECT TO_CHAR(TO_DATE('98','RR'),'YYYY') test1, --두자리를 입력할 경우, RR로 할때는 1900년대
TO_CHAR(TO_DATE('05','RR'),'YYYY') test2, 
TO_CHAR(TO_DATE('98','YY'),'YYYY') test3, --두자리를 입력했는데, 2000년대를 원하면 YY
TO_CHAR(TO_DATE('05','YY'),'YYYY') test4 
FROM  dual;

SELECT   '000123',  to_number('000123')  FROM  dual;

--Q12)  다음 문장의 실행 결과를 알아보자.
SELECT   to_timestamp_tz ('2004-8-20 1:30:00 -3:00', 'YYYY-MM-DD HH:MI:SS TZH:TZM')
FROM dual;-- CHAR, VARCHAR2 데이터 타입을 TIMESTAMP WITH TIME ZONE 데이터 타입으로 리턴  

SELECT to_timestamp('2004-8-20 1:30:00', 'YYYY-MM-DD HH:MI:SS') 
FROM dual;-- CHAR, VARCHAR2 데이터 타입을 TIMESTAMP데이터 타입으로 리턴 

SELECT sysdate, sysdate+to_yminterval('01-03') "15Months later"--1년하고 3개월후 
FROM  dual;  ---- CHAR, VARCHAR2 데이터 타입을 INTERVAL YEAR TO MONTH 데이터 타입으로 리턴 

SELECT  sysdate, sysdate+to_dsinterval('003 17:00:00') as "3days 17hours later" 
FROM dual; ---- CHAR, VARCHAR2 데이터 타입을 INTERVAL DAY TO SECOND 데이터 타입으로 리턴 

--Q13)  다음 문장의 실행 결과를 알아보자.
 --EMP 테이블의 사원이름,  매니저 번호, 매니저번호가 null이면 ‘대표’ 로 표시하고, 매니저번호가 있으면 '프로'으로 표시. 
 SELECT ename, mgr, NVL2(mgr, mgr||'프로','대표') 
 FROM SCOTT.EMP;


--Q14) EMP 테이블의 사원이름 , 업무, 업무가 'CLERK‘ 인 경우 NULL로 나오도록 리턴.
SELECT  ename, job, NULLIF(job,'CLERK') AS result 
FROM  SCOTT.EMP;


--Q15)EMP테이블에서 이름, 커미션,봉급, 보너스가 null 아닌 경우 커미션을, 보너스가 null인 경우엔 봉급을,
--모두 null인 경우엔 50으로 리턴.
SELECT ename, comm,sal, COALESCE(comm,sal,50) result 
FROM SCOTT.EMP;

--Q16) decode함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라.
SELECT  ename, sal, DECODE(SIGN(sal-1000),-1,'A', DECODE(SIGN(sal-2500),-1,'B','C')) grade 
FROM  SCOTT.EMP;

--Q17)case 함수를 이용하여 급여가 1000보다 작으면 ‘A’, 1000이상 2500미만이면 ‘B’, 2500이상이면 ‘C’로 표시하라. 
SELECT ename,sal, 
        CASE WHEN sal < 1000
        			THEN 'A' 
             WHEN sal>=1000 AND sal<2500 
             		THEN 'B'
             ELSE 'C' END AS grade 
FROM SCOTT.EMP ORDER BY grade;


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
GROUP BY ROLLUP (DEPTNO); -- 내부 정렬+ 총계가 추가되었다고 생각하면 편함 groupby에서


SELECT DEPTNO, COUNT(*), sum(SAL) 
FROM EMP e
GROUP BY DEPTNO ;


--Q19) 사원 테이블에서 부서별, 직업별 급여의 합 조회시 Rollup집계를 내보자.

SELECT DEPTNO, JOB , COUNT(*), sum(SAL) 
FROM EMP e 
GROUP BY ROLLUP (DEPTNO, JOB);

SELECT DEPTNO, JOB , MGR , sum(SAL) 
FROM EMP e 
GROUP BY ROLLUP (DEPTNO, JOB, MGR);

--Q20) 사원 테이블 CUBE

SELECT DEPTNO, COUNT(*), sum(SAL)
FROM EMP e
GROUP BY CUBE  (DEPTNO);

SELECT DEPTNO, JOB ,COUNT(*), sum(SAL) -- 위에 모든 총계들을 미리 보여준다.
FROM EMP e
GROUP BY CUBE  (DEPTNO, JOB); -- 2* 2 = 4 개의 그룹화를 계산한다.


SELECT DEPTNO, JOB ,MGR , sum(SAL) -- 위에 모든 총계들을 미리 보여준다.
FROM EMP e
GROUP BY CUBE  (DEPTNO, JOB, MGR); -- 2*2*2 8개의 그룹화를 계산한다.


--Q21) Grouping 함수는 rollup, cube와 함께 사용한다. 

/*
 * - 하나의 열을 인수로 갖는다.
 * - 인수는 group by 절에 칼럼과 같아야 한다.
 * 
 * 0 또는 1을 반환한다.
 * 0: 해당 열을 그대로 사용하여 집계 값을 계산 했거나 해당 열에 나오는 null 값이 저장된 것을 의미한다.
 * 1: 해당 열을 사용하지 않고 집계 값을 계산 했거나 null값이 그룹화의 결과로 rollup, cube에 리턴값으로 구현된 것을 의미한다.
 * - select문 뒤에 선언한다.
 * 	- 행에서 하위 총계를 형성한 그룹을 찾을 수 있다.
 */

SELECT DEPTNO, JOB, SUM(SAL), GROUPING(DEPTNO), GROUPING(JOB) 
FROM EMP e 
GROUP BY ROLLUP (JOB, DEPTNO); -- Job을 먼저 기준을 잡는다. job을 고정시키고 deptno에 차이를 둔다.

SELECT DEPTNO, JOB, SUM(SAL), GROUPING(DEPTNO), GROUPING(JOB) 
FROM EMP e 
GROUP BY ROLLUP (DEPTNO, JOB); -- Deptno를 기준으로 잡는다.

SELECT DEPTNO, JOB, SUM(SAL), GROUPING(DEPTNO), GROUPING(JOB) 
FROM EMP e 
GROUP BY CUBE  (JOB, DEPTNO);


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

/* 1)GROUP BY GROUPING SETS(A,B,C) = 
 * GROUP BY A UNION ALL 
 * GROUP BY B UNION ALL 
 * GROUP BY C UNION ALL
 *  
 * 2)GROUP BY GROUPING SETS(A,B,(B,C))= 
 * GROUP BY A UNION ALL 
 * GROUP BY B UNION ALL 
 * GROUP BY B,C 
 * 
 * 3)GROUP BY GROUPING SETS((A,B,C))= 
 * GROUP BY A,B,C 
 * 
 * 4)GROUP BY GROUPING SETS(A,(B),()) = 
 * GROUP BY A UNION ALL
 * GROUP BY B UNION ALL
 * GROUP BY () 
 * / 
 
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

-- 사원번호, 사원의 이름, 부서번호, 봉급, 부서내에서 급여가 많은 사원부터 순위를 출력하자.

SELECT EMPNO, ENAME, DEPTNO, SAL,
		RANK() over(PARTITION BY DEPTNO
		ORDER BY SAL DESC) "순 위"
FROM EMP e ;


SELECT EMPNO, ENAME, DEPTNO, SAL,
		DENSE_RANK() over(PARTITION BY DEPTNO
		ORDER BY SAL DESC) "순 위"
FROM EMP e ;

--Q25) CUME_DIST(): 누적된 분산 정도를 출력. - 그룹핑 -> 정렬 -> 그룹별 상대적인 위치(누적된 분산정도)
	-- 상대적인 위치 : 구하고자 하는 값보다 작거나 같은 값을 가진  ROW수를 그룹의 전체 ROW수로 나눈 것을 의미한다.
--20번 사원의 이름, 봉급, 누적분산을 출력해보자.

SELECT ENAME, SAL,
		CUME_DIST () over(
		ORDER BY SAL) "누적 분산"
FROM EMP e
WHERE  DEPTNO = 20;


SELECT ENAME , sal
FROM EMP e 
WHERE DEPTNO  = 20;


--Q26) NTITLE(N): 버킷 분할
-- 사원의 봉급을 기준으로 4등분을 하자

SELECT ENAME, SAL,
		NTILE(4)over(
		ORDER BY SAL) RES_NTITLE
FROM EMP e;

--Q27) 사원이름, 부서번호, 봉급, 전체 봉급의 합계, 부서별 봉급 합계를 출력해보자.

SELECT ENAME, SAL, SUM(SAL) --갯수가 안 맞음.
FROM EMP e 
GROUP BY DEPTNO;


SELECT ENAME, SAL, SUM(SAL) over()"TOTAL_SUM",
sum(SAL) over(
	PARTITION BY DEPTNO 
)  "DEPT_SUM"
FROM EMP e;


--Q28) 사원이름, 직업, 봉급, 직업별 평균, 직업 중에 최대 급여를 출력

SELECT ENAME, JOB,
AVG(SAL) over(
	PARTITION BY JOB ) "JOB_AVG",
max(SAL) OVER (
	PARTITION BY JOB
) "JOB_MAX"
FROM EMP e;


--Q29) 사원의 이름, 부서번호, 봉급의 합계를 더한 결과를 , 누적합계를 출력 해보자.

SELECT ENAME, DEPTNO, SAL,
SUM(SAL) over(ORDER BY SAL ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) "sum1",
sum(SAL) OVER (ORDER BY SAL ROWS UNBOUNDED PRECEDING ) "Sum2" 
FROM EMP e;

--Q30) RATIO_TO_REPORT를 이용해서 해당 구간을 차지하는 비율을 리턴해보자.
--사원의 월급을 50000으로 증가했을때 기존 비율을 적용했을 경우 각 사원은 얼마를 받을 수 있을지 추출하자.
SELECT ENAME, SAL, RATIO_TO_REPORT(SAL) over() AS "비율" 
FROM EMP e 

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


--Q32) LEAD: 그룹핑 내에서 상대적 로우를 참조한다. - 하위를 가져온다. 
-- 상대적으로 상위에 위치한 로우 (오름차순의 경우 로우의 정렬 컬럼의 값보다 큰 값을 갖는 로우,
-- 내림차순의 경우 기준 로우의 정렬 컬럼 값보다 작은 값을 갖는 로우를 참조하기 위해 사용된다.)


SELECT ENAME, DEPTNO, SAL, LEAD(SAL, 1, 0 ) over(ORDER  BY SAL) AS "NEXT_SAL",-- 자기자 - 
LEAD(SAL, 1, SAL) over(ORDER BY SAL) AS "NEXT_SAL02",
LEAD(SAL, 1, SAL) over(PARTITION BY DEPTNO ORDER BY SAL) AS "NEXT_SAL03"
FROM EMP e;