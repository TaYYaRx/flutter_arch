import 'dart:async';

import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/data/services/hive_service/hive_service.dart';
import 'package:flutter_arch/data/services/api_service.dart';
import 'package:flutter_arch/logic/hs_error_provider/hs_error.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proje_async_.g.dart';

@riverpod
class ProjeAsync extends _$ProjeAsync {
  @override
  FutureOr<List<Proje>> build() async {
    // Yerel veriyi hemen döndür
    final localProjeler = ref
        .read(hiveServiceProvider.notifier)
        .getAllListFromBox();

    print('📦 Local DB\'den ${localProjeler.length} proje yüklendi');

    // Arka planda remote veri çekmeyi başlat
    Future.microtask(() => _fetchFromRemote());
    print('🔄 Arka planda API sync başlatıldı');

    return localProjeler;
  }

  Future<void> _fetchFromRemote() async {
    if (state.isLoading && state.isRefreshing) return;

    try {
      print('🔄 Veriler API\'den getiriliyor...');

      //Verileri Remote kaynaktan getir.
      final remoteData = await locator<ApiService>().fetchProjeler();
      print('✅ API başarılı: ${remoteData.length} proje alındı');

      //Verileri localDB'e ekle
      await ref
          .read(hiveServiceProvider.notifier)
          .cleanAndSaveListToBox(remoteData);
      print('💾 Veriler local DB\'ye kaydedildi');

      state = AsyncData(remoteData);
      print('✅ State güncellendi - Başarılı!');
    } catch (e, stack) {
      print('❌ Remote fetch hatası: $e');
      print(
        '📚 Stack trace: ${stack.toString().split('\n').take(3).join('\n')}',
      );

      // Her zaman hatayı göster - sunucu kapalıysa kullanıcı bilmeli
      state = AsyncError(e, stack);
      print('⚠️ State hata durumuna geçti');
    }
  }

  // Manuel refresh için
  Future<void> refresh() async {
    state = const AsyncLoading();
    await _fetchFromRemote();
  }

  Future<void> updateProje(Proje proje) async {
    final previousState = await future;

    // 1. Adım: Yerel State'i Hemen Güncelle (Optimistic update)
    final updatedProje = proje.copyWith(
      projeAdi: proje.projeAdi,
      projeDetay: proje.projeDetay,
    );
    final updatedList = [
      for (final p in previousState)
        if (p.id == proje.id) updatedProje else p,
    ];
    state = AsyncData(updatedList);

    try {
      // 2. Adım: API'ye gönder (await eklendi!)
      await locator<ApiService>().updateProje(updatedProje: updatedProje);

      // 3. Adım: Başarılıysa Local DB'yi de güncelle
      await ref
          .read(hiveServiceProvider.notifier)
          .updateItemFromBox(updatedProje);
    } catch (e) {
      // Hata durumunda rollback
      print('Update error: $e');
      state = AsyncData(previousState);
      rethrow; // Hatayı UI'a ilet
    }
  }

  Future<void> addProje(Proje proje) async {
    final previousState = await future;

    // 1. Adım: Geçici olarak Yerel State'i Güncelle (optimistic update)
    final updatedList = [...previousState, proje];
    state = AsyncData(updatedList);

    try {
      // 2. Adım: API'ye gönder ve MongoDB'nin oluşturduğu ID'yi al
      final createdProje = await locator<ApiService>().addProje(proje: proje);

      // 3. Adım: State'i gerçek ID ile güncelle
      final finalList = [
        ...previousState,
        createdProje, // MongoDB'nin ID'si ile
      ];
      state = AsyncData(finalList);

      // 4. Adım: Başarılıysa Local DB'ye de gerçek ID ile ekle
      await ref.read(hiveServiceProvider.notifier).addItemToBox(createdProje);
    } catch (e) {
      // Hata durumunda önceki state'e geri dön
      state = AsyncData(previousState);
      rethrow;
    }
  }

  Future<void> deleteProje(String id) async {
    final previousState = await future;

    // DELETE STATE → deleting
    ref.read(deleteProjeStateProvider.notifier).state =
        const DeleteState.deleting();

    // 1. Adım: Optimistic Update - Hemen UI'dan kaldır
    final updatedList = previousState.where((p) => p.id != id).toList();
    state = AsyncData(updatedList);
    try {
      // 2. Adım: API'ye gönder
      await locator<ApiService>().deleteProje(id: id);

      // 3. Adım: Başarılıysa Local DB'den de sil
      await ref.read(hiveServiceProvider.notifier).deleteItemFromBox(id);

      // SUCCESS
      ref.read(deleteProjeStateProvider.notifier).state =
          const DeleteState.success();

      // Reset to idle after success
      Future.delayed(const Duration(seconds: 2), () {
        ref.read(deleteProjeStateProvider.notifier).state =
            const DeleteState.idle();
      });
    } catch (e) {
      // Hata durumunda rollback - öğeyi geri ekle
      state = AsyncData(previousState);
      ref.read(deleteProjeStateProvider.notifier).state = DeleteState.error(
        'Silinemedi',
      );

      // Reset to idle after error
      Future.delayed(const Duration(seconds: 3), () {
        ref.read(deleteProjeStateProvider.notifier).state =
            const DeleteState.idle();
      });
      rethrow; // Hatayı UI'a ilet
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