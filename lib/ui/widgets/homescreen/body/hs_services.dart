import 'package:flutter/material.dart';
import 'package:flutter_arch/data/models/projedetaymodel/projedetay_model.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HSService {
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
                  decoration: InputDecoration(
                    labelText: 'Proje Adı',
                    prefixIcon: const Icon(Icons.folder),
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
              onPressed: () async {
                final projeAdi = projeAdiController.text.trim();
                final kuyuBoy = double.tryParse(kuyuBoyController.text) ?? 0;
                final kuyuDerinlik =
                    double.tryParse(kuyuDerinlikController.text) ?? 0;

                if (projeAdi.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Proje adı boş olamaz')),
                  );
                  return;
                }

                final projeDetay = ProjeDetay(
                  todoStatus: todoStatus,
                  kuyuBoy: kuyuBoy,
                  kuyuDerinlik: kuyuDerinlik,
                  createdAt: proje?.projeDetay.createdAt ?? DateTime.now(),
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
                    if (!context.mounted) return;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proje başarıyla güncellendi'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Güncelleme hatası: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );
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
                        .addProje(newProje);
                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Proje başarıyla eklendi'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667eea),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isEdit ? 'Güncelle' : 'Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
