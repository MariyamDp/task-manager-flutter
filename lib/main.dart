import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/di/injection.dart';
import 'features/tasks/presentation/pages/task_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // injectable environments are plain strings (e.g. 'dev', 'prod', 'cloud')
  await configureDependencies(env: 'dev');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF6750A4),
          onPrimary: const Color.fromARGB(255, 255, 255, 255),
          primaryContainer: const Color(0xFFEADDFF),
          onPrimaryContainer: const Color(0xFF21005D),
          secondary: const Color(0xFF4A4458),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFE8DEF8),
          onSecondaryContainer: const Color(0xFF1D192B),
          error: const Color(0xFFB3261E),
          onError: Colors.white,
          errorContainer: const Color(0xFFF9DEDC),
          onErrorContainer: const Color(0xFF410E0B),
          background: const Color.fromARGB(255, 255, 255, 255),
          onBackground: const Color(0xFF1D1B20),
          surface: Colors.white,
          onSurface: const Color(0xFF1D1B20),
          surfaceVariant: const Color(0xFFE7E0EC),
          onSurfaceVariant: const Color(0xFF49454F),
          outline: const Color(0xFF79747E),
          shadow: Colors.black.withOpacity(0.15),
          inverseSurface: const Color(0xFF322F35),
          onInverseSurface: const Color(0xFFF5EFF7),
          inversePrimary: const Color.fromARGB(255, 255, 255, 255),
          surfaceTint: const Color(0xFF6750A4),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: AppBarTheme(
          foregroundColor: const Color(0xFF1D1B20),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1D1B20),
          ),
        ),
      ),
      home: const TaskListPage(),
    );
  }
}
