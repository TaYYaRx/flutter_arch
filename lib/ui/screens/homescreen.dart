import 'package:flutter/material.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_arch/ui/widgets/homescreen/appbar/hs_appbar.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_body.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_emptystate.dart';
import 'package:flutter_arch/ui/widgets/homescreen/fab/hs_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePageT extends StatelessWidget {
  const MyHomePageT({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: HomeScreenAppBar(),
      body: Consumer(
        builder: (context, ref, child) => ref
            .watch(projeAsyncProvider)
            .when(
              data: (data) {
                if (data.isEmpty) {
                  return Center(child: HSEmptyState());
                } else {
                  return HomeScreenListView(data: data, ref: ref);
                }
              },
              error: (error, stackTrace) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bir hata oluştu',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
      ),
      floatingActionButton: HSFloatingActionButton(),
    );
  }
}
