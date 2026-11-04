# Ukore Shot Importer

Shot Importer เป็นหน้าต่างใน Unity สำหรับดึงไฟล์ Shot ที่ Publish มาจาก Maya
(Animation, กล้อง, Texture ใบหน้า) เข้ามาในโปรเจกต์ทีละหลายๆ Shot พร้อมกัน
แต่ละแถวในตารางคือ 1 Shot เลือก Shot ที่ต้องการแล้วกด **Start Import** ได้เลย
นอกจากนี้ยังใช้ Render Shot ออกมาเป็นไฟล์วิดีโอ `.mp4` ได้ด้วย

**เปิดหน้าต่าง:** `UkoreHub > Shot Importer...` หรือ Tab **Shot Importer** ใน
`UkoreHub > UkoreHub Panel...`

!!! note "เดิมเคยอยู่ใน Asset Importer"
    Shot Importer เคยเป็น Step หนึ่งใน [Asset Importer](../unity_ukore_importer/quick-start.md)
    ตอนนี้แยกออกมาเป็นหน้าต่างของตัวเองแล้ว แต่ผลลัพธ์ที่ได้เหมือนเดิมทุกอย่าง
    ส่วนการเอา Shot ไปวางบน Timeline ยังใช้ Step **Add Shot to Timeline** ใน
    Asset Importer เหมือนเดิม

---

<a id="actor-folder"></a>

## ก่อนเริ่ม: ตัวละครและ Prop ต้องอยู่ที่ไหน

Shot Importer จะดูว่าไฟล์ Animation แต่ละไฟล์เป็นของใคร ด้วยการหา **ไฟล์ Model
ชื่อเดียวกัน** (เช่น Animation ของ `Kafka` → หา `Kafka.fbx`) และระบบจะหาเฉพาะใน
**2 Folder นี้เท่านั้น** ซึ่งตั้งตายตัวไว้ในโค้ด เปลี่ยนจากหน้าต่างไม่ได้

| Folder | ใช้กับ | ตัวอย่าง |
| --- | --- | --- |
| `Assets/SetupActor/Character` | ตัวละคร | `Assets/SetupActor/Character/Kafka/Fbx/Kafka.fbx` |
| `Assets/SetupActor/Prop` | Prop ที่มี Animation | `Assets/SetupActor/Prop/Jacob/Jacob.fbx` |

- จะวางไฟล์ไว้ใน Folder ย่อยกี่ชั้นก็ได้ เช่น `Kafka/Kafka.fbx` หรือ
`Kafka/Fbx/Kafka.fbx` ก็หาเจอเหมือนกัน
- ไฟล์ที่อยู่**นอก** 2 Folder นี้ ระบบจะไม่นับเลย ถึงชื่อจะตรงกันก็ตาม (เช่น
`Kafka.fbx` ตัวเก่าที่ค้างอยู่ใน `Assets/Test/`) เพื่อไม่ให้ไปหยิบผิดตัว
- ถ้าหาไม่เจอ Shot นั้นยัง Import ได้ แต่ตัวนั้นจะขึ้นในคอลัมน์ **Other Anims**
(สีเหลือง) และจะไม่ถูกวางลง Timeline ให้ ต้องย้าย/Set up ตัวนั้นไว้ใน Folder
ที่ถูกต้องก่อน แล้วกด **Rescan**
- กล้อง (`RenderCam`) ก็ใช้ที่เดียวกันคือ
`Assets/SetupActor/Character/Camera/RenderCam.prefab`

!!! tip "เพิ่มตัวละครหรือ Prop ใหม่"
    ใช้ Step **Import Actor Setup** ใน Asset Importer โดยตั้ง Import Path เป็น
    `Assets/SetupActor/Character` (ตัวละคร) หรือ `Assets/SetupActor/Prop` (Prop)
    ระบบจะสร้าง Prefab ที่พร้อมใช้งานให้ แล้วกลับมากด **Rescan** ใน Shot Importer

---

## ช่องตั้งค่าด้านบน

