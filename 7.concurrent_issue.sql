-- read uncommitted : 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 실습절차
-- 1)워크벤치에서 auto_commit 해제. update 실행. commit하지 않음. (transaction1)
-- 2)터미널을 열어 selected 했을 때 위 update 변경사항이 읽히는지 확인 (transaction2)
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read 발생 x

-- read committed : 커밋한 데이터만 read 가능 -> phantom read 발생(또는 non-repeatable)
-- 실습절차
-- 1)워크벤치에서 아래 코드 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;
-- 2) 터미널을 열어 아래 코드 실행
insert into author(email) values('ggg@naver.com');

-- repeatable read : 읽기의 일관성 보장 -> lost update 문제 발생 -> 배타lock(배타적 잠금)으로 해결
-- lost update 문제 발생하는 상황 
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world',9);
    select post_count into count from author where id=9;
    do sleep(15);
    update author set post_count=count+1 where id=9;
    commit;
end //
DELIMITER ;
call concurrent_test1();
-- 터미널에서는 아래 코드 실행
select post_count from author where id=9;

-- 배타락을 통해 lost update 문제를 해결한 상황
-- select for update를 하게 되면 트랜잭션이 실행되는 동안 lock이 걸리고, 트랜잭션 종료된 후에 lock 풀림.
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values('hello world', 9);
    select post_count into count from author where id=9 for update;
    do sleep(15);
    update author set post_count=count+1 where id=9;
    commit;
end //
DELIMITER ;
call concurrent_test2();
-- 터미널에서는 아래 코드 실행
select post_count from author where id=9 for update;

-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성 문제없음(성능저하)