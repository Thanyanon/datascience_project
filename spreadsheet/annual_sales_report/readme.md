# Annual Sales Analysis and Dashboard from xxCompany Data Using a Pivot Table and a Pivot Chart 

เป็น project ที่ใช้ data จริงซึ่งเป็น annual sales ของบริษัทแห่งนึง ที่ต้องทำข้อมูลสรุปรายงานการขายประจำปีและประจำเดือนทุกครั้ง โดยผู้เขียนขอเข้าไปช่วยให้ความรู้และทำให้การใส่ข้อมูลเป็นระบบมากขึ้น รวมถึงสามารถ "pivot" ข้อมูลเพื่อดู insight และสร้าง dashboard ที่สามารถเลือกดูข้อมูลตามที่ต้องการได้

## From "Dirty" to "Clean" data

**From this**

![original data](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/original.png)

**To this**

![prep_data](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/prep_data.png)
![pivot_si](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/pivot_si.png)
![bi_page1](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/bi_page1.png)
![bi_page2](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/bi_page2.png)

## Content

- Understanding User requirement
- Data preparation
- Start building data model
- Analyze the data
- Create a dashboard

## Understanding User requirement

**Requirement**

  - User ต้องการสร้าง dashboard เพื่อนำไปประกอบการนำเสนอตอนประชุม sales meeting
  - สอบถามเรื่อง data พบว่า user ไม่มี database และ CRM platfrom จึงเสนอให้เริ่มจากทำผ่าน excel เนื่องจากจำนวนข้อมูลยังไม่เยอะ โดยจะใช้ data model เป็นตัวช่วย
  - ทำ data analysis เบื้องต้นจาก data ที่มีอยู่ด้วย pivot table และสร้าง dashboard ด้วย power bi เพื่อดูว่าเราจะพบ insight อะไรได้บ้าง

**Data understanding**

  - Missing data ที่หายไปเกิดจากอะไร ทำไมถึงไม่ได้ใส่
  - สีที่อยู่ในแต่ละ row หมายความว่าอะไร
  
พบว่า

  - **Date column:** cell ที่ว่างอยู่หมายถึง date เดียวกัน
  - **Product column:** Rows ที่เป็นสีเดียวกันหมายถึงเป็น PO เดียวกัน โดยแต่ละ PO อาจมีจำนวนการสั่งซื้อ หรือ Qty ของ product ชนิดนั้นมากกว่า 1 Qty แต่ไม่สามารถรวมเข้าด้วยกันได้ เพราะว่าวันที่ส่งของของแต่ละตัวอาจจะไม่ตรงกัน อาจจะต้องแก้ปัญหาด้วยการเพิ่ม column po และ delivery_date
  
## Data preparation

### Clean data

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

**Example of dimension table :Product Dimension Table**

![product_dimension](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/product_dimension.png)

### Deal with fact table

- เปลี่ยนข้อมูลใน fact table ในส่วนของ customer และ product จากชื่อเป็น id
- เพิ่ม columns sale_id

ได้ fact table ตามภาพด้านล่าง

![prep_data](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/prep_data.png)

### Create a relationship

สร้าง relation ship ของ fact table กับ dimension table โดยใช้ columns id เป็น key

![diagram](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/diagram.png)

## Analyze the data

### Question

ปรึกษา user ว่าต้องการทราบข้อมูลอะไรบ้างจากข้อมูลยอดขายที่เรามีอยู่พบว่า user อยากทราบ

1. ยอดขายโดยรวมของแต่ละเดือนในปีที่สนใจ
2. ยอดสั่งซื้อของลูกค้าแต่ละคน
3. ยอดขายของแต่ละ product

## Create pivot table and dashboard

### Insight founded!!

สร้าง pivot table และ dashboard เพื่อหา insight จากข้อมูลตามโจทย์ที่ user ต้องการ โดยตัวอย่างข้อมูลที่สำคัญที่พบคือ

