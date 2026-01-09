import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';

import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/logic/hs_error_provider/hs_error.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_dismissibleBackground.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HSDismissible extends ConsumerWidget {
  //HomeScreenDismissible
  const HSDismissible({super.key, required this.proje, required this.gradient});

  final Proje proje;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<DeleteState>(deleteProjeStateProvider, (prev, next) {
      final messenger = ScaffoldMessenger.of(context);

      if (next.status == DeleteStatus.deleting) {
        messenger.showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Siliniyor...'),
              ],
            ),
            duration: Duration(minutes: 1),
            backgroundColor: Colors.blue,
          ),
        );
      }

      if (next.status == DeleteStatus.success) {
        messenger.removeCurrentSnackBar();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Başarıyla silindi'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      if (next.status == DeleteStatus.error) {
        messenger.removeCurrentSnackBar();
        messenger.showSnackBar(
          SnackBar(
            content: Text(next.message ?? 'Silme başarısız'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    final projeAdi = proje.projeAdi;
    final projeTarihi =
        '${proje.projeDetay.createdAt.day}/${proje.projeDetay.createdAt.month}/${proje.projeDetay.createdAt.year}';
    final projeDurumu = proje.projeDetay.todoStatus
        ? 'Tamamlandı'
        : 'Devam Ediyor';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          debugPrint('Proje tıklandı: ${proje.id}');
        },
        child: Dismissible(
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              // Düzenleme sola kaydırma eylemi
              locator<HSService>().showAddEditDialog(
                context,
                ref,
                proje: proje,
              );
              return false;
            }

            // Silme Sağa kaydırma eylemi
            final confirmed = await locator<HSService>().showDeleteConfirmation(
              context,
              proje,
            );

            if (confirmed != true) return false;

            try {
              await ref.read(projeAsyncProvider.notifier).deleteProje(proje.id);
              return true;
            } catch (_) {
              return false;
            }
          },
          background: DismissibleBackground(
            color: gradient.colors.first.withValues(alpha: 0.3),
            alignment: Alignment.centerLeft,
            icon: Icons.delete,
            label: 'Sil',
          ),
          secondaryBackground: DismissibleBackground(
            color: gradient.colors.first.withValues(alpha: 0.5),
            alignment: Alignment.centerRight,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
          key: Key(proje.id),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              projeAdi,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: proje.projeDetay.todoStatus
                                  ? const Color.fromARGB(
                                      255,
                                      63,
                                      150,
                                      67,
                                    ).withAlpha(180)
                                  : Colors.white.withAlpha(180),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              projeDurumu,
                              style: TextStyle(
                                color: proje.projeDetay.todoStatus
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(128),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              projeTarihi,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
