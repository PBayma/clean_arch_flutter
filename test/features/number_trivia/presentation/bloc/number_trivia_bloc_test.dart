import 'package:clean_flutter_tdd/core/error/failures.dart';
import 'package:clean_flutter_tdd/core/usecases/usecase.dart';
import 'package:clean_flutter_tdd/core/util/input_converter.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia, GetConcreteNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  group(
    'get trivia for concrete number',
    () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(number: 1, text: 'test text');

      group('failure path', () {
        test('should emit [Error] when the input is invalid', () async {
          //arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
          //act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                const ErrorNumberTriviaState(
                    message: INVALID_INPUT_FAILURE_MESSAGE)
              ]));
        });

        test(
            'should emit [Error] when the getConcreteNumberTrivia get return a serverFailure',
            () async {
          //arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
            return Left(ServerFailure());
          });

          //act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                LoadingNumberTriviaState(),
                const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE)
              ]));
        });
        test(
            'should emit [Error] with a proper message when getting data fails',
            () async {
          //arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async {
            return Left(CacheFailure());
          });

          //act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                LoadingNumberTriviaState(),
                const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE)
              ]));
        });
      });

      group('sucess path', () {
        setUp(() {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(tNumberParsed));
          when(mockGetConcreteNumberTrivia.call(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
        });

        test(
            'should call the input converter to validate and convert the string to integer',
            () async {
          //act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          //assert
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        });

        test('should get data from concrete usecase', () async {
          //act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia.call(any));

          //assert
          verify(mockGetConcreteNumberTrivia
              .call(const Params(number: tNumberParsed)));
        });
        test('should emit [Loading, Loaded] when get data sucessfully',
            () async {
          //act
          bloc.add(const GetTriviaForConcreteNumber(tNumberString));

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                LoadingNumberTriviaState(),
                const LoadedNumberTriviaState(numberTrivia: tNumberTrivia)
              ]));
        });
      });
    },
  );
  group(
    'get trivia for random number',
    () {
      const tNumberTrivia = NumberTrivia(number: 1, text: 'test text');

      group('failure path', () {
        test(
            'should emit [Error] when the getRandomNumberTrivia get return a serverFailure',
            () async {
          //arrange
          when(mockGetRandomNumberTrivia.call(any)).thenAnswer((_) async {
            return Left(ServerFailure());
          });

          //act
          bloc.add(GetTriviaForRandomNumber());

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                LoadingNumberTriviaState(),
                const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE)
              ]));
        });
        test(
            'should emit [Error] with a proper message when getting data fails',
            () async {
          //arrange
          when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async {
            return Left(CacheFailure());
          });

          //act
          bloc.add(GetTriviaForRandomNumber());

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                LoadingNumberTriviaState(),
                const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE)
              ]));
        });
      });

      group('sucess path', () {
        setUp(() {
          when(mockGetRandomNumberTrivia.call(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
        });

        test('should get data from concrete usecase', () async {
          //act
          bloc.add(GetTriviaForRandomNumber());
          await untilCalled(mockGetRandomNumberTrivia.call(any));

          //assert
          verify(mockGetRandomNumberTrivia.call(NoParams()));
        });
        test('should emit [Loading, Loaded] when get data sucessfully',
            () async {
          //act
          bloc.add(GetTriviaForRandomNumber());

          //assert
          expectLater(
              bloc.stream,
              emitsInOrder(<NumberTriviaState>[
                LoadingNumberTriviaState(),
                const LoadedNumberTriviaState(numberTrivia: tNumberTrivia)
              ]));
        });
      });
    },
  );
}
