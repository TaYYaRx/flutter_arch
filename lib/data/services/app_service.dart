
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';

abstract class AppService {
  //proje,kabin,motorsus,raykapi anabaşlıkları, hive işlemleri için genel bir sınıf.

  Future<void> addItemToBox(Proje proje);
  Future<void> deleteItemFromBox(String id);
  Future<void> updateItemFromBox(Proje proje);
  List<Proje> getAllListFromBox();
  Future<void> cleanAndSaveListToBox(List<Proje> projeler);
  Proje? getByIdFromBox(String id);
}