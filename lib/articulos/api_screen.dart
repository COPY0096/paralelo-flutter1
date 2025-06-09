import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'articulo_model.dart';
import 'articulo_service.dart';
import 'sistema_util.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  bool? wifiActivo;
  bool? gpsActivo;
  bool? conectadoInternet;
  String filtro = '';
  List<Articulo> articulos = [];
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StreamSubscription<ServiceStatus>? _gpsSubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        conectadoInternet = result != ConnectivityResult.none;
        wifiActivo = result == ConnectivityResult.wifi;
      });
    });

    _gpsSubscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      setState(() {
        gpsActivo = status == ServiceStatus.enabled;
      });
    });

    verificarEstados();
    cargarArticulos();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }

  Future<void> verificarEstados() async {
    final connectivity = await Connectivity().checkConnectivity();
    conectadoInternet = connectivity != ConnectivityResult.none;
    wifiActivo = await WiFiForIoTPlugin.isEnabled();
    gpsActivo = await Geolocator.isLocationServiceEnabled();
    setState(() {});
  }

  Future<void> cargarArticulos([String consulta = '']) async {
    try {
      final lista = await fetchArticulos(consulta: consulta);
      setState(() {
        articulos = lista;
      });
    } catch (e) {
      print('Error al cargar artículos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estado del Sistema + API')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text("Conexión a Internet: ${conectadoInternet == true ? 'Sí' : 'No'}"),
            Text("Wi-Fi: ${wifiActivo == true ? 'Activo' : 'Inactivo'}"),
            Text("GPS: ${gpsActivo == true ? 'Activo' : 'Inactivo'}"),
            StreamBuilder<bool>(
              stream: SistemaUtil.bluetoothStream(),
              builder: (context, snapshot) {
                final activo = snapshot.data ?? false;
                return Text("Bluetooth: ${activo ? 'Activo' : 'Inactivo'}");
              },
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar artículo...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filtro = value;
                cargarArticulos(filtro);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: articulos.isEmpty
                  ? const Center(child: Text('No hay artículos disponibles'))
                  : ListView.builder(
                      itemCount: articulos.length,
                      itemBuilder: (context, index) {
                        final art = articulos[index];
                        return ListTile(
                          title: Text(art.nombre),
                          subtitle: Text(
                            'Marca: ${art.marca}, Modelo: ${art.modelo}\n'
                            'Cantidad: ${art.cantidad} | Precio: ${art.precio.toStringAsFixed(2)} RD\$',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
