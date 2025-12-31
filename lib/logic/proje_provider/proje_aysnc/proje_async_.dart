import 'dart:async';
import 'dart:convert';
import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/services/hive_service/hive_service.dart';
import 'package:flutter_arch/data/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proje_async_.g.dart';

@riverpod
class ProjeAsync extends _$ProjeAsync {
  @override
  FutureOr<List<Proje>> build() async {
    state = const AsyncLoading();
    final localProjeler = ref.read(hiveServiceProvider.notifier).getAllListFromBox();

    if (localProjeler.isNotEmpty) {
      print('LOCAL DE VERİ VAR');
      state = AsyncData(localProjeler);
      return localProjeler;
    }

    try {
      print('LOCAL DE VERİ YOK YENISI EKLENECEK');
      final remoteProjelerString = await locator<ApiService>().fetchProjeler();
      final List<dynamic> remoteProjelerList = json.decode(remoteProjelerString);
      final remoteProjeler = remoteProjelerList.map((e) => Proje.fromJson(e as Map<String, dynamic>)).toList();
      ref.read(hiveServiceProvider.notifier).cleanAndSaveListToBox(remoteProjeler);
      state = AsyncData(remoteProjeler);

      return remoteProjeler;
    } catch (e) {
      return [];
    }
  }
}
