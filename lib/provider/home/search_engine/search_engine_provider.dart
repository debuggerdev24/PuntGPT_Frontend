import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/compare_horse_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/runner_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/search_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/tip_slip_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/track_item_model.dart';
import 'package:puntgpt_nick/services/search_engine/search_engine_api_service.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';

class SearchEngineProvider extends ChangeNotifier {
  // -------------------------------
  // Search filter defaults (ranges)
  // -------------------------------
  static const RangeValues _defaultOddsRange = RangeValues(1, 1);
  static const RangeValues _defaultJockeyWinsRange = RangeValues(1, 1);

  bool isSearched = false, _isMenuOpen = false, _isEditSavedSearch = false;
  int _selectedTab = 0;
  List<TipSlipModel>? tipSlips;
  int? expandedTipSlipId;
  JumpType _selectedRaceTimingEnum = JumpType.jumps_within_10mins;
  JumpType get selectedRaceTimingEnum => _selectedRaceTimingEnum;

  /// Cached track payload per date key (`today` / `tomorrow`): combined list + optional metro/regional groups for UI.
  final Map<String, _CachedTrackLists> _tracksPack = {};

  TextEditingController oddsRangeCtr = TextEditingController(),
      jockeyHorseWinsCtr = TextEditingController();
  RangeValues oddsRangeValues = _defaultOddsRange;
  bool hasSelectedOddsRange = false,
      hasSelectedJockeyHorseWinsRange = false,
      hasSelectedBarrierRange = false;
  RangeValues jockeyHorseWinsRangeValues = _defaultJockeyWinsRange;

  RangeValues barrierRangeIndexValues = const RangeValues(0, 0);

  List<SaveSearchModel>? saveSearches;
  List<String>? trackList,
      trainerList,
      jockeyList,
      distanceDetails,
      searchFilterDetails,
      barrierList,
      metroTrackList,
      regionalTrackList;

  //* When the API returns `{ metro: [], regional: [] }`, these mirror those lists (order: Metro → Regional in the UI).
  //* If the API returns a flat list instead, both stay `null` and only [trackList] is used.
  SaveSearchModel? selectedSaveSearch;
  List<RunnerModel>? runnersList;
  CompareHorseModel? compareHorse;

  //* Pagination from upcoming-runners API (data.total_runners, data.total_pages, data.page).
  int? totalRunners, totalPages;
  int _runnersCurrentPage = 1;
  bool isLoadingMoreRunners = false;

  bool get hasMoreRunners {
    if (totalPages == null) return false;
    return _runnersCurrentPage < totalPages!;
  }

  @override
  void dispose() {
    super.dispose();
    oddsRangeCtr.dispose();
    jockeyHorseWinsCtr.dispose();
  }

  void toggleTipSlipExpand(int tipSlipId) {
    expandedTipSlipId = expandedTipSlipId == tipSlipId ? null : tipSlipId;
    notifyListeners();
  }

  void removeTipSlipAt(int index) {
    tipSlips?.removeAt(index);
    notifyListeners();
  }

  /// Selected track names (multi-select). API receives them comma-separated, e.g. `Ararat, Sapphire Coast`.
  List<String> selectedTracks = [], selectedJockeys = [], selectedTrainers = [];

  // String?
  bool? placeAtTrack,
      selectedWinsAtTrack,
      selectedPlaceAtDistance,
      selectedWinsAtDistance;

  /// Comma-separated string for `track` in search/save-search payloads.
  String get trackFilterForApi =>
      selectedTracks.isEmpty ? '' : selectedTracks.join(', ');

  /// Comma-separated jockey names for API `jockey` filter.
  String get jockeyFilterForApi =>
      selectedJockeys.isEmpty ? '' : selectedJockeys.join(', ');

  /// Comma-separated trainer names for API `trainer` filter.
  String get trainerFilterForApi =>
      selectedTrainers.isEmpty ? '' : selectedTrainers.join(', ');

  void toggleSelectedTrack(String track) {
    if (selectedTracks.contains(track)) {
      selectedTracks.remove(track);
    } else {
      selectedTracks.add(track);
    }
    notifyListeners();
  }

  void clearSelectedTracks() {
    selectedTracks.clear();
    notifyListeners();
  }

