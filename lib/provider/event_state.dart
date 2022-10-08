import 'package:myliveevent/provider/disposable_provider.dart';

class EventState extends DisposableProvider {

  List<Map<String, dynamic>>? _messages = [];
  String? _progessUpload = '';
  String? _nameVideoUploading = '';
  double? _latitude = 0.0;
  double? _longitude = 0.0;
  String? _email = '';
  String? _nomUser = '';
  String? _urlDownload = '';
  String? _dist;
  String? _unit;

  String? _addEventLoad = '';


  String get nomUser => _nomUser!;

  set nomUser(String value) {
    _nomUser = value;
    notifyListeners();
  }

  String get urlDownload => _urlDownload!;

  set urlDownload(String value) {
    _urlDownload = value;
    notifyListeners();
  }

  String get addEventLoad => _addEventLoad!;


  String get email => _email!;

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set addEventLoad(String value) {
    _addEventLoad = value;
    notifyListeners();
  }

  double get latitude => _latitude!;

  set latitude(double value) {
    _latitude = value;
    notifyListeners();
  }

  double get longitude => _longitude!;

  set longitude(double value) {
    _longitude = value;
    notifyListeners();
  }


  String get nameVideoUploading => _nameVideoUploading!;

  set nameVideoUploading(String value) {
    _nameVideoUploading = value;
    notifyListeners();
  }

  String get progessUpload => _progessUpload!;

  set progessUpload(String value) {
    _progessUpload = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get messages => _messages!;

  String? _infoMapService;


  String get infoMapService => _infoMapService!;

  set infoMapService(String value) {
    _infoMapService = value;
    notifyListeners();
  }

  set messages(List<Map<String, dynamic>> value) {
    _messages = value;
    notifyListeners();
  }


  String get dist => _dist!;

  set dist(String value) {
    _dist = value;
    notifyListeners();
  }

  String get unit => _unit!;

  set unit(String value) {
    _unit = value;
    notifyListeners();
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }

}