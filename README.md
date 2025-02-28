"My first commit"
commands rules (tokenized):
-Commands are tokenized using space character delimiter.
-Text inside double quotes are not tokenized.
-Date is always in dd/MM/yyyy format.
-[commands_here]+ means the commands inside square bracket can be repeated once or more time.

commands rules (JSON):
-Date is in dd/MM/yyyy format

commands list:
1. Add a new inventory:
   -format: 1 Product_name item_code selling_price ENDCMD
   -example: 1 "my Product" COD111 100.00 ENDCMD
   -json:
   {
   "main_command": 1,
   "product_name": string,
   "item_code": string,
   "price": double
   }
   -response:
   {
   "status": bool,
   "body": {}
   }

2. Purchase inventory:
   -format: 2 date seller_name [item_db price_each qty]+ paid_cash ENDCMD
   -example: 2 10/10/2024 Orange INV000001 90 100 INV000002 80 100 15000 ENDCMD
   -json:
   {
   "main_command": 2,
   "date": string,
   "seller": string,
   "items": [
   {
   "dbcode": string,
   "price": double,
   "qty": int
   },
   ],
   "paid_cash": double
   }
   -response:
   {
   "status": bool,
   "body": {}
   }

3. Purchase assets:
   -format: 3 date eq_name item_code cost residual yr_useful paid_cash ENDCMD
   -example: 3 10/10/2024 Car "" 12000 1000 10 12000 ENDCMD
   -json:
   json:
   {
   "main_command": 3,
   "date": string,
   "name": string,
   "item_code": string,
   "cost": double,
   "residual_value": double
   "useful_life": int,
   "paid_cash": double
   }
   -response:
   {
   "status": bool,
   "body": {}
   }

4. Capitalize assets:
   -format: 4 date db_code capt_amt paid_cash ENDCMD
   -example: 4 10/10/2024 EQP000001 2500 0 ENDCMD
   -json:
   {
   "main_command": 4,
   "date": string,
   "dbcode": string
   "cost": double,
   "paid_cash": double
   }
   -response:
   {
   "status": bool,
   "body": {}
   }

5. Sell inventory:
   -format: 5 date [db_code qty]+ paid_cash ENDCMD
   -example: 5 10/10/2024 INV000002 50 0 ENDCMD
   -json:
   {
   "main_command": 5,
   "date": string,
   "items": [
   {
   "dbcode": string,
   "qty": int
   },
   ],
   "paid_cash": double
   }
   -response:
   {
   "status": bool,
   "body": {}
   }

6. Sell assets:
   -format: 6 date db_code price paid_cash ENDCMD
   -example: 6 11/11/2024 EQP000002 5000 5000 ENDCMD
   -json:
   {
   "main_command": 6,
   "date": string,
   "dbcode": string,
   "price": double,
   "paid_cash": double,
   }
   -response:
   {
   "status": bool,
   "body": {}
   }

7. End of year adjustment:
   -format: 7 ENDCMD
   -example: 7 ENDCMD
   -json:
   {
   "main_command": 7
   }
   -response:
   {
   "status": bool,
   "body": {}
   }
8. Inventory information:
   -format: 8 ENDCMD
   -json:
   {
   "main_command": 8
   }
   -response:
   {
   "status": bool,
   "body":
   {
   "data":
   [
   {
   "dbcode": string,
   "item_code": string,
   "name": string,
   "price": double,
   },

   ]
   }
   }
9. Assets information:
   -format: 9 ENDCMD
   -json:
   {
   "main_command": 9
   }
   -response:
   {
   "status": bool,
   "body":
   {
   "data":
   [
   {
   "dbcode": string,
   "name": string,
   "cost": double,
   "residual_value": double,
   "book_value": double
   "useful_life": int,
   "date_purchased": dd/MM/yyyy,
   "last_depreciation_date": dd/MM/yyyy
   },

   ]
   }
   }
