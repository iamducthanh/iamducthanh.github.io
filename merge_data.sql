DROP FUNCTION IF EXISTS mergeData;
CREATE OR REPLACE FUNCTION mergeData ( 
    IN tableTarget VARCHAR, -- bảng nguồn
    IN colMerge1 VARCHAR, -- cột cần thao tác thứ nhất
    IN colMerge2 VARCHAR, -- cột cần thao tác thứ hai
    IN tableSoucre VARCHAR, -- bảng đích
		IN colTarget VARCHAR, -- cột đích của dữ liệu mới
		IN colOther VARCHAR, -- các cột còn lại
		IN operator VARCHAR
 		,VARIADIC colMerges VARCHAR[]
) 
RETURNS BOOLEAN AS $$ 
		DECLARE passed BOOLEAN DEFAULT TRUE;
 		DECLARE newValue VARCHAR;
--		DECLARE r staff%rowtype;
		DECLARE col VARCHAR;
		DECLARE size INTEGER;
BEGIN
-- 		raise notice 'colMerges: %', colMerges[1];
--  		FOR r IN EXECUTE 'SELECT ' || colMerge1 || ' FROM staff'
-- --     LOOP
				size:= SELECT "length" FROM (colMerges);

				
        raise notice 'colMerges: %', size;

--     END LOOP;

-- 		FOR col IN colMerges
--      LOOP
--         raise notice 'colMerges: %', col;
--      END LOOP;
		
		if operator = '/' OR operator = '*' OR operator = '+' OR operator = '-' then
				EXECUTE 
						'INSERT INTO ' || tableTarget || '(' || colTarget || colOther || ') (SELECT ' || colMerge1 || operator 						|| colMerge2 || colOther ||' FROM ' || tableSoucre || ')';
			
		elsif operator = ' ' then
			   EXECUTE 
						'INSERT INTO ' || tableTarget || '(' || colTarget || colOther || ') (SELECT concat(' || colMerge1 || ',' 						|| colMerge2 || ')' || colOther ||' FROM ' || tableSoucre || ')';
		end if;

    RETURN passed;

END;
$$ LANGUAGE plpgsql;

SELECT mergeData ( 
	'"customer"', -- bảng nguồn
	'"lastname"', -- cột cần thao tác thứ nhất
	'"firstname"', -- cột cần thao tác thứ hai
	'"staff"', -- bảng đích
	'"fullname"', -- cột đích của dữ liệu mới
	',"phone", "delete_flag", "email"', -- các cột còn lại
	' '  
	,'lastname', 'firstname'
) 