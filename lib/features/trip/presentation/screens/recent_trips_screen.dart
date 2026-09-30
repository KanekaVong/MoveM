import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:movem/core/theme/app_colors.dart';
import 'package:movem/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:movem/features/trip/data/services/trip_service.dart';
import 'package:movem/features/trip/data/dto/response/trip_summary_response.dart';
import 'package:movem/features/trip/presentation/controllers/edit_trip_controller.dart';
import 'package:movem/features/trip/presentation/controllers/trip_controller.dart';
import 'package:movem/features/trip/presentation/screens/trip_detail_screen.dart';
import 'package:movem/l10n/app_localizations.dart';

enum TripSortOption {
  dateNewest,
  dateOldest,
  highestSpent,
}

class RecentTripScreen extends StatefulWidget {
  final TripController tripController;

  const RecentTripScreen({
    super.key,
    required this.tripController,
  });

  @override
  State<RecentTripScreen> createState() => _RecentTripScreenState();
}

class _RecentTripScreenState extends State<RecentTripScreen> {
  List<TripSummaryResponse> _trips = [];
  TripSortOption _currentSort = TripSortOption.dateNewest;
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTrips();
    });
  }

  Future<void> _loadTrips({
    bool showLoading = true,
  }) async {
    await widget.tripController.getMyTrips(
      showLoading: showLoading,
    );

    if (!mounted) return;

    setState(() {
      _trips = List.from(widget.tripController.recentTrips);
      _hasLoadedOnce = true;
    });

    _sortTrips(_currentSort);
  }

  void _sortTrips(TripSortOption option) {
    setState(() {
      _currentSort = option;

      switch (option) {
        case TripSortOption.dateNewest:
          _trips.sort(
                (a, b) => (b.startActivity ?? DateTime(0))
                .compareTo(a.startActivity ?? DateTime(0)),
          );
          break;

        case TripSortOption.dateOldest:
          _trips.sort(
                (a, b) => (a.startActivity ?? DateTime(0))
                .compareTo(b.startActivity ?? DateTime(0)),
          );
          break;

        case TripSortOption.highestSpent:
          _trips.sort(
                (a, b) => (b.totalSpent ?? 0.0)
                .compareTo(a.totalSpent ?? 0.0),
          );
          break;
      }
    });
  }

  String _formatCustomDate(
      DateTime? date,
      BuildContext context,
      ) {
    if (date == null) {
      return AppLocalizations.of(context)!.notAvailable;
    }

    final locale = Localizations.localeOf(context);

    return DateFormat(
      'MMMM | dd | yyyy',
      locale.languageCode,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                20,
                10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.05),
                      border: Border.all(
                        color: colorScheme.onSurface.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: colorScheme.onSurface,
                        size: 16,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Text(
                    l10n.recentTrips,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  PopupMenuButton<TripSortOption>(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.sortBy,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.70,
                            ),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorScheme.onSurface.withValues(
                            alpha: 0.70,
                          ),
                          size: 20,
                        ),
                      ],
                    ),
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: _sortTrips,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: TripSortOption.dateNewest,
                        child: Text(
                          l10n.newestDate,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TripSortOption.dateOldest,
                        child: Text(
                          l10n.oldestDate,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        value: TripSortOption.highestSpent,
                        child: Text(
                          l10n.highestSpent,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: !_hasLoadedOnce
                  ? const SizedBox.shrink()
                  : _trips.isEmpty
                  ? Center(
                child: Text(
                  l10n.noTripsYet,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(
                      alpha: 0.54,
                    ),
                    fontSize: 14,
                  ),
                ),
              )
                  : RefreshIndicator(
                color: colorScheme.primary,
                onRefresh: () => _loadTrips(
                  showLoading: false,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: _trips.length,
                  itemBuilder: (context, index) {
                    final trip = _trips[index];

                    return _TripCardItem(
                      trip: trip,
                      formatDate: (date) =>
                          _formatCustomDate(
                            date,
                            context,
                          ),
                      tripController:
                      widget.tripController,
                      onCoverPhotoChanged: () {
                        _loadTrips(
                          showLoading: false,
                        );
                      },
                      onTripUpdated: () {
                        _loadTrips(
                          showLoading: false,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripCardItem extends StatefulWidget {
  final TripSummaryResponse trip;
  final String Function(DateTime?) formatDate;
  final TripController tripController;
  final VoidCallback onCoverPhotoChanged;
  final VoidCallback onTripUpdated;

  const _TripCardItem({
    required this.trip,
    required this.formatDate,
    required this.tripController,
    required this.onCoverPhotoChanged,
    required this.onTripUpdated,
  });

  @override
  State<_TripCardItem> createState() => _TripCardItemState();
}

class _TripCardItemState extends State<_TripCardItem> {
  void _showCoverPhotoMenu() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasCoverPhoto =
        widget.trip.coverPhoto?.filePath != null &&
            widget.trip.coverPhoto!.filePath!.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(
                      alpha: 0.25,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  hasCoverPhoto
                      ? l10n.changeTripCover
                      : l10n.addTripCover,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    hasCoverPhoto
                        ? Icons.image_outlined
                        : Icons.add_photo_alternate_outlined,
                    color: colorScheme.onSurface,
                  ),
                  title: Text(
                    hasCoverPhoto
                        ? l10n.changeCurrentImage
                        : l10n.addTripCoverImage,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(bottomSheetContext);

                    final success = await widget.tripController
                        .pickAndUploadCoverPhoto(
                      widget.trip.activityId,
                    );

                    if (!mounted || !success) {
                      return;
                    }

                    widget.onCoverPhotoChanged();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurface.withValues(
                      alpha: isDark ? 0.55 : 0.50,
                    ),
                  ),
                  title: Text(
                    l10n.cancel,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(
                        alpha: isDark ? 0.55 : 0.50,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.trip;
    final l10n = AppLocalizations.of(context)!;

    final hasCoverPhoto =
        trip.coverPhoto?.filePath != null &&
            trip.coverPhoto!.filePath!.isNotEmpty;

    return Container(
      height: 145,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onLongPress: _showCoverPhotoMenu,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  hasCoverPhoto
                      ? Image.network(
                    trip.coverPhoto!.filePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/images/everest_bg.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/images/everest_bg.png',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.black.withValues(alpha: 0.45),
                          Colors.black.withValues(alpha: 0.20),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                trip.activityName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons
                                            .calendar_today_outlined,
                                        color: Colors.white70,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        widget.formatDate(
                                          trip.startActivity,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        l10n.membersCount(
                                          trip.memberCount ?? 0,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons
                                            .person_outline_rounded,
                                        color: Colors.white70,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                          BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.totalSpent(
                                          trip.totalSpent ?? 0,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(
                              alpha: 0.25,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TripDetailScreen(
                                        activityId:
                                        trip.activityId,
                                        editTripController:
                                        EditTripController(
                                          tripRepository:
                                          TripRepositoryImpl(
                                            tripService:
                                            TripService(),
                                          ),
                                          tripController:
                                          widget.tripController,
                                          activityId:
                                          trip.activityId,
                                        ),
                                      ),
                                ),
                              );

                              if (!mounted) return;

                              widget.onTripUpdated();
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}