// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class AppConfig {
//   static String get backendUrl =>
//       dotenv.env['BACKEND_URL'] ?? 'http://localhost:3000';
//   static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

//   static bool get isDevelopment => environment == 'development';
//   static bool get isProduction => environment == 'production';
// }

// // Export the backend URL for use in other files
// String get BACKEND_URL => AppConfig.backendUrl;

// Remove the flutter_dotenv import
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // Remove this line

//vercel
class AppConfig {
  static String get backendUrl => const String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:3000',
  );

  static String get environment =>
      const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}

// Export the backend URL for use in other files
String get BACKEND_URL => AppConfig.backendUrl;
