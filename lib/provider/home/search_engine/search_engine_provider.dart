import 'package:puntgpt_nick/core/app_imports.dart';
import 'package:puntgpt_nick/models/home/search_engine/compare_horse_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/runner_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/search_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/tip_slip_model.dart';
import 'package:puntgpt_nick/models/home/search_engine/track_item_model.dart';
import 'package:puntgpt_nick/services/search_engine/search_engine_api_service.dart';

class SearchEngineProvider extends ChangeNotifier {
  bool isSearched = false, _isMenuOpen = false, _isEditSavedSearch = false;
  int _selectedTab = 0;
  List<TipSlipModel>? tipSlips;
  int? expandedTipSlipId;
  JumpType _selectedRaceTimingEnum = JumpType.jumps_within_10mins;
  JumpType get selectedRaceTimingEnum => _selectedRaceTimingEnum;
  TextEditingController oddsRangeCtr = TextEditingController(),
      jockeyHorseWinsCtr = TextEditingController();
  List<SaveSearchModel>? saveSearches;
  List<String>? trackDetails, distanceDetails, searchFilterDetails, barrierList;
  SaveSearchModel? selectedSaveSearch;
  List<RunnerModel>? runnersList;
  CompareHorseModel? compareHorse;

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

  

  String? selectedTrack,
      selectedPlaceAtDistance,
      selectedWinsAtTrack,
      selectedWinsAtDistance,
      selectedPlaceAtTrack,
      selectedBarrier;

  set setSelectedTrack(String value) {
    selectedTrack = value;
    notifyListeners();
  }

  set setSelectedPlaceAtDistance(String value) {
    selectedPlaceAtDistance = value;
    notifyListeners();
  }

  set setSelectedWinsAtTrack(String value) {
    selectedWinsAtTrack = value;
    notifyListeners();
  }

  set setSelectedWinsAtDistance(String value) {
    selectedWinsAtDistance = value;
    notifyListeners();
  }

  set setSelectedPlaceAtTrack(String value) {
    selectedPlaceAtTrack = value;
    notifyListeners();
  }

  set setSelectedBarrier(String value) {
    selectedBarrier = value;
    notifyListeners();
  }

