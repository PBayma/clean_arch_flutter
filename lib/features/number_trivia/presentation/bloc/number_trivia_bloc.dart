import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_flutter_tdd/core/error/failures.dart';
import 'package:clean_flutter_tdd/core/usecases/usecase.dart';
import 'package:clean_flutter_tdd/core/util/input_converter.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(EmptyNumberTriviaState());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold((failure) async* {
        yield const ErrorNumberTriviaState(
            message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (integer) async* {
        yield LoadingNumberTriviaState();

        final failureOrTriviaEither =
            await getConcreteNumberTrivia.call(Params(number: integer));

        yield* _mapEitherToState(failureOrTriviaEither);
      });
    }
    if (event is GetTriviaForRandomNumber) {
      yield LoadingNumberTriviaState();

      final failureOrTriviaEither =
          await getRandomNumberTrivia.call(NoParams());

      yield* _mapEitherToState(failureOrTriviaEither);
    }
  }
}

Stream<NumberTriviaState> _mapEitherToState(
    Either<Failure, NumberTrivia> failureOrTriviaEither) async* {
  yield* failureOrTriviaEither.fold(
    (failure) async* {
      yield* _mapFailureToErrorState(failure);
    },
    (numberTrivia) async* {
      yield LoadedNumberTriviaState(numberTrivia: numberTrivia);
    },
  );
}

Stream<NumberTriviaState> _mapFailureToErrorState(Failure failure) async* {
  switch (failure.runtimeType) {
    case ServerFailure:
      yield const ErrorNumberTriviaState(message: SERVER_FAILURE_MESSAGE);
      break;
    case CacheFailure:
      yield const ErrorNumberTriviaState(message: CACHE_FAILURE_MESSAGE);
      break;
  }
}
