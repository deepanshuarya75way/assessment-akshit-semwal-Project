import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Tabcontroller extends GetxController {
  RxInt _tabindex = 0.obs;

  int get tabindex => _tabindex.value;

  void indexchange(int Value) {
    _tabindex.value = Value;
  }
}
