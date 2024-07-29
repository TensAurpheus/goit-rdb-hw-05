select *, (select customer_id from orders where id = order_details.order_id) as customer_id
from order_details;

select * from order_details
where (select shipper_id from orders where id = order_details.order_id) = 3;

select order_id, avg(quantity) as avg_qnt
from (select * from order_details where quantity > 10) as temp 
group by order_id;

with Temp as (
	select * from order_details where quantity > 10)
select order_id, avg(quantity) as avg_qnt
from Temp
group by order_id;

drop function if exists divide;
delimiter //

create function divide(num float, den float)
returns float
deterministic
no sql
begin
	declare result float;
    set result = num / den;
    return result;
end //

delimiter ;

with product_qnts as (
	select product_id, max(quantity) as max_qnt 
    from order_details 
    group by product_id)
select order_id, product_id, divide(
	quantity, (
		select max_qnt 
        from product_qnts 
        where product_qnts.product_id = order_details.product_id))
as perc_of_product
from order_details; 




