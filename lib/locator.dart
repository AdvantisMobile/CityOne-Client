
import 'package:cityone_driver/services/background_locator_services.dart';
import 'package:cityone_driver/services/firestore_service.dart';
import 'package:get_it/get_it.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => BackgroundLocatorServices());
  //locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => FirestoreService());

}