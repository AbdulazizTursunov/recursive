import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recursive/data/model/jadval_model.dart';
import 'package:recursive/generated/codegen_loader.g.dart';
import 'data/db/db_initialize.dart';
import 'view_jadvaal/recursive_folders.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  Directory? directory;
  if (Platform.isWindows) {
    directory = await getApplicationSupportDirectory();
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  if (!await directory.exists()) {
  await directory.create(recursive: true);
  }
    DbInitialize().initDb(directory.path);
  runApp(
    EasyLocalization(
        supportedLocales:const  [Locale('en'), Locale('uz'), Locale('ru')],
        path: 'assets/translation', // <-- change the path of the translation files
        fallbackLocale:const  Locale('ru'),
        assetLoader:const  CodegenLoader(),
        child:const  MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Jadval jadval = Jadval();
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: RecursiveFoldersView(jadval: jadval, folder: '',),
    );
  }
}

