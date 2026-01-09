import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/logic/hs_error_provider/hs_error.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HSDismissible extends ConsumerWidget {
  //HomeScreenDismissible
  const HSDismissible({super.key, required this.proje, required this.gradient});

  final Proje proje;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projeAdi = proje.projeAdi;
    final projeTarihi =
        '${proje.projeDetay.createdAt.day}/${proje.projeDetay.createdAt.month}/${proje.projeDetay.createdAt.year}';

    final projeDurumu = proje.projeDetay.todoStatus
        ? 'Tamamlandı'
        : 'Devam Ediyor';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ClipRRect(
          // iOS standartlarında daha yumuşak ve geniş köşeler (Squircle hissi)
          borderRadius: BorderRadius.circular(24.0),
          child: BackdropFilter(
            // --- SİHİRLİ KISIM: BUZLU CAM EFEKTİ ---
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                // Arka plan rengi (Oldukça şeffaf gri/siyah)
                gradient: gradient,
                // İnce beyaz kenarlık (Border) - iOS kartlarında derinlik için sık kullanılır
                border: Border.all(
                  color: Colors.white.withValues(),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(
                  24.0,
                ), // Container için de aynı radius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- ÜST SATIR ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBackground.withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: CupertinoColors.activeOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              projeDurumu,
                              style: TextStyle(
                                color: CupertinoColors.black, // iOS mavisi
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                letterSpacing: 0.5,
                                fontFamily:
                                    '.SF Pro Text', // iOS fontu simülasyonu
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Eylem Butonları (Cupertino ikonları ile)
                      Row(
                        children: [
                          _buildIOSButton(CupertinoIcons.pencil, context, ref),
                          const SizedBox(width: 12),
                          _buildIOSButton(
                            CupertinoIcons.trash,
                            context,
                            ref,
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- BAŞLIK ---
                  Text(
                    projeAdi,
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600, // Semi-bold
                      letterSpacing:
                          -0.5, // iOS başlıklarında harfler biraz sıkışıktır
                    ),
                  ),

                  const SizedBox(height: 6),

                  // --- TARİH ---
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.calendar,
                            color: CupertinoColors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Create At: $projeTarihi',
                            style: TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.calendar,
                            color: CupertinoColors.black,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Update At: $projeTarihi',
                            style: TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- PROGRESS BAR (iOS Slider Tarzı) ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Custom Rounded Progress Bar
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(70), // Arka plan track
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.60,
                          child: Container(
                            decoration: BoxDecoration(
                              // iOS'te gradientler soldan sağa yumuşak geçişlidir
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0A84FF).withAlpha(90),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Yüzde Metni
                      Text(
                        '60%',
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIOSButton(
    IconData icon,
    BuildContext context,
    WidgetRef ref, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: () async {
        if (isDestructive) {
          // DELETE
          final confirmed = await locator<HSService>().showDeleteConfirmation(
            context,
            proje,
          );

          if (confirmed == true) {
            try {
              await ref.read(projeAsyncProvider.notifier).deleteProje(proje.id);
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        } else {
          //EDIT
          locator<HSService>().showAddEditDialog(context, ref, proje: proje);
        }
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(120), // Çok hafif arka plan
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            // Yıkıcı işlemler (silme) için kırmızı, diğerleri için beyaz
            color: isDestructive
                ? CupertinoColors.darkBackgroundGray
                : CupertinoColors.darkBackgroundGray,
            size: 18,
          ),
        ),
      ),
    );
  }
}
