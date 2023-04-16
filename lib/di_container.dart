import 'package:Aap_job/data/chat/ContactsRepository.dart';
import 'package:Aap_job/data/chat/chat_auth_repository.dart';
import 'package:Aap_job/data/chat/chat_repository.dart';
import 'package:Aap_job/data/chat/firebase_storage_repository.dart';
import 'package:Aap_job/data/respository/ads_repo.dart';
import 'package:Aap_job/data/respository/auth_repo.dart';
import 'package:Aap_job/data/respository/category_repo.dart';
import 'package:Aap_job/data/respository/config_repo.dart';
import 'package:Aap_job/data/respository/content_repo.dart';
import 'package:Aap_job/data/respository/hr_jobs_repo.dart';
import 'package:Aap_job/data/respository/hrplan_repo.dart';
import 'package:Aap_job/data/respository/jobcity_repo.dart';
import 'package:Aap_job/data/respository/jobs_repo.dart';
import 'package:Aap_job/data/respository/jobtitle_repo.dart';
import 'package:Aap_job/data/respository/notification_repo.dart';
import 'package:Aap_job/providers/HrJobs_provider.dart';
import 'package:Aap_job/providers/Jobs_provider.dart';
import 'package:Aap_job/providers/ads_provider.dart';
import 'package:Aap_job/providers/auth_provider.dart';
import 'package:Aap_job/providers/category_provider.dart';
import 'package:Aap_job/providers/cities_provider.dart';
import 'package:Aap_job/providers/config_provider.dart';
import 'package:Aap_job/providers/content_provider.dart';
import 'package:Aap_job/providers/hrplan_provider.dart';
import 'package:Aap_job/providers/jobtitle_provider.dart';
import 'package:Aap_job/providers/localization_provider.dart';
import 'package:Aap_job/providers/notification_provider.dart';
import 'package:Aap_job/providers/profile_provider.dart';
import 'package:Aap_job/providers/splash_provider.dart';
import 'package:Aap_job/utill/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'package:get_it/get_it.dart';

import 'data/respository/splash_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => JobsRepo(dioClient: sl()));
  sl.registerLazySingleton(() => AdsRepo(dioClient: sl()));
  sl.registerLazySingleton(() => HrPlanRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => JobtitleRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ContentRepo(dioClient: sl()));
  sl.registerLazySingleton(() => HrJobRepo(dioClient: sl()));
  sl.registerLazySingleton(() => JobCityRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => ConfigRepo(dioClient: sl(),sharedPreferences: sl()));


  // Provider
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => ProfileProvider(authRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl()));
  sl.registerFactory(() => JobsProvider(jobsRepo: sl()));
  sl.registerFactory(() => AdsProvider(adsRepo: sl()));
  sl.registerFactory(() => HrPlanProvider(hrPlanRepo: sl()));
  sl.registerFactory(() => HrJobProvider(hrJobRepo: sl()));
  sl.registerFactory(() => CitiesProvider(jobCityRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => JobtitleProvider(jobtitleRepo: sl()));
  sl.registerFactory(() => ContentProvider(contentRepo: sl()));
  sl.registerFactory(() => ConfigProvider(configRepo: sl()));
  sl.registerFactory(() => FirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance));
  sl.registerFactory(() => ChatAuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance, realtime: FirebaseDatabase.instance,));
  sl.registerFactory(() => ChatRepository (auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));
  sl.registerFactory(() => ContactsRepository(firestore: FirebaseFirestore.instance));
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  // sl.registerLazySingleton(() => Connectivity());
}
