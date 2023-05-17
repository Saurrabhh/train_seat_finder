import 'package:flutter/material.dart';
import 'package:train_seat_finder/screens/main_dashboard/components/seats.dart';

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
