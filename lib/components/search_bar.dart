import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:train_seat_finder/services/seat_finder_service.dart';
import '../constants.dart';
import '../size_config.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.scrollToCabin,
  });

  final TextEditingController controller;
  final Function(double) scrollToCabin;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: SizeConfig.screenHeight * 0.075,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: kPrimaryColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Seat Number...",
                    hintStyle: Theme.of(context).textTheme.titleLarge,
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          widget.controller.text.isEmpty
                              ? Colors.grey.shade400
                              : kPrimaryColor)),
                  onPressed: () {
                    String searchString = widget.controller.text;
                    if (searchString.isEmpty) {
                      return;
                    }
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (searchString.endsWith(',')) {
                      searchString =
                          searchString.substring(0, searchString.length - 1);
                    }
                    List<int> searchSeatList =
                        searchString.split(',').map(int.parse).toSet().toList();
                    searchSeatList
                        .removeWhere((element) => element < 1 || element > 72);
                    if (searchSeatList.isEmpty) {
                      return;
                    }
                    searchSeatList.sort();
                    Provider.of<SeatFinderService>(context, listen: false)
                        .setSearchSeatList(searchSeatList);
                    double cabinNo = searchSeatList[0] / 8;
                    cabinNo = cabinNo > 4
                        ? cabinNo.ceilToDouble()
                        : cabinNo.floorToDouble();
                    if (searchSeatList[0] % 8 == 0 && cabinNo < 4) {
                      cabinNo -= 1;
                    }
                    widget.scrollToCabin(cabinNo);
                  },
                  child: Text(
                    "Find",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
