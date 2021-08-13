import 'package:clean_flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  mockNumberTriviaRepository = MockNumberTriviaRepository();
  usecase = GetConcreteNumberTrivia(MockNumberTriviaRepository());

  const testNumber = 1;
  const testNumberTrivia =
      NumberTrivia(text: "Esse numero é o numero da sorte", number: 1);

  test('should get trivia from the number from repository', () async {
    when(mockNumberTriviaRepository.getContreteNumberTrivia(any))
        .thenAnswer((_) async => const Right(testNumberTrivia));
  });
}
