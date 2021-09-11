import 'package:clean_flutter_tdd/core/error/exceptions.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);

    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

    test(
        '''should perform a GET request on a URL with number being the endpoint 
        and with application/json''', () async {
      //act
      await dataSource.getContreteNumberTrivia(tNumber);

      //assert
      verify(
        mockClient.get(
          Uri.http('numbersapi.com', '/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });
    test('should return response code 200 and get a valid NumberTrivia',
        () async {
      //act
      final result = await dataSource.getContreteNumberTrivia(tNumber);

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should return response code 404 and get a ServerException', () async {
      // arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      //act
      final call = dataSource.getContreteNumberTrivia;

      //assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');
    test(
        '''should perform a GET request on a URL with number being the endpoint 
        and with application/json''', () async {
      //act
      await dataSource.getRandomNumberTrivia();

      //assert
      verify(
        mockClient.get(
          Uri.http('numbersapi.com', '/random'),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });
    test('should return response code 200 and get a valid NumberTrivia',
        () async {
      //act
      final result = await dataSource.getRandomNumberTrivia();

      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should return response code 404 and get a ServerException', () async {
      // arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      //act
      final call = dataSource.getRandomNumberTrivia;

      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
