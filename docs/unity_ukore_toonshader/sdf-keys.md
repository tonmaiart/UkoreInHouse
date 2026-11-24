# Key เงา SDF บนหน้า (ต่อ Sequence)

เงาบนหน้าของ Kafka ไม่ได้ตามแสงในฉากแล้ว คนทำ lookdev ต้อง key เองใน Timeline โดยแต่ละ sequence (ETA, KBA) มี object เดียวให้ key ตลอดทั้ง sequence

Key เก็บแยกไว้ในไฟล์ของ sequence เอง ถ้านักแอนิเมตส่ง animation เวอร์ชันใหม่มาแล้ว import ใหม่ key ก็ยังอยู่ และเงาก็ยังเหมือนเดิม

เปิดใช้: ใน Unity เปิด scene ของ sequence (`Assets/Timeline/ETA/ETA_scene.unity` หรือ `Assets/Timeline/KBA/KBA.unity`) แล้วเลือก `ETA_Timeline` / `KBA_Timeline` ใน Hierarchy เพื่อเปิด Timeline

## มีอะไรบ้าง

1. **Object `FacialLight`** ใน Hierarchy: ตัวที่ใช้ key เงา ใน Inspector ส่วน `SDF Face Light Driver` ตั้ง Effect Source เป็น `None` (ไม่วัดแสงหรือมุมอะไรเลย) มีช่องที่ key ได้ 2 ช่อง
   - **Left Shadow** เงาที่เข้ามาจากขอบหน้าฝั่งซ้ายของตัวละคร (ซ้ายของ Kafka เอง ไม่ใช่ซ้ายของจอ)
   - **Right Shadow** เงาที่เข้ามาจากขอบหน้าฝั่งขวาของตัวละคร
     - `0` = ไม่มีเงาจากฝั่งนั้น, `0.5` = เงาเข้ามาถึงกลางหน้า, `1` = เงาทั้งหน้า
     - **เงาสองฝั่งคูณกัน (multiply)** ตรงไหนโดนเงาฝั่งใดฝั่งหนึ่งก็มืด เลื่อนสองช่องข้ามกันได้โดยไม่มีแสงฝั่งไหนไปทับเงาอีกฝั่ง
     - ทั้งสองช่องเป็น `0` = หน้าสว่างหมด, รวมกันตั้งแต่ `1` ขึ้นไป (เช่น 0.6 + 0.4) = หน้ามืดหมด
     - หน้าผาก ข้างหัว หู และคอ มืดสว่างตามสองช่องนี้ด้วย ไม่ได้ตามไฟในฉาก
2. **Track `Kafka SDF`** ใน Timeline: มี clip เดียวชื่อ `ETA_SDF` / `KBA_SDF` ยาวตั้งแต่ต้นจนจบ sequence
3. **ไฟล์ key** อยู่ที่ `Assets/Lookdev/SDF/ETA/ETA_Kafka_SDF.anim` และ `Assets/Lookdev/SDF/KBA/KBA_Kafka_SDF.anim`

## กฎที่ห้ามพลาด

- **เงาไม่หมุนตามหัวเองแล้ว** ถ้า Kafka หันหัวแล้วอยากให้เงาเปลี่ยน ต้อง key Left Shadow / Right Shadow เอง ให้ฝั่งที่มืดอยู่ตรงข้ามกับทิศไฟในฉาก (ดูจากผมกับตัว)
- **Key อยู่ที่เฟรมของ Timeline** ถ้ามีคนย้ายหรือยืดหด shot บน Timeline เอง ต้องย้าย key ตามด้วย (การ import animation ใหม่ไม่ย้ายจุดเริ่มของ shot)
- **อย่าลบหรือย้ายไฟล์ใน `Assets/Lookdev/SDF`** ไฟล์พวกนี้คืองานที่ key ไว้

## วิธี key

1. เปิด scene แล้วเลือก Timeline ตามด้านบน
2. กดปุ่ม Record (วงกลมแดง) ที่ track `Kafka SDF`
3. เลื่อนหัวอ่านไปเฟรมที่ต้องการ แล้วเลือก `FacialLight` และแก้ **Left Shadow** / **Right Shadow** ใน Inspector ทุกครั้งที่แก้จะเกิด key ใหม่ที่เฟรมนั้น
4. กด Record อีกครั้งเพื่อหยุด แล้วกด Save
5. ถ้าอยากปรับละเอียด ให้ดับเบิลคลิก clip แล้วแก้ curve ใน Curve Editor

ตอนตั้งระบบนี้ (23 พ.ย. 2026) ต้นทุก shot มี key หนึ่งตัว (ตั้งแต่ 24 พ.ย. ทุก key เป็นแบบ Linear คือเงาเลื่อนด้วยความเร็วคงที่จาก key หนึ่งไปอีก key ถ้าอยากให้เปลี่ยนทันทีตรงไหน ให้คลิกขวาที่ key ใน Curve Editor แล้วเลือก Both Tangents > Constant) ค่านั้นทำให้เฟรมแรกของแต่ละ shot ออกมาเหมือนเงาที่ render ไว้เดิม จะแก้หรือเพิ่ม key ตรงไหนก็ได้ (24 พ.ย. 2026 เปลี่ยนจาก Angle มาเป็น Left Shadow / Right Shadow โดยแปลงค่าให้หน้าตาใกล้เคียงเดิม หลาย shot ใน KBA เป็น 1 ทั้งสองช่องคือหน้ามืดหมด ควร key ใหม่ด้วยตา)

## ระบบทำอะไรให้เอง

- ตอนกด Update Timelines, Start Import และ Start Recorder ใน Shot Importer: clip `ETA_SDF` / `KBA_SDF` จะยืดให้ยาวถึงจบ shot สุดท้ายเสมอ โดย key ข้างในไม่เปลี่ยน
- Shot ใหม่ใน sequence ไม่ต้องทำอะไรเพิ่ม clip ครอบคลุมให้เอง

## เจอปัญหา?

| อาการ | ทำแบบนี้ |
| --- | --- |
| ไม่มี track `Kafka SDF` หรือ clip หาย | เปิด scene ของ sequence แล้วกด **SDF Clips** ใน Shot Importer |
| clip SDF ไม่ยาวถึงจบ sequence | กด **Update Timelines** ใน Shot Importer |
| กด Record แล้วขึ้น "This clip is not recordable" | กด **Update Timelines** หรือ **SDF Clips** ใน Shot Importer หนึ่งครั้ง แล้ว Record ใหม่ |
| เงาไม่เปลี่ยนตอนหันหัว | ต้อง key **Left Shadow** / **Right Shadow** เองในช่วงที่หันหัว |
| หน้ามืดหมด | สองช่องรวมกันถึง 1 แล้ว ลดฝั่งที่ไฟส่องมาลง |
| หน้าดูเหมือนโดนไฟสองทาง | มีเงาเข้ามาทั้งสองฝั่ง หรือฝั่งที่มีเงาไม่ตรงกับไฟที่ผมและตัว ให้เหลือเงาแค่ฝั่งตรงข้ามกับไฟ |
