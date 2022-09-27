import 'package:myliveevent/provider/disposable_provider.dart';

class ChatState extends DisposableProvider {

  List<Map<String, dynamic>>? _messages = [];


  List<Map<String, dynamic>> get messages => _messages!;

  set messages(List<Map<String, dynamic>> value) {
    _messages = value;
    notifyListeners();
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}