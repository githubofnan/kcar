import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:kcar/router/router.dart';
import 'package:kcar/application.dart';

void main() => runApp(new ThisApp());

class ThisApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return new MaterialApp(
      title: 'kcar',
      onGenerateRoute: Application.router.generator,
    );
  }
}