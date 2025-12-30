import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/services/hive_service.dart';

abstract class AppRepository {
  //proje,kabin,motorsus,raykapi anabaşlıkları, hive işlemleri için genel bir sınıf.

  Future<void> add(Proje proje);
  Future<void> delete(String id);
  Future<void> update(Proje proje);
  List<Proje> getAllList();
  Future<void> cleanAndSaveListToHive(List<Proje> projeler);
  Proje? getById(String id);
}

class HiveRepository extends AppRepository {
  //Hive ile konuşur
  //Veri nasıl saklanıyor → Service umursamaz

  @override
  Future<void> add(Proje proje) async {
    await HiveService.projeBoX.add(proje);
  }

  @override
  Future<void> cleanAndSaveListToHive(List<Proje> projeler) async {
    print('YENISI EKLENIYOR');

    await HiveService.projeBoX.clear();
    for (final proje in projeler) {
      await HiveService.projeBoX.put(proje.id, proje);
    }
  }

  @override
  Future<void> delete(String id) async {
    await HiveService.projeBoX.delete(id);
  }

  @override
  List<Proje> getAllList() {
    return HiveService.projeBoX.values.toList();
  }

  @override
  Future<void> update(Proje proje) async {
    await HiveService.projeBoX.put(proje.id, proje);
  }

  @override
  Proje? getById(String id) {
    return HiveService.projeBoX.get(id);
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
