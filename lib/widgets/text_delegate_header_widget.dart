import 'package:flutter/material.dart';


class TextDelegateHeaderWidget extends SliverPersistentHeaderDelegate
{
  String? title;
  TextDelegateHeaderWidget({this.title,});

  @override
  Widget build(BuildContext context, double shrinkOffSet, bool overlapsContent,)
  {
    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
           color: Colors.indigo
        ),
        height: 152,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: InkWell(
          child: Text(
            title.toString(),
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 50;

  @override
  // TODO: implement minExtent
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;


}
