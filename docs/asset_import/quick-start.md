# Asset Import

ใช้นำ Model และ Texture ของฉากกับพร็อปเข้า Unity แล้วต่อเป็น Prefab ที่มี Material พร้อมใช้
ไม่ต้องทำมือทีละชิ้น เปิดได้ที่ `UkoreHub > Asset Importer...`

ไม่ต้องตั้ง Path เอง แค่เลือกว่าเป็น **Map** หรือ **Prop** และชื่อ ระบบจะหาโฟลเดอร์ให้ทั้งหมด

![ขั้นตอนของ Asset Import จากไฟล์ต้นทางจนได้ Prefab พร้อมใช้](../assets/images/asset_import_flow.png)

![Asset Importer](../assets/images/asset_import_ui.png)

1. **Execute Steps** — เลือก Step ที่จะดู และติ๊ก Step ที่จะรันรวมกัน หน้านี้ใช้แค่หมวด **Assets**
2. **Asset** — เลือก Map หรือ Prop และชื่อ ส่วนโฟลเดอร์ปลายทางจะขึ้นให้เองและแก้ไม่ได้
3. **Steps Info** — ค่าของ Step นี้ เช่น Extension Filter, Import Mode ส่วน External Source Folder จะขึ้นให้เอง
4. **Configuration** — บันทึกหรือเรียกชุดค่าที่ตั้งไว้
5. **Execute** — **Execute Current** รัน Step ที่เลือกอยู่ ส่วน **Execute Checked** รันทุก Step ที่ติ๊กตามลำดับ
6. **Preview Result** — ดูก่อนรันว่าเจอไฟล์อะไร และชื่อไหนผ่านหรือไม่ผ่าน

## กฎที่ต้องรู้ 1: วางไฟล์ให้ถูกโฟลเดอร์

| ประเภท | วางไฟล์ไว้ที่ | เข้า Unity ที่ |
| --- | --- | --- |
| Map | `PublishToUnity/map/{ชื่อ}/Models` และ `Textures` | `Assets/Map/{ชื่อ}/` |
| Prop | `PublishToUnity/model/{ชื่อ}/Models` และ `Textures` | `Assets/Prop/{ชื่อ}/` |

ใน `Assets/Map/{ชื่อ}/` หรือ `Assets/Prop/{ชื่อ}/` จะมี `Models`, `Textures`, `Prefabs`, `Materials`
ถ้าไม่มีโฟลเดอร์ `{ชื่อ}` ตัวเลือกนั้นจะไม่ขึ้นในรายการ

## กฎที่ต้องรู้ 2: ตั้งชื่อให้ตรง Pattern

ระบบจับคู่ไฟล์จากชื่อเท่านั้น โดยใช้ `{AssetId}` เป็นตัวเชื่อม

| ประเภท | Pattern | ตัวอย่าง |
| --- | --- | --- |
| Model | `SM_{AssetId}_{PartName}` | `SM_Wall_WallA` |
| Prefab | `PF_{AssetId}_{PartName}` | `PF_Wall_WallA` |
| Material | `M_{AssetId}_{SlotName}` | `M_Wall_Wall` |
| Texture | `T_{AssetId}_{SlotName}_{MapName}` | `T_Wall_Wall_BaseColor` |

`{PartName}` และ `{SlotName}` จะมีหรือไม่มีก็ได้ แก้ Pattern ได้ที่ `UkoreHub > Template Editor... > Naming Convention`

!!! note "ชื่อไม่ตรงจะไม่ขึ้น Error"
    ไฟล์นั้นจะถูกข้ามไปเฉยๆ ก่อนรันให้ดูรายการ Invalid ใน **Preview Result** ทุกครั้ง

ไฟล์ที่ใช้ `{AssetId}` เดียวกันจะได้ Material ตัวเดียวกัน เหมาะกับชิ้นส่วนที่ใช้ร่วมกัน
แต่ถ้าตั้งชื่อซ้ำโดยไม่ตั้งใจ ก็จะถูกรวมเป็น Material เดียวด้วย

### กฎการตั้งชื่อ

- **เขียนติดกันแบบ PascalCase** ห้ามมี `_` ในแต่ละส่วน เช่น `ElevatorDoorLeft` ไม่ใช่ `ElevatorDoor_left`
- **ตั้ง `{AssetId}` ตามชุด Texture ไม่ใช่ตามชิ้น** ชิ้นที่ใช้ Texture ชุดเดียวกันให้ใช้ `{AssetId}` เดียวกัน แล้วแยกชิ้นด้วย `{PartName}` เช่น `SM_BigFloorSeams_FloorSeamsA`
- **`{SlotName}` ของ Texture ให้เหมือน `{AssetId}`** เช่น `T_Wall_Wall_BaseColor` ถ้าเป็น Texture คนละชุด ให้แยก `{AssetId}` แทน
- **Model กับ Texture ต้องมี `{AssetId}` ตรงกัน** ไม่อย่างนั้น Prefab จะไม่ได้ Material
- **Model หนึ่งชิ้นได้ Material เดียว** แม้ใน Model จะมีหลาย Slot ระบบจะใส่ตัวเดียวกันทุก Slot ถ้าต้องการหลาย Material ให้แยก Mesh เป็นคนละ Model
- **เช็กชื่อก่อน Export** ตัวอักษรพิเศษอาจกลายเป็นรหัส เช่น `SM_CubeFBXASC046040`

