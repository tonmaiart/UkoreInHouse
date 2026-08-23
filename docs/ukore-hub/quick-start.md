# Quick Start to Ukore Hub

![รูปตัวอย่าง](../assets/images/ukhub_overall.png)

Ukore Hub เป็นโปรแกรมศูนย์กลางที่ Production Artist ทุกคนจะใช้ในการเปิดงาน , แก้ไขงาน และส่งงาน

ซึ่ง Production Artist ทุกคนต้องเปิดโปรแกรม DCC (Digital Content Creation) ต่างๆ เช่น Autodesk Maya , Blender , Unity 
Artist ผ่าน Ukore Hub เท่านั้น เพื่อให้รักษาสภาพแวดล้อมการทำงานของทุกคนเป็นมาตรฐานเดียวกัน และทำให้สามารถใช้ Pipeline Tools ต่างๆได้

<br>

---

<br>

### สิ่งที่ต้องเตรียมก่อนใช้งาน Ukore Hub

1. สมัครบัญชี Github ด้วย Email ส่วนตัวได้ที่  [GitHub Website](http://www.github.com/)
2. ดาวน์โหลดและติดตั้งโปรแกรมเหล่านี้ลงในคอมของคุณ ก่อนติดตั้ง Ukore Hub
    - [Download Git](https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.4/Git-2.55.0.4-64-bit.exe)
    - [Download Git LFS](https://github.com/git-lfs/git-lfs/releases/download/v3.7.1/git-lfs-windows-v3.7.1.exe)
    - [Download Python Manager](https://www.python.org/ftp/python/pymanager/python-manager-26.3.msix)

<br>

---

<br>

### การติดตั้ง Ukore Hub

1. [ดาวน์โหลด Ukore Hub](https://github.com/tonmaiart/UkoreHubLauncher/archive/refs/heads/main.zip)
2. ทำการแตกไฟล์ Extract .zip ไว้ที่ไหนก็ได้บนเครื่อง แล้วเปิดไฟล์ UkoreHubLauncher.exe 
3. โปรแกรมจะขึ้นหน้าต่างให้ Login github ผ่านเบราว์เซอร์ และนำโค้ดจากโปรแกรมไปกรอกใส่เพื่อยืนยันการ Login
4. รอโปรแกรม Update สักครู่แล้วหน้าต่าง UkoreHub พอ Update เสร็จมันจะเปิดหน้าต่างขึ้นมาเอง

<br>

---

<br>

### การเลือก Repositories ที่จะทำงาน
1. เมื่อ Ukore Hub เปิดหน้าต่างขึ้นมา ให้กดเลือก Tab Project Editor ทางซ้ายมือ
2. จะมีรายการ Repositories ให้เลือก ตรงนี้ให้สอบถามข้อมูลแต่ละแผนกว่าแผนกนั้นต้องใช้ Repositories ไหน
3. กดเลือก Repostories นั้นแล้วกด Clone 
4. ไปที่ Tab Submit แล้วรอจนกว่าสถานะการ Clone ด้านล่างซ้ายมือจะครบ 100% เป็นอันเสร็จสิ้น

**หมายเหตุ :** บาง Repositories อาจถูกจำกัดสิทธิ์ให้เข้าถึงได้บาง User เท่านั้น สามารถติดต่อแผนก Pipeline เพื่อสอบถามสิทธิ์เพิ่มเติม
การแก้ไขไฟล์และส่งไฟล์

<br>

---

<br>

### โปรดศึกษาการใช้งาน Ukore Hub เพิ่มเติม

![รูปตัวอย่าง](../assets/images/ukhub_core_feature.png)


Artist ควรศึกษาการใช้โปรแกรมนี้ให้เข้าใจ เพื่อเรียนรู้วิธีการส่งงาน , Sync Other Commit , เปิดโปรแกรม อย่างถูกต้อง เพื่อไม่ให้เกิดข้อผิดพลาดที่อาจจะส่งผลกับไฟล์งานในอนาคต โดยเราจะมี Tab หลักๆ แค่ 4 ส่วนสำคัญที่ต้องเข้าใจ ได้แก่

1. [Project Editor Tab](../ukore-hub/project-editor.md)
2. [Explorer Tab](../ukore-hub/explorer.md)
3. [Submit Tab](../ukore-hub/submit.md)
4. [Program Launcher Tab](../ukore-hub/program-launcher.md)

