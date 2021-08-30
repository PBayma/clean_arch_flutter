import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';
import 'package:clean_flutter_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
    expect(tNumberTriviaModel.number, equals(1));
    expect(tNumberTriviaModel.text, equals('test text'));
  });
  group('fromJson ', () {
    test('should return  a valid number when the JSON number is a integer', () {
      final result = NumberTriviaModel.fromJson(fixture('trivia.json'));

      expect(result, equals(tNumberTriviaModel));
    });

    test(
        'should return  a valid number when the JSON number is regarded as double',
        () {
      final result = NumberTriviaModel.fromJson(fixture('trivia_double.json'));

      expect(result, equals(tNumberTriviaModel));
    });
  });

  group('toJson ', () {
    test('should return  a valid number when the JSON number is a integer', () {
      final result = tNumberTriviaModel.toJson();

      expect(result, equals('{"text":"test text","number":1}'));
    });
  });
}
