import 'package:flutter/material.dart';

class ReactionsModel extends ChangeNotifier {
  int _upvotes = 120;
  int _awesome = 29;
  int _love = 6;
  int _funny = 42;
  int _angry = 4;
  int _sad = 8;

  void setUpvotes(int upvotes, bool notify) {
    _upvotes = upvotes;
    if (notify) notifyListeners();
  }

  void setAwesome(int awesome, bool notify) {
    _awesome = awesome;
    if (notify) notifyListeners();
  }

  void setLove(int love, bool notify) {
    _love = love;
    if (notify) notifyListeners();
  }

  void setFunny(int funny, bool notify) {
    _funny = funny;
    if (notify) notifyListeners();
  }

  void setAngry(int angry, bool notify) {
    _angry = angry;
    if (notify) notifyListeners();
  }

  void setSad(int sad, bool notify) {
    _sad = sad;
    if (notify) notifyListeners();
  }

  int get upvotes => _upvotes;
  int get awesome => _awesome;
  int get love => _love;
  int get funny => _funny;
  int get angry => _angry;
  int get sad => _sad;
  int get total => _upvotes + _awesome + _love + _funny + _angry + _sad;
}
