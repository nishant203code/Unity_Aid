import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';
import '../../widgets/theme/app_colors.dart';
import '../../widgets/ngo_search/ngo_card.dart';
import '../../widgets/ngo_search/ngo_search_bar.dart';

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
    });
  }

  /// TEMP DATA (replace with Firebase later)
  final List<NGO> ngos = [
    NGO(
      name: "Care Foundation",
      description: "Providing disaster relief and emergency aid.",
      location: "Delhi",
      logoUrl: "https://i.pravatar.cc/150?img=10",
      members: 120,
      followers: 5400,
    ),
    NGO(
      name: "HopeWorks",
      description: "Helping underprivileged communities thrive.",
      location: "Mumbai",
      logoUrl: "https://i.pravatar.cc/150?img=11",
      members: 80,
      followers: 3200,
    ),
  ];

  List<NGO> filtered = [];

  @override
  void initState() {
    filtered = ngos;
    super.initState();
  }

  void search(String query) {
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      search(controller.text);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
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
                  return NGOCard(ngo: filtered[index]);
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
                      color: Colors.grey[300],
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

                  /// LOCATION DROPDOWN
                  DropdownButtonFormField<String>(
                    value: tempLocation,
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