  static List<String> parseTrackFilterString(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) {
      return raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    final s = raw.toString().trim();
    if (s.isEmpty) return [];
    return s
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static bool trackSelectionsMatchFilter(List<String> selected, dynamic all) {
    final savedList = parseTrackFilterString(all);
    if (selected.length != savedList.length) return false;
    return Set<String>.from(selected) == Set<String>.from(savedList);
  }

  set setSelectedPlaceAtDistance(bool value) {
    selectedPlaceAtDistance = value;
    notifyListeners();
  }

  set setSelectedWinsAtTrack(bool? value) {
    selectedWinsAtTrack = value;
    notifyListeners();
  }

  void toggleSelectedJockey(String name) {
    if (selectedJockeys.contains(name)) {
      selectedJockeys.remove(name);
    } else {
      selectedJockeys.add(name);
    }
    notifyListeners();
  }

  void toggleSelectedTrainer(String name) {
    if (selectedTrainers.contains(name)) {
      selectedTrainers.remove(name);
    } else {
      selectedTrainers.add(name);
    }
    notifyListeners();
  }

  void clearSelectedJockeys() {
    selectedJockeys.clear();
    notifyListeners();
  }

  void clearSelectedTrainers() {
    selectedTrainers.clear();
    notifyListeners();
  }

  set setSelectedWinsAtDistance(bool value) {
    selectedWinsAtDistance = value;
    notifyListeners();
  }

  set setSelectedPlaceAtTrack(bool? value) {
    placeAtTrack = value;
    notifyListeners();
  }

  set setSelectedRaceTimingEnum(JumpType value) {
    _selectedRaceTimingEnum = value;

    getTrackList();
    getJockeyList();
    getTrainerList();
    notifyListeners();
  }

  int get selectedTab => _selectedTab;
  bool get isMenuOpen => _isMenuOpen;
  bool get isEditSavedSearch => _isEditSavedSearch;

  set setIsEditSavedSearch(bool value) {
    _isEditSavedSearch = value;
    notifyListeners();
  }

  set setIsMenuOpen(bool value) {
    _isMenuOpen = value;
    notifyListeners();
  }

  set changeTab(int value) {
    _selectedTab = value;
    notifyListeners();
  }

  // Maps race starting timing indices to their corresponding JumpType enums
  List<JumpType> raceTimingEnums = [
    JumpType.jumps_within_10mins,
    JumpType.jumps_within_an_hour,
    JumpType.jumps_today,
    JumpType.jumps_tomorrow,
  ];

  //* Home Screen Track Section (Checkboxes) - Simple boolean variables
  bool placedLastStart = false,
      placedAtDistance = false,
      wonAtDistance = false,
      wonLastStart = false,
      wonLast12Months = false;

  //* Saved Search Screen Track Section (Checkboxes)
  final List<TrackItemModel> savedSearchTrackItems = [
    TrackItemModel.fromTrackType(TrackType.placed_last_start),
    TrackItemModel.fromTrackType(TrackType.won_last_start),
    TrackItemModel.fromTrackType(TrackType.won_last_12_months),
    // TrackItemModel.fromTrackType(TrackType.odds_range),
  ];

  //* Toggle method for track checkboxes
  void togglePlacedLastStart(bool value) {
    placedLastStart = value;
    notifyListeners();
  }

  void toggleWonLastStart(bool value) {
    wonLastStart = value;
    notifyListeners();
  }

  void togglePlacedAtDistance(bool value) {
    placedAtDistance = value;
    notifyListeners();
  }

  void toggleWonAtDistance(bool value) {
    wonAtDistance = value;
    notifyListeners();
  }

  void toggleWonLast12Months(bool value) {
    wonLast12Months = value;
    notifyListeners();
  }

  void updateOddsRange(RangeValues values) {
    // User changed odds slider => persist as selected range.
    oddsRangeValues = values;
    hasSelectedOddsRange = true;
    oddsRangeCtr.text = _formatRange(values.start, values.end);
    notifyListeners();
  }

  void updateJockeyHorseWinsRange(RangeValues values) {
    // User changed jockey wins slider => persist as selected range.
    jockeyHorseWinsRangeValues = values;
    hasSelectedJockeyHorseWinsRange = true;
    jockeyHorseWinsCtr.text = _formatJockeyWinsRange(values.start, values.end);
    notifyListeners();
  }

  /// 0: 1-3, 1: 4-6, 2: 7-10, 3: 11-13, 4: 14-16.
  /// We store slider indexes (0..4), then convert to min/max for API.
  void updateBarrierRange(RangeValues values) {
    barrierRangeIndexValues = RangeValues(
      values.start.roundToDouble(),
      values.end.roundToDouble(),
    );
    hasSelectedBarrierRange = true;
    notifyListeners();
  }

  //* Toggle method for saved search track checkboxes
  void updateSavedSearchTrackItem(String label, bool value) {
    final index = savedSearchTrackItems.indexWhere(
      (item) => item.trackType.value == label,
    );
    if (index != -1) {
      savedSearchTrackItems[index] = savedSearchTrackItems[index].copyWith(
        checked: value,
      );
      notifyListeners();
    }
  }

  void setIsSearched({required bool value}) {
    isSearched = value;
    notifyListeners();
  }

  //* APIs functions

  String _trackDateKeyFromJumpType(JumpType type) {
    return type == JumpType.jumps_tomorrow ? "tomorrow" : "today";
  }

  //* Get track list
  Future<void> getTrackList({bool force = false}) async {
    final dateKey = _trackDateKeyFromJumpType(selectedRaceTimingEnum);

    if (!force && _tracksPack.containsKey(dateKey)) {
      final cached = _tracksPack[dateKey]!;
      trackList = cached.all;
      metroTrackList = cached.metro;
      regionalTrackList = cached.regional;
      notifyListeners();
      return;
    }

    notifyListeners();

    final result = await SearchEngineAPISearvice.instance.getTrackList(
      queryParameters: {"date": dateKey},
    );

    result.fold((l) => Logger.error(l.errorMsg), (r) {
      final parsed = _parseTrackResponseData(r["data"]);
      if (parsed == null) {
        trackList = null;
        metroTrackList = null;
        regionalTrackList = null;
        return;
      }
      _tracksPack[dateKey] = parsed;
      trackList = parsed.all;
      metroTrackList = parsed.metro;
      regionalTrackList = parsed.regional;
    });

    // isLoadingTrackList = false;
    notifyListeners();
  }

  //* Get jockey list
  Future<void> getJockeyList() async {
    final dateKey = _trackDateKeyFromJumpType(selectedRaceTimingEnum);

    final result = await SearchEngineAPISearvice.instance.getJockeyList(
      queryParameters: {"date": dateKey},
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"]["jockeys"];

        if (data is List) {
          jockeyList = List<String>.from(data.map((e) => e.toString()));
        } else {
          jockeyList = null;
        }
      },
    );
    notifyListeners();
  }