| ช่อง | คืออะไร |
| --- | --- |
| **Published Shots** | Folder ต้นทางที่ Maya Publisher ส่งไฟล์มา ข้างในจะเป็น `{ShotName}/v001/`, `{ShotName}/v002/` ... |
| **Published Textures** | Folder ต้นทางของ Texture ใบหน้าที่ Bake มาจาก Maya (`{ShotName}/v00N/{Material}.{Frame}.png`) ถ้าไม่มีก็เว้นว่างได้ |
| **Shots (Project)** | Folder ปลายทางในโปรเจกต์ ไฟล์จะไปอยู่ที่ `{Shots}/{Sequence}/{ShotName}/` เช่น `Assets/Shot/KBA/KBA030/` |
| **Render Folder** | ที่เก็บไฟล์วิดีโอเวลากด **Start Recorder** (ค่าเริ่มต้นคือ `{Project}/Recordings`) |
| **Lighting Template** | ฉากต้นแบบที่จะก๊อปแสงไปใส่ฉากอื่น (ดู [Lighting Template](#lighting-template)) |
| **Import Mode** | วิธีจัดการไฟล์ที่มีอยู่แล้ว (ดู [โหมดการ Import](#import-mode)) |
| **Build Texture Arrays** | รวมภาพ Texture ที่เป็นลำดับเฟรม (`ชื่อ.1001.png`, `ชื่อ.1002.png` ...) ให้เป็นไฟล์เดียว เพื่อให้ Shader เล่นเป็น Animation ได้ |

ปุ่ม **Browse...** ใช้เลือก Folder ส่วน **Open** / **Show** ใช้เปิดดู Folder นั้น

**Sequence** คือตัวอักษรข้างหน้าชื่อ Shot เช่น `KBA030` อยู่ใน Sequence `KBA`

---

## ตาราง Shot

แต่ละแถวคือ 1 Shot ลากขอบคอลัมน์เพื่อปรับความกว้างได้

| คอลัมน์ | ความหมาย |
| --- | --- |
| **Check** | ติ๊กเลือก Shot ที่จะ Import / Render |
| **Shot**, **Seq** | ชื่อ Shot และ Sequence |
| **Version** | เวอร์ชันที่จะ Import ค่าเริ่มต้นคือเวอร์ชันล่าสุด กดเลือกเวอร์ชันเก่าได้ |
| **Latest** | เวอร์ชันล่าสุดที่มีใน Published Shots |
| **In Project** | สถานะเทียบกับในโปรเจกต์ (ดูด้านล่าง) |
| **Characters**, **Props** | ตัวละครและ Prop ที่มี Animation ใน Shot นี้ |
| **Other Anims** | Animation ที่หา Model ไม่เจอใน 2 Folder ด้านบน (สีเหลือง = ควรตรวจสอบ) |
| **Cam** | มีกล้องใน Shot หรือไม่ (สีแดง = ไม่มีกล้อง) |
| **Files**, **Destination** | จำนวนไฟล์ และ Folder ปลายทาง |
| **Status**, **Time** | ผลการ Import ล่าสุดและเวลาที่ใช้ (เอาเมาส์ชี้เพื่ออ่านข้อความเต็ม) |
| **Render** | สถานะการ Render (เอาเมาส์ชี้เพื่ออ่านข้อความเต็ม) |

**สถานะ In Project**

- **Up to date** — ไฟล์ของเวอร์ชันที่เลือกมีครบในโปรเจกต์แล้ว ไม่ต้อง Import ซ้ำ
- **Outdated (n/m)** — มีแค่บางไฟล์ (n จาก m ไฟล์) ควร Import ใหม่
- **Not imported** — ยังไม่เคย Import เลย

### ค้นหาและเลือก Shot

- **ช่องค้นหา** พิมพ์ชื่อ Shot หรือชื่อตัวละคร/Prop ก็ได้ เช่นพิมพ์ `Rubik`
จะเห็นทุก Shot ที่มี Rubik
- **Only not up to date** ซ่อน Shot ที่ Up to date แล้ว
- **Check All** / **Check None** / **Check Not Up To Date** ติ๊กหรือเอาติ๊กออก
เฉพาะแถวที่แสดงอยู่
- **Rescan** อ่าน Folder ใหม่อีกรอบ (ติ๊กและเวอร์ชันที่เลือกไว้ยังอยู่เหมือนเดิม)
ให้กดทุกครั้งหลังเพิ่มตัวละคร/Prop ใหม่ หรือหลัง Maya Publish เวอร์ชันใหม่

### คลิกขวาที่แถว

ถ้าเลือกไว้หลายแถว คำสั่งจะทำกับทุกแถวที่เลือก

- **Import Now** — Import เฉพาะ Shot ที่เลือกทันที
- **Record Now** — Render เฉพาะ Shot ที่เลือกทันที
- **Check** / **Uncheck**
- **Show in Project** — ไปที่ Folder ของ Shot ใน Project Window
- **Open Published Folder** — เปิด Folder ต้นทางใน Explorer
- **Copy Shot Name** — Copy ชื่อ Shot
- **Copy Breakdown** — Copy รายการของใน Shot (ข้อความเดียวกับช่อง Details)

### ช่อง Details

อยู่มุมซ้ายล่าง แสดงว่าใน Shot ที่เลือกมีอะไรบ้าง

- **เลือก 1 Shot** — แสดงทุกไฟล์ พร้อมสถานะของแต่ละไฟล์
- **เลือกหลาย Shot** — สรุปว่าตัวละคร/Prop แต่ละตัวอยู่ในกี่ Shot และ Shot
ไหนไม่มีกล้อง

ระบบดูประเภทของไฟล์จากชื่อไฟล์:

| ชื่อไฟล์ | คืออะไร |
| --- | --- |
| `{Shot}_{Asset}_anim_001.fbx` | Animation ของตัวละครหรือ Prop |
| `{Shot}_camera.fbx` | กล้อง |
| `{ชื่อ}.{เฟรม}.png` | Texture ลำดับเฟรม (บอกจำนวนเฟรมด้วย) |
| ไฟล์อื่นๆ เช่น `{Shot}_metadata.json` | ไฟล์ประกอบ |

ใต้ชื่อตัวละคร/Prop แต่ละตัวอาจมีข้อมูลเพิ่ม:

- **scale** — ขนาดที่อ่านจาก `{Shot}_metadata.json` ระบบจะตั้งขนาดตอน Import ให้ตามนี้
- **no Avatar** — หาโครงกระดูก (Avatar) ของตัวนี้ไม่เจอ ส่วนใหญ่เป็นเพราะ Model
ไม่ได้อยู่ใน 2 Folder ด้านบน

---

## การ Import

1. ตั้ง **Published Shots** และ **Shots (Project)** ให้ถูก
2. ติ๊ก Shot ที่ต้องการ (หรือกด **Check Not Up To Date**)
3. กด **Start Import**

แต่ละแถวจะอัปเดตสถานะให้ดูระหว่างรัน กด **Stop Import** เพื่อหยุดได้ (ไฟล์ที่กำลัง
ทำอยู่จะทำจนเสร็จ ที่เหลือจะขึ้นว่า Cancelled) ผลลัพธ์และคำเตือนทั้งหมดจะอยู่ในช่อง
Log ด้านล่าง มีปุ่ม **Copy** และ **Clear**

### Import Mode

| โหมด | ทำอะไร |
| --- | --- |
| **Import Append and Replace** (ค่าเริ่มต้น) | Copy ทุกไฟล์ ทับไฟล์ชื่อเดิม ใช้แบบนี้เป็นหลัก เพราะเวอร์ชันใหม่มักใช้ชื่อไฟล์เดิม |
| **Import Append** | Copy เฉพาะไฟล์ที่ยังไม่มี ไฟล์ชื่อเดิมจะถูกข้าม (ระวัง: ได้ไฟล์เวอร์ชันใหม่ไม่ครบ) |
| **Clean and Import** | ลบไฟล์เดิมใน Folder ของ Shot นั้นทิ้งก่อน (ไปที่ Recycle Bin) แล้ว Copy ใหม่ทั้งหมด จะมีหน้าต่างถามยืนยันพร้อมบอกจำนวนไฟล์ที่จะลบ |

### ระบบตั้งค่าอะไรให้อัตโนมัติบ้าง

ทุกไฟล์ `.fbx` ที่ Import เข้ามา ระบบจะตั้งค่าให้เอง ไม่ต้องกดทีละไฟล์:

- **ผูกโครงกระดูก (Avatar)** เข้ากับตัวละคร/Prop ตัวจริง โดยหาจากชื่อ Asset ใน
2 Folder ด้านบน ทำให้ Animation เล่นบน Prefab ในฉากได้ ถ้าหาไม่เจอก็ยัง Import ได้
แต่จะขึ้นคำเตือนใน Log
- **ปิดการบีบอัด Animation** เพื่อให้ท่าทางตรงกับใน Maya ที่สุด
- **ตั้งขนาด (Scale)** ตามค่าใน `{Shot}_metadata.json` ถ้ามีไฟล์นี้
- **ตั้งชื่อ Animation Clip** จาก `Take 001` เป็น `{ShotName}_{AssetName}` เช่น
`KBA030_Kafka`
- **Texture ใบหน้า** เวอร์ชันล่าสุดจะถูก Import มาพร้อมกันใน Folder เดียวกัน และถ้า
เปิด **Build Texture Arrays** ไว้ จะรวมเป็นไฟล์ชื่อ `{ShotName}_{Material}`

---

## Animation เวอร์ชันล่าสุดบน Timeline

ทุกครั้งที่ Maya Publish เวอร์ชันใหม่ จะได้ไฟล์ใหม่แยกกัน เช่น
`ETA020_Kafka_anim_001.fbx` แล้วตามด้วย `ETA020_Kafka_anim_002.fbx` (ไฟล์เก่า
ยังอยู่) ระบบจะเปลี่ยน Clip บน Timeline ให้ใช้**เลขเวอร์ชันสูงสุด**ให้เอง

- Clip ยังเริ่มที่ตำแหน่งเดิม แต่ความยาวเปลี่ยนตาม Animation ใหม่ (Clip ถัดไป
ไม่ถูกเลื่อน)
- ระบบอัปเดตให้เมื่อ:
    - Import เสร็จ (เฉพาะ Shot ที่เพิ่ง Import)
    - กด **Start Recorder** (เฉพาะ Shot ที่จะ Render)
    - กด **Update Timelines** ด้านบน (ทุก Shot ในทุก Timeline)
- ถ้าไฟล์ Animation ของ Clip ไหนถูกลบไปแล้ว จะแจ้งใน Log และเปลี่ยนให้ไม่ได้
- ไฟล์กล้อง (`{Shot}_camera.fbx`) ไม่มีเลขเวอร์ชัน Import ทับไฟล์เดิมเสมอ จึงเป็น
ตัวล่าสุดตลอด

!!! note
    Texture และ Material (Lookdev) ของตัวละคร**ไม่ได้**อัปเดตผ่านระบบนี้
    ให้แก้ที่ Material ของตัวละครใน `Assets/SetupActor/...` โดยตรง แล้วทุกฉากจะ
    เปลี่ยนตามเอง

---

## Render วิดีโอ (Recorder)

กด **Start Recorder** เพื่อ Render ทุก Shot ที่ติ๊กไว้ ออกมาเป็น
`{Render Folder}/{ShotName}.mp4`

- **ไฟล์ที่ได้:** MP4 ขนาด 1920x1080 คุณภาพสูง ไม่มีเสียง
- **เฟรมเรต:** ตาม Timeline ของ Sequence นั้น ได้ครบทุกเฟรมไม่ตกหล่น
- **ไม่ต้องเปิดฉากเอง:** ระบบจะหาเองว่า Shot นั้นอยู่บน Timeline ในฉากไหน แล้ว
เปิดฉากนั้น กด Play, Render, แล้วกลับมาเปิดฉากเดิมที่เราเปิดไว้ให้ตอนจบ
    - ต้อง Save ฉากที่เปิดอยู่ก่อน (ระบบจะถามให้ Save ถ้ายังไม่ได้ Save)
- **กล้อง:** Render ผ่านกล้อง `RenderCam` ในฉาก ถ้าฉากไม่มี จะใช้ Main Camera แทน
และแจ้งใน Log
- ถ้ามีไฟล์ `.mp4` ของ Shot นั้นอยู่แล้ว ระบบจะถามก่อนว่าจะเขียนทับไหม
- **Stop Recorder** หรือกดออกจาก Play Mode เองเพื่อหยุด (Shot ที่กำลัง Render จะได้
วิดีโอไม่ครบ และขึ้นว่า Cancelled)
- Import กับ Render ทำพร้อมกันไม่ได้

### Shot ที่ยังไม่อยู่บน Timeline

ติ๊ก **Add Missing to Timeline** (ข้าง Render Folder) แล้วระบบจะวาง Shot ลง
Timeline ให้ก่อน Render

- Shot จะถูกวางในฉากของ Sequence เดียวกัน เช่น ETA010 จะไปอยู่ในฉากเดียวกับ ETA030
- จะวางกล้องและตัวละคร/Prop ที่ยังไม่มีในฉากให้ด้วย แล้ว Save ฉากให้
- **ถ้ายังไม่มีฉากของ Sequence นั้นเลย** ระบบจะสร้างฉากใหม่ให้ที่
`Assets/Timeline/{SEQ}/{SEQ}.unity` พร้อม Timeline `{SEQ}_Timeline.playable`
แล้วก๊อปแสงจาก Lighting Template มาใส่ให้
- Shot ต้อง Import เข้ามาก่อนแล้ว
- ถ้าไม่ติ๊กช่องนี้ Shot ที่ยังไม่อยู่บน Timeline จะขึ้นว่า Failed

---

## Lighting Template

ใช้ก๊อปแสงจากฉากต้นแบบไปใส่ฉากของ Sequence อื่น ให้ทุก Sequence แสงเหมือนกัน
ค่าเริ่มต้นคือ `Assets/Timeline/ETA/ETA_scene.unity`

**สิ่งที่ถูกก๊อป**

- ชุดไฟในฉาก เช่น OverallLight, GradientKafkaTop/Bot, FacialLight,
PostProcessVolume
- ค่าในหน้าต่าง Lighting (Skybox, Ambient, Fog, Reflection)

**สิ่งที่ไม่ถูกก๊อป**

- ไฟที่เป็นของฉากนั้นๆ (Prefab ของฉาก เช่น `PF_Light_EntranceRoom`)
- ไฟหลัก (Directional Light) อื่นในฉากปลายทางจะถูกปิด ไม่ได้ลบ

ไฟที่ผูกกับตัวละคร (เช่น Gradient และไฟหน้า) จะถูกผูกกับตัวละครในฉากปลายทางให้เอง
ถ้าฉากปลายทางไม่มีตัวละครตัวนั้น ส่วนนั้นจะถูกข้ามไป

**ใช้เมื่อไหร่**

- อัตโนมัติ กับทุกฉากที่ Recorder สร้างใหม่
- กดเอง: **Apply to Open Scene** เพื่อก๊อปแสงลงฉากที่เปิดอยู่ (จะถามก่อน แล้ว Save ให้)

กดซ้ำได้ไม่มีปัญหา ระบบจะแทนที่ของเดิมที่ตัวเองเคยใส่ ควรกดอีกครั้งหลังเพิ่ม
ตัวละครใหม่ในฉาก เพื่อให้ไฟผูกกับตัวใหม่ด้วย

---

## Preset (ใช้ร่วมกันทั้งทีม)

- **Save** — บันทึก Shot ที่ติ๊กไว้ พร้อม Folder และตัวเลือกทั้งหมด เก็บไว้ที่
`Assets/Editor/ShotImporterPresets/`
    - Shot ที่ใช้เวอร์ชันล่าสุดอยู่ จะตามเวอร์ชันใหม่ไปเองเมื่อมีการ Publish
    - Shot ที่เลือกเวอร์ชันเก่าไว้ จะล็อกไว้ที่เวอร์ชันนั้น
- **Load** — โหลด Preset กลับมา ถ้ามี Shot หรือเวอร์ชันที่ไม่มีแล้ว จะแจ้งใน Log
- **Delete** — ลบ Preset (ไปที่ Recycle Bin)

---

## ปัญหาที่เจอบ่อย

**ตัวละครขึ้นใน Other Anims หรือขึ้นว่า no Avatar**

Model ของตัวนั้นไม่ได้อยู่ใน `Assets/SetupActor/Character` หรือ
`Assets/SetupActor/Prop` หรือชื่อไฟล์ไม่ตรงกับชื่อใน Animation (เช่น Animation
ชื่อ `KBA030_Kafka_anim_001` ต้องมี `Kafka.fbx`) แก้แล้วกด **Rescan**

**Import แล้วแต่ Timeline ยังเล่น Animation เก่า**

กด **Update Timelines** ด้านบน

**Shot ขึ้น Outdated ทั้งที่เพิ่ง Import**

ตรวจดูว่าใช้โหมด **Import Append** อยู่หรือเปล่า โหมดนี้จะข้ามไฟล์ชื่อเดิม
ให้เปลี่ยนเป็น **Import Append and Replace** แล้ว Import ใหม่

**Render ไม่ได้ ขึ้น Failed**

Shot ยังไม่ได้ Import หรือยังไม่อยู่บน Timeline (ติ๊ก **Add Missing to
Timeline**) หรือโปรเจกต์มี Error ในโค้ดทำให้กด Play ไม่ได้ ดูข้อความเต็มได้ที่
คอลัมน์ Render
