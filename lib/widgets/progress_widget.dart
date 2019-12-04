import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

class ProgressWidget extends StatefulWidget{
  final double value;
  final double height;
  final bool isRadius;
  final Color bgColor;
  final Color valueColor;

  ProgressWidget(
    this.value,
    this.height,
    this.isRadius,
    this.bgColor,
    this.valueColor,
  );

  ProgressWidgetState createState() => new ProgressWidgetState();
}

class ProgressWidgetState extends State<ProgressWidget>{
  @override
  Widget build(BuildContext context){
    return new SizedBox(
      height: widget.height,
      child: new ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(widget.isRadius ? widget.height/2 : 0)),
        child: new LinearProgressIndicator(
          value: widget.value,
          backgroundColor: widget.bgColor,
          valueColor: new AlwaysStoppedAnimation<Color>(widget.valueColor),
        ),
      ),
    );
  }
}
