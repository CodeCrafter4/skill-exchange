import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:employer_app/itemsScreens/items_ui_design_widget.dart';
import 'package:employer_app/itemsScreens/upload_items_screen.dart';
import 'package:employer_app/models/items.dart';
import '../global/global.dart';
import 'package:employer_app/models/jobs.dart';
import '../widgets/text_delegate_header_widget.dart';


class ItemsScreen extends StatefulWidget
{
  jobs? model;

  ItemsScreen({this.model,});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}



class _ItemsScreenState extends State<ItemsScreen>
{
  String? title="";
  @override
  Widget build(BuildContext context)
  {

    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(



          title:  Text(
            widget.model?.jobTitle ?? 'Unknown Job Title'.toUpperCase(),
            style: const TextStyle(
              fontSize: 25,
              //fontFamily: 'Signatra',
              color: Colors.white,


            ),
          ),


        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
             color: Colors.indigo
          ),
        ),


        actions: [
          IconButton(
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadItemsScreen(
                model: widget.model,
              )));
            },
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [



          //1. query
          //2. model
          //3. ui design widget

          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("employers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("jobs")
                .doc(widget.model!.jobID)
                .collection("jobsItems")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot)
            {
              if(dataSnapshot.hasData) //if brands exists
                  {
                //display brands
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    JobsItems itemsModel = JobsItems.fromJson(
                      dataSnapshot.data.docs[index].data() as Map<String, dynamic>,
                    );

                    return ItemsUiDesignWidget(
                      model: itemsModel,
                      context: context,
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              }
              else //if brands NOT exists
                  {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No job Items exists",
                    ),
                  ),
                );
              }
            },
          ),

        ],
      ),
    );
  }
}
