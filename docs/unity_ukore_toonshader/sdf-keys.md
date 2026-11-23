# Key เงา SDF บนหน้า (ต่อ Shot)

เงาบนหน้าของ Kafka ไม่ได้ตามแสงในฉากแล้ว คนทำ lookdev ต้อง key เองใน Timeline ของแต่ละ shot

Key ของแต่ละ shot เก็บอยู่ในไฟล์ของ shot นั้นเอง ถ้านักแอนิเมตส่ง animation เวอร์ชันใหม่มาแล้ว import ใหม่ key ก็ยังอยู่ และเงาก็ยังเหมือนเดิม

เปิดใช้: ใน Unity เปิด scene ของ sequence (`Assets/Timeline/ETA/ETA_scene.unity` หรือ `Assets/Timeline/KBA/KBA.unity`) แล้วเลือก `ETA_Timeline` / `KBA_Timeline` ใน Hierarchy เพื่อเปิด Timeline

## มีอะไรบ้าง

1. **Track `Kafka SDF`** ใน Timeline: มี clip ชื่อ `{Shot}_SDF` (เช่น `ETA040_SDF`) อยู่ตรงกับกล้องของ shot นั้นพอดี
2. **Object `FacialLight`** ใน Hierarchy: เป็นตัวที่ track นี้ควบคุม ใน Inspector มีช่องที่ key ได้ 3 ช่องในส่วน `SDF Face Light Driver`
   - **Angle** คือแสงมาจากทางไหนเทียบกับหน้า
     - `0` = ตรงหน้า (หน้าสว่างหมด)
     - `90` / `-90` = มาจากด้านข้าง (คนละข้างกัน)
     - `180` = มาจากด้านหลัง
   - **Offset** เลื่อนขอบเงาเข้าหรือออก
   - **Scale** ความกว้างของช่วงที่เงาเปลี่ยน
3. **ไฟล์ key** อยู่ที่ `Assets/Lookdev/SDF/{SEQ}/{Shot}_Kafka_SDF.anim` หนึ่งไฟล์ต่อหนึ่ง shot

## กฎที่ห้ามพลาด

- **เงาไม่หมุนตามหัวเองแล้ว** ถ้า Kafka หันหัวแล้วอยากให้เงาเปลี่ยน ต้อง key Angle เอง
- **อย่าลบหรือย้ายไฟล์ใน `Assets/Lookdev/SDF`** ไฟล์พวกนี้คืองานที่ key ไว้ ระบบจะไม่สร้างทับให้

## วิธี key

1. เปิด scene แล้วเลือก Timeline ตามด้านบน
2. กดปุ่ม Record (วงกลมแดง) ที่ track `Kafka SDF`
3. เลื่อนหัวอ่านไปเฟรมที่ต้องการ แล้วเลือก `FacialLight` และแก้ **Angle** / **Offset** / **Scale** ใน Inspector ทุกครั้งที่แก้จะเกิด key ใหม่ที่เฟรมนั้น
4. กด Record อีกครั้งเพื่อหยุด แล้วกด Save
5. ถ้าอยากปรับละเอียด ให้ดับเบิลคลิก clip แล้วแก้ curve ใน Curve Editor

ตอนตั้งระบบนี้ (23 พ.ย. 2026) ทุก shot มี key เริ่มต้นหนึ่งตัวที่เฟรมแรก ซึ่งทำให้เฟรมแรกออกมาเหมือนเงาที่ render ไว้เดิม

## ระบบทำอะไรให้เอง

- **Shot ยาวขึ้นหรือสั้นลง** หลัง import animation ใหม่: clip `{Shot}_SDF` จะขยับตามกล้องเอง ตอนกด Update Timelines, Start Import และ Start Recorder ใน Shot Importer โดย key ข้างในไม่เปลี่ยน
  - key นับจากต้น shot เสมอ
  - ถ้า shot ยาวขึ้น ค่าสุดท้ายจะค้างไว้จนจบ
- **Shot ใหม่**: เปิด scene ของ sequence แล้วกดปุ่ม **SDF Clips** ใน Shot Importer ระบบจะเพิ่ม clip ให้ shot ที่ยังไม่มี และจะไม่แตะ shot ที่ key ไว้แล้ว

## เจอปัญหา?

| อาการ | ทำแบบนี้ |
| --- | --- |
| Shot ใหม่ไม่มี clip `{Shot}_SDF` | เปิด scene ของ sequence แล้วกด **SDF Clips** ใน Shot Importer |
| clip SDF สั้นหรือยาวไม่เท่ากล้อง | กด **Update Timelines** ใน Shot Importer |
| เงาไม่เปลี่ยนตอนหันหัว | ต้อง key **Angle** เองในช่วงที่หันหัว |
| หน้าสว่างหมดหรือมืดหมดทั้ง shot | ดูค่า **Angle** (ใกล้ 0 = สว่างหมด, ใกล้ 180 = มืดหมด) และ **Scale** |
