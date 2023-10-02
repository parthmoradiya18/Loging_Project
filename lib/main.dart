import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loging_id_project/registratio_page.dart';
import 'package:loging_id_project/view_contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);
  var box = await Hive.openBox('login_id');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  static Database? database;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var box = Hive.box('login_id');

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  bool temp = true;

  //var box=Hive.box("login");

  @override
  void initState() {
    super.initState();
    // Add listeners to this class
    get_date_base_sql();
    temp = box.get("isLogin") ?? false;
  }

  check_login(BuildContext context) {
    if (temp == true) {
      Future.delayed(Duration.zero).then((value) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return view_contact();
        }));
      });
    }
  }

  get_date_base_sql() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ram.db');

    Home.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE con_book(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,contact TEXT,email TEXT,password TEXT,gender TEXT,skill TEXT,date TEXT,photo TEXT)');
    });
  }

  @override
  Widget build(BuildContext context) {
    check_login(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Id"),
      ),
      body: Column(
        children: [
          Card(
            child: TextField(
              controller: t1,
              decoration:
                  InputDecoration(hintText: "username", labelText: "username"),
            ),
          ),
          Card(
            child: TextField(
              controller: t2,
              decoration:
                  InputDecoration(hintText: "password", labelText: "password"),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                String email = t1.text;
                String pass = t2.text;
                String sql =
                    "select * from con_book where email='$email'and password='$pass'";
                List<Map> l = await Home.database!.rawQuery(sql);

                if (l.length == 1) {
                  box.put('isLogin', true);
                  box.put('user_details', l[0]);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return view_contact();
                  }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid username and password")));
                }
              },
              child: Text("Submit")),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return registratio_page();
                }));
              },
              child: Text("New Registration")),
        ],
      ),
    );
  }
}
