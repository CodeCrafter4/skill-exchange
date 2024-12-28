import 'package:employer_app/itemsScreens/items_details_screen.dart';
import 'package:flutter/material.dart';

import 'package:employer_app/models/items.dart';

import 'items_screen.dart';

class ItemsUiDesignWidget extends StatefulWidget
{
  JobsItems? model;

  BuildContext? context;

  ItemsUiDesignWidget({this.model, this.context,});

  @override
  State<ItemsUiDesignWidget> createState() => _ItemsUiDesignWidgetState();
}




class _ItemsUiDesignWidgetState extends State<ItemsUiDesignWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsDetailsScreen(
          model: widget.model,
        )));
      },
      child: Card(
        elevation: 10,
        color: Colors.transparent,
        shadowColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                list(url: widget.model!.thumbnailUrl.toString(),name: widget.model!.itemTitle.toString(),desc:widget.model!.status.toString(),msg:"" ),
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
      leading:   CircleAvatar(
        radius: 30,

        backgroundImage: NetworkImage( widget.model!.thumbnailUrl.toString(),),
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
            Text(desc,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),


          ],
        ),
      ),
    );
  }
}
