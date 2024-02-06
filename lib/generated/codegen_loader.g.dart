// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "Ok": "Ok",
  "Cansel": "Cansel",
  "Editing": "Editing",
  "Unlist_folders": "Unlist folders ?",
  "Add_folder": "Add folder",
  "name": "name",
  "Added": "Added"
};
static const Map<String,dynamic> ru = {
  "Ok": "Дa",
  "Cansel": "Отмена",
  "Editing": "Редактирование",
  "Unlist_folders": "Удалить папки из списка ?",
  "Add_folder": "Добавить папку",
  "name": "имя",
  "Added": "Добавлено"
};
static const Map<String,dynamic> uz = {
  "Ok": "Ha",
  "Cansel": "Qaytish",
  "Editing": "Tahrirlash",
  "Unlist_folders": "Papkalar ro'yxatidan chiqarilsinmi ?",
  "Add_folder": "Jild qo'shish",
  "name": "nomi",
  "Added": "Qo'shish"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ru": ru, "uz": uz};
}
