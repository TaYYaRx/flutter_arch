import 'dart:async';

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
    // 1. Önce yerel veritabanındaki veriyi getir (Hızlı yükleme)
    final localProjeler = ref.read(hiveServiceProvider.notifier).getAllListFromBox();

    // 2. Arka planda API'den güncel veriyi çek ve yereli güncelle
    _fetchFromRemote();
    return localProjeler;
  }

  Future<void> _fetchFromRemote() async {
    print('Veriler getiriliyor');
    try {
      //Verileri Remote kaynaktan getir.
      final remoteData = await locator<ApiService>().fetchProjeler();
      //Verileri localDB'e ekle
      await ref.read(hiveServiceProvider.notifier).cleanAndSaveListToBox(remoteData);
      state = AsyncData(remoteData);
    } catch (e) {
      // Hata yönetimi (Opsiyonel: UI'a hata göstermek için)
      print(e);
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updateProje(Proje proje) async {
    final previousState = await future;
    //final preProje = previousState.firstWhere((p) => p.id == proje.id);

    // 1. Adım: Yerel State'i Hemen Güncelle (Veri remote tarafında hatasız olarak güncellendi varsayıyorum).
    final updatedProje = proje.copyWith(projeAdi: proje.projeAdi);
    final updatedList = [
      for (final p in previousState)
        if (p.id == proje.id) updatedProje else p,
    ];
    state = AsyncData(updatedList);

    try {
      // 2. Adım: API'ye gönder
      locator<ApiService>().updateProje(updatedProje: updatedProje);

      // 3. Adım: Başarılıysa Local DB'yi de güncelle
      await ref.read(hiveServiceProvider.notifier).updateItemFromBox(updatedProje);
    } catch (e) {
      state = AsyncData(previousState);
    }
  }
}


/**
 *     state = const AsyncLoading();
    // 1. Önce yerel veritabanındaki veriyi getir (Hızlı yükleme)
    final localProjeler = ref.read(hiveServiceProvider.notifier).getAllListFromBox();

    if (localProjeler.isNotEmpty) {
      //LocalDB'de veri var ve state güncelleniyor.
      print('LOCAL DE VERİ VAR');
      state = AsyncData(localProjeler);
      return localProjeler;
    }

    try {
      print('LOCAL DE VERİ YOK YENISI EKLENECEK');
      //LocalDB'de veri yok ve service ile veri getiriliyor.
      final remoteProjeler = await locator<ApiService>().fetchProjeler();

      ref.read(hiveServiceProvider.notifier).cleanAndSaveListToBox(remoteProjeler);
      state = AsyncData(remoteProjeler);

      return remoteProjeler;
    } catch (e) {
      return [];
    }
 */