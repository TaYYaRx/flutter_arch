import 'package:flutter/material.dart';
import 'package:flutter_arch/logic/hs_error_provider/hs_error.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_arch/ui/widgets/app_gradients.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_dismissible.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_emptystate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreenListView extends ConsumerStatefulWidget {
  const HomeScreenListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenListViewState();
}

class _HomeScreenListViewState extends ConsumerState<HomeScreenListView> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      await ref.read(projeAsyncProvider.notifier).refresh();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Delete state listener - sadece burada, bir kez çalışır
    ref.listen<DeleteState>(deleteProjeStateProvider, (prev, next) {
      final messenger = ScaffoldMessenger.of(context);

      if (next.status == DeleteStatus.deleting) {
        // Önceki tüm snackbar'ları temizle
        messenger.clearSnackBars();
        // Yeni snackbar göster
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
            duration: Duration(seconds: 10),
            backgroundColor: Colors.blue,
          ),
        );
      }

      if (next.status == DeleteStatus.success) {
        // Önceki tüm snackbar'ları temizle
        messenger.clearSnackBars();
        // Kısa bir delay ile yeni snackbar göster
        Future.delayed(const Duration(milliseconds: 100), () {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Başarıyla silindi'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        });
      }

      if (next.status == DeleteStatus.error) {
        // Önceki tüm snackbar'ları temizle
        messenger.clearSnackBars();
        // Kısa bir delay ile yeni snackbar göster
        Future.delayed(const Duration(milliseconds: 100), () {
          messenger.showSnackBar(
            SnackBar(
              content: Text(next.message ?? 'Silme başarısız'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        });
      }
    });
    final asyncProje = ref.watch(projeAsyncProvider);
    return asyncProje.when(
      data: (proje) {
        if (proje.isEmpty) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            header: const WaterDropHeader(
              complete: Text(
                'Yenilendi!',
                style: TextStyle(color: Colors.grey),
              ),
              waterDropColor: Colors.blue,
            ),
            child: const Center(child: HSEmptyState()),
          );
        } else {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            enablePullUp: false,
            header: const WaterDropHeader(
              complete: Text(
                'Yenilendi!',
                style: TextStyle(color: Colors.grey),
              ),
              waterDropColor: Colors.blue,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: proje.length,
              itemBuilder: (context, index) {
                final gradient = AppGradients
                    .gradients[index % AppGradients.gradients.length];
                return HSDismissible(proje: proje[index], gradient: gradient);
              },
            ),
          );
        }
      },
      error: (error, stackTrace) {
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: const WaterDropHeader(
            complete: Text('Yenilendi!', style: TextStyle(color: Colors.grey)),
            waterDropColor: Colors.blue,
          ),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 16),
                    const Text(
                      'Yenilemek için aşağı çekin',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
