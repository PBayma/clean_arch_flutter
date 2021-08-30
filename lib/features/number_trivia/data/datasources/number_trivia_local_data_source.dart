import 'package:clean_flutter_tdd/features/number_trivia/data/models/number_trivia_data.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] wich was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws a [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
