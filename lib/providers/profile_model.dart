import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  String _username = '';
  String _profilePic = '';
  String _email = '';
  final List<dynamic> _bookmarks = [];

  void setUsername(String username, bool notify) {
    _username = username;
    if (notify) {
      notifyListeners();
    }
  }

  void setEmail(String email, bool notify) {
    _email = email;
    if (notify) {
      notifyListeners();
    }
  }

  void setProfilePic(String url, bool notify) {
    _profilePic = url;
    if (notify) {
      notifyListeners();
    }
  }

  void addBookmark(String manga, bool notify) {
    _bookmarks.add(manga);
    if (notify) {
      notifyListeners();
    }
  }

  void addBookmarks(List<dynamic> manga, bool notify) {
    _bookmarks.addAll(manga);
    if (notify) {
      notifyListeners();
    }
  }

  void removeBookmark(String manga, bool notify) {
    _bookmarks.remove(manga);
    if (notify) {
      notifyListeners();
    }
  }

  // set username(String username) {
  //   _username = username;
  //   notifyListeners();
  // }

  // set email(String email) {
  //   _email = email;
  //   notifyListeners();
  // }

  // set profilePic(String url) {
  //   _profilePic = url;
  //   notifyListeners();
  // }

  String get username => _username;
  String get email => _email;
  String get profilePic {
    return _profilePic;
  }

  List<dynamic> get bookmarks => _bookmarks;
}