### ชื่อ Map ที่รองรับ

ส่วนท้ายของชื่อ Texture ต้องเป็นหนึ่งในชื่อนี้ ไม่สนตัวพิมพ์เล็กใหญ่ และไม่จำเป็นต้องมีครบ

| `{MapName}` | ใช้เป็น | ตัวอย่าง |
| --- | --- | --- |
| `BaseColor` | สีพื้น | `T_Wall_Wall_BaseColor` |
| `Normal` | Normal Map | `T_Wall_Wall_Normal` |
| `MOS` | Metallic, Occlusion, Smoothness รวมในไฟล์เดียว | `T_Wall_Wall_MOS` |
| `Occlusion` | Occlusion แยกไฟล์ | `T_Wall_Wall_Occlusion` |
| `Emissive` | ส่วนที่เรืองแสง | `T_Wall_Wall_Emissive` |

ชื่ออื่น เช่น `Albedo` หรือ `Diffuse` จะไม่ถูกเสียบเข้า Material

## วิธีใช้

1. วางไฟล์ให้ถูกโฟลเดอร์ และตั้งชื่อไฟล์ให้ตรง Pattern
2. ที่ **Asset** เลือก Map หรือ Prop และชื่อ
3. เลือก **Import Model** แล้วตั้ง Extension Filter เป็น `.fbx` จากนั้นทำแบบเดียวกันที่ **Import Texture** เช่น `.png`
4. เลือก **Build Prefabs** แล้วเช็ก Preview Result
5. เลือก **Build Materials** เลือก **Mapping Template** แล้วเช็ก Preview Result
6. เลือก **Assign Materials** แล้วเช็ก Preview Result
7. ติ๊กทุก Step ที่จะใช้ แล้วกด **Execute Checked**

ต้องรัน Build Materials ก่อน Assign Materials เสมอ เพราะ Assign Materials ไม่สร้าง Material ให้

## แต่ละ Step ทำอะไรให้

- **Import Model / Import Texture** — Copy ไฟล์เข้าโปรเจกต์พร้อมโครงสร้างโฟลเดอร์ย่อย
- **Build Prefabs** — สร้าง Prefab จาก Model เช่น `SM_Wall_WallA` ได้ `PF_Wall_WallA`
- **Build Materials** — รวม Texture ที่มี `{AssetId}` เดียวกันเป็น Material แล้วเสียบ Map ตาม Mapping Template
- **Assign Materials** — ใส่ Material ให้ทุก Slot ของ Prefab **โดยทับของเดิม**

## ตัวเลือกตอนรันซ้ำ

| Import Mode | ผล |
| --- | --- |
| Clean and Import | ย้ายไฟล์เดิมที่ตรง Filter ลง Recycle Bin แล้ว Copy ใหม่ (ถามยืนยันก่อน) |
| Import Append | Copy เฉพาะไฟล์ที่ยังไม่มี |
| Import Append and Replace | Copy ทับทั้งหมด แต่ไม่ลบอะไร |

| Build Behaviour | ผล |
| --- | --- |
| Add Only (ค่าเริ่มต้น) | ไม่แตะ Prefab ที่มีอยู่แล้ว |
| Add and Overwrite | เขียนทับ Prefab เดิม |
| Clear and Add | ลบ Prefab ทั้งหมดในโฟลเดอร์ก่อน **ย้อนกลับไม่ได้** |

!!! note "ตัวละครและช็อตไม่ได้ใช้หน้านี้"
    ตัวละครใช้ Import Actor Setup ส่วนช็อตใช้ [Shot Importer](../unity_ukore_shotimporter/quick-start.md)
    ดูรายละเอียดทุก Step ได้ที่ [Unity Ukore Importer](../unity_ukore_importer/quick-start.md)

## เจอปัญหา?

| อาการ | ลองดู |
| --- | --- |
| ไม่เจอชื่อที่ต้องการใน Asset | ยังไม่มีโฟลเดอร์ `PublishToUnity/map/{ชื่อ}` หรือ `model/{ชื่อ}` สร้างแล้วกด **Refresh** |
| ขึ้น skipped -- pick a Map or Prop first | ยังไม่ได้เลือก Asset Config เก่าต้องเลือกใหม่แล้วกด **Save Config** หนึ่งครั้ง |
| ไฟล์หายจากผลลัพธ์ | ชื่อไม่ตรง Pattern ดูรายการ Invalid ใน Preview Result |
| มีไฟล์แปลกติดมาด้วย เช่น `.py` | Extension Filter ว่างอยู่ ระบบจะ Copy ทุกไฟล์ ให้ใส่นามสกุลที่ต้องการ |
| Prefab ไม่ได้ Material | ยังไม่ได้รัน Build Materials หรือ `{AssetId}` ไม่ตรงกัน |
| Material ขาด Map บางตัว | `{MapName}` ไม่ตรงกับ Slot ใน Mapping Template |
| Material ที่ใส่เองหาย | รัน Assign Materials ซ้ำ ระบบทับของเดิม |
