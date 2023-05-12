import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:train_seat_finder/constants.dart';
import 'package:train_seat_finder/services/seat_finder_service.dart';
import 'package:train_seat_finder/size_config.dart';
import 'package:train_seat_finder/theme.dart';

import 'components/search_bar.dart';

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
        home: const MainDashboard(),
      ),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  static TextEditingController controller = TextEditingController();

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _scrollController = ScrollController();

  void _scrollToPosition(double percent) {
    final position = _scrollController.position.maxScrollExtent * percent;
    _scrollController.animateTo(position,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Seat Finder",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SearchBarWidget(
                controller: MainDashboard.controller,
                f: _scrollToPosition,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: List.generate(
                            9, (index) => Cabin(cabinNo: index + 1)),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Cabin extends StatelessWidget {
  const Cabin({
    super.key,
    required this.cabinNo,
  });

  final int cabinNo;

  @override
  Widget build(BuildContext context) {
    int firstSeat = (cabinNo - 1) * 8 + 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Seats(
                startIndex: firstSeat,
                totalLength: 3,
                up: true,
              ),
              Seats(
                startIndex: firstSeat + 6,
                totalLength: 1,
                up: true,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Seats(
                startIndex: firstSeat + 3,
                totalLength: 3,
                up: false,
              ),
              Seats(
                startIndex: firstSeat + 7,
                totalLength: 1,
                up: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Seats extends StatelessWidget {
  const Seats({
    super.key,
    required this.startIndex,
    required this.totalLength,
    required this.up,
  });

  final int startIndex, totalLength;
  final bool up;

  @override
  Widget build(BuildContext context) {
    double boxSize = SizeConfig.screenWidth * 0.15;
    double horizontalLength = (boxSize * totalLength) + totalLength;
    double verticalLength = boxSize / 2;
    double borderWidth = 7;
    Color borderColor = const Color.fromARGB(255, 111, 198, 255);
    Radius radius = const Radius.circular(10);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: borderWidth / 2 - 2),
          child: Container(
            color: Colors.white,
            child: Row(
              children: List.generate(
                  totalLength,
                  (index) => Consumer<SeatFinderService>(
                        builder: (BuildContext context, seatFinderService,
                            Widget? child) {
                          int searchIndex = seatFinderService.searchSeat;
                          int currentIndex = index + startIndex;
                          return Padding(
                            padding: const EdgeInsets.all(1),
                            child: Container(
                                width: boxSize,
                                height: boxSize,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  color: currentIndex == searchIndex
                                      ? const Color.fromARGB(255, 0, 149, 253)
                                      : const Color.fromARGB(255, 205, 233, 255),
                                ),
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Positioned(
                                      top: 5,
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Center(
                                        child: Text(
                                          currentIndex.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  color: currentIndex ==
                                                          searchIndex
                                                      ? Colors.white
                                                      : kTextColor),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: up ? 2 : null,
                                      top: up ? null : 5,
                                      right: 0,
                                      left: 0,
                                      child: Center(
                                        child: Text(
                                          seatMap[currentIndex % 8]!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  color: currentIndex ==
                                                          searchIndex
                                                      ? Colors.white
                                                      : kTextColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        },
                      )),
            ),
          ),
        ),

        // Top/Bottom
        Positioned(
          bottom: up ? null : 0,
          child: Container(
            height: borderWidth,
            width: horizontalLength + borderWidth,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.only(
                topLeft: up ? radius : Radius.zero,
                topRight: up ? radius : Radius.zero,
                bottomLeft: !up ? radius : Radius.zero,
                bottomRight: !up ? radius : Radius.zero,
              ),
            ),
          ),
        ),

        //Left
        Positioned(
          top: up ? borderWidth : null,
          bottom: up ? null : borderWidth / 2,
          child: Container(
            width: borderWidth,
            height: verticalLength,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.only(
                bottomLeft: up ? radius : Radius.zero,
                bottomRight: up ? radius : Radius.zero,
                topRight: !up ? radius : Radius.zero,
                topLeft: !up ? radius : Radius.zero,
              ),
            ),
          ),
        ),

        // Right
        Positioned(
          right: 0,
          top: up ? borderWidth : null,
          bottom: up ? null : borderWidth,
          child: Container(
            width: borderWidth,
            height: verticalLength,
            decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: up ? radius : Radius.zero,
                  bottomRight: up ? radius : Radius.zero,
                  topRight: !up ? radius : Radius.zero,
                  topLeft: !up ? radius : Radius.zero,
                )),
          ),
        )
      ],
    );
  }
}
