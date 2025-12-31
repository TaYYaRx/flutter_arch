import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/data/services/api_service.dart';
import 'package:flutter_arch/logic/proje_provider/proje_aysnc/proje_async_.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Consumer(
        builder: (context, ref, child) {
          return ref
              .watch(projeAsyncProvider)
              .when(
                data: (data) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          final updatedProje = data[index].copyWith(projeAdi: 'UPDATED-$index');
                          ref.read(projeAsyncProvider.notifier).updateProje(updatedProje);
                        },
                        child: ListTile(title: Text(data[index].projeAdi)),
                      );
                    },
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) {
                  return Center(child: Text(error.toString()));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
        },
      ),
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          return FloatingActionButton(
            onPressed: () => {locator<ApiService>().fetchProjeler()},
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
