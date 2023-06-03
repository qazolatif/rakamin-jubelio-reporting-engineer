INSERT INTO public."Q3_Q4_Review"
SELECT 
	sales_table.purchase_date, 
	sales_table.quantity*marketplace_table.price as total_price, 
	promo_code.promo_name,
	sales_table.quantity*marketplace_table.price-promo_code.price_deduction as price_after_promo
from sales_table
	left join marketplace_table on sales_table.item_id=marketplace_table.item_id
	left join promo_code on CAST(promo_code.promo_id AS INT)=sales_table.promo_id
where sales_table.purchase_date>='2022-07-01' and sales_table.purchase_date<='2022-12-31'
order by purchase_date

INSERT INTO shipping_summary
select 
	shipping_table.shipping_date,
	seller_table.seller_name,
	buyer_table.buyer_name,
	buyer_table.address as buyer_address,
	buyer_table.city as buyer_city,
	buyer_table.zipcode as buyer_zipcode,
	concat(shipping_table.shipping_id, 
		   to_char(shipping_table.purchase_date, 'YYYYMMDD'),
		   to_char(shipping_table.shipping_date, 'YYYYMMDD'),
		   buyer_table.buyer_id,
		   seller_table.seller_id) as kode_resi
from shipping_table
	inner join seller_table on shipping_table.seller_id=seller_table.seller_id
	inner join buyer_table on shipping_table.buyer_id=buyer_table.buyer_id
