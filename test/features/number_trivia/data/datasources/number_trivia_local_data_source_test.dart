import 'package:clean_flutter_tdd/core/error/exceptions.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  mockSharedPreferences = MockSharedPreferences();
  dataSource =
      NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);

  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

  group('getLastNumberTrivia', () {
    test('should getLastNumberTrivia has sucess when there is a cached value',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cache.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should getLastNumberTrivia throw when there isnt cached value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;

      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    test('should call sharedPreferences to cache number trivia', () async {
      when(mockSharedPreferences.setString(cachedNumberTrivia, any))
          .thenAnswer((_) async => true);
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      //assert
      verify(mockSharedPreferences.setString(
          cachedNumberTrivia, tNumberTriviaModel.toJson()));
    });
  });
}
