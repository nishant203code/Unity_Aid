import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../widgets/theme/app_colors.dart';
import 'widgets/post_card.dart';

class NewsFeedPage extends StatelessWidget {
  final Function(String caseId)? onDonateTap;
  final bool isNGO;

  const NewsFeedPage({
    super.key,
    this.onDonateTap,
    this.isNGO = false, // ⭐ NEW
  });

  @override
  Widget build(BuildContext context) {
    final posts = [
      Post(
        userName: "Rahul Sharma",
        profilePic: "https://i.pravatar.cc/150?img=5",
        location: "Delhi",
        mediaUrls: [
          "https://images.unsplash.com/photo-1627398242454-45a1465c2479",
          "https://images.unsplash.com/photo-1593113598332-cd288d649433"
        ],
        caseTitle: "Car Accident Emergency",
        caseId: "UA10234",
        description:
            "Met with a severe accident last night. Need urgent financial help for surgeries.Met with a severe accident last night. Need urgent financial help for surgeries.Met with a severe accident last night. Need urgent financial help for surgeries.Met with a severe accident last night. Need urgent financial help for surgeries.",
        raised: 25000,
        goal: 50000,
        status: VerificationStatus.verified,
      ),
      Post(
        userName: "Anita Verma",
        profilePic: "https://i.pravatar.cc/150?img=8",
        location: "Mumbai",
        mediaUrls: [
          "https://images.unsplash.com/photo-1593113598332-cd288d649433"
        ],
        caseTitle: "House Fire Relief",
        caseId: "UA10290",
        description:
            "Lost our home in a fire accident. Any support would mean the world to us.Lost our home in a fire accident. Any support would mean the world to us.Lost our home in a fire accident. Any support would mean the world to us.Lost our home in a fire accident. Any support would mean the world to us.",
        raised: 40000,
        goal: 80000,
        status: VerificationStatus.falseCase,
      ),
    ];

    return Scaffold(
        backgroundColor: AppColors.background,

        /// UNITY AID TITLE
        appBar: AppBar(
          title: const Text(
            "UnityAid",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: false,
        ),
        body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: posts.length,
            itemBuilder: (_, index) => PostCard(
              post: posts[index],
              onDonateTap: onDonateTap,
              isNGO: isNGO,
            ),
          ),
        ));
  }
}
