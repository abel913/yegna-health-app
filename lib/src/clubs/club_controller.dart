import 'package:flutter/foundation.dart';

import 'club_models.dart';
import 'club_repository.dart';

class ClubController extends ChangeNotifier {
  ClubController({
    required ClubRepository repository,
  }) : _repository = repository;

  final ClubRepository _repository;

  List<StudentClub> _clubs = [];
  final Set<String> _joinedClubIds = {};
  bool _isLoading = false;
  String? _errorMessage;
  ClubCategory _selectedCategory = ClubCategory.all;
  String _searchQuery = '';
  bool _showOnlyJoined = false;
  String? _currentUserId;

  List<StudentClub> get clubs {
    var result = _clubs;
    if (_showOnlyJoined) {
      result = result.where((c) => _joinedClubIds.contains(c.id)).toList();
    }
    return result;
  }

  Set<String> get joinedClubIds => Set.unmodifiable(_joinedClubIds);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  ClubCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get showOnlyJoined => _showOnlyJoined;
  int get joinedCount => _joinedClubIds.length;

  bool isJoined(String clubId) => _joinedClubIds.contains(clubId);

  List<StudentClub> get myClubs =>
      _clubs.where((c) => _joinedClubIds.contains(c.id)).toList();

  Future<void> loadClubs(String? userId) async {
    _currentUserId = userId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clubs = List<StudentClub>.from(await _repository.getClubs(
        category: _selectedCategory,
        query: _searchQuery,
      ));

      if (userId != null && userId.isNotEmpty) {
        final joined = await _repository.getJoinedClubIds(userId);
        _joinedClubIds.clear();
        _joinedClubIds.addAll(joined);
      } else {
        _joinedClubIds.clear();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(ClubCategory category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadClubs(_currentUserId);
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    loadClubs(_currentUserId);
  }

  void toggleFilterJoined(bool onlyJoined) {
    if (_showOnlyJoined == onlyJoined) return;
    _showOnlyJoined = onlyJoined;
    notifyListeners();
  }

  Future<bool> joinClub(
    String clubId,
    String userId, {
    String? userEmail,
    String? userName,
  }) async {
    final success = await _repository.joinClub(
      clubId,
      userId,
      userEmail: userEmail,
      userName: userName,
    );
    if (success) {
      _joinedClubIds.add(clubId);
      // Refresh club item in memory
      final updatedClub = await _repository.getClubById(clubId);
      if (updatedClub != null) {
        final idx = _clubs.indexWhere((c) => c.id == clubId);
        if (idx >= 0) {
          _clubs[idx] = updatedClub;
        }
      }
      notifyListeners();
    }
    return success;
  }

  Future<bool> leaveClub(String clubId, String userId) async {
    final success = await _repository.leaveClub(clubId, userId);
    if (success) {
      _joinedClubIds.remove(clubId);
      final updatedClub = await _repository.getClubById(clubId);
      if (updatedClub != null) {
        final idx = _clubs.indexWhere((c) => c.id == clubId);
        if (idx >= 0) {
          _clubs[idx] = updatedClub;
        }
      }
      notifyListeners();
    }
    return success;
  }
}
