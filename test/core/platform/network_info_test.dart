import 'package:clean_flutter_tdd/core/platform/network_info.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  NetworkInfoImpl networkInfoImpl;
  MockConnectivity mockConnectivityChecker;

  mockConnectivityChecker = MockConnectivity();
  networkInfoImpl = NetworkInfoImpl(mockConnectivityChecker);
  group('isConnected', () {
    test('should foward the call to Connectivity has a mobile connection',
        () async {
      // arrange
      when(mockConnectivityChecker.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.mobile);
      //act
      final result = await networkInfoImpl.isConnected;

      //assert
      verify(mockConnectivityChecker.checkConnectivity());
      expect(result, equals(true));
    });
    test('should foward the call to Connectivity has a wifi connection',
        () async {
      // arrange
      when(mockConnectivityChecker.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      //act
      final result = await networkInfoImpl.isConnected;

      //assert
      verify(mockConnectivityChecker.checkConnectivity());
      expect(result, equals(true));
    });
    test('should foward the call to Connectivity has none connection',
        () async {
      // arrange
      when(mockConnectivityChecker.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      //act
      final result = await networkInfoImpl.isConnected;

      //assert
      verify(mockConnectivityChecker.checkConnectivity());
      expect(result, equals(false));
    });
  });
}
