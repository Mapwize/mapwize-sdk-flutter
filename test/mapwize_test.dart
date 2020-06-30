import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapwize/mapwize.dart';

void main() {
  const MethodChannel channel = MethodChannel('Mapwize');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
