import 'package:get/get.dart';
import 'package:intune/code/controllers/chords.dart';
import 'package:intune/code/controllers/metro.dart';
import 'package:intune/code/controllers/song_controller.dart';
import 'package:intune/code/controllers/tuner.dart';

class DependenciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChordController());
    Get.lazyPut<MetroController>(() => MetroController(), fenix: true);
    Get.lazyPut<TunerController>(() => TunerController(), fenix: true);
    Get.lazyPut<SongController>(() => SongController(), fenix: true);
    Get.lazyPut<SongController>(() => SongController(), fenix: true);
  }
}
