import 'package:flutter/material.dart';
import 'package:flutter_arch/data/models/projedetaymodel/projedetay_model.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HSService {
  Future<bool?> showDeleteConfirmation(
    BuildContext context,
    Proje proje,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text('Projeyi Sil'),
          ],
        ),
        content: Text(
          '"${proje.projeAdi}" projesini silmek istediğinizden emin misiniz?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void showAddEditDialog(BuildContext context, WidgetRef ref, {Proje? proje}) {
    final isEdit = proje != null;
    final projeAdiController = TextEditingController(
      text: proje?.projeAdi ?? '',
    );
    final kuyuBoyController = TextEditingController(
      text: proje?.projeDetay.kuyuBoy.toString() ?? '',
    );
    final kuyuDerinlikController = TextEditingController(
      text: proje?.projeDetay.kuyuDerinlik.toString() ?? '',
    );
    bool todoStatus = proje?.projeDetay.todoStatus ?? false;
    String? projeAdiError;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isEdit ? Icons.edit : Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(isEdit ? 'Projeyi Düzenle' : 'Yeni Proje Ekle'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: projeAdiController,
                  autofocus: false,
                  onChanged: (_) {
                    // Kullanıcı yazdıkça hatayı temizle
                    if (projeAdiError != null) {
                      setState(() => projeAdiError = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Proje Adı',
                    prefixIcon: const Icon(Icons.folder),
                    errorText: projeAdiError,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: kuyuBoyController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Kuyu Boyu (m)',
                    prefixIcon: const Icon(Icons.height),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: kuyuDerinlikController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Kuyu Derinliği (m)',
                    prefixIcon: const Icon(Icons.arrow_downward),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Proje Durumu'),
                  subtitle: Text(todoStatus ? 'Tamamlandı' : 'Devam Ediyor'),
                  value: todoStatus,
                  onChanged: (value) {
                    setState(() {
                      todoStatus = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF667eea),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final projeAdi = projeAdiController.text.trim();
                      final kuyuBoy =
                          double.tryParse(kuyuBoyController.text) ?? 0;
                      final kuyuDerinlik =
                          double.tryParse(kuyuDerinlikController.text) ?? 0;

                      // Validasyon
                      if (projeAdi.isEmpty) {
                        setState(() => projeAdiError = 'Proje adı boş olamaz');
                        return;
                      }

                      if (projeAdi.length < 3) {
                        setState(
                          () => projeAdiError =
                              'Proje adı en az 3 karakter olmalıdır',
                        );
                        return;
                      }

                      // Loading başlat
                      setState(() => isLoading = true);

                      final projeDetay = ProjeDetay(
                        todoStatus: todoStatus,
                        kuyuBoy: kuyuBoy,
                        kuyuDerinlik: kuyuDerinlik,
                        createdAt:
                            proje?.projeDetay.createdAt ?? DateTime.now(),
                      );

                      if (isEdit) {
                        try {
                          final updatedProje = proje.copyWith(
                            projeAdi: projeAdi,
                            projeDetay: projeDetay,
                          );
                          await ref
                              .read(projeAsyncProvider.notifier)
                              .updateProje(updatedProje);
                          if (context.mounted) {
                            Navigator.pop(context); // Sadece başarılıysa kapat
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Proje başarıyla güncellendi'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() => isLoading = false); // Loading durdur
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Güncelleme hatası: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      } else {
                        try {
                          // MongoDB will generate the ObjectId, so we pass empty string
                          final newProje = Proje(
                            projeAdi: projeAdi,
                            projeDetay: projeDetay,
                          );
                          await ref
                              .read(projeAsyncProvider.notifier)
                              .addProje(
                                newProje,
                              ); //ŞAYET BURADA BİR HATA ÇIKARSA CATCH yakalayacak.

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Proje başarıyla eklendi'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() => isLoading = false); // Loading durdur
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ekleme hatası: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 4),
                              ),
                            );
                          }
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(isEdit ? 'Güncelle' : 'Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
