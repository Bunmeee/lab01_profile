# Lab L1 · คำตอบและการทดสอบ (67103747 Natthaphum Sriwiboon)

## Q1 · เครื่องมือ
จากการรัน `flutter doctor` พบผลดังนี้:
- **Flutter (3.50.1)**, **Android toolchain (Android SDK 36.1.0)** และ **Chrome (web)** ผ่านเครื่องหมายถูก (`[√]`)
- พบปัญหา `[X] Visual Studio - develop Windows apps` (ยังไม่ได้ติดตั้ง Visual Studio C++ workload สำหรับ build Windows desktop) และเมื่อเช็กด้วย `flutter emulators` พบว่ายังไม่มี Android AVD image ติดตั้งไว้ (`Unable to find any emulator sources`)
- **เครื่องมือ/วิธีแก้ที่ใช้:** ใช้ `flutter doctor -v` และ `flutter devices` ตรวจสอบอุปกรณ์ที่พร้อมใช้งานบนเครื่อง พบว่า `Chrome` พร้อมใช้งาน (`[√]`) จึงเลือกใช้คำสั่ง `flutter run -d chrome` สำหรับรันและทดสอบแอป รวมถึงใช้ `flutter analyze` และ `flutter test` ตรวจสอบโค้ด

## Q2 · Reload (`r` vs `R`)
เมื่อ `Likes` เป็น `3`:
- **กด `r` (Hot reload):** ค่า `Likes` **ยังคงเป็น `3`** เหมือนเดิม (และหากแก้ไข UI/ข้อความ เช่น title ใน `AppBar` ส่วนที่แก้จะเปลี่ยนทันที) เพราะ Hot reload จะอัปเดตโค้ดใหม่เข้าไปใน runtime และเรียก `build()` ใหม่โดย **รักษา `State` เดิม (`_HomePageState`)** ที่เก็บตัวแปร `_likes` เอาไว้
- **กด `R` (Hot restart):** ค่า `Likes` **รีเซ็ตกลับเป็น `0`** เพราะ Hot restart จะทำลาย `State` ทั้งหมดในหน่วยความจำ แล้วเริ่มรันแอปใหม่ตั้งแต่ฟังก์ชัน `main()`

*(จากการรัน `flutter run -d chrome` จริง: Hot reload `r` ใช้เวลา `621ms` และ Hot restart `R` ใช้เวลา `661ms` โดยหลัง `R` หน้าจอกลับมาแสดง `Likes: 0` และเมื่อกด `Like` ต่อเนื่องได้ `Likes: 4` ถึง `Likes: 67`)*

## Q3 · โค้ด และ Git
- **ทำไม `_likes++` ต้องใช้ `setState`:** การเขียนแค่ `_likes++` จะเปลี่ยนเฉพาะค่าตัวแปรในหน่วยความจำ แต่ Flutter จะไม่รู้ว่าหน้าจอต้องวาดใหม่ การเรียก `setState(() => _likes++)` เป็นการแจ้ง framework ว่าสถานะของ `_HomePageState` เปลี่ยนแล้ว ให้จัดคิวเรียก `build(context)` ใหม่ เพื่ออัปเดตข้อความ `Text('Likes: $_likes')` บนหน้าจอ
- **ตัวอย่าง Commit ที่เลือกอธิบาย:** Commit `"Add like counter with setState"`
  - เปลี่ยนคลาส `HomePage` จาก `StatelessWidget` เป็น `StatefulWidget` และสร้าง `_HomePageState` เพื่อเก็บตัวแปร `int _likes = 0`
  - เพิ่มเมธอด `_like()` ที่เรียก `setState(() => _likes++)`
  - ลบ `const` หน้า `Center` ออก (เพราะ `Text('Likes: $_likes')` มีค่าที่เปลี่ยนแปลงได้) และเพิ่ม `Text('Likes: $_likes')` กับปุ่ม `FilledButton` (`Like`) ใน `Column` พร้อมอัปเดต `test/widget_test.dart`

## ตารางทดสอบ

| ประเภท | input หรือการกระทำ | ผลที่คาดหวัง | ผลจริง |
| --- | --- | --- | --- |
| Normal | เปิดแอป | title ไอคอน ชื่อ “Likes: 0” | แสดง `Lab L1 · 67103747`, `Icons.person`, `Natthaphum Sriwiboon - 67103747`, `Likes: 0` และปุ่ม `Like` (ตรวจผ่าน `flutter test` และ `flutter run -d chrome`) |
| Normal | กด Like หนึ่งครั้ง | “Likes: 1” | ตัวเลขเปลี่ยนจาก `Likes: 0` เป็น `Likes: 1` (ยืนยันผ่าน `flutter test` และทดสอบกดจริงบน Chrome) |
| Boundary | กด Like เร็ว ๆ 20 ครั้ง | “Likes: 20” ไม่มี error | นับถึง `Likes: 20` ถูกต้อง ไม่มี exception (ยืนยันผ่าน `flutter test` และกดจริงบน Chrome ต่อเนื่องถึง `Likes: 67` โดยไม่พบ error) |
| Boundary | หมุนจอเป็นแนวนอน | ยังอยู่กลางจอ ไม่ overflow | เนื้อหาอยู่กลางจอและไม่เกิด overflow error (ตรวจผ่าน `flutter test` ที่ขนาด `1600x720` px / `devicePixelRatio: 2.0`) |
| Reload | กด 3 ครั้ง แล้ว `r` แล้ว `R` | หลัง `r` ได้ 3 · หลัง `R` ได้ 0 | ทดสอบ `r` (`Reloaded application in 621ms` คงสถานะไว้) และ `R` (`Restarted application in 661ms` รีเซ็ตกลับเป็น `Likes: 0` จาก `main()`) บน Chrome |
| Failure | ปิด emulator แล้ว `flutter run` | ข้อความว่า ไม่พบ device | รัน `flutter run -d android` ขณะไม่มี emulator/Android device แสดงข้อความ `No supported devices found with name or id matching 'android'.` |

## การใช้ AI
- ใช้ AI (Antigravity) ช่วยปรับโค้ดใน `lib/main.dart` ตามโครงสร้างในสไลด์, เขียนชุดทดสอบ `test/widget_test.dart`, รันตรวจสอบ `flutter doctor` / `flutter analyze` / `flutter test` / `flutter run -d chrome` และช่วยเรียบเรียงคำตอบใน `answers.md`
- ผู้ทำได้ตรวจสอบโค้ดทุกส่วน (`MaterialApp`, `HomePage`, `StatefulWidget`, `setState`) และเข้าใจการทำงานเพื่ออธิบายด้วยตนเองแล้ว
