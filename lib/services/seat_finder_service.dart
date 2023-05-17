import 'package:flutter/foundation.dart';

class SeatFinderService extends ChangeNotifier {
  List<int> _searchSeatList = [];
  List<int> get searchSeatList => _searchSeatList;

  setSearchSeatList(List<int> newSearchSeatList) {
    _searchSeatList = newSearchSeatList;
    notifyListeners();
  }
}