  set setSelectedRaceTimingEnum(JumpType value) {
    _selectedRaceTimingEnum = value;

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

  String get selectedRaceTimingApiString => selectedRaceTimingEnum.name;

  //* Home Screen Track Section (Checkboxes) - Simple boolean variables
  bool placedLastStart = false;
  bool wonLastStart = false;
  bool wonLast12Months = false;

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

  void toggleWonLast12Months(bool value) {
    wonLast12Months = value;
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

  //todo APIs functions

  Future<void> getTrackDetails() async {
    trackDetails = null;
    notifyListeners();
    final result = await SearchEngineAPISearvice.instance.getTrackDetails();

    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        final data = r["data"];
        if (data is List) {
          trackDetails = data.map((e) => e.toString()).toList();
        } else {
          trackDetails = null;
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

  Future<void> getSearchEngine({required VoidCallback onSuccess}) async {
    // runnersList = null;
    notifyListeners();
    // Get the first checked track item, if any
    String? trackValue;
    if (placedLastStart) {
      trackValue = "placed_last_start";
    } else if (wonLastStart) {
      trackValue = "won_last_start";
    } else if (wonLast12Months) {
      trackValue = "won_last_12_months";
    }

    final result = await SearchEngineAPISearvice.instance.getSearchEngine(
      jumpFilter: selectedRaceTimingApiString,
      track: trackValue,
    );
    result.fold(
      (l) {
        Logger.error("get search engine error: ${l.errorMsg}");
        runnersList = null;
      },
      (r) async {
        final data = r["data"];
        final runners = data["runners"] ?? [];

        if (runners.isEmpty) {
          runnersList = [];
          notifyListeners();
          return;
        }

        final int total = runners.length;
        final int chunkSize = (total / 6).ceil();


        runnersList = [];

        for (int i = 0; i < total; i += chunkSize) {
          final end = (i + chunkSize).clamp(0, total);
          final chunk = runners.sublist(i, end);
          Logger.info("chunk: ${chunk.length}");
          final convertedChunk = chunk
              .map<RunnerModel>((e) => RunnerModel.fromJson(e as Map<String, dynamic>))
              .toList();
          runnersList!.addAll(convertedChunk);
          notifyListeners();

          // Yield to event loop so UI can paint (no fixed delay)
          if (end < total) {
            await Future.delayed(Duration.zero);
          }
        }

        onSuccess.call();
      },
    );
    // final data = r["data"];
    // final runners = data["runners"] as List;
    // runnersList = runners.map((e) => RunnerModel.fromJson(e)).toList();
    // onSuccess.call();

    notifyListeners();
  }

  bool isCreatingSaveSearch = false;
  Future<void> createSaveSearch({
    required String name,
    required Function(String error) onError,
    required VoidCallback onSuccess,
  }) async {
    isCreatingSaveSearch = true;
    notifyListeners();
    final data = {
      "name": name,
      "filters": {
        "track": "Flemington",
        "placed_last_start": placedLastStart,
        "placed_at_distance": selectedPlaceAtDistance,
        "placed_at_track": selectedPlaceAtTrack,
        "odds_range": oddsRangeCtr.text,
        "wins_at_track": selectedWinsAtTrack,
        "win_at_distance": selectedWinsAtDistance,
        "won_last_start": wonLastStart,
        "won_last_12_months": wonLast12Months,
        "jockey_horse_wins": jockeyHorseWinsCtr.text,
        "barrier": selectedBarrier,
        "jockey_strike_rate_last_12_months": "",
      },
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
    oddsRangeCtr.clear();
    jockeyHorseWinsCtr.clear();
    selectedTrack = null;
    selectedPlaceAtDistance = null;
    selectedPlaceAtTrack = null;
    selectedWinsAtTrack = null;
    selectedWinsAtDistance = null;
    selectedBarrier = null;
    placedLastStart = false;
    wonLastStart = false;
    wonLast12Months = false;
    notifyListeners();
  }

  /// Clear saved search fields (used when navigating away from saved search details)
  clearSavedSearchFields() {
    oddsRangeCtr.clear();
    jockeyHorseWinsCtr.clear();

    selectedTrack = null;
    selectedPlaceAtDistance = null;
    selectedPlaceAtTrack = null;
    selectedWinsAtTrack = null;
    selectedWinsAtDistance = null;
    selectedBarrier = null;
    placedLastStart = false;
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
          selectedTrack = (filters.track != null && filters.track!.isNotEmpty)
              ? filters.track
              : null;
          selectedPlaceAtDistance =
              (filters.placedAtDistance != null &&
                  filters.placedAtDistance!.isNotEmpty)
              ? filters.placedAtDistance
              : null;
          selectedPlaceAtTrack =
              (filters.placedAtTrack != null &&
                  filters.placedAtTrack!.isNotEmpty)
              ? filters.placedAtTrack
              : null;
          selectedWinsAtTrack =
              (filters.winsAtTrack != null && filters.winsAtTrack!.isNotEmpty)
              ? filters.winsAtTrack
              : null;
          selectedWinsAtDistance =
              (filters.winAtDistance != null &&
                  filters.winAtDistance!.isNotEmpty)
              ? filters.winAtDistance
              : null;
          selectedBarrier =
              (filters.barrier != null && filters.barrier!.isNotEmpty)
              ? filters.barrier
              : null;

          // Boolean fields - default to false if null
          placedLastStart = filters.placedLastStart ?? false;
          wonLastStart = filters.wonLastStart ?? false;
          wonLast12Months = filters.wonLast12Months ?? false;

          // Text controllers - handle null/empty safely, use empty string to avoid null errors
          oddsRangeCtr.text =
              (filters.oddsRange != null && filters.oddsRange!.isNotEmpty)
              ? filters.oddsRange!
              : "";
          jockeyHorseWinsCtr.text =
              (filters.jockeyHorseWins != null &&
                  filters.jockeyHorseWins!.isNotEmpty)
              ? filters.jockeyHorseWins!
              : "";
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
    if (!stringsEqual(selectedTrack, filters.track)) return true;
    if (!stringsEqual(selectedPlaceAtDistance, filters.placedAtDistance)) {
      return true;
    }
    if (!stringsEqual(selectedPlaceAtTrack, filters.placedAtTrack)) return true;
    if (!stringsEqual(selectedWinsAtTrack, filters.winsAtTrack)) return true;
    if (!stringsEqual(selectedWinsAtDistance, filters.winAtDistance)) {
      return true;
    }
    if (!stringsEqual(selectedBarrier, filters.barrier)) return true;

    // Compare boolean fields
    if (placedLastStart != (filters.placedLastStart ?? false)) return true;
    if (wonLastStart != (filters.wonLastStart ?? false)) return true;
    if (wonLast12Months != (filters.wonLast12Months ?? false)) return true;

    // Compare text controller values
    final currentOddsRange = oddsRangeCtr.text.trim();
    final savedOddsRange =
        (filters.oddsRange != null && filters.oddsRange!.isNotEmpty)
        ? filters.oddsRange!.trim()
        : "";
    if (currentOddsRange != savedOddsRange) return true;

    final currentJockeyWins = jockeyHorseWinsCtr.text.trim();
    final savedJockeyWins =
        (filters.jockeyHorseWins != null && filters.jockeyHorseWins!.isNotEmpty)
        ? filters.jockeyHorseWins!.trim()
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
        "filters": {
          "track": selectedTrack ?? "",
          "placed_last_start": placedLastStart,
          "placed_at_distance": selectedPlaceAtDistance ?? "",
          "placed_at_track": selectedPlaceAtTrack ?? "",
          "odds_range": oddsRangeCtr.text.isNotEmpty ? oddsRangeCtr.text : "",
          "wins_at_track": selectedWinsAtTrack ?? "",
          "win_at_distance": selectedWinsAtDistance ?? "",
          "won_last_start": wonLastStart,
          "won_last_12_months": wonLast12Months,
          "jockey_horse_wins": jockeyHorseWinsCtr.text.isNotEmpty
              ? jockeyHorseWinsCtr.text
              : "",
          "barrier": selectedBarrier ?? "",
          "jockey_strike_rate_last_12_months": "",
        },
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

  //! ============= tip slip section ====================
  //* create tip slip
  bool isCreatingTipSlip = false;
  String? creatingForSelectionId;
  Future<void> createTipSlip({
    required String selectionId,
    required BuildContext context,
  }) async {
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
          AppToast.info(context: context, message: "Already added to tip slip");
          return;
        }
        if (data["tip_slip"] != null) {
          AppToast.success(
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
    // tipSlips = null;
    // notifyListeners();
    final result = await SearchEngineAPISearvice.instance.getTipSlips();
    result.fold(
      (l) {
        Logger.error(l.errorMsg);
      },
      (r) {
        Logger.info(r.toString());
        final data = r["data"];
        tipSlips = (data != null)
            ? (data["tip_slips"] as List).map((e) => TipSlipModel.fromJson(e)).toList()
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