  //* Get trainer list
  Future<void> getTrainerList() async {
    final dateKey = _trackDateKeyFromJumpType(selectedRaceTimingEnum);

    final result = await SearchEngineAPISearvice.instance.getTrainerList(
      queryParameters: {"date": dateKey},
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"]["trainers"];
        if (data is List) {
          trainerList = List<String>.from(data.map((e) => e.toString()));
        } else {
          trainerList = null;
        }
      },
    );
    notifyListeners();
  }

  Future<void> getDistanceDetails() async {
    distanceDetails = null;
    notifyListeners();
    final result = await SearchEngineAPISearvice.instance.getDistanceDetails();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        if (data is List) {
          distanceDetails = data.map((e) => e.toString()).toList();
        } else {
          distanceDetails = null;
        }
      },
    );
    notifyListeners();
  }

  Future<void> getBarrierDetails() async {
    barrierList = null;
    notifyListeners();
    final result = await SearchEngineAPISearvice.instance.getBarrierDetails();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        if (data is List) {
          barrierList = data.map((e) => e.toString()).toList();
        } else {
          barrierList = null;
        }
      },
    );
    notifyListeners();
  }

  bool isGettingRunners = false;
  Future<void> getUpcomingRunner({required VoidCallback onSuccess}) async {
    runnersList = null;
    totalRunners = null;
    totalPages = null;
    isGettingRunners = true;
    _runnersCurrentPage = 1;
    notifyListeners();

    final result = await SearchEngineAPISearvice.instance.getSearchEngine(
      // jumpFilter: selectedRaceTimingApiString,
      page: 1,
      filters: _buildSearchFilters(),
    );
    result.fold(
      (l) {
        Logger.error("get search engine error: ${l.errorMsg}");
        runnersList = null;
      },
      (r) {
        final data = r["data"] as Map<String, dynamic>?;
        final runners = data?["runners"] as List? ?? [];
        runnersList = runners
            .map<RunnerModel>(
              (e) => RunnerModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        totalRunners = data?["total_runners"] as int?;
        totalPages = data?["total_pages"] as int?;
        _runnersCurrentPage = data?["page"] as int? ?? 1;
        onSuccess.call();
      },
    );
    isGettingRunners = false;
    notifyListeners();
  }

  //* Load next page of runners and append to [runnersList]. No-op if no more pages or already loading.
  Future<void> loadNextRunners() async {
    if (!hasMoreRunners || isLoadingMoreRunners || runnersList == null) return;

    isLoadingMoreRunners = true;
    notifyListeners();

    final nextPage = _runnersCurrentPage + 1;
    final result = await SearchEngineAPISearvice.instance.getSearchEngine(
      page: nextPage,
      filters: _buildSearchFilters(),
    );

    result.fold(
      (l) {
        Logger.error("load next runners error: ${l.errorMsg}");
      },
      (r) {
        final data = r["data"] as Map<String, dynamic>?;
        final runners = data?["runners"] as List? ?? [];
        final converted = runners
            .map<RunnerModel>(
              (e) => RunnerModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        runnersList!.addAll(converted);
        _runnersCurrentPage = data?["page"] as int? ?? nextPage;
      },
    );

    isLoadingMoreRunners = false;
    notifyListeners();
  }

  bool isCreatingSaveSearch = false;
  Map<String, dynamic> _buildSearchFilters() {
    final filters = <String, dynamic>{
      "jump": selectedRaceTimingEnum.name,
      "track": trackFilterForApi,
    };

    final jockeyPayload = jockeyFilterForApi;
    if (jockeyPayload.isNotEmpty) {
      filters["jockey"] = jockeyPayload;
    }
    final trainerPayload = trainerFilterForApi;
    if (trainerPayload.isNotEmpty) {
      filters["trainer"] = trainerPayload;
    }

    if (placedLastStart) {
      filters["placed_last_start"] = placedLastStart;
    }

    if (placedAtDistance) {
      filters["placed_at_distance"] = placedAtDistance;
    }

    if (placeAtTrack != null) {
      filters["placed_at_track"] = placeAtTrack;
    }

    if (selectedWinsAtTrack != null) {
      filters["wins_at_track"] = selectedWinsAtTrack;
    }
    if (wonAtDistance) {
      filters["win_at_distance"] = wonAtDistance;
    }
    if (wonLastStart) {
      filters["won_last_start"] = wonLastStart;
    }
    if (wonLast12Months) {
      filters["won_last_12_months"] = wonLast12Months;
    }

    if (hasSelectedOddsRange) {
      filters["odds_min"] = _formatBound(oddsRangeValues.start);
      filters["odds_max"] = _formatBound(oddsRangeValues.end, isUpper: true);
    }

    if (hasSelectedJockeyHorseWinsRange) {
      filters["jockey_horse_wins_min"] = _formatJockeyWinsBound(
        jockeyHorseWinsRangeValues.start,
      );
      filters["jockey_horse_wins_max"] = _formatJockeyWinsBound(
        jockeyHorseWinsRangeValues.end,
      );
    }

    if (hasSelectedBarrierRange) {
      final barrierRange = _barrierMinMaxFromIndexes(
        barrierRangeIndexValues.start.round(),
        barrierRangeIndexValues.end.round(),
      );
      filters["barrier_min"] = barrierRange.$1.toString();
      filters["barrier_max"] = barrierRange.$2.toString();
    }

    filters["jockey_strike_rate_last_12_months"] = "";
    return filters;
  }

  int uniqueSearchId = 0;
  Future<void> createSaveSearch({
    required String name,
    required Function(String error) onError,
    required VoidCallback onSuccess,
    int? index,
  }) async {
    isCreatingSaveSearch = true;
    uniqueSearchId = index ?? uniqueSearchId;
    notifyListeners();
    final data = {
      "name": name,
      "filters": _buildSearchFilters(),
      "comment": "Custom comment",
    };
    Logger.info(data.toString());
    final result = await SearchEngineAPISearvice.instance.createSaveSearch(
      data: data,
    );
    result.fold(
      (l) {
        onError.call("createSaveSearch function error: ${l.errorMsg}");
      },
      (r) {
        Logger.info(r.toString());
        onSuccess.call();
      },
    );
    isCreatingSaveSearch = false;
    notifyListeners();
  }

  /// Clear all search fields (used for new searches)
  clearSearchFields() {
    _resetOddsRangeSelection();
    _resetJockeyWinsSelection();
    _resetBarrierSelection();
    selectedTracks.clear();
    selectedJockeys.clear();
    selectedTrainers.clear();
    selectedPlaceAtDistance = null;
    placeAtTrack = null;
    selectedWinsAtTrack = null;
    selectedWinsAtDistance = null;
    placedLastStart = false;
    placedAtDistance = false;
    wonAtDistance = false;
    wonLastStart = false;
    wonLast12Months = false;
    notifyListeners();
  }

  /// Clear saved search fields (used when navigating away from saved search details)
  clearSavedSearchFields() {
    _resetOddsRangeSelection();
    _resetJockeyWinsSelection();
    _resetBarrierSelection();

    selectedTracks.clear();
    selectedJockeys.clear();
    selectedTrainers.clear();
    selectedPlaceAtDistance = null;
    placeAtTrack = null;
    selectedWinsAtTrack = null;
    selectedWinsAtDistance = null;
    placedLastStart = false;
    placedAtDistance = false;
    wonAtDistance = false;
    wonLastStart = false;
    wonLast12Months = false;
    selectedSaveSearch = null;
    setIsEditSavedSearch = false;
    notifyListeners();
  }

  Future<void> getAllSaveSearch() async {
    saveSearches = null;
    notifyListeners();
    final result = await SearchEngineAPISearvice.instance.getAllSaveSearch();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
        saveSearches = [];
      },
      (r) {
        saveSearches = (r["data"] != null)
            ? (r["data"] as List)
                  .map((e) => SaveSearchModel.fromJson(e))
                  .toList()
            : null;
        notifyListeners();
      },
    );
    notifyListeners();
  }

  Future<void> getSaveSearchDetails({required String id}) async {
    selectedSaveSearch = null;
    // Clear fields before loading new data
    clearSavedSearchFields();
    notifyListeners();
    final result = await SearchEngineAPISearvice.instance.getSaveSearchDetails(
      id: id,
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        selectedSaveSearch = SaveSearchModel.fromJson(r["data"]);
        final filters = selectedSaveSearch?.filters;
        if (filters != null) {
          // Populate all fields from saved search data
          // Handle null/empty values gracefully - use empty string instead of null to avoid errors
          selectedTracks = parseTrackFilterString(filters.track);
          selectedJockeys = parseTrackFilterString(filters.jockey);
          selectedTrainers = parseTrackFilterString(filters.trainer);
          placeAtTrack = _parseFlexibleNullableBool(filters.placedAtTrack);
          selectedWinsAtTrack = _parseFlexibleNullableBool(filters.winsAtTrack);
          final hasBarrierMin =
              filters.barrierMin != null && filters.barrierMin!.isNotEmpty;
          final hasBarrierMax =
              filters.barrierMax != null && filters.barrierMax!.isNotEmpty;
          if (hasBarrierMin && hasBarrierMax) {
            final min = int.tryParse(filters.barrierMin!.trim());
            final max = int.tryParse(filters.barrierMax!.trim());
            if (min != null && max != null) {
              barrierRangeIndexValues = RangeValues(
                _barrierNearestIndex(min).toDouble(),
                _barrierNearestIndex(max).toDouble(),
              );
              hasSelectedBarrierRange = true;
            } else {
              _resetBarrierSelection();
            }
          } else {
            _resetBarrierSelection();
          }

          // Boolean fields - default to false if null
          placedLastStart = filters.placedLastStart ?? false;
          placedAtDistance = _parseFlexibleBool(filters.placedAtDistance);
          wonAtDistance = _parseFlexibleBool(filters.winAtDistance);
          wonLastStart = filters.wonLastStart ?? false;
          wonLast12Months = filters.wonLast12Months ?? false;

          // Text controllers - handle null/empty safely, use empty string to avoid null errors
          _setOddsRangeFromSavedFilters(filters);
          _setJockeyWinsRangeFromSavedFilters(filters);
        }
      },
    );
    notifyListeners();
  }

  //* Check if there are any changes in the saved search fields
  bool hasChangesInSavedSearch() {
    if (selectedSaveSearch == null) return false;

    final filters = selectedSaveSearch!.filters;

    // Helper function to compare nullable strings
    bool stringsEqual(String? a, String? b) {
      final aValue = (a != null && a.isNotEmpty) ? a : null;
      final bValue = (b != null && b.isNotEmpty) ? b : null;
      return aValue == bValue;
    }

    // Compare all fields
    if (!trackSelectionsMatchFilter(selectedTracks, filters.track)) return true;
    if (!trackSelectionsMatchFilter(selectedJockeys, filters.jockey)) {
      return true;
    }
    if (!trackSelectionsMatchFilter(selectedTrainers, filters.trainer)) {
      return true;
    }
    if (placedAtDistance != _parseFlexibleBool(filters.placedAtDistance)) {
      return true;
    }
    if (placeAtTrack != _parseFlexibleNullableBool(filters.placedAtTrack)) {
      return true;
    }
    if (selectedWinsAtTrack !=
        _parseFlexibleNullableBool(filters.winsAtTrack)) {
      return true;
    }
    if (wonAtDistance != _parseFlexibleBool(filters.winAtDistance)) {
      return true;
    }
    final hasSavedBarrierMin =
        filters.barrierMin != null && filters.barrierMin!.isNotEmpty;
    final hasSavedBarrierMax =
        filters.barrierMax != null && filters.barrierMax!.isNotEmpty;
    final currentBarrier = hasSelectedBarrierRange
        ? _barrierStringFromIndexes(
            barrierRangeIndexValues.start.round(),
            barrierRangeIndexValues.end.round(),
          )
        : null;
    final savedBarrier = (hasSavedBarrierMin && hasSavedBarrierMax)
        ? _barrierStringFromValues(filters.barrierMin!, filters.barrierMax!)
        : null;
    if (!stringsEqual(currentBarrier, savedBarrier)) return true;

    // Compare boolean fields
    if (placedLastStart != (filters.placedLastStart ?? false)) return true;
    if (wonLastStart != (filters.wonLastStart ?? false)) return true;
    if (wonLast12Months != (filters.wonLast12Months ?? false)) return true;

    // Compare text controller values
    final currentOddsRange = hasSelectedOddsRange
        ? _formatRange(oddsRangeValues.start, oddsRangeValues.end)
        : "";
    final hasSavedOddsMin =
        filters.oddsMin != null && filters.oddsMin!.isNotEmpty;
    final hasSavedOddsMax =
        filters.oddsMax != null && filters.oddsMax!.isNotEmpty;
    final savedOddsRange = (hasSavedOddsMin && hasSavedOddsMax)
        ? _normalizeOddsRangeFromBounds(filters.oddsMin!, filters.oddsMax!)
        : (filters.oddsRange != null && filters.oddsRange!.isNotEmpty)
        ? filters.oddsRange!.trim()
        : "";
    if (currentOddsRange != savedOddsRange) return true;

    final currentJockeyWins = hasSelectedJockeyHorseWinsRange
        ? _formatJockeyWinsRange(
            jockeyHorseWinsRangeValues.start,
            jockeyHorseWinsRangeValues.end,
          )
        : "";
    final hasSavedJockeyMin =
        filters.jockeyHorseWinsMin != null &&
        filters.jockeyHorseWinsMin!.isNotEmpty;
    final hasSavedJockeyMax =
        filters.jockeyHorseWinsMax != null &&
        filters.jockeyHorseWinsMax!.isNotEmpty;
    final savedJockeyWins = (hasSavedJockeyMin && hasSavedJockeyMax)
        ? _normalizeJockeyRangeFromBounds(
            filters.jockeyHorseWinsMin!,
            filters.jockeyHorseWinsMax!,
          )
        : "";
    if (currentJockeyWins != savedJockeyWins) return true;

    return false; // No changes detected
  }

  Future<void> editSaveSearch({required VoidCallback onSuccess}) async {
    final id = selectedSaveSearch!.id.toString();
    final result = await SearchEngineAPISearvice.instance.editSaveSearch(
      id: id,
      data: {
        "name": selectedSaveSearch?.name ?? "Custom edited Name",
        "filters": _buildSearchFilters(),
        "comment": selectedSaveSearch?.comment ?? "Custom edited comment",
      },
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        setIsEditSavedSearch = false;
        getSaveSearchDetails(id: id);
        onSuccess.call();
      },
    );
    notifyListeners();
  }

  Future<void> deleteSaveSearch({
    required String id,
    required VoidCallback onSuccess,
  }) async {
    final result = await SearchEngineAPISearvice.instance.deleteSaveSearch(
      id: id,
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        onSuccess.call();
        getAllSaveSearch();
      },
    );
  }

  bool _parseFlexibleBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      final v = value.trim().toLowerCase();
      return v == "true" || v == "1" || v == "yes";
    }
    return false;
  }

  // -------------------------------
  // Range helper methods
  // -------------------------------
  void _resetOddsRangeSelection() {
    oddsRangeCtr.clear();
    oddsRangeValues = _defaultOddsRange;
    hasSelectedOddsRange = false;
  }

  void _resetJockeyWinsSelection() {
    jockeyHorseWinsCtr.clear();
    jockeyHorseWinsRangeValues = _defaultJockeyWinsRange;
    hasSelectedJockeyHorseWinsRange = false;
  }

  void _resetBarrierSelection() {
    barrierRangeIndexValues = const RangeValues(0, 0);
    hasSelectedBarrierRange = false;
  }

  void _setOddsRangeFromSavedFilters(Filters filters) {
    final hasOddsMin = filters.oddsMin != null && filters.oddsMin!.isNotEmpty;
    final hasOddsMax = filters.oddsMax != null && filters.oddsMax!.isNotEmpty;

    if (hasOddsMin && hasOddsMax) {
      final combined = "${filters.oddsMin}-${filters.oddsMax}";
      oddsRangeCtr.text = combined;
      _applyOddsRangeFromString(combined);
      return;
    }

    // Backward compatibility for older saved searches.
    if (filters.oddsRange != null && filters.oddsRange!.isNotEmpty) {
      oddsRangeCtr.text = filters.oddsRange!;
      _applyOddsRangeFromString(filters.oddsRange!);
      return;
    }

    _resetOddsRangeSelection();
  }

  void _setJockeyWinsRangeFromSavedFilters(Filters filters) {
    final hasJockeyMin =
        filters.jockeyHorseWinsMin != null &&
        filters.jockeyHorseWinsMin!.isNotEmpty;
    final hasJockeyMax =
        filters.jockeyHorseWinsMax != null &&
        filters.jockeyHorseWinsMax!.isNotEmpty;

    if (hasJockeyMin && hasJockeyMax) {
      final combined =
          "${filters.jockeyHorseWinsMin}-${filters.jockeyHorseWinsMax}";
      jockeyHorseWinsCtr.text = combined;
      _applyJockeyWinsRangeFromString(combined);
      return;
    }

    _resetJockeyWinsSelection();
  }

  void _applyOddsRangeFromString(String rawValue) {
    final cleaned = rawValue.trim();
    if (cleaned.isEmpty) {
      oddsRangeValues = const RangeValues(2.5, 10);
      hasSelectedOddsRange = false;
      return;
    }
    final parts = cleaned.split("-");
    if (parts.length != 2) {
      oddsRangeValues = const RangeValues(2.5, 10);
      hasSelectedOddsRange = false;
      return;
    }
    double? parseBound(String input) {
      final cleaned = input.replaceAll("\$", "").replaceAll("+", "").trim();
      return double.tryParse(cleaned);
    }

    final start = parseBound(parts[0]);
    final end = parseBound(parts[1]);
    if (start == null || end == null) {
      oddsRangeValues = const RangeValues(2.5, 10);
      hasSelectedOddsRange = false;
      return;
    }
    final normalizedStart = start.clamp(1.0, 20.0);
    final normalizedEnd = end.clamp(1.0, 20.0);
    oddsRangeValues = RangeValues(
      normalizedStart <= normalizedEnd ? normalizedStart : normalizedEnd,
      normalizedStart <= normalizedEnd ? normalizedEnd : normalizedStart,
    );
    hasSelectedOddsRange = true;
  }

  String _formatRange(double start, double end) {
    final String Function(double, {bool isUpper}) fmt = _formatBound;
    if (start == end) {
      return fmt(start, isUpper: true);
    }
    return "${fmt(start)}-${fmt(end, isUpper: true)}";
  }

  String _formatBound(double value, {bool isUpper = false}) {
    if (isUpper && value >= 20) return "20+";
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  String _normalizeOddsRangeFromBounds(String minRaw, String maxRaw) {
    final min = minRaw.trim().replaceAll("\$", "");
    final max = maxRaw.trim().replaceAll("\$", "");
    if (min.isEmpty && max.isEmpty) return "";
    if (min == max) return max;
    return "$min-$max";
  }

  void _applyJockeyWinsRangeFromString(String rawValue) {
    final cleaned = rawValue.trim();
    if (cleaned.isEmpty) {
      jockeyHorseWinsRangeValues = const RangeValues(1, 5);
      hasSelectedJockeyHorseWinsRange = false;
      return;
    }
    final parts = cleaned.split("-");
    if (parts.length == 1) {
      final single = double.tryParse(parts.first.trim());
      if (single == null) {
        jockeyHorseWinsRangeValues = const RangeValues(1, 5);
        hasSelectedJockeyHorseWinsRange = false;
        return;
      }
      final normalized = single.clamp(1.0, 5.0);
      jockeyHorseWinsRangeValues = RangeValues(normalized, normalized);
      hasSelectedJockeyHorseWinsRange = true;
      return;
    }
    if (parts.length != 2) {
      jockeyHorseWinsRangeValues = const RangeValues(1, 5);
      hasSelectedJockeyHorseWinsRange = false;
      return;
    }
    final start = double.tryParse(parts[0].trim());
    final end = double.tryParse(parts[1].trim());
    if (start == null || end == null) {
      jockeyHorseWinsRangeValues = const RangeValues(1, 5);
      hasSelectedJockeyHorseWinsRange = false;
      return;
    }
    final normalizedStart = start.clamp(1.0, 5.0);
    final normalizedEnd = end.clamp(1.0, 5.0);
    jockeyHorseWinsRangeValues = RangeValues(
      normalizedStart <= normalizedEnd ? normalizedStart : normalizedEnd,
      normalizedStart <= normalizedEnd ? normalizedEnd : normalizedStart,
    );
    hasSelectedJockeyHorseWinsRange = true;
  }

  String _formatJockeyWinsBound(double value) => value.toStringAsFixed(0);

  String _formatJockeyWinsRange(double start, double end) {
    final min = _formatJockeyWinsBound(start);
    final max = _formatJockeyWinsBound(end);
    if (min == max) return min;
    return "$min-$max";
  }

  String _normalizeJockeyRangeFromBounds(String minRaw, String maxRaw) {
    final min = minRaw.trim();
    final max = maxRaw.trim();
    if (min.isEmpty && max.isEmpty) return "";
    if (min == max) return max;
    return "$min-$max";
  }

  // Barrier uses single-value points on UI (no "x-y" labels).
  static const List<int> _barrierPoints = [1, 4, 7, 10, 13, 16];

  (int, int) _barrierMinMaxFromIndexes(int startIndex, int endIndex) {
    final lowerIndex = startIndex <= endIndex ? startIndex : endIndex;
    final upperIndex = startIndex <= endIndex ? endIndex : startIndex;
    return (_barrierPoints[lowerIndex], _barrierPoints[upperIndex]);
  }

  int _barrierNearestIndex(int value) {
    int nearestIndex = 0;
    int minDiff = 1 << 30;
    for (int i = 0; i < _barrierPoints.length; i++) {
      final diff = (value - _barrierPoints[i]).abs();
      if (diff <= minDiff) {
        minDiff = diff;
        nearestIndex = i;
      }
    }
    return nearestIndex;
  }

  String _barrierStringFromIndexes(int startIndex, int endIndex) {
    final (minValue, maxValue) = _barrierMinMaxFromIndexes(
      startIndex,
      endIndex,
    );
    if (minValue == maxValue) return "$minValue";
    return "$minValue-$maxValue";
  }

  String _barrierStringFromValues(String minRaw, String maxRaw) {
    final minParsed = int.tryParse(minRaw.trim());
    final maxParsed = int.tryParse(maxRaw.trim());
    if (minParsed == null || maxParsed == null) return "";
    final min = _barrierPoints[_barrierNearestIndex(minParsed)];
    final max = _barrierPoints[_barrierNearestIndex(maxParsed)];
    if (min == max) return "$max";
    return "$min-$max";
  }

  bool? _parseFlexibleNullableBool(dynamic value) {
    if (value == null) return null;
    if (value is String && value.trim().isEmpty) return null;
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      final v = value.trim().toLowerCase();
      if (v == "true" || v == "1" || v == "yes") return true;
      if (v == "false" || v == "0" || v == "no") return false;
    }
    return null;
  }

  //! ============= tip slip section ====================
  //* create tip slip
  bool isCreatingTipSlip = false;
  String? creatingForSelectionId;
  Future<void> createTipSlip({
    required String selectionId,
    required BuildContext context,
  }) async {
    if (isCreatingTipSlip) return;
    isCreatingTipSlip = true;
    creatingForSelectionId = selectionId;
    notifyListeners();

    final result = await SearchEngineAPISearvice.instance.createTipSlip(
      data: {"selection": selectionId},
    );
    result.fold(
      (l) {
        Logger.info("createTipSlip function error: ${l.errorMsg}");
      },
      (r) {
        final data = r["data"];
        if (data == null) {
          AppToast.info(
            durationSecond: 3,
            context: context,
            message: "Already added to tip slip",
          );
          return;
        }
        if (data["tip_slip"] != null) {
          AppToast.success(
            duration: const Duration(seconds: 3),
            context: context,
            message: "Added to tip slip successfully",
          );
          // tipSlipCount++;
          getAllTipSlips();
        }
      },
    );
    isCreatingTipSlip = false;
    creatingForSelectionId = null;
    notifyListeners();
  }

  //* get tip slips
  Future<void> getAllTipSlips() async {
    tipSlips = null;

    if (LocaleStorageService.acccessToken.isEmpty) return;

    final result = await SearchEngineAPISearvice.instance.getTipSlips();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        tipSlips = (data != null)
            ? (data["tip_slips"] as List)
                  .map((e) => TipSlipModel.fromJson(e))
                  .toList()
            : [];
        // tipSlipCount = data["count"] ?? 0;
      },
    );
    notifyListeners();
  }

  //* remove from tip slip
  Future<void> removeFromTipSlip({required String tipSlipId}) async {
    final result = await SearchEngineAPISearvice.instance.removeFromTipSlip(
      tipSlipId: tipSlipId,
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        getAllTipSlips();
      },
    );
  }

  //* compare horses
  Future<void> compareHorses({required String selectionId}) async {
    compareHorse = null;
    notifyListeners();
    final result = await SearchEngineAPISearvice.instance.compareHorses(
      data: {"selection_id": selectionId},
    );
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
        notifyListeners();
      },
      (r) {
        final data = r;
        compareHorse = CompareHorseModel.fromJson(data);

        notifyListeners();
      },
    );
  }
}

/// Parses `data` from the track list API: either a flat `List` or `{ "metro": [], "regional": [] }`.
_CachedTrackLists? _parseTrackResponseData(dynamic data) {
  List<String> stringsFromList(dynamic v) {
    if (v is! List) return [];
    return v
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  if (data is Map) {
    final raw = Map<String, dynamic>.from(data);
    final metro = stringsFromList(raw['metro']);
    final regional = stringsFromList(raw['regional']);
    final all = [...metro, ...regional];
    if (all.isEmpty) return null;
    return _CachedTrackLists(all: all, metro: metro, regional: regional);
  }

  if (data is List) {
    final all = data
        .map((e) => e.toString().trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (all.isEmpty) return null;
    return _CachedTrackLists(all: all, metro: null, regional: null);
  }

  return null;
}

class _CachedTrackLists {
  const _CachedTrackLists({required this.all, this.metro, this.regional});

  final List<String> all;
  final List<String>? metro;
  final List<String>? regional;
}
