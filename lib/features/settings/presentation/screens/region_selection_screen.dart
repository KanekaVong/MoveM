import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class RegionSelectionScreen extends StatefulWidget {
  final String? currentRegion;

  const RegionSelectionScreen({
    super.key,
    this.currentRegion,
  });

  @override
  State<RegionSelectionScreen> createState() =>
      _RegionSelectionScreenState();
}

class _RegionSelectionScreenState
    extends State<RegionSelectionScreen> {
  List<Map<String, dynamic>> _countries = [];

  List<String> _countryNames = [];
  List<String> _regionNames = [];

  String? _selectedCountry;
  String? _selectedRegion;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json',
      );

      final List<dynamic> data = jsonDecode(jsonString);

      _countries = data
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
      )
          .toList();

      _countryNames = _countries
          .map((country) => country['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      // Default country.
      _selectedCountry = 'Cambodia';

      _loadRegionsForCountry(_selectedCountry!);

      // Try to restore existing region.
      if (widget.currentRegion != null &&
          widget.currentRegion!.trim().isNotEmpty &&
          _regionNames.contains(widget.currentRegion)) {
        _selectedRegion = widget.currentRegion;
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load location data: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadRegionsForCountry(String countryName) {
    final country = _countries.cast<Map<String, dynamic>?>().firstWhere(
          (item) => item?['name']?.toString() == countryName,
      orElse: () => null,
    );

    if (country == null) {
      _regionNames = [];
      _selectedRegion = null;
      return;
    }

    final states = country['state'];

    if (states is! List) {
      _regionNames = [];
      _selectedRegion = null;
      return;
    }

    _regionNames = states
        .whereType<Map>()
        .map((state) => state['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    if (!_regionNames.contains(_selectedRegion)) {
      _selectedRegion = null;
    }
  }

  String _countryDisplayName(String countryName) {
    final country = _countries.cast<Map<String, dynamic>?>().firstWhere(
          (item) => item?['name']?.toString() == countryName,
      orElse: () => null,
    );

    if (country == null) {
      return countryName;
    }

    final emoji = country['emoji']?.toString();

    if (emoji == null || emoji.isEmpty) {
      return countryName;
    }

    return '$emoji  $countryName';
  }

  Color _cardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? const Color(0xFF162341).withValues(alpha: 0.65)
        : Colors.white;
  }

  Color _borderColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.10);
  }

  Color _primaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? Colors.white
        : const Color(0xFF0F172A);
  }

  Color _secondaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? const Color(0xFFA0AAB2)
        : const Color(0xFF64748B);
  }

  Color _fieldColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? const Color(0xFF162341)
        : const Color(0xFFF8FAFC);
  }

  Color _popupColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? const Color(0xFF162341)
        : Colors.white;
  }

  InputDecoration _inputDecoration(
      BuildContext context,
      String hint,
      ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: _secondaryTextColor(context),
        fontSize: 14,
      ),
      filled: true,
      fillColor: _fieldColor(context),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: _borderColor(context),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: _borderColor(context),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF3B82F6),
          width: 1.2,
        ),
      ),
    );
  }

  Widget _buildPicker<T>({
    required BuildContext context,
    required String hint,
    required List<T> items,
    required T? selectedItem,
    required ValueChanged<T?> onSelected,
    required String Function(T) itemAsString,
    required String searchHint,
    required bool enabled,
  }) {
    return DropdownSearch<T>(
      items: (filter, loadProps) => items,
      selectedItem: selectedItem,
      enabled: enabled,
      itemAsString: itemAsString,
      compareFn: (a, b) => a == b,
      onSelected: onSelected,
      popupProps: PopupProps<T>.menu(
        showSearchBox: true,
        showSelectedItems: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: TextStyle(
              color: _secondaryTextColor(context),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: _secondaryTextColor(context),
            ),
            filled: true,
            fillColor: _fieldColor(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _borderColor(context),
              ),
            ),
          ),
          style: TextStyle(
            color: _primaryTextColor(context),
          ),
        ),
        menuProps: MenuProps(
          backgroundColor: _popupColor(context),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: _inputDecoration(
          context,
          hint,
        ),
      ),
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null) {
          return Text(
            hint,
            style: TextStyle(
              color: _secondaryTextColor(context),
              fontSize: 14,
            ),
          );
        }

        return Text(
          itemAsString(selectedItem),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _primaryTextColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: _primaryTextColor(context),
            size: 18,
          ),
        ),
        title: Text(
          'Region',
          style: TextStyle(
            color: _primaryTextColor(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF3B82F6),
          ),
        )
            : Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            24,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your region',
                style: TextStyle(
                  color: _primaryTextColor(context),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Select your country and province, state, or region.',
                style: TextStyle(
                  color: _secondaryTextColor(context),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _cardColor(context),
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color: _borderColor(context),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Country',
                      style: TextStyle(
                        color: _primaryTextColor(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _buildPicker<String>(
                      context: context,
                      hint: 'Select country',
                      items: _countryNames,
                      selectedItem: _selectedCountry,
                      searchHint: 'Search country...',
                      enabled: true,
                      itemAsString: (country) =>
                          _countryDisplayName(country),
                      onSelected: (country) {
                        if (country == null) {
                          return;
                        }

                        setState(() {
                          _selectedCountry = country;
                          _selectedRegion = null;
                          _loadRegionsForCountry(country);
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Region / State / Province',
                      style: TextStyle(
                        color: _primaryTextColor(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _buildPicker<String>(
                      context: context,
                      hint: 'Select region',
                      items: _regionNames,
                      selectedItem: _selectedRegion,
                      searchHint: 'Search region...',
                      enabled: _selectedCountry != null &&
                          _regionNames.isNotEmpty,
                      itemAsString: (region) => region,
                      onSelected: (region) {
                        setState(() {
                          _selectedRegion = region;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedRegion == null ||
                      _selectedRegion!
                          .trim()
                          .isEmpty
                      ? null
                      : () {
                    Navigator.of(context).pop(
                      _selectedRegion!.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF3B82F6),
                    disabledBackgroundColor: isDark
                        ? const Color(0xFF263657)
                        : const Color(0xFFE2E8F0),
                    foregroundColor: Colors.white,
                    disabledForegroundColor:
                    isDark
                        ? const Color(0xFF68758C)
                        : const Color(0xFF94A3B8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}