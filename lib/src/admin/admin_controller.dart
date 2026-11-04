import 'package:flutter/foundation.dart';

import '../clubs/club_models.dart';
import '../discovery/facility_model.dart';
import '../discovery/mentor_model.dart';
import 'admin_models.dart';
import 'admin_repository.dart';
import 'content_templates.dart';

class AdminController extends ChangeNotifier {
  AdminController({
    required AdminRepository repository,
  }) : _repository = repository;

  final AdminRepository _repository;

  bool _isAuthenticated = false;
  String _currentAdminEmail = '';
  bool _isLoading = false;
  String? _errorMessage;

  AdminDashboardMetrics? _metrics;
  List<ModuleDraft> _modules = [];
  List<QuestionDraft> _questions = [];
  List<ArticleDraft> _articles = [];
  List<Facility> _facilities = [];
  List<Mentor> _mentors = [];
  List<StudentClub> _clubs = [];
  List<ManagedUser> _users = [];
  List<AdminAccount> _adminAccounts = [];
  List<AdminAuditEntry> _auditLogs = [];

  bool get isAuthenticated => _isAuthenticated;
  String get currentAdminEmail => _currentAdminEmail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AdminDashboardMetrics? get metrics => _metrics;
  List<ModuleDraft> get modules => List.unmodifiable(_modules);
  List<QuestionDraft> get questions => List.unmodifiable(_questions);
  List<ArticleDraft> get articles => List.unmodifiable(_articles);
  List<Facility> get facilities => List.unmodifiable(_facilities);
  List<Mentor> get mentors => List.unmodifiable(_mentors);
  List<StudentClub> get clubs => List.unmodifiable(_clubs);
  List<ManagedUser> get users => List.unmodifiable(_users);
  List<AdminAccount> get adminAccounts => List.unmodifiable(_adminAccounts);
  List<AdminAuditEntry> get auditLogs => List.unmodifiable(_auditLogs);

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final isValid = await _repository.verifyAdminCredentials(email, password);
      if (isValid) {
        _isAuthenticated = true;
        _currentAdminEmail = email.trim();
        await loadDashboard();
        return true;
      } else {
        _errorMessage = 'Invalid administrator credentials.';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void signOut() {
    _isAuthenticated = false;
    _currentAdminEmail = '';
    _metrics = null;
    _modules = [];
    _questions = [];
    _articles = [];
    _facilities = [];
    _mentors = [];
    _clubs = [];
    _users = [];
    _adminAccounts = [];
    _auditLogs = [];
    notifyListeners();
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _metrics = await _repository.getDashboardMetrics();
      _modules = await _repository.getModules();
      _questions = await _repository.getQuestions();
      _articles = await _repository.getArticles();
      _facilities = await _repository.getFacilities();
      _mentors = await _repository.getMentors();
      _clubs = await _repository.getClubs();
      _users = await _repository.getUsers();
      _adminAccounts = await _repository.getAdminAccounts();
      _auditLogs = await _repository.getAuditLogs();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- MODULE ACTIONS ---
  Future<void> saveModule(ModuleDraft module) async {
    await _repository.saveModule(module, adminEmail: _currentAdminEmail);
    _modules = await _repository.getModules();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> deleteModule(String moduleId) async {
    await _repository.deleteModule(moduleId, adminEmail: _currentAdminEmail);
    _modules = await _repository.getModules();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  // --- QUESTION ACTIONS ---
  Future<void> saveQuestion(QuestionDraft question) async {
    await _repository.saveQuestion(question, adminEmail: _currentAdminEmail);
    _questions = await _repository.getQuestions();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> deleteQuestion(String questionId) async {
    await _repository.deleteQuestion(questionId,
        adminEmail: _currentAdminEmail);
    _questions = await _repository.getQuestions();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  // --- ARTICLE ACTIONS ---
  Future<void> saveArticle(ArticleDraft article) async {
    await _repository.saveArticle(article, adminEmail: _currentAdminEmail);
    _articles = await _repository.getArticles();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> deleteArticle(String articleId) async {
    await _repository.deleteArticle(articleId, adminEmail: _currentAdminEmail);
    _articles = await _repository.getArticles();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  // --- FACILITY ACTIONS ---
  Future<void> saveFacility(Facility facility) async {
    await _repository.saveFacility(facility, adminEmail: _currentAdminEmail);
    _facilities = await _repository.getFacilities();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> deleteFacility(String facilityId) async {
    await _repository.deleteFacility(facilityId,
        adminEmail: _currentAdminEmail);
    _facilities = await _repository.getFacilities();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  // --- MENTOR ACTIONS ---
  Future<void> saveMentor(Mentor mentor) async {
    await _repository.saveMentor(mentor, adminEmail: _currentAdminEmail);
    _mentors = await _repository.getMentors();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> deleteMentor(String mentorId) async {
    await _repository.deleteMentor(mentorId, adminEmail: _currentAdminEmail);
    _mentors = await _repository.getMentors();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  // --- CLUB ACTIONS ---
  Future<void> saveClub(StudentClub club) async {
    await _repository.saveClub(club, adminEmail: _currentAdminEmail);
    _clubs = await _repository.getClubs();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> deleteClub(String clubId) async {
    await _repository.deleteClub(clubId, adminEmail: _currentAdminEmail);
    _clubs = await _repository.getClubs();
    _metrics = await _repository.getDashboardMetrics();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<List<ClubMembership>> getClubRoster(String clubId) async {
    return _repository.getClubRoster(clubId);
  }

  // --- USER ACTIONS ---
  Future<void> updateUserRole(String userId, String role) async {
    await _repository.updateUserRole(userId, role,
        adminEmail: _currentAdminEmail);
    _users = await _repository.getUsers();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  Future<void> toggleUserStatus(String userId) async {
    await _repository.toggleUserStatus(userId, adminEmail: _currentAdminEmail);
    _users = await _repository.getUsers();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }

  // --- ADMIN ACCOUNTS ACTIONS ---
  Future<void> saveAdminAccount(AdminAccount account) async {
    await _repository.saveAdminAccount(account, adminEmail: _currentAdminEmail);
    _adminAccounts = await _repository.getAdminAccounts();
    _auditLogs = await _repository.getAuditLogs();
    notifyListeners();
  }
}
