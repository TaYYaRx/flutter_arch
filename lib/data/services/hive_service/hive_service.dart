import 'package:flutter/material.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/services/app_service.dart';
import 'package:flutter_arch/data/services/hive_box_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_service.g.dart';

@riverpod
class HiveService extends _$HiveService implements AppService {
  @override
  FutureOr<List> build() {
    return [];
  }

  @override
  Future<void> addItemToBox(Proje proje) async {
    await HiveBoxService.projeBoX.add(proje);
  }

  @override
  Future<void> cleanAndSaveListToBox(List<Proje> projeler) async {
    debugPrint('cleanAndSaveListToBox çalışıyor');

    await HiveBoxService.projeBoX.clear();
    for (final proje in projeler) {
      await HiveBoxService.projeBoX.put(proje.id, proje);
    }
  }

  @override
  Future<void> deleteItemFromBox(String id) async {
    await HiveBoxService.projeBoX.delete(id);
  }

  @override
  List<Proje> getAllListFromBox() {
    return HiveBoxService.projeBoX.values.toList();
  }

  @override
  Proje? getByIdFromBox(String id) {
    return HiveBoxService.projeBoX.get(id);
  }

  @override
  Future<void> updateItemFromBox(Proje proje) async {
    await HiveBoxService.projeBoX.put(proje.id, proje);
  }
}
