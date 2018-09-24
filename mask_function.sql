--Author: Marek Martofel, Pivotal

CREATE OR REPLACE FUNCTION mask (OrigVal VARCHAR)
RETURNS VARCHAR

AS $$
DECLARE 
   NewVal VARCHAR ='';
   OrigLen INT;
   LoopCt INT = 1;
   Part VARCHAR = '';
   PartLength INT;     -- MaskLength
   PartStartIndex INT; -- MaskStartIndex

BEGIN
OrigLen := length(OrigVal);

IF OrigLen = 1 THEN
        RETURN 'X';
END IF;

IF OrigLen = 2 THEN
        RETURN 'XX';
END IF;

IF OrigLen = 3 THEN
        PartStartIndex = 2;
        PartLength = OrigLen - 1;
        Part = SUBSTRING(OrigVal, PartStartIndex, PartLength);
END IF;

IF OrigLen BETWEEN 4 AND 8 THEN
        PartStartIndex = 2;
        PartLength = OrigLen - 2;
        Part = SUBSTRING(OrigVal, PartStartIndex, PartLength);
END IF;

IF OrigLen BETWEEN 9 AND 11 THEN
        PartStartIndex = 3;
        PartLength = OrigLen - PartStartIndex - 1;
        Part = SUBSTRING(OrigVal, PartStartIndex, PartLength);
END IF;

IF OrigLen > 11 THEN
        PartStartIndex = 4;
        PartLength = OrigLen - PartStartIndex - 2;
        Part = SUBSTRING(OrigVal, PartStartIndex, PartLength);
END IF;

WHILE LoopCt <= PartLength LOOP
        NewVal := NewVal || 'X';
        LoopCt := LoopCt + 1;
END LOOP;
    RETURN replace(OrigVal, Part, NewVal);
END
$$
LANGUAGE 'plpgsql';

drop view secret_data_masked;
drop table secret_data;
create table secret_data (id int, name varchar(20), mobile varchar(20));
insert into secret_data values (1,'Marek','+');
insert into secret_data values (2,'Marek','+4');
insert into secret_data values (3,'Marek','+48');
insert into secret_data values (4,'Marek','+486');																   
insert into secret_data values (5,'Marek','+4866');																   
insert into secret_data values (6,'Marek','+48661');
insert into secret_data values (7,'Marek','+486619');
insert into secret_data values (8,'Marek','+4866196');
insert into secret_data values (9,'Marek','+48661966');
insert into secret_data values (10,'Marek','+486619660');
insert into secret_data values (11,'Marek','+4866196608');
insert into secret_data values (12,'Marek','+486619660801');
insert into secret_data values (13,'Marek','+4866196608012');
insert into secret_data values (14,'Marek','+48661966080123');
insert into secret_data values (15,'Marek','+486619660801234');
insert into secret_data values (16,'Marek','+4866196608012345');
create or replace view secret_data_masked as (select id as id, mask(name) as name, mask(mobile) as mobile from secret_data);

select * from secret_data order by id;
select * from secret_data_masked order by id;

-- 1	"MXXXk"	"X"
-- 2	"MXXXk"	"XX"
-- 3	"MXXXk"	"+XX"
-- 4	"MXXXk"	"+XX6"
-- 5	"MXXXk"	"+XXX6"
-- 6	"MXXXk"	"+XXXX1"
-- 7	"MXXXk"	"+XXXXX9"
-- 8	"MXXXk"	"+XXXXXX6"
-- 9	"MXXXk"	"+4XXXXX66"
-- 10	"MXXXk"	"+4XXXXXX60"
-- 11	"MXXXk"	"+4XXXXXXX08"
-- 12	"MXXXk"	"+48XXXXXXX801"
-- 13	"MXXXk"	"+48XXXXXXXX012"
-- 14	"MXXXk"	"+48XXXXXXXXX123"
-- 15	"MXXXk"	"+48XXXXXXXXXX234"
-- 16	"MXXXk"	"+48XXXXXXXXXXX345"
