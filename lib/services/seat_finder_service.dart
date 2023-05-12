import 'package:flutter/foundation.dart';

class SeatFinderService extends ChangeNotifier{

  int _searchSeat = 0;
  int get searchSeat => _searchSeat;

  updateSeat(int newSeat){
    _searchSeat = newSeat;
    notifyListeners();
  }

}