import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/models/jobs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:employer_app/global/global.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../widgets/loading_dialog.dart';


class UploadItemsScreen extends StatefulWidget
{
  jobs? model;

  UploadItemsScreen({this.model,});

  @override
  State<UploadItemsScreen> createState() => _UploadItemsScreenState();
}




class _UploadItemsScreenState extends State<UploadItemsScreen>
{

  _UploadItemsScreenState(){

    selectedVal=_jobCategoryList[0];
  }

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController itemDescriptionTextEditingController = TextEditingController();
  TextEditingController itemUnitTextEditingController = TextEditingController();

  bool uploading = false;
  String downloadUrlImage = "";
  String itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  final _jobCategoryList=["Database","FrontEnd","BackEnd","Graphics","Mobile_App"];

  String? selectedVal="";
  double? unit ;

  double? borrowAmount;

  DateTime date = DateTime.now();


  @override
  void initState(){
    super.initState();
    readTotalEarnings();

  }


  readTotalEarnings() async
  {
    await FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap)
    {
      setState(() {
        unit = double.parse(snap.data()!["unit"].toString() ) ;



      });
    });
  }

  saveJobInfo()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("jobs")
        .doc(widget.model!.jobID)
        .collection("jobsItems")
        .doc(itemUniqueId)
        .set(
        {
          "itemID": itemUniqueId,
          "jobID": widget.model!.jobID.toString(),
          "employerUID": sharedPreferences!.getString("uid"),
          "employerName": sharedPreferences!.getString("name"),
          "employerEmail": sharedPreferences!.getString("email"),
          "itemTitle": selectedVal,
          "longDescription": itemDescriptionTextEditingController.text.trim(),
          "unit": itemUnitTextEditingController.text.trim(),
          "DueDate": date,
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": downloadUrlImage,
        }).then((value)
    {
      FirebaseFirestore.instance
          .collection("jobsItems")
          .doc(itemUniqueId)
          .set(
          {
            "itemID": itemUniqueId,
            "jobID": widget.model!.jobID.toString(),
            "employerUID": sharedPreferences!.getString("uid"),
            "employerName": sharedPreferences!.getString("name"),
            "employerEmail": sharedPreferences!.getString("email"),
            "itemTitle": selectedVal,
            "longDescription": itemDescriptionTextEditingController.text.trim(),
            "unit": itemUnitTextEditingController.text.trim(),
            "DueDate": date,
            "publishedDate": DateTime.now(),
            "status": "available",
            "thumbnailUrl": downloadUrlImage,
          });
    });

    setState(() {
      uploading = false;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    Fluttertoast.showToast(msg: "uploaded successfully.");
  }

  validateUploadForm() async
  {




    if (imgXFile != null) {

      if (itemDescriptionTextEditingController.text.isNotEmpty
          && itemUnitTextEditingController.text.isNotEmpty) {

         borrowAmount = double.parse(itemUnitTextEditingController.value.text) ;




       if (unit!>borrowAmount! ) {

          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialogWidget(
                  message: "Uploading",
                );
              }
          );

          setState(() {
            uploading = true;
          });


          //1. upload image to storage - get downloadUrl
          String fileName = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();

          fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
              .ref()
              .child("employerItemsImages").child(fileName);

          fStorage.UploadTask uploadImageTask = storageRef.putFile(
              File(imgXFile!.path));

          fStorage.TaskSnapshot taskSnapshot = await uploadImageTask
              .whenComplete(() {});

          await taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadUrlImage = urlImage;
          });

          //2. save job info to firestore database
          saveJobInfo();

        } else {
          Fluttertoast.showToast(msg: "not enough unit.");
        }
      }

      else{
          Fluttertoast.showToast(msg: "Please fill complete form.");

        }
      }

    else {
      Fluttertoast.showToast(msg: "Please choose image.");
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
                Icons.cloud_upload,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.indigo
          ),
        ),
        title: const Text(
            "Upload New job"
        ),
        centerTitle: true,
      ),
      body: ListView(

        children: [

          //image


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("Total unit you have: $unit",style: const TextStyle(
                fontSize: 18,
                color: Colors.indigo
              ),),
            ),
          ),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.8,

            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,


                child: GestureDetector(
                  onTap: ()
                  {
                    obtainImageDialogBox();
                  },
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    backgroundColor: Colors.white,
                    backgroundImage: imgXFile == null
                        ? null
                        : FileImage(
                        File(imgXFile!.path)
                    ),
                    child: imgXFile == null
                        ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.black54,
                      size: MediaQuery.of(context).size.width * 0.20,
                    ) : null,
                  ),
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: DropdownButtonFormField(
              value: selectedVal,
              items: _jobCategoryList.map(
                      (e)=> DropdownMenuItem(child: Text(e),value: e,)
              ).toList(),
              onChanged: (val){
                setState(() {
                  selectedVal= val as String;
                });
              },icon: const Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.indigo,
            ),
              decoration: const InputDecoration(
                  labelText: "Job title",
                  prefixIcon: Icon(Icons.category,
                    color: Colors.indigo,
                    // color: Colors.black,
                  ),
                  border: UnderlineInputBorder()

              ),
            ),
          ),


          const Padding(
            padding: EdgeInsets.only(top: 10,left: 28,bottom: 2),
            child: Text("job requirement",style: TextStyle(
              color: Colors.indigo,fontSize: 16
            ),),
          ),
          ListTile(

            title: SizedBox(
              width: 250,

              child: TextField(
                style: const TextStyle(color: Colors.black),
                minLines: 5,
                maxLines: 7,
                maxLength: 1000,
                controller: itemDescriptionTextEditingController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "job requirement",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),


                ),
              ),
            ),
          ),



          const Padding(
            padding: EdgeInsets.only(left: 28.0),
            child: Text("job unit",style: TextStyle(
                color: Colors.indigo,fontSize: 16
            ),),
          ),
          //item unit
          ListTile(

            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                minLines: 1,
                maxLines: 7,
                maxLength: 4,
                controller: itemUnitTextEditingController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "job unit",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),


                ),
              ),
            ),
          ),


          ListTile(
            leading:  IconButton(
              icon: const Icon(Icons.calendar_month),
              iconSize: 25,
              color: Colors.indigo,
              onPressed: () async {
                final DateTime? datetime=await
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );if(datetime!=null){
                  setState(() {
                    date=datetime;
                  });
                }
              },

            ),
            title: SizedBox(
              width: 190,
              child:  Text(
                'Due date: ${date.year} - ${date.month} - ${date.day}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),


          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: ()
                {
                  uploading == true ? null : validateUploadForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                 // fixedSize:  Size(290, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Upload",style: TextStyle(fontSize: 18,),
                )
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return  uploadFormScreen();
  }


  obtainImageDialogBox()
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            title: const Text(
              "job Image",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImagewithPhoneCamera();
                },
                child: const Text(
                  "Capture image with Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  getImageFromGallery();
                },
                child: const Text(
                  "Select image from Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

  getImageFromGallery() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imgXFile;
    });
  }

  captureImagewithPhoneCamera() async
  {
    Navigator.pop(context);

    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imgXFile;
    });
  }
}
