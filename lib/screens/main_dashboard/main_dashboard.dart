import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/search_bar.dart';
import '../../services/seat_finder_service.dart';
import '../../size_config.dart';
import 'components/cabin.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  static TextEditingController controller = TextEditingController();

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final _scrollController = ScrollController();

  double seatToCabin(int seatNo) {
    double cabinNo = seatNo / 8;
    cabinNo = cabinNo > 4 ? cabinNo.ceilToDouble() : cabinNo.floorToDouble();
    if (seatNo % 8 == 0 && cabinNo < 4) {
      cabinNo -= 1;
    }
    return cabinNo;
  }

  void _scrollToCabin(double cabinNo) {
    _scrollController.animateTo(cabinNo * SizeConfig.screenWidth * 0.3,
        duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                scrollToCabin: _scrollToCabin,
              ),
              _buildSearchResults(),
              _buildCoach()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoach() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: List.generate(9, (index) => Cabin(cabinNo: index + 1)),
            )),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SeatFinderService>(
      builder: (BuildContext context, seatFinderService, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "Search Results",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            GridView.count(
                crossAxisCount: 6,
                mainAxisSpacing: 1,
                crossAxisSpacing: 3,
                childAspectRatio: 2,
                shrinkWrap: true,
                children: seatFinderService.searchSeatList
                    .map((e) => GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(255, 111, 198, 255),
                                width: 3,
                              ),
                            ),
                            child: Center(child: Text(e.toString())),
                          ),
                          onTap: () => _scrollToCabin(seatToCabin(e)),
                        ))
                    .toList())
          ],
        );
      },
    );
  }
}
