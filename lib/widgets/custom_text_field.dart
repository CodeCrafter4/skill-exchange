import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget
{
  TextEditingController? textEditingController;
  IconData? iconData;
  String? hintText;
  int? maxLength;
  var isObsecre1;
  bool? enabled = true;

  CustomTextField({super.key,
    this.textEditingController,
    this.iconData,
    this.hintText,
    this.maxLength,
    this.isObsecre1,
    this.enabled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
{
  @override
  Widget build(BuildContext context)
  {
    var isObsecre=false;

    return Material(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,

          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),

        child: TextFormField(
          style: const TextStyle(color: Colors.black),
          enabled: widget.enabled,

          controller: widget.textEditingController,
          obscureText: widget.isObsecre1!,
          maxLength: widget.maxLength,

          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            // suffixIcon:IconButton(
            //     padding:EdgeInsetsDirectional.only(end: 12.0),
            //
            //     icon:widget.isObsecre1!
            //         ? const Icon(Icons.visibility,):
            //    const Icon(Icons.visibility_off,),
            //   onPressed: () {
            //       setState(() {
            //         isObsecre =! isObsecre;
            //       });
            //
            //       },
            // ) ,
            border: InputBorder.none,

            prefixIcon: Icon(

              widget.iconData,
              color: Colors.black54,
            ),

            
            focusColor: Theme.of(context).primaryColorDark,
            hintText: widget.hintText,hintStyle: const TextStyle(color: Colors.grey),

            //contentPadding: EdgeInsets.all(20)
          ),
        ),
      ),
    );
  }
}