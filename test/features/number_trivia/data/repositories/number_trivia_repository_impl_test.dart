import 'package:clean_flutter_tdd/core/error/exceptions.dart';
import 'package:clean_flutter_tdd/core/error/failures.dart';
import 'package:clean_flutter_tdd/core/platform/network_info.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  MockNumberTriviaLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
  mockLocalDataSource = MockNumberTriviaLocalDataSource();
  mockNetworkInfo = MockNetworkInfo();
  repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo);

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test text');
    const tNumberTrivia = tNumberTriviaModel;
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getContreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
      });
      test(
          'should return server failure when the call to remote data source is unsucess',
          () async {
        when(mockRemoteDataSource.getContreteNumberTrivia(any))
            .thenThrow(ServerException());
        final result = await repository.getContreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getContreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });

      test('should check if the device is online', () async {
        await repository.getContreteNumberTrivia(tNumber);
        verify(await mockNetworkInfo.isConnected);
      });

      test(
          'should return remote data when the call to remote data source is sucess',
          () async {
        final result = await repository.getContreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getContreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is sucess',
          () async {
        await repository.getContreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getContreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    tearDown(() {
      mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImpl(
          remoteDataSource: mockRemoteDataSource,
          localDataSource: mockLocalDataSource,
          networkInfo: mockNetworkInfo);
    });
    group('device is offline', () {
      setUp(() {
        when(mockRemoteDataSource.getContreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange

        //act
        final result = await repository.getContreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when is no cached data', () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => throw CacheException());

        //act
        final result = await repository.getContreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
    tearDown(() {
      mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImpl(
          remoteDataSource: mockRemoteDataSource,
          localDataSource: mockLocalDataSource,
          networkInfo: mockNetworkInfo);
    });
  });
  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test text');
    const tNumberTrivia = tNumberTriviaModel;
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      });
      test(
          'should return server failure when the call to remote data source is unsucess',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });

      test('should check if the device is online', () async {
        await repository.getRandomNumberTrivia();
        verify(await mockNetworkInfo.isConnected);
      });

      test(
          'should return remote data when the call to remote data source is sucess',
          () async {
        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is sucess',
          () async {
        await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    tearDown(() {
      mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
      mockLocalDataSource = MockNumberTriviaLocalDataSource();
      mockNetworkInfo = MockNetworkInfo();
      repository = NumberTriviaRepositoryImpl(
          remoteDataSource: mockRemoteDataSource,
          localDataSource: mockLocalDataSource,
          networkInfo: mockNetworkInfo);
    });
    group('device is offline', () {
      setUp(() {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange

        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure when is no cached data', () async {
        // arrange
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => throw CacheException());

        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