- ลูกค้าที่เป็น end user แบ่งออกเป็น 2 กลุ่มคือ กลุ่มที่ให้บริษัททำทั้ง solution และกล่มที่ซื้อ part ไปติดตั้งเอง โดยกลุ่มลูกค้าที่สร้างยอดขายให้กับได้สูงสุดคือ end user ที่ให้บริษัททำทั้ง solution
- กลุ่มลูกค้าที่เป็น SI และ Trader มีแนวโน้มที่จะซื้อ product เพียงแค่ชนิดเดียว ซึ่่งอาจจะเป็นสินค้าที่แข่งขันได้ของบริษัท


### Solution สำหรับกลุ่มลูกค้าที่เป็น SI

SI คือลูกค้าที่เป็น maker ซื้อของไปประกอบเป็น solution โดยซื้อกล้องเป็นอัตราส่วนที่สูงที่สุด ตามด้วย solution project เป็นอันดับที่ 2 และ software เป็นอันดับที่ 3 ซึ่งอาจจะเป็นเพราะราคาทีแข่งขันได้ของกล้อง และคุณสัมบัติพิเศษของ software ที่เป็นจุดแข็ง แต่ส่วนประกอบอื่นๆเช่น lens หรือ lighting ลูกค้าอาจจะซื้อจากคู่แข่งที่ถูกกว่า โดย solution ที่เสนอแบ่งเป็น 3 กรณี

1. ในกรณีที่วิเคราะห์แล้วว่าลูกค้าต้องการใช้คุณสมบัติพิเศษของกล้องร่วมกับ software จริงๆ อาจจะเสนอเป็น package รวมทั้งชุดกับลูกค้ากลุ่มนี้ เพื่อเพิ่มยอดขายของ lens และ lighting
2. ลูกค้าซื้อเพียงแต่กล้อง อาจจะหมายความว่าลูกค้ามีความสามารถในการทำ software เอง ให้เพิ่มส่วนลดของ lens และ lighting เมื่อซื้อร่วมกับกล้อง เพื่อเพิ่มโอกาสในการขาย lens และ lighting
3. กรณีที่ลูกค้าซื้อเพียงแต่ software แปลว่ามีกล้องอยู่แล้ว อาจจะเสนอ solution กล้องตัวใหม่ที่มีคุณสมบัติที่ดีกว่าไปกับ software เพื่อเพิ่มโอกาสในการขายกล้อง

![si](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/pivot_si.png)

### Solution สำหรับกลุ่มลูกค้าที่เป็น trader

จากข้อมูลพบว่า Trader มีการซื้อ lens ของเราเป็นอัตราส่วนที่สูงที่สุด ซึ่งส่วนใหญ่แล้วลูกค้าในกลุ่มนี้อาจจะแข่งขันด้านราคาเป็นหลัก ทำให้พบว่า lens ของเราสามารถแข่งขันด้านราคาได้ จึงเสนอให้ทำ catalog lens พร้อมกับส่วนลดแบบขั้นบันไดตามจำนวนการสั่งซื้อไปให้กับลูกค้าในกลุ่มที่เป็น trader ทั้งลูกค้าเก่าและใหม่

![trader](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/pivot_trader.png)

### Solution สำหรับกลุ่มลูกค้าที่เป็น end user

กลุ่มลูกค้าที่เป็น end user เป็นกลุ่มลูกค้าที่ควรหาเพิ่มมากที่สุดของบริษัท โดยกลุ่มที่ซื้อทั้ง solution จะได้ยอดขายที่สูง ส่วนกลุ่มที่ซื้อ part ไปจะซื้อของหลากหลายและไม่ต้องการ support เท่ากับกลุ่มที่ต้องการให้ทำให้ทั้ง solution อาจจะแนะนำให้ศึกษาลักษณะของลูกค้ากลุ่มนี้และให้ sale เข้าไปนำเสนอสินค้าของบริษัท

![enduser](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/pivot_enduser.png)

## Create a dashboard

สร้าง dashbaord ให้ตาม requirement ของ user อิงจาก pivot table ได้ dashboard ตามด้านล่าง

![bi_page1](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/bi_page1.png)
![bi_page2](https://github.com/Thanyanon/datascience_project/blob/main/spreadsheet/annual_sales_report/bi_page2.png)
