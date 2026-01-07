import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';

import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_dismissibleBackground.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HSDismissible extends StatelessWidget {
  //HomeScreenDismissible
  const HSDismissible({
    super.key,
    required this.proje,
    required this.gradient,
    required this.ref,
  });

  final Proje proje;
  final LinearGradient gradient;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final projeAdi = proje.projeAdi;
    final projeTarihi =
        '${proje.projeDetay.createdAt.day}/${proje.projeDetay.createdAt.month}/${proje.projeDetay.createdAt.year}';
    final projeDurumu = proje.projeDetay.todoStatus
        ? 'Tamamlandı'
        : 'Devam Ediyor';
    return Dismissible(
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Düzenleme sola kaydırma eylemi
          locator<HSService>().showAddEditDialog(context, ref, proje: proje);
          return false;
        } else {
          return await locator<HSService>().showDeleteConfirmation(context, ref, proje);
          // Silme Sağa kaydırma eylemi
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () {},

              borderRadius: BorderRadius.circular(16),
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
    );
  }


}
