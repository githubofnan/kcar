class CarInfo{
  List _tags;
  String _errormsg;
  num _errorcode;
  List _logo_coord;
  Map _car_coord;

  CarInfo({
    List tags,
    String errormsg,
    num errorcode,
    List logo_coord,
    Map car_coord,
  }){
    this._tags = tags;
    this._errormsg = errormsg;
    this._errorcode = errorcode;
    this._logo_coord = logo_coord;
    this._car_coord = car_coord;
  }

  CarInfo.fromJson(Map<String, dynamic> json){
    this._errormsg = json['errormsg'];
    this._errorcode = json['errorcode'];
    this._logo_coord = json['logo_coord'];
    this._car_coord = json['car_coord'];
    if (json['tags'] != null) {
      _tags = new List();
      json['tags'].forEach((v) {
        _tags.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tags'] = this._tags;
    data['errormsg'] = this._errormsg;
    data['errorcode'] = this._errorcode;
    data['logo_coord'] = this._logo_coord;
    data['car_coord'] = this._car_coord;
    return data;
  }
}