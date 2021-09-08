import 'package:clean_flutter_tdd/core/platform/network_info.dart';
import 'package:clean_flutter_tdd/core/util/input_converter.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serverLocal = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  //BloC
  serverLocal.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: serverLocal(),
      getRandomNumberTrivia: serverLocal(),
      inputConverter: serverLocal()));

  //Use cases
  serverLocal
      .registerLazySingleton(() => GetConcreteNumberTrivia(serverLocal()));
  serverLocal.registerLazySingleton(() => GetRandomNumberTrivia(serverLocal()));

  //Repository
  serverLocal.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: serverLocal(),
          localDataSource: serverLocal(),
          networkInfo: serverLocal()));

  // Data sources
  serverLocal.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: serverLocal()));

  serverLocal.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serverLocal()));

  //! Core
  serverLocal.registerLazySingleton(() => InputConverter());
  serverLocal
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serverLocal()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serverLocal.registerLazySingleton(() => sharedPreferences);
  serverLocal.registerLazySingleton(() => http.Client());
  serverLocal.registerLazySingleton(() => Connectivity());
}
