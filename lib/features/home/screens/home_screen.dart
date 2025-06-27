import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../features/schemes/models/scheme_model.dart';
import '../../../features/schemes/services/scheme_service.dart';
import '../../schemes/screens/scheme_details_screen.dart';
import '../../../features/schemes/services/filter_service.dart';
import '../../../features/bookmarks/screens/bookmarks_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../features/admin/screens/admin_panel_screen.dart';
import '../../../features/profile/screens/user_info_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = SchemeService();
  final _filterService = FilterService();

  List<Scheme> _allSchemes = [];
  List<Scheme> _filteredSchemes = [];

  String _selectedState = 'Select State';
  String _selectedSector = 'Select Sector';
  String? _selectedEligibilityChip;

  final List<String> _states = ['Select State'];
  final List<String> _sectors = ['Select Sector'];
  List<String> _eligibilityChips = [];

  bool _filtersLoading = true;
  bool _checkingProfile = true;
  bool _showUserForm = false;
  bool _isAdmin = false;

  String userName = '';

  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUserProfile();
    _fetchUserName();
    _loadEligibilityChips();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        _isAdmin = data?['isAdmin'] == true;
      });
    }
  }

  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        userName = doc.data()?['name'] ?? 'Friend';
      });
    }
  }

  Future<void> _checkUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      setState(() {
        _showUserForm = true;
        _checkingProfile = false;
      });
    } else {
      await _initFilters();
      setState(() {
        _checkingProfile = false;
      });
    }
  }

  Future<void> _initFilters() async {
    final fetchedStates = await _filterService.getStates();
    final fetchedSectors = await _filterService.getSectors();

    final updatedStates = ['Select State', ...fetchedStates.where((s) => s != 'Select State')];
    final updatedSectors = ['Select Sector', ...fetchedSectors.where((s) => s != 'Select Sector')];

    setState(() {
      _states.clear();
      _sectors.clear();
      _states.addAll(updatedStates);
      _sectors.addAll(updatedSectors);

      _filtersLoading = false;
    });

    _loadSchemes();
  }

  Future<void> _loadSchemes() async {
    final data = await _service.fetchAllSchemes();
    setState(() {
      _allSchemes = data;
      _applyFilters();
    });
  }

  Future<void> _loadEligibilityChips() async {
    final doc = await FirebaseFirestore.instance.collection('filters').doc('options').get();
    final data = doc.data();
    if (data != null && data['eligibility'] != null) {
      final List<dynamic> rawList = data['eligibility'];
      setState(() {
        _eligibilityChips = List<String>.from(rawList);
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredSchemes = _allSchemes.where((scheme) {
        final stateMatch = (_selectedState == 'Select State' || scheme.state == _selectedState || scheme.state == 'All');
        final sectorMatch = (_selectedSector == 'Select Sector' || scheme.sector == _selectedSector);
        final eligibilityMatch = (_selectedEligibilityChip == null) ||
            (scheme.eligibility != null && scheme.eligibility.contains(_selectedEligibilityChip!));
        final searchMatch = _searchQuery.isEmpty ||
            scheme.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            scheme.description.toLowerCase().contains(_searchQuery.toLowerCase());

        return stateMatch && sectorMatch && eligibilityMatch && searchMatch;
      }).toList();
    });
  }

  Widget _buildChip(String label) {
    final bool isSelected = _selectedEligibilityChip == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.teal,
        backgroundColor: Colors.teal[100],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (selected) {
          setState(() {
            _selectedEligibilityChip = selected ? label : null;
            _applyFilters();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showUserForm) {
      return const UserInfoForm();
    }

    if (_filtersLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Namaste, $userName 👋"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => BookmarksScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSchemes,
          ),
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen()));
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search schemes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                            _applyFilters();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFilters();
                });
              },
            ),

            const SizedBox(height: 10),

            // Quick Eligibility Filter Chips + Reset Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quick Filters (Eligibility):",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedState = 'Select State';
                      _selectedSector = 'Select Sector';
                      _selectedEligibilityChip = null;
                      _searchQuery = '';
                      _searchController.clear();
                      _applyFilters();
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Reset Filters"),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _eligibilityChips.map((label) => _buildChip(label)).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Dropdown Filters Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("State", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedState,
                          isExpanded: true,
                          items: _states
                              .map((state) => DropdownMenuItem(
                                    value: state,
                                    child: Text(state),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedState = value);
                              _applyFilters();
                              FocusScope.of(context).requestFocus(FocusNode());  // THIS LINE clears the highlight
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Sector", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSector,
                        isExpanded: true,
                        items: _sectors
                            .map((sector) => DropdownMenuItem(
                                  value: sector,
                                  child: Text(sector),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedSector = value);
                            _applyFilters();
                            FocusScope.of(context).requestFocus(FocusNode());  // Clear highlight here too
                          }
                        },
                      ),
                    )

                    ],
                  ),
                ),
              ],
            ),

            const Divider(),

            // Schemes List
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _filteredSchemes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text("No schemes match your filters.",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      )
                    : ListView.builder(
                        key: ValueKey(_filteredSchemes.length),
                        itemCount: _filteredSchemes.length,
                        itemBuilder: (context, index) {
                          final scheme = _filteredSchemes[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: ListTile(
                              title: Text(
                                scheme.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                scheme.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        SchemeDetailsScreen(scheme: scheme),
                                    transitionsBuilder: (_, animation, __, child) {
                                      return FadeTransition(opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                            ),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
