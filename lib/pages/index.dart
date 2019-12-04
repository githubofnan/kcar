import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kcar/util/net_util.dart';
import 'package:kcar/widgets/progress_widget.dart';
import 'package:kcar/widgets/future_net_weight.dart';

class IndexPage extends StatefulWidget{
  @override
  createState() => new IndexPageView();
}

class IndexPageView extends State<IndexPage>{
  FormData _params;
  File _image;


  Future _tapPickerImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var copyName = image.path.substring(image.path.lastIndexOf('/')+1, image.path.lastIndexOf('.'))+'_less';
    String newName = image.path.substring(0, image.path.lastIndexOf('/')+1) + copyName + image.path.substring(image.path.lastIndexOf('.'));
    if(image.lengthSync() > 1024*1024){
      image = await _compressAndGetFile(image, newName);
    }
    String name = image.path.substring(image.path.lastIndexOf('/')+1);
    FormData formData = new FormData.from({
      "img_noSign": new UploadFileInfo(new File(image.path), name)
    });
    setState(() {
      _image = image;
      _params = formData;
    });
  }

  Future<File> _compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, 
      targetPath,
      quality: 88,
    );
    return result;
  }
  
  @override

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        preferredSize: Size.zero,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tapPickerImage,
        tooltip: 'pick image',
        backgroundColor: Colors.orange,
        child: Icon(Icons.camera_alt, size: 30),
      ),
      body: FutureNetWeight(
        futureFunc: NetUtils.getCarInfo,
        builder: (context, data) {
          return new Container(
            padding: EdgeInsets.all(20),
            child: data == null
              ? _centerText('上传车辆图片，识别品牌型号')
              : _resultWidget(data),
          );
        },
        params: _params,
      )
    );
  }

  Widget _resultWidget(data) {
    List<Widget> lists = [];
    if(data.toJson()['tags'].length > 0){
      for(var item in data.toJson()['tags']){
        lists.add(_resRowWidget(item));
      }
    }
    print(data.toJson());
    return new Column(
      children: <Widget>[
        new LimitedBox(
          maxHeight: 300,
          child: new Center(
            child: new Image.file(_image),
          )
        ),
        lists.length > 0
        ? new Column(
            children: lists,
          )
        : _centerText('车库里没有找到这辆车呢~')
      ]
    );
  }
  Widget _resRowWidget(item) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            _textTitle(item['brand']),
            _textTitle(item['serial']),
          ],
        ),
        new ProgressWidget(item['confidence'], 12.0, true, Color.fromARGB(20, 0, 0, 0), Colors.orange),
      ],
    );
  }
  Widget _textTitle(text){
    return new Padding(
      padding: EdgeInsets.only(top: 20, bottom: 2, right: 10),
      child: Text(text, style: new TextStyle(fontSize: 16))
    );
  }
  Widget _centerText(text){
    return new Align(
      child: new Text(text, style: new TextStyle(fontSize: 16)),
    );
  }
}