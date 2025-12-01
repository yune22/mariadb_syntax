-- 사용자목록조회
select * from mysql.user;

-- 사용자생성
create user 'marketing'@'%' identified by 'test4321';

-- 사용자에게 권한부여
grant select on board.author to 'marketing'@'%';
grant select, insert on board.* to 'marketing'@'%';
grant all privileges on board.* to 'marketing'@'%';

-- 사용자에게 권한부여
revoke select on board.author from 'marketing'@'%';

-- 사용자 권한 조회
show grants for 'marketing'@'%';

-- 사용자 계정 삭제
drop user 'marketing'@'%';