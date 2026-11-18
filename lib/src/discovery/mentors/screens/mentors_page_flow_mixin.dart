import 'package:flutter/material.dart';

import '../models/mentor.dart';
import '../repositories/local_verified_mentor_repository.dart';
import '../repositories/mentor_repository.dart';
import '../repositories/sync_mentor_repository.dart';
import 'mentors_page.dart';

mixin MentorsPageFlowMixin on State<MentorsPage> {
  late MentorRepository repository;
  final TextEditingController searchController = TextEditingController();

  List<Mentor> mentors = [];
  bool isLoading = true;
  String selectedCampus = 'all';

  @override
  void initState() {
    super.initState();
    repository =
        widget.mentorRepository ?? const LocalVerifiedMentorRepository();
    searchController.addListener(onSearchChanged);
    setupRepositoryListener();
    loadMentors();
  }

  void setupRepositoryListener() {
    final repo = repository;
    if (repo is Listenable) {
      (repo as Listenable).addListener(onRepositoryUpdated);
    }
  }

  void removeRepositoryListener() {
    final repo = repository;
    if (repo is Listenable) {
      (repo as Listenable).removeListener(onRepositoryUpdated);
    }
  }

  void onRepositoryUpdated() {
    if (mounted) {
      loadMentors();
    }
  }

  @override
  void didUpdateWidget(MentorsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mentorRepository != oldWidget.mentorRepository) {
      removeRepositoryListener();
      repository =
          widget.mentorRepository ?? const LocalVerifiedMentorRepository();
      setupRepositoryListener();
      loadMentors();
    }
  }

  @override
  void dispose() {
    removeRepositoryListener();
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    loadMentors();
  }

  Future<void> loadMentors({bool forceRefresh = false}) async {
    final query = searchController.text;
    final campus = selectedCampus == 'all' ? null : selectedCampus;
    List<Mentor> results;
    final repo = repository;
    if (forceRefresh && repo is SyncMentorRepository) {
      results = await repo.refreshMentors(
        query: query,
        campus: campus,
      );
    } else {
      results = await repository.getMentors(
        query: query,
        campus: campus,
      );
    }
    if (mounted) {
      setState(() {
        mentors = results;
        isLoading = false;
      });
    }
  }

  void resetFilters() {
    searchController.clear();
    setState(() {
      selectedCampus = 'all';
    });
    loadMentors();
  }

  void selectCampus(String campusId) {
    setState(() {
      selectedCampus = campusId;
    });
    loadMentors();
  }
}
