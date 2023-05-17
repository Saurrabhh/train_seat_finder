import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../services/seat_finder_service.dart';
import '../../../size_config.dart';

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
        // Body
        buildBody(borderWidth, boxSize),
        // Top/Bottom Border
        buildTopBottomBorder(
            borderWidth, horizontalLength, borderColor, radius),
        // Left Border
        buildLeftBorder(borderWidth, verticalLength, borderColor, radius),
        // Right Border
        buildRightBorder(borderWidth, verticalLength, borderColor, radius)
      ],
    );
  }

  Widget buildRightBorder(double borderWidth, double verticalLength,
      Color borderColor, Radius radius) {
    return Positioned(
      right: 0,
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
            )),
      ),
    );
  }

  Widget buildLeftBorder(double borderWidth, double verticalLength,
      Color borderColor, Radius radius) {
    return Positioned(
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
    );
  }

  Widget buildTopBottomBorder(double borderWidth, double horizontalLength,
      Color borderColor, Radius radius) {
    return Positioned(
      bottom: up ? null : 0,
      child: Container(
        height: borderWidth,
        width: horizontalLength +
            (totalLength == 1 ? borderWidth / 2 : borderWidth),
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
    );
  }

  Padding buildBody(double borderWidth, double boxSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: borderWidth / 2 - 2),
      child: Container(
        color: Colors.white,
        child: Row(
          children: List.generate(
              totalLength,
              (index) => Consumer<SeatFinderService>(
                    builder: (BuildContext context, seatFinderService,
                        Widget? child) {
                      int currentIndex = index + startIndex;
                      bool isSearchIndex = seatFinderService.searchSeatList
                          .contains(currentIndex);
                      return Padding(
                        padding: const EdgeInsets.all(1),
                        child: Container(
                            width: boxSize,
                            height: boxSize,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: isSearchIndex
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
                                              color: isSearchIndex
                                                  ? Colors.white
                                                  : kTextColor),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: up ? 5 : null,
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
                                              color: isSearchIndex
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
    );
  }
}
