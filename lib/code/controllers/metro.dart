
import 'package:get/get.dart';
import 'package:intune/code/controllers/settings_controller.dart';
import 'package:metronome/metronome.dart';

class MetroController extends GetxController {
  // Observable values for UI
  RxInt count = 0.obs;         // Current beat position
  RxInt beats = 4.obs;         // Number of beats in measure (time signature)
  RxDouble tempo = 120.0.obs;  // Default to 120 BPM
  RxBool play = false.obs;     // Is metronome playing

  final _metronomePlugin = Metronome();
  final SettingsController _settingsController = Get.find<SettingsController>();

  int currentTick = 0;

  @override
  void onInit() {
    super.onInit();
    _metronomePlugin.init(
      'sounds/${_settingsController.settings.value.otherBeatsSound}44_wav.wav',
      accentedPath: 'sounds/${_settingsController.settings.value.firstBeatSound}44_wav.wav',
      bpm: tempo.value.toInt(),
      enableTickCallback: true,
      timeSignature: beats.value,
      sampleRate: 44100,
    );
    _metronomePlugin.tickStream.listen(
      (int tick) {
        count.value = tick;
      },
    );
  }

  void start() {
    _metronomePlugin.setBPM(tempo.value.toInt());
    _metronomePlugin.setTimeSignature(beats.value);
    _metronomePlugin.play();
    play.value = true;
  }

  void stop() {
    _metronomePlugin.stop();
    count.value = 0;
    play.value = false;
  }

  void updateTempo(double newTempo) {
    tempo.value = newTempo;
    _metronomePlugin.setBPM(tempo.value.toInt());
    _metronomePlugin.setTimeSignature(beats.value);
    count.value = 0;
  }

  @override
  void onClose() {
    _metronomePlugin.destroy();
    super.dispose();
  }
}