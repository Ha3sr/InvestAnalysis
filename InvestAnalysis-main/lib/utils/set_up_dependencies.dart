import 'package:get/instance_manager.dart';
import 'package:invest_analize/repositories/finhub_repository.dart';
import 'package:invest_analize/repositories/persistence/persistence_repository.dart';
import 'package:invest_analize/repositories/persistence/sqlite_persistence_repository.dart';
import 'package:invest_analize/repositories/repository.dart';

Future<void> setUpDependecies() async {
  Get.put<Repository>(FinHubRepository());
  final persistence =
      Get.put<PersistenceRepository>(SqLitePersistenceRepository());
  await persistence.init();
}
