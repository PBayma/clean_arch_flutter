import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numberapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getContreteNumberTrivia(int? number);

  /// Calls the http://numberapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
