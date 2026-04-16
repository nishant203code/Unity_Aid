import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';
import '../../widgets/ngo_search/ngo_card.dart';
import '../../widgets/ngo_search/ngo_search_bar.dart';
import '../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class NGOSearchPage extends StatefulWidget {
  const NGOSearchPage({super.key});

  @override
  State<NGOSearchPage> createState() => _NGOSearchPageState();
}

class _NGOSearchPageState extends State<NGOSearchPage> {
  String selectedLocation = "Any";
  double minMembers = 0;
  double minFollowers = 0;
  final controller = TextEditingController();

  Position? userPosition;
  bool sortByLocation = true;

  @override
  void initState() {
    super.initState();
    filtered = ngos;
    _initializeLocation();
  }

  /// Initialize user location
  Future<void> _initializeLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (mounted) {
      setState(() {
        userPosition = position;
      });
      // Apply filters with new location for sorting
      applyFilters();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void applyFilters() {
    setState(() {
      filtered = ngos.where((ngo) {
        final matchesSearch =
            ngo.name.toLowerCase().contains(controller.text.toLowerCase());
        final matchesLocation =
            selectedLocation == "Any" || ngo.location == selectedLocation;
        final matchesMembers = ngo.members >= minMembers;
        final matchesFollowers = ngo.followers >= minFollowers;
        return matchesSearch &&
            matchesLocation &&
            matchesMembers &&
            matchesFollowers;
      }).toList();

      // Sort by distance if user location is available
      if (sortByLocation && userPosition != null) {
        filtered.sort((a, b) {
          final distanceA = LocationService.calculateDistance(
            userPosition!.latitude,
            userPosition!.longitude,
            a.latitude,
            a.longitude,
          );

          final distanceB = LocationService.calculateDistance(
            userPosition!.latitude,
            userPosition!.longitude,
            b.latitude,
            b.longitude,
          );

          return distanceA.compareTo(distanceB);
        });
      }
    });
  }

  /// TEMP DATA (replace with Firebase later)
  final List<NGO> ngos = [
    NGO(
      name: "Care Foundation",
      description: "Providing disaster relief and emergency aid.",
      location: "Delhi",
      latitude: 28.6139,
      longitude: 77.2090,
      logoUrl: "https://i.pravatar.cc/150?img=10",
      members: 120,
      followers: 5400,
    ),
    NGO(
      name: "HopeWorks",
      description: "Helping underprivileged communities thrive.",
      location: "Mumbai",
      latitude: 19.0760,
      longitude: 72.8777,
      logoUrl: "https://i.pravatar.cc/150?img=11",
      members: 80,
      followers: 3200,
    ),
  ];

  List<NGO> filtered = [];

  void search(String query) {
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      search(controller.text);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Search NGOs")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            NGOSearchBar(
              controller: controller,
              onFilterTap: openFilterSheet,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final ngo = filtered[index];
                  String? distanceText;

                  // Calculate distance if user location is available
                  if (userPosition != null && sortByLocation) {
                    final distance = LocationService.calculateDistance(
                      userPosition!.latitude,
                      userPosition!.longitude,
                      ngo.latitude,
                      ngo.longitude,
                    );
                    distanceText = LocationService.formatDistance(distance);
                  }

                  return NGOCard(
                    ngo: ngo,
                    distanceText: distanceText,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        String tempLocation = selectedLocation;
        double tempMembers = minMembers;
        double tempFollowers = minFollowers;
        bool tempSortByLocation = sortByLocation;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Indicator
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const Text(
                    "Refine Search",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SORT BY LOCATION TOGGLE
                  if (userPosition != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 8),
                              const Text(
                                "Sort by Nearest Location",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Switch(
                            value: tempSortByLocation,
                            onChanged: (val) {
                              setModalState(() {
                                tempSortByLocation = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                  if (userPosition != null) const SizedBox(height: 20),

                  /// LOCATION DROPDOWN
                  DropdownButtonFormField<String>(
                    initialValue: tempLocation,
                    items: ["Any", "Delhi", "Mumbai"]
                        .map(
                          (loc) => DropdownMenuItem(
                            value: loc,
                            child: Text(loc),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setModalState(() {
                        tempLocation = val!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MEMBERS SLIDER
                  Text("Minimum Members: ${tempMembers.toInt()}"),
                  Slider(
                    value: tempMembers,
                    max: 500,
                    divisions: 10,
                    onChanged: (val) {
                      setModalState(() {
                        tempMembers = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  /// FOLLOWERS SLIDER
                  Text("Minimum Followers: ${tempFollowers.toInt()}"),
                  Slider(
                    value: tempFollowers,
                    max: 10000,
                    divisions: 20,
                    onChanged: (val) {
                      setModalState(() {
                        tempFollowers = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  /// APPLY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedLocation = tempLocation;
                          minMembers = tempMembers;
                          minFollowers = tempFollowers;
                          sortByLocation = tempSortByLocation;
                        });
                        applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filters"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
