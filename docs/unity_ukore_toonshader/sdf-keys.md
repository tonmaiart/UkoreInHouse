# Key เงา SDF บนหน้า (ต่อ Sequence)

เงาบนหน้าของ Kafka ไม่ได้ตามแสงในฉากแล้ว คนทำ lookdev ต้อง key เองใน Timeline โดยแต่ละ sequence (ETA, KBA) มี object เดียวให้ key ตลอดทั้ง sequence

Key เก็บแยกไว้ในไฟล์ของ sequence เอง ถ้านักแอนิเมตส่ง animation เวอร์ชันใหม่มาแล้ว import ใหม่ key ก็ยังอยู่ และเงาก็ยังเหมือนเดิม

เปิดใช้: ใน Unity เปิด scene ของ sequence (`Assets/Timeline/ETA/ETA_scene.unity` หรือ `Assets/Timeline/KBA/KBA.unity`) แล้วเลือก `ETA_Timeline` / `KBA_Timeline` ใน Hierarchy เพื่อเปิด Timeline

## มีอะไรบ้าง

1. **Object `FacialLight`** ใน Hierarchy: ตัวที่ใช้ key เงา ใน Inspector ส่วน `SDF Face Light Driver` มีช่องที่ key ได้ 3 ช่อง
   - **Angle** คือแสงมาจากทางไหนเทียบกับหน้า
     - `0` = ตรงหน้า (หน้าสว่างหมด)
     - `90` / `-90` = มาจากด้านข้าง (คนละข้างกัน)
     - `180` = มาจากด้านหลัง
   - **Offset** เลื่อนขอบเงาเข้าหรือออก
   - **Scale** ความกว้างของช่วงที่เงาเปลี่ยน
2. **Track `Kafka SDF`** ใน Timeline: มี clip เดียวชื่อ `ETA_SDF` / `KBA_SDF` ยาวตั้งแต่ต้นจนจบ sequence
3. **ไฟล์ key** อยู่ที่ `Assets/Lookdev/SDF/ETA/ETA_Kafka_SDF.anim` และ `Assets/Lookdev/SDF/KBA/KBA_Kafka_SDF.anim`

## กฎที่ห้ามพลาด

- **เงาไม่หมุนตามหัวเองแล้ว** ถ้า Kafka หันหัวแล้วอยากให้เงาเปลี่ยน ต้อง key Angle เอง
- **Key อยู่ที่เฟรมของ Timeline** ถ้ามีคนย้ายหรือยืดหด shot บน Timeline เอง ต้องย้าย key ตามด้วย (การ import animation ใหม่ไม่ย้ายจุดเริ่มของ shot)
- **อย่าลบหรือย้ายไฟล์ใน `Assets/Lookdev/SDF`** ไฟล์พวกนี้คืองานที่ key ไว้

## วิธี key

1. เปิด scene แล้วเลือก Timeline ตามด้านบน
2. กดปุ่ม Record (วงกลมแดง) ที่ track `Kafka SDF`
3. เลื่อนหัวอ่านไปเฟรมที่ต้องการ แล้วเลือก `FacialLight` และแก้ **Angle** / **Offset** / **Scale** ใน Inspector ทุกครั้งที่แก้จะเกิด key ใหม่ที่เฟรมนั้น
4. กด Record อีกครั้งเพื่อหยุด แล้วกด Save
5. ถ้าอยากปรับละเอียด ให้ดับเบิลคลิก clip แล้วแก้ curve ใน Curve Editor

ตอนตั้งระบบนี้ (23 พ.ย. 2026) ต้นทุก shot มี key ที่ค้างค่าไว้จนถึง shot ถัดไป ค่านั้นทำให้เฟรมแรกของแต่ละ shot ออกมาเหมือนเงาที่ render ไว้เดิม จะแก้หรือเพิ่ม key ตรงไหนก็ได้

## ระบบทำอะไรให้เอง

- ตอนกด Update Timelines, Start Import และ Start Recorder ใน Shot Importer: clip `ETA_SDF` / `KBA_SDF` จะยืดให้ยาวถึงจบ shot สุดท้ายเสมอ โดย key ข้างในไม่เปลี่ยน
- Shot ใหม่ใน sequence ไม่ต้องทำอะไรเพิ่ม clip ครอบคลุมให้เอง

## เจอปัญหา?

| อาการ | ทำแบบนี้ |
| --- | --- |
| ไม่มี track `Kafka SDF` หรือ clip หาย | เปิด scene ของ sequence แล้วกด **SDF Clips** ใน Shot Importer |
| clip SDF ไม่ยาวถึงจบ sequence | กด **Update Timelines** ใน Shot Importer |
| เงาไม่เปลี่ยนตอนหันหัว | ต้อง key **Angle** เองในช่วงที่หันหัว |
| หน้าสว่างหมดหรือมืดหมด | ดูค่า **Angle** (ใกล้ 0 = สว่างหมด, ใกล้ 180 = มืดหมด) และ **Scale** |
