import 'package:flutter/material.dart';
import 'package:flutter_arch/data/models/projemodel/proje_model.dart';
import 'package:flutter_arch/ui/widgets/app_gradients.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_dismissible.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenListView extends StatelessWidget {
  const HomeScreenListView({super.key, required this.data, required this.ref});

  final List<Proje> data;
  final WidgetRef ref;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final gradient =
            AppGradients.gradients[index % AppGradients.gradients.length];
        return HSDismissible(proje: data[index], gradient: gradient, ref: ref);
      },
    );
  }

}
