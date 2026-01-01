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
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updateProje(Proje proje) async {
    final previousState = await future;

    // 1. Adım: Yerel State'i Hemen Güncelle (Optimistic update)
    final updatedProje = proje.copyWith(projeAdi: proje.projeAdi, projeDetay: proje.projeDetay);
    final updatedList = [
      for (final p in previousState)
        if (p.id == proje.id) updatedProje else p,
    ];
    state = AsyncData(updatedList);

    try {
      // 2. Adım: API'ye gönder (await eklendi!)
      await locator<ApiService>().updateProje(updatedProje: updatedProje);

      // 3. Adım: Başarılıysa Local DB'yi de güncelle
      await ref.read(hiveServiceProvider.notifier).updateItemFromBox(updatedProje);
    } catch (e) {
      // Hata durumunda rollback
      print('Update error: $e');
      state = AsyncData(previousState);
      rethrow; // Hatayı UI'a ilet
    }
  }

  Future<void> addProje(Proje proje) async {
    final previousState = await future;

    // 1. Adım: Yerel State'i Hemen Güncelle
    final updatedList = [...previousState, proje];
    state = AsyncData(updatedList);

    try {
      // 2. Adım: API'ye gönder
      await locator<ApiService>().addProje(proje: proje);

      // 3. Adım: Başarılıysa Local DB'ye de ekle
      await ref.read(hiveServiceProvider.notifier).addItemToBox(proje);
    } catch (e) {
      // Hata durumunda önceki state'e geri dön
      state = AsyncData(previousState);
    }
  }

  Future<void> deleteProje(String id) async {
    final previousState = await future;

    // 1. Adım: Yerel State'i Hemen Güncelle
    final updatedList = previousState.where((p) => p.id != id).toList();
    state = AsyncData(updatedList);

    try {
      // 2. Adım: API'ye gönder
      await locator<ApiService>().deleteProje(id: id);

      // 3. Adım: Başarılıysa Local DB'den de sil
      await ref.read(hiveServiceProvider.notifier).deleteItemFromBox(id);
    } catch (e) {
      // Hata durumunda önceki state'e geri dön
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