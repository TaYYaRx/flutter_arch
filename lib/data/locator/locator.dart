import 'package:flutter_arch/data/repositories/api_repository.dart';
import 'package:flutter_arch/data/services/api_service.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/hs_services.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiRepository>(() => ApiRepository());
  locator.registerLazySingleton<ApiService>(
    () => ApiService(repository: locator<ApiRepository>()),
  );

  locator.registerLazySingleton<HSService>(() => HSService());
}
