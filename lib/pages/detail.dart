import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kcar/util/net_util.dart';
import 'package:kcar/widgets/future_net_weight.dart';

class DetailPage extends StatefulWidget{
  final Map<String, dynamic> params;
  DetailPage(this.params);

  DetailPageState createState() => new DetailPageState();
}

class DetailPageState extends State<DetailPage>{
  Map<String, dynamic> params;
  @override
  Widget build (BuildContext context){
    setState(() {
      params = json.decode(widget.params['params'][0]);
    });
    final Map<String, dynamic> message = {'message': params['serial'].substring(0, params['serial'].indexOf('#'))};
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(params['serial']),
      ),
      body: FutureNetWeight(
        futureFunc: NetUtils.getCarPrice,
        builder: (context, data) {
          return new Container(
            padding: EdgeInsets.all(20),
            child: data == null
              ? new Center(child: CupertinoActivityIndicator())
              : _pageMain(data),
          );
        },
        params: message,
      ),
    );
  }

  Widget _pageMain(data){
    final Map<String, dynamic> res = data['data'][0]['display'];
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        LimitedBox(
          maxHeight: 300,
          child: new Center(
            child: res['cover_url'] != null 
              ? new Image.network(res['cover_url'])
              : new Image.asset(params['carUrl'])
          )
        ),
        _textTitle('${res["series_name"] ?? params["serial"]}'),
        _textTitle('车型：${res["series_type"] ?? res["serie"][0]["level"]}'),
        _textTitle('品牌：${res["sub_brand_name"] ?? params["brand"]}'),
        _textTitle('经销商报价：${res["agent_price"] ?? res["serie"][0]["pricelimits"]}'),
        _textTitle('厂商指导价：${res["official_price"] ?? res["serie"][0]["pricelimits"]}'),

      ],
    );
  }
  Widget _textTitle(text){
    return new Padding(
      padding: EdgeInsets.only(top: 10, left: 50),
      child: new Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: new TextStyle(fontSize: 16)),
      )
    );
  }
}