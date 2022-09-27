-- 1-1을 했다.


CREATE TABLE my_table(
	key1 char(4),
	key2 char(4),
	key3 char(4),
	key4 char(4),
	val number
);

DROP TABLE my_table;
TRUNCATE TABLE my_table;

/*	
	Insert into 테이블명 values(1,1,1,1); 1:1관계, 순차적인 값이 매핑.
	
	Insert into 테이블명(칼럼명) values(값, , , , ) 

*/

INSERT INTO MY_TABLE values('AAAA', 'AAA', 'AA', 'A', 100);
INSERT INTO MY_TABLE values('AAAA', 'AAA', 'BB', 'A', 110);
INSERT INTO MY_TABLE VALUES('AAAA','AAA','BB','A',120);
INSERT INTO MY_TABLE VALUES('AAAA','AAA','BB','B',130); 
INSERT INTO MY_TABLE VALUES('AAAA','BBB','AA','A',140); 
INSERT INTO MY_TABLE VALUES('AAAA','BBB','AA','B',150);
INSERT INTO MY_TABLE VALUES('AAAA','BBB','BB','A',160); 
INSERT INTO MY_TABLE VALUES('AAAA','BBB','BB','B',170); 
INSERT INTO MY_TABLE VALUES('BBBB','AAA','AA','A',180); 
INSERT INTO MY_TABLE VALUES('BBBB','AAA','AA','B',190); 
INSERT INTO MY_TABLE VALUES('BBBB','AAA','BB','A',200); 
INSERT INTO MY_TABLE VALUES('BBBB','AAA','BB','B',210); 
INSERT INTO MY_TABLE VALUES('BBBB','BBB','AA','A',220);
INSERT INTO MY_TABLE VALUES('BBBB','BBB','AA','B',230);
INSERT INTO MY_TABLE VALUES('BBBB','BBB','BB','A',240); 
INSERT INTO MY_TABLE VALUES('BBBB','BBB','BB','B',250);

SELECT *
FROM MY_TABLE;

--Q1) 전체 갯수

SELECT COUNT(*)
FROM EMP e;

--Q2) key1, key2 그룹핑 해서 그룹평 개수와 val값

SELECT KEY1, KEY2, COUNT(*), sum(VAL)
FROM MY_TABLE
GROUP BY (KEY1, KEY2)
ORDER BY 1,2;

--Q3) key를 이용한 rollup을 해보자.

SELECT KEY1, KEY2, COUNT(*), SUM(VAL)  
FROM MY_TABLE
GROUP BY key1, ROLLUP(KEY2)
ORDER BY 1,2;

SELECT KEY1, KEY2 
FROM MY_TABLE
GROUP BY ROLLUP (key1, KEY2)
ORDER BY 1,2;

--key1과 key2에 대한 총계들이 나오는데, 우선 key2의 총계값 그리고 그것들이 끝나면, 둘다.


SELECT key1, key2, key3, COUNT(*), sum(val) 
FROM my_table
GROUP BY key1, rollup(key2, key3)
ORDER BY 1,2, 3;

--Q4) key1, 2 3,4 를 이용한 rollup을 해보자. (key3, key4)만 그룹으로 rollup을 해보자.

SELECT key1, key2, key3, key4, COUNT(*), sum(val) 
FROM my_table
GROUP BY key1, key2, rollup(key3, key4)
ORDER BY 1, 2, 3;


SELECT key1, key2, key3,key4, COUNT(*), sum(val) 
FROM my_table
GROUP BY key1, key2, ROLLUP((key3, key4))
ORDER BY 1,2, 3;

 --rollup이 하나로 움직인다. (key3, key4)가 같이 총계가 된다. 함께 움직인다.

--Q5) 그룹핑을 해보자. grouping -> 1,0

SELECT GROUPING(key1) AS GP01, -- 집계된열 1, 집계안된 열 0 -- ROLLUP 부분이 
GROUPING(key2) AS GP02,
GROUPING(key3) AS GP03,--롤 업의 결과가 나올때 1이 나오게 한다.
GROUPING_ID(key1, key2, key3)  AS GID,key1, key2, key3,
count(*), sum(val)
FROM my_table
GROUP BY key1, ROLLUP (key2, key3)
ORDER BY key1, key2, key3;


--Q7) cube를 이용해서 key1, key2, key3을 그룹핑해보자.

SELECT GROUPING(key1) AS GP01, -- 집계된열 1, 집계안된 열 0
GROUPING(key2) AS GP02,
GROUPING(key3) AS GP03,
GROUPING_ID(key1, key2, key3)  AS GID,key1, key2, key3,
count(*), sum(val)
FROM my_table
GROUP BY key1, CUBE (key2, key3)
ORDER BY key1, key2, key3;


--Q8) cube를 이용해서 (key1, (key2, key3))을 그룹핑해보자.

SELECT GROUPING(key1) AS GP01, -- 집계된열 1, 집계안된 열 0
GROUPING(key2) AS GP02,
GROUPING(key3) AS GP03,
GROUPING_ID(key1, key2, key3)  AS GID,key1, key2, key3,
count(*), sum(val)
FROM my_table
GROUP BY CUBE (key1, (key2, key3)) --key2, key3를 하나의 뭉탱이로 봐야지
ORDER BY key1, key2, key3;

SELECT GROUPING(key1) AS GP01, -- 집계된열 1, 집계안된 열 0
GROUPING(key2) AS GP02,
GROUPING(key3) AS GP03,
GROUPING_ID(key1, key2, key3)  AS GID,key1, key2, key3,
count(*), sum(val)
FROM my_table
GROUP BY CUBE (key1, key2, key3) --key2, key3를 하나의 뭉탱이로 봐야지
ORDER BY key1, key2, key3;


--Q9) cube를 이용해서 (key2, (key1, key3))을 그룹핑해보자.

SELECT GROUPING(key1) AS GP01, -- 집계된열 1, 집계안된 열 0
GROUPING(key2) AS GP02,
GROUPING(key3) AS GP03,
GROUPING_ID(key1, key2, key3)  AS GID,key1, key2, key3,
count(*), sum(val)
FROM my_table
GROUP BY CUBE (key2, (key1, key3))
ORDER BY key1, key2, key3;
