import 'package:clean_flutter_tdd/core/error/exceptions.dart';
import 'package:clean_flutter_tdd/core/platform/network_info.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter_tdd/core/error/failures.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getContreteNumberTrivia(
      int? number) async {
    return _getTrivia(() => remoteDataSource.getContreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);

        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
