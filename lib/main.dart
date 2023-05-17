import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:train_seat_finder/screens/main_dashboard/main_dashboard.dart';
import 'package:train_seat_finder/services/seat_finder_service.dart';
import 'package:train_seat_finder/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SeatFinderService>(
            create: (_) => SeatFinderService())
      ],
      child: MaterialApp(
        theme: MyTheme.themeData,
        debugShowCheckedModeBanner: false,
        home: const MainDashboard(),
      ),
    );
  }
}
