# Anual sales data from "xxx" company

เป็น project ที่ใช้ data จริงซึ่งเป็น annual sales ของบริษัทแห่งนึง ที่ต้องทำข้อมูลสรุปรายงานการขายประจำปีและประจำเดือนทุกครั้ง โดยผู้เขียนขอเข้าไปช่วยให้ความรู้และทำให้การใส่ข้อมูลเป็นระบบมากขึ้น รวมถึงสามารถ "pivot" ข้อมูลเพื่อดู insight และสร้าง dashboard ที่สามารถเลือกดูข้อมูลตามที่ต้องการได้

## From "Dirty" to "Clean" data

**From this**

![original data](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/original.png)

**To this**

![prep_data](https://raw.githubusercontent.com/Thanyanon/datascience_project/main/spreadsheet/annual_sales_report/prep_data.png)

### Clean data และทำความเข้าใจกับ user เกี่ยวกับ data ที่มีอยู่ เช่น

  - Missing data ที่หายไปเกิดจากอะไร ทำไมถึงไม่ได้ใส่
  - สีที่อยู่ในแต่ละ row หมายความว่าอะไร
  
พบว่า

  - Date column: cell ที่ว่างอยู่หมายถึง date เดียวกัน
  - Product column: 1 rows มี Qty ของ product ชนิดนั้นมากกว่า 1 Qty โดยไม่สามารถรวมเป็น 3 Qty ได้ เพราะว่าวันที่ส่งของของแต่ละตัวอาจจะไม่ตรงกัน
  
### Clean data โดย

  - Create a copy of fact table
  - Clear all format
  - Delete unused columns
  - เปลี่ยน data type ของแต่ละ columns ให้ถูกต้อง
  - Fill missing date ด้วย date ของ cell ที่อยู่ด้านบน
  - เปลี่ยน date columns ให้เป้น date type และเป็น ISO format

### Add new columns

  - เพิ่ม qty columns ที่แสดงถึงจำนวน products ที่ถูกซื้อในแต่ละ PO โดยแบ่งตามวันส่งของหรือ delivery date
  
## Start building data model

เนื่องจาก user ไม่ได้มี CRM platform และ database ใช้เลย และยังไม่มีงบประมาณในส่วนนี้เร็วๆนี้ จึงแนะนำให้เริ่มจากการใส่ข้อมูล product, customers และ sales ลงไปใน data model ก่อน ซึ่งสะดวกต่อการเพิ่มข้อมูลในอนาคต
  
### Create Dimension table

สร้าง dimension table ของ product และ customer โดย ปรึกษากับ user ว่ามีข้อมูลอะไรบ้างเกี่ยวกับตัว dimension table ที่ต้องการสร้าง โดย

- product และ customers table user ได้บอกว่ามีข้อมูลในส่วนของ "ประเภท" ของ product และ cusomers อยู่ จึงใส่เข้าไปก่อนเป็นอันดับแรก โดยส่วนที่ต้องการเพิ่มเติมจะใส่ให้เป็นชื่อ columns ไว้ให้ แล้วให้ user ไปใส่ data เพิ่มเติม
- sales dimension ประกอบด้วย ชื่อ, ตำแหน่ง และพื้นที่ที่รับผิดชอบ

process การสร้าง dimension table

  - use `unique()` to get all unique product or customers data from fact table
  - create id column
  - Insert "type" column

**Product Dimension Table**

![product_dimension](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/product_dimension.png)

### Deal with fact table

- เปลี่ยนข้อมูลใน fact table ในส่วนของ customer และ product จากชื่อเป็น id
- เพิ่ม columns sale_id

ได้ fact table ตามภาพด้านล่าง

![prep_data](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/prep_data.png)

### Create a 
