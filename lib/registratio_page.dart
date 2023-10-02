import 'dart:io';
import 'dart:math';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class registratio_page extends StatefulWidget {
  Map? m;

  registratio_page([this.m]);

  static Database? database;

  @override
  State<registratio_page> createState() => _registratio_pageState();
}

class _registratio_pageState extends State<registratio_page> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();

  String gender = "male";
  bool temp1 = false, temp2 = false, temp3 = false;
  String a = "";
  String b = "";
  String c = "";

  ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    // Add listeners to this class
    getdat();
    get_date_base_sql();
    if (widget.m != null) {
      t1.text = widget.m!['name'];
      t2.text = widget.m!['contact'];
      t3.text = widget.m!['email'];
      t4.text = widget.m!['password'];
      List skill = widget.m!['skill'].split("/");
      if (skill.contains("Php")) {
        temp1 = true;
      }
      if (skill.contains("Android")) {
        temp2 = true;
      }
      if (skill.contains("Flutter")) {
        temp3 = true;
      }
    }
  }

  get_date_base_sql() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ram.db');

    registratio_page.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE con_book(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,contact TEXT,email TEXT,password TEXT,gender TEXT,skill TEXT,date TEXT,photo TEXT)');
    });
  }

  getdat() async {
    var status = await Permission.camera.status;
    var status1 = await Permission.storage.status;
    if (status.isDenied && status1.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.location,
        Permission.storage,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registratio ID"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: TextField(
                controller: t1,
                decoration: InputDecoration(
                    hintText: "Enter Name", labelText: "Enter Name"),
              ),
            ),
            Card(
              child: TextField(
                controller: t2,
                decoration: InputDecoration(
                    hintText: "Enter Contact", labelText: "Enter Contact"),
              ),
            ),
            Card(
              child: TextField(
                controller: t3,
                decoration: InputDecoration(
                    hintText: "Enter Email", labelText: "Enter Email"),
              ),
            ),
            Card(
              child: TextField(
                controller: t4,
                decoration: InputDecoration(
                    hintText: "Enter Password", labelText: "Enter Password"),
              ),
            ),
            Center(
              child: Text("Gender"),
            ),
            Row(
              children: [
                Radio(
                    value: "male",
                    groupValue: gender,
                    onChanged: (value) {
                      gender = value.toString();

                      setState(() {});
                    }),
                Text("Male"),
                SizedBox(
                  width: 10,
                ),
                Radio(
                    value: "female",
                    groupValue: gender,
                    onChanged: (value) {
                      gender = value.toString();

                      setState(() {});
                    }),
                Text("Female"),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Center(
              child: Text("Skill"),
            ),
            Row(
              children: [
                Checkbox(
                    value: temp1,
                    onChanged: (value) {
                      temp1 = value as bool;
                      setState(() {});
                    }),
                Text("PHP"),
                Checkbox(
                    value: temp2,
                    onChanged: (value) {
                      temp2 = value as bool;
                      setState(() {});
                    }),
                Text("Android"),
                Checkbox(
                    value: temp3,
                    onChanged: (value) {
                      temp3 = value as bool;
                      setState(() {});
                    }),
                Text("Flutter"),
              ],
            ),
            Center(
              child: Text("Birth Date"),
            ),
            DropdownDatePicker(
              isDropdownHideUnderline: true,
              // optional
              isFormValidator: true,
              // optional
              startYear: 2000,
              // optional
              endYear: 2030,
              // optional
              width: 10,
              // optional
              selectedDay: 31,
              // optional
              selectedMonth: 08,
              // optional
              selectedYear: 2000,
              // optional
              onChangedDay: (value) {
                setState(() {
                  a = value!;
                });
              },
              onChangedMonth: (value) {
                setState(() {
                  b = value!;
                });
              },
              onChangedYear: (value) {
                setState(() {
                  c = value!;
                });
              },
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      image: (image != null)
                          ? DecorationImage(image: FileImage(File(image!.path)))
                          : null,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("image upload"),
                              actions: [
                                IconButton(
                                    onPressed: () async {
                                      image = await picker.pickImage(
                                          source: ImageSource.camera);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    icon: Text(
                                      "camera",
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      image = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    icon: Text("gallery")),
                              ],
                            );
                          });
                    },
                    child: Text("Upload")),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  String name = t1.text;
                  String contact = t2.text;
                  String email = t3.text;
                  String password = t4.text;
                  String gender_m_f = gender;
                  print(name);
                  print(contact);
                  print(email);
                  print(password);
                  print(gender_m_f);

                  StringBuffer sb = StringBuffer();
                  if (temp1 == true) {
                    if (sb.length > 0) {
                      sb.write("PHP");
                    }
                  }
                  if (temp2 == true) {
                    if (sb.length > 0) {
                      sb.write("/");
                    }
                    sb.write("Android");
                  }

                  if (temp3 == true) {
                    if (sb.length > 0) {
                      sb.write("/");
                    }
                    sb.write("Flutter");
                  }

                  String skill = sb.toString();
                  print(skill);
                  String date = ("$a/$b/$c");
                  print("A=$a");
                  print("A=$b");
                  print("A=$c");
                  print("DATE = $date");

                  var dir_path =
                      await ExternalPath.getExternalStoragePublicDirectory(
                              ExternalPath.DIRECTORY_DOWNLOADS) +
                          "/image_fo";
                  print(dir_path);

                  Directory dir = Directory(dir_path);
                  if (!await dir.exists()) {
                    dir.create();
                  }
                  String img_name = "myimag${Random().nextInt(1000)}.jpg";
                  File file = File("${dir_path}/${img_name}");
                  print("ImagesPath: ${file.path}");
                  file.writeAsBytes(await image!.readAsBytes());
                  String img_path = file.path;

                  if (widget.m != null) {
                    String sql = "update con_book set name='$name',"
                        "contact='$contact', email='$email',"
                        "password='$password',gender='$gender',"
                        "skill='$skill',date='$date',photo='$img_path' where id=${widget.m!['id']}";
                    registratio_page.database!.rawUpdate(sql);
                  } else {
                    String qry =
                        "INSERT INTO con_book(name,contact,email,password,gender,skill,date,photo) VALUES "
                        "('$name','$contact','$email','$password','$gender','$skill','$date','$img_path')";
                    registratio_page.database!.rawInsert(qry).then((value) {
                      print("ID : $value");
                    });
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
