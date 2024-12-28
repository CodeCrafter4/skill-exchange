import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employer_app/my_skill/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:employer_app/models/items.dart';
import 'package:intl/intl.dart';
import '../global/global.dart';

class ItemsDetailsScreen extends StatefulWidget
{
  JobsItems? model;

  ItemsDetailsScreen({this.model,});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}



class _ItemsDetailsScreenState extends State<ItemsDetailsScreen>
{
  var format = DateFormat('dd MMMM, yyyy - hh:mm aa');
  deleteItem()
  {
    FirebaseFirestore.instance
        .collection("employers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("jobs")
        .doc(widget.model!.jobID)
        .collection("jobsItems")
        .doc(widget.model!.itemID)
        .delete()
        .then((value)
    {
      FirebaseFirestore.instance
          .collection("jobsItems")
          .doc(widget.model!.itemID)
          .delete();

      Fluttertoast.showToast(msg: "job Item Deleted Successfully.");
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        flexibleSpace: Container(
            decoration: const BoxDecoration(
               color: Colors.lightBlue
            ),
        ),
        title: Text(
          widget.model!.itemTitle.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: ()
          {
             showDialog(
                context: context,
                builder: (context)
            {
              return SimpleDialog(
                title: const Text(
                  "Are you sure you want to Delete?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),
                ),
                children: [
                  SimpleDialogOption(
                    onPressed: ()
                    {
                      deleteItem();
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
           // deleteItem();
          },
          label: const Text(
            "Delete this job Item"

          ),
        icon: const Icon(
          Icons.delete_sweep_outlined,
          color: Colors.pinkAccent,
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.center,
                child: Flexible(

                  child: Image.network(
                    widget.model!.thumbnailUrl.toString(),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "${widget.model!.itemTitle.toString().toUpperCase()}.",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.lightBlue,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                "from: ""${widget.model!.employerName.toString().toUpperCase()}.",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.all(8.0, ),
              child: Text(
                "Requirements:- ",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0, ),
              child: Text(
                 widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${widget.model!.unit} unit",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blue,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 320.0),
              child: Divider(
                height: 1,
                thickness: 2,
                color: Colors.lightBlue,
              ),
            ),

          const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(

               "posted date: ${DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.parse(widget.model!.publishedDate.toString()))}",

                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
              child: Text(
                "Due date: ${DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.parse(widget.model!.dueDate.toString()))}",
               //"due Date: ${widget.model!.dueDate}",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 100,),

          ],
        ),
      ),
    );
  }
}
