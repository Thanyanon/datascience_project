# Anual sales data from "xxx" company

เป็น project ที่ใช้ data จริงซึ่งเป็น annual sales ของบริษัทแห่งนึง ที่ต้องทำข้อมูลสรุปรายงานการขายประจำปีและประจำเดือนทุกครั้ง โดยผมขอเข้าไปช่วยทำให้การใส่ข้อมูลเป็นระบบมากขึ้น รวมถึงสามารถ "pivot" ข้อมูลเพื่อดู insight และสร้าง dashboard ที่สามารถเลือกดูข้อมูลตามที่ต้องการได้

## From "dirty" to "clean" data

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
  - Fill missing date ด้วย date ของ cell ที่อยู่ด้านบน
  - เปลี่ยน date columns ให้เป้น date type และเป็น ISO format
  
### Add new columns
  - เพิ่ม qty columns ที่แสดงถึงจำนวน products ที่ถูกซื้อในแต่ละ PO โดยแบ่งตามวันส่งของหรือ delivery date

Add new tables
  
