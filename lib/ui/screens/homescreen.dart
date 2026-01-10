import 'package:flutter/material.dart';
import 'package:flutter_arch/ui/widgets/homescreen/appbar/hs_appbar.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_body.dart';
import 'package:flutter_arch/ui/widgets/homescreen/fab/hs_fab.dart';

class MyHomePageT extends StatelessWidget {
  const MyHomePageT({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: HomeScreenAppBar(),
      body: const HomeScreenListView(),
      floatingActionButton: HSFloatingActionButton(),
    );
  }
}
