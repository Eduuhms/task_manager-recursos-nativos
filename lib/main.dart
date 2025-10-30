import 'package:flutter/material.dart';
import 'package:task_manager/services/camera_service.dart';
import 'dart:io' show Platform;
import 'screens/task_list_screen.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Inicializa o FFI (obrigatório para desktop)
  // sqfliteFfiInit();

  // Define o databaseFactory global para o desktop
  // databaseFactory = databaseFactoryFfi;

  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar câmera somente em mobile (evita MissingPluginException no desktop)
  if (Platform.isAndroid || Platform.isIOS) {
    await CameraService.instance.initialize();
  } else {
    print('⚠️ Câmera não inicializada: plataforma não suportada para plugin de câmera.');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}