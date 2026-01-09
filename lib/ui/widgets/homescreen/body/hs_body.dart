import 'package:flutter/material.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/logic/hs_error_provider/hs_error.dart';
import 'package:flutter_arch/ui/widgets/app_gradients.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_dismissible.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenListView extends ConsumerWidget {
  const HomeScreenListView({super.key, required this.data});

  final List<Proje> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Delete state listener - sadece burada, bir kez çalışır
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
            duration: Duration(seconds: 10),
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

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final gradient =
            AppGradients.gradients[index % AppGradients.gradients.length];
        return HSDismissible(proje: data[index], gradient: gradient);
      },
    );
  }
}
