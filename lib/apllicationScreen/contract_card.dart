import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/items.dart';
import 'contract_details_screen.dart';


class OrderCard extends StatefulWidget
{
  int? itemCount;
  List<DocumentSnapshot>? data;
  String? orderId;
  List<String>? seperateQuantitiesList;

  OrderCard({
    this.itemCount,
    this.data,
    this.orderId,
    this.seperateQuantitiesList,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard>
{
  @override
  Widget build(BuildContext context)
  {
    return GestureDetector(
      onTap: (){
               Navigator.push(context,MaterialPageRoute(builder: (c)=> contractDetailsScreen(orderID:widget.orderId,
       )));
      },
      child: Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.lightBlue,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          height: widget.itemCount! * 125, //2*125
          child: ListView.builder(
            itemCount: widget.itemCount,
            itemBuilder: (context, index)
            {
              JobsItems model = JobsItems.fromJson(widget.data![index].data() as Map<String, dynamic>);
              return placedOrdersItemsDesignWidget(model, context, widget.seperateQuantitiesList![index]);
            },
          ),
        ),
      ),
    );
  }
}


Widget placedOrdersItemsDesignWidget(JobsItems job, BuildContext context, itemQuantity)
{
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    color: Colors.transparent,
    child: Row(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            job.thumbnailUrl.toString(),
            width: 120,
          ),
        ),

        const SizedBox(width: 10.0,),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(
                  height: 20,
                ),

                //title and price
                Row(
                  children: [

                    Expanded(
                      child: Text(
                        job.itemTitle.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    const Text(
                      "UNIT ",
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      job.unit.toString(),
                      style: const TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                //x with quantity
                Row(
                  children: [

                     const Text(
                      "info  ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),

                    Flexible(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        job.status.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),

      ],
    ),
  );
}
