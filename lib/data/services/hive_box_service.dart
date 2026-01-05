import 'package:flutter_arch/data/models/projedetaymodel/projedetay_model.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:hive_ce_flutter/adapters.dart';

class HiveBoxService {
  //Sadece Hive’ı başlatır ve box verir
  static const String _projeBox = 'proje_box';
  static Box<Proje>? _projeBoxInstance;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProjeAdapter());
    Hive.registerAdapter(ProjeDetayAdapter());

    _projeBoxInstance = await Hive.openBox<Proje>(_projeBox);
    if (_projeBoxInstance != null) {
      print('Hive initialized successfully');
    }
  }

  static Box<Proje> get projeBoX {
    if (_projeBoxInstance == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    return _projeBoxInstance!;
  }
}



/**
 *   static List<Proje> getProjeList() {
    return projeBox.values.toList();
  }

  static Future<void> updateProje(Proje proje) async {
    await projeBox.put(proje.id, proje);
  }

  static Future<void> deleteProje(String id) async {
    await projeBox.delete(id);
  }

  static Future<void> saveProjeList(List<Proje> projeler) async {
    await projeBox.clear();
    for (final proje in projeler) {
      await projeBox.put(proje.id, proje);
    }
  }
 */