import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

typedef ValueWeightBuild<T> = Widget Function(
  BuildContext context,
  T value,
);

class FutureNetWeight<T> extends StatefulWidget{
  final ValueWeightBuild<T> builder;
  final Function futureFunc;
  final Map<String, dynamic> params;
  final Widget loadingWidget;

  FutureNetWeight({
    @required this.builder,
    @required this.futureFunc,
    this.params,
    Widget loadingWidget,
  }) : loadingWidget = loadingWidget ??
        Container(
          alignment: Alignment.center,
          height: 200,
          child: CupertinoActivityIndicator(),
        );

  @override
  FutureNetWeightState createState() => new FutureNetWeightState();
}

class FutureNetWeightState extends State<FutureNetWeight>{
  Future _future;
  var oldParams;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      _request();
    });
  }

  void _request() {
    setState(() {
      if(widget.params != null){
        _future = widget.futureFunc(widget.params);
        oldParams = widget.params;
      }
    });
  }

  @override
  void didUpdateWidget(FutureNetWeight oldWidget) {
    if(oldParams != widget.params || oldWidget.futureFunc != widget.futureFunc){
      WidgetsBinding.instance.addPostFrameCallback((call) {
        _request();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return widget.loadingWidget;
          case ConnectionState.none:
          case ConnectionState.done:
            return widget.builder(context, snapshot.data);
        }
        return Container();
      },
    );  
  }
}