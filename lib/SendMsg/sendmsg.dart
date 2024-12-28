import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/models/freelancers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:employer_app/global/global.dart';
import '../widgets/loading_dialog.dart';


class msgscreen extends StatefulWidget
{
  Freelancers? model;

  msgscreen({this.model,});

  @override
  State<msgscreen> createState() => _msgscreenState();
}

class _msgscreenState extends State<msgscreen>
{


  TextEditingController itemInfoTextEditingController = TextEditingController();


  bool uploading = false;

  String msgUniqueId = DateTime.now().millisecondsSinceEpoch.toString();


  saveJobInfo()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))

        .collection("msg")
        .doc(msgUniqueId)
        .set(
        {
          "msgID": msgUniqueId,
          "employerUID": sharedPreferences!.getString("uid"),
          "employerName": sharedPreferences!.getString("name"),
          "msg": itemInfoTextEditingController.text.trim(),

          "senddDate": DateTime.now(),

        }).then((value)
    {
      FirebaseFirestore.instance
          .collection("msg")
          .doc(msgUniqueId)
          .set(
          {
            "msgID": msgUniqueId,
            "employerUID": sharedPreferences!.getString("uid"),
            "employerName": sharedPreferences!.getString("name"),
            "msg": itemInfoTextEditingController.text.trim(),
            "senddDate": DateTime.now(),

          });
    });

    setState(() {
      uploading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    Fluttertoast.showToast(msg: "send successfully.");
  }

  validateUploadForm() async
  {


      if(itemInfoTextEditingController.text.isNotEmpty
          )
      {
        setState(() {
          uploading = true;
        });

        saveJobInfo();

      }
      else
      {
        Fluttertoast.showToast(msg: "Please fill complete form.");
      }


  }

  uploadFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: ()
              {

                //validate upload form
                uploading == true ? null : validateUploadForm();
              },
              icon: const Icon(
                Icons.send,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.lightBlue
          ),
        ),
        title: const Text(
            "send New message"
        ),
        centerTitle: true,
      ),
      body: ListView(

        children: [

          //image
          const Divider(
            color: Colors.lightBlue,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(
              Icons.message,
              color: Colors.blue,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: itemInfoTextEditingController,
                maxLength: 40,
                decoration: const InputDecoration(
                  hintText: "Write Message",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.lightBlue,
            thickness: 1,
          ),


          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: ()
              {

                uploading == true ? null : validateUploadForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                fixedSize: const Size(290, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Send",style: TextStyle(fontSize: 18,),
              )
          ),

        ],
      ),
    );
  }




  defaultScreen()
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.lightBlue
          ),
        ),
        title: const Text(
            "Add New job"
        ),
        centerTitle: true,
      ),

    );
  }

  @override
  Widget build(BuildContext context)
  {
    return

      uploadFormScreen() ;
  }



}
