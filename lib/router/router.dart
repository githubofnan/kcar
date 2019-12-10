import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcar/pages/index.dart';
import 'package:kcar/pages/detail.dart';

final router = Router();

var indexHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) => IndexPage()
);
var detailHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) => DetailPage(params)
);

class Routes{
  static String indexPage = '/';
  static String detailPage = '/detail';

  static void configureRoutes(Router router){
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        print('ERROR====>ROUTE WAS NOT FONUND!!!');
        return null;
      }
    );
    router.define(indexPage, handler: indexHandler);
    router.define(detailPage, handler: detailHandler);
  }
}