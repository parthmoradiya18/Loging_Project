import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loging_id_project/registratio_page.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';

class view_contact extends StatefulWidget {
  static Database ? database;

  @override
  State<view_contact> createState() => _view_contactState();
}

class _view_contactState extends State<view_contact> {
  var box =Hive.box('login_id');
  List<Map> l = [];
  List l1=[];
  Map ?m;
  bool temp= false;
  bool temp1 = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m=box.get("user_details");
    get_data();
  }
  get_data() async {
    String sql = "select * from con_book";
    l1=l;

    l = await registratio_page.database!.rawQuery(sql);
    print(l);
    temp = true;
    setState(() {});
  }
  check_login(BuildContext context){
    if(box.get("is login")== false)
      {

        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Home();
        }));
      }
  }
  @override
  Widget build(BuildContext context) {
    check_login(context);
    return Scaffold(
      appBar: AppBar(title: (temp1)?TextField(onChanged: (value){
        l1=l.where((element) => (element.toString().contains(value))).toList();
        setState((){

        });
      },
      autofocus: true,
        cursorColor: Colors.white,
      ):Text("view_contact"),
      actions: [
        IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return registratio_page();
          }));
        }, icon: Icon(Icons.add)),
        IconButton(onPressed: () {
          setState(() {
            temp1=!temp1;
          });

        }, icon: (temp1)?Icon(Icons.close):Icon(Icons.search))
      ],
      ),
      drawer: Drawer(child:
      ListView(children: [

        ListTile(
          title: Text("Name : ${m!['name']}",),),
        ListTile(title: Text("Email : ${m!['email']}",)),
        ListTile(title: Text("Logout"),onTap: (){
          box.put("isLogin",false);
          Navigator.push(context,MaterialPageRoute(builder: (context){
            return Home();
          }));
        },),
      ],),
      ),

      body: ListView.builder(itemCount: l.length,
        itemBuilder: (BuildContext context, int index) {

          return Card(child: ListTile(
          leading: CircleAvatar(backgroundImage: FileImage(File("${l[index]['photo']}")),),
            title: Text("${l[index]['name']}"),
            subtitle: Text("${l[index]['contact']}"),
            trailing: Wrap(children: [
              IconButton(onPressed: () {
                String sql =
                    "delete from con_book where id=${l[index]['id']}";
                registratio_page.database!.rawDelete(sql);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return view_contact();
                  },
                ));
              }, icon: Icon(Icons.delete)),

              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return registratio_page(l[index]);
                }));
              }, icon: Icon(Icons.edit)),

            ],),
          ),);
        },),
    );
  }
}
