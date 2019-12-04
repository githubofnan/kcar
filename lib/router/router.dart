import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcar/pages/index.dart';

final router = Router();

var indexHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) => IndexPage()
);

class Routes{
  static String indexPage = '/';
  static String personalPage = '/personal';

  static void configureRoutes(Router router){
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        print('ERROR====>ROUTE WAS NOT FONUND!!!');
        return null;
      }
    );
    router.define(indexPage, handler: indexHandler);
  }
}