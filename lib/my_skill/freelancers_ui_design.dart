import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:employer_app/models/freelancers.dart';

import '../SendMsg/sendmsg.dart';




class EmployerUIDesignWidget extends StatefulWidget
{
  Freelancers? model;
  String? userUID;

  EmployerUIDesignWidget({this.model,this.userUID,});

  @override
  State<EmployerUIDesignWidget> createState() => _EmployersUIDesignWidgetState();
}




class _EmployersUIDesignWidgetState extends State<EmployerUIDesignWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
         // Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(
         //  )));
      },


      child: Card(
        color: Colors.black12,
        elevation: 20,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                list(url: widget.model!.photoUrl.toString(),name: widget.model!.name.toString(),desc:"Skill: "+widget.model!.skill.toString(),msg:"chat" ),
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
      leading: CircleAvatar(
        radius: 30,

        backgroundImage: NetworkImage( widget.model!.photoUrl.toString(),),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
            Text(desc,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),

            Container(
              decoration: const BoxDecoration(
              ),


              child: SmoothStarRating(
                rating: widget.model!.ratings == null ? 0.0 : double.parse(widget.model!.ratings.toString()),
                starCount: 5,
                color: Colors.deepPurple,
                borderColor: Colors.black,
                size: 16,
              ),
            ),

          ],
        ),

      ),


    );

  }


}
