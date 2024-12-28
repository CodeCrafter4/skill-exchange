
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:employer_app/global/global.dart';
import 'package:employer_app/models/freelancers.dart';
import 'package:employer_app/my_skill/freelancers_ui_design.dart';
import 'package:employer_app/widgets/my_drawer.dart';


class Freelancers_home extends StatefulWidget
{
  @override
  State<Freelancers_home> createState() => _freelancersHomeScreenState();
}


class _freelancersHomeScreenState extends State<Freelancers_home>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.indigo
          ),
        ),
        title: const Text(
          "Skill exchange",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          //query
          //model
          //design widget

          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapshot)
            {
              if(dataSnapshot.hasData)
              {
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                  itemBuilder: (context, index)
                  {
                    Freelancers model = Freelancers.fromJson(
                        dataSnapshot.data.docs[index].data() as Map<String, dynamic>
                    );

                    return EmployerUIDesignWidget(
                      model: model,
                    );
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
              }
              else
              {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No Freelancer Data exists.",
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
