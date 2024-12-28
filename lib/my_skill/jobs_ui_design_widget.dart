import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:employer_app/splashScreen/my_splash_screen.dart';
import 'package:flutter/material.dart';
//import 'package:employer_app/itemsScreens/items_screen.dart';
import 'package:employer_app/models/jobs.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../itemsScreens/items_screen.dart';

class jobsUiDesignWidget extends StatefulWidget
{
  jobs? model;
  BuildContext? context;

  jobsUiDesignWidget({super.key, this.model, this.context,});

  @override
  State<jobsUiDesignWidget> createState() => _jobsUiDesignWidgetState();
}



class _jobsUiDesignWidgetState extends State<jobsUiDesignWidget>
{
  deleteJobType(String jobUniqueID)
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("jobs")
        .doc(jobUniqueID)
        .delete();

    Fluttertoast.showToast(msg: "job type Deleted.");
    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
  }
  @override
  Widget build(BuildContext context)
  {

    return GestureDetector(
      onTap: ()
      {
         Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(
         model: widget.model,)));
      },

      child: Card(
        elevation: 10,
        color: Colors.transparent,
        shadowColor: Colors.white,

        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,

            child: Column(

              children: [

                list(url: widget.model!.thumbnailUrl.toString(),name: widget.model!.jobTitle.toString(),desc:widget.model!.jobInfo.toString(),msg:"" ),
                const Divider(height: 7.9,),

              ],
            ),

          ),

        ),
      ),
    );

  }


  ListTile list({required String url,required String name,required String desc,required String msg}) {
    return ListTile(

      contentPadding: const EdgeInsets.only(top: 5, left: 10),
      leading:  const CircleAvatar(
        radius: 30,

        backgroundImage: ExactAssetImage('images/go.png'),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 19

            ),),

          ],
        ),
      ),
          subtitle: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(desc,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                     Container(
                         decoration: const BoxDecoration(
                                  ),
                   child: IconButton(tooltip: msg,
                      onPressed: ()
                      {
                        showDialog(
                            context: context,
                            builder: (context)
                            {
                              return SimpleDialog(
                                title: const Text(
                                  "Are you sure you want to Delete this job category?",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  SimpleDialogOption(
                                    onPressed: ()
                                    {
                                      deleteJobType(widget.model!.jobID.toString());
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15
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
                                        color: Colors.blue,
                                          fontSize: 15
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                        );


                      },
            icon: const Icon(
        Icons.delete_sweep,
        color: Colors.pinkAccent,
      ),
    ),
    ),

          ],
        ),
      ),
    );
  }
}
