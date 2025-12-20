// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'screens/product_list_screen.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return MaterialApp(
//       title: 'Ecommerce App',
//       theme: ThemeData(
//         primaryColor: const Color(0xFF1A237E),
//         scaffoldBackgroundColor: const Color(0xFFF5F7FA),
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           primary: const Color(0xFF1A237E), // Indigo
//           secondary: const Color(0xFF00BCD4), // Cyan
//           onPrimary: Colors.white,
//           onSecondary: Colors.white,
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.white,
//           foregroundColor: const Color(0xFF212121),
//           elevation: 0.5,
//           iconTheme: const IconThemeData(color: Color(0xFF1A237E)),
//           titleTextStyle: GoogleFonts.montserrat(
//             color: const Color(0xFF212121),
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         cardTheme: CardTheme(
//           elevation: 2,
//           shadowColor: Colors.black.withOpacity(0.05),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF1A237E),
//             foregroundColor: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
//             textStyle: GoogleFonts.montserrat(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
//           headlineMedium: GoogleFonts.montserrat(
//               fontWeight: FontWeight.bold, color: const Color(0xFF212121)),
//           headlineSmall: GoogleFonts.montserrat(
//               fontWeight: FontWeight.bold, color: const Color(0xFF212121)),
//           titleLarge: GoogleFonts.montserrat(
//               color: const Color(0xFF1A237E), fontWeight: FontWeight.bold),
//           bodyLarge: TextStyle(color: Colors.grey[800]),
//           bodyMedium: TextStyle(color: Colors.grey[600]),
//         ),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ProductListScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/product_list_screen.dart';
import 'screens/add_edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ecommerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProductListScreen(),
        '/add': (context) => AddEditProductScreen(),
        '/edit': (context) => AddEditProductScreen(),
      },
    );
  }
}
