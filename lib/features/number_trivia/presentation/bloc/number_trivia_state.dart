part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class EmptyNumberTriviaState extends NumberTriviaState {}

class LoadingNumberTriviaState extends NumberTriviaState {}

class LoadedNumberTriviaState extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  const LoadedNumberTriviaState({required this.numberTrivia});

  @override
  List<Object> get props => [numberTrivia];
}

class ErrorNumberTriviaState extends NumberTriviaState {
  final String message;

  const ErrorNumberTriviaState({required this.message});

  @override
  List<Object> get props => [message];
}
