import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:geolocator/geolocator.dart';

class SistemaUtil {
  static final FlutterReactiveBle _ble = FlutterReactiveBle();

  static Stream<bool> bluetoothStream() {
    return _ble.statusStream.map((status) => status == BleStatus.ready);
  }

  static Future<bool> estaBluetoothActivo() async {
    final status = await _ble.statusStream.first;
    return status == BleStatus.ready;
  }

  static Future<bool> hayInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<bool> estaWiFiActivo() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  static Future<bool> estaGpsActivo() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
