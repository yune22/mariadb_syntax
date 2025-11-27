-- 회원 테이블 생성 
-- id(pk), email(unique, not null), name(not null), password(not null)
create table author(id bigint auto_increment primary key , email varchar(255) not null unique, name varchar(255) not null, password varchar(255) not null);

-- 주소 테이블
-- id, country(not null), city(not null), street(not null), author_id(fk, not null)
create table address(id bigint auto_increment primary key, country varchar(255) not null, city varchar(255) not null, street varchar(255) not null, author_id bigint not null unique, foreign key(author_id) references author(id)); 

-- post 테이블
-- id, tilte(not null), contents
create table post(id bigint auto_increment primary key, title varchar(255) not null, contents varchar(3000));

-- 연결(junction) 테이블
create table author_post_list(id bigint auto_increment primary key, author_id bigint not null, post_id bigint not null, foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 복합키를 이용한 연결(junction) 테이블 생성
create table author_post_list(author_id bigint not null, post_id bigint not null, primary key(author_id, post_id), foreign key(author_id) references author(id), foreign key(post_id) references post(id));

-- 회원가입 및 주소 생성
insert into author(email, name, password) values('cde@naver.com', 'cde', '345');
insert into address(country, city, street, author_id) values('korea', 'seoul', 'sindabang2', (select id from author order by id desc limit 1));

-- 글쓰기
-- 최초 생성자
insert into post(title, contents) values('hello1', 'hello1 world is ...');
insert into author_post_list(author_id, post_id) values(1, (select id from post order by id desc limit 1));
-- 추후 참여자
-- update ...
-- insert into author_post_list values(1, 2);

-- 글 전체 목록 조회하기 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select 쿼리 생성
select p.title, p.contents, a.name from post p inner join author_post_list ap on p.id=ap.post_id inner join author a on a.id=ap.author_id; 

-- 테이블 생성
create table user(id bigint auto_increment primary key, name varchar(255) not null, address varchar(255) not null unique, tel varchar(255) not null);
create table order_table(id bigint auto_increment primary key, user_id bigint not null, foreign key(user_id) references user(id));
create table product(id bigint auto_increment primary key, user_id bigint not null, product varchar(255) not null, price bigint not null, stock bigint not null, foreign key(user_id) references user(id));
create table order_list_table(id bigint auto_increment primary key, order_id bigint not null, product_id bigint not null, num bigint not null, foreign key(order_id) references order_table(id), foreign key(product_id) references product(id));
alter table user add column role enum('buyer','seller') not null default 'buyer';

-- 회원가입
insert into user(name, address, tel, role) values('a','abc','123','seller');
insert into user(name, address tel) values('d','def','456');

-- 주문하기
insert into order_table(user_id) values (7);
insert into order_list_table(order_id, product_id, num, ordered_price) values((select id from order_table order by id desc limit 1), 7, 3, (select price from product where id='7'));
update product set stock='6' where id='7';

-- 상품 정보 조회 (상품 이름, 가격, 재고, 판매자 이름)
select p.product, p.price, p.stock, u.name from user u inner join product p on u.id=p.user_id;
-- 주문 정보 조회 (구매자 이름, 구매한 상품, 구매 수량)
select u.name, p.product, olt.num from order_table ot inner join order_list_table olt on olt.order_id=ot.id inner join user u on u.id=ot.user_id inner join product p on p.id=olt.product_id where ot.user_id=4 and ot.id=1;