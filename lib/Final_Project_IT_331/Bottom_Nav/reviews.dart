// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:TeaMax/Final_Project_IT_331/mainLogin.dart';
import 'package:TeaMax/Final_Project_IT_331/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Reviews extends StatefulWidget {
  const Reviews({super.key});

  @override
  State<Reviews> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<Reviews> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  final List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('reviews') ?? [];

    setState(() {
      _reviews.clear();
      _reviews.addAll(saved.map((e) => Review.fromJson(jsonDecode(e))));
    });
  }

  Future<void> _saveReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encoded =
        _reviews.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('reviews', encoded);
  }

  void _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please give a rating.')),
      );
      return;
    }

    final commentText = _commentController.text.trim();
    final prefs = await SharedPreferences.getInstance();

    final newReview = Review(
      username: currentUser?.username ?? 'Anonymous',
      comment: commentText, // empty is allowed
      rating: _rating,
      profilePicPath: currentUser?.profilePicture?.path,
    );

    setState(() {
      _reviews.add(newReview);
      _rating = 0;
      _commentController.clear();
    });

    final updatedJsonList =
        _reviews.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('saved_reviews', updatedJsonList);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted.')),
    );

    _saveReviews();
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            Icons.star,
            color: _rating >= starIndex ? deepBrownHeader : Colors.grey,
          ),
          onPressed: () => setState(() => _rating = starIndex.toDouble()),
        );
      }),
    );
  }

  Widget _buildReviewTile(Review review) {
    final profileImage = review.profilePicPath != null
        ? FileImage(File(review.profilePicPath!))
        : const AssetImage('assets/default_user.png') as ImageProvider;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: profileImage,
          radius: 22,
        ),
        title: Text(
          review.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: deepBrownHeader,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(review.comment),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: teaMaxBrown,
        elevation: 0,
        title: const Text(
          'Customer Reviews',
          style: TextStyle(
            fontFamily: 'EBGaramond-Medium',
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ Rating Stars
              Center(
                child: Column(
                  children: [
                    const Text(
                      'How was your tea?',
                      style: TextStyle(
                        fontFamily: 'EBGaramond-Medium',
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStarRating(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 💬 Comment Box
              TextField(
                controller: _commentController,
                maxLines: 4,
                style: const TextStyle(fontFamily: 'EBGaramond-Medium'),
                decoration: InputDecoration(
                  hintText: 'Leave a review...',
                  hintStyle: const TextStyle(
                      fontFamily: 'tea_max', color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🚀 Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 227, 207, 160),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Submit Review',
                    style: TextStyle(
                      fontFamily: 'EBGaramond-Medium',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'What others are saying:',
                style: TextStyle(
                  fontFamily: 'EBGaramond-Medium',
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 12),

              // 📋 Review List
              _reviews.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'No reviews yet.',
                          style: TextStyle(fontFamily: 'EBGaramond-Medium'),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reviews.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) =>
                          _buildReviewTile(_reviews[index]),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Review {
  final double rating;
  final String comment;
  final String username;
  final String? profilePicPath;

  Review({
    required this.rating,
    required this.comment,
    required this.username,
    this.profilePicPath,
  });

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        'username': username,
        'profilePicPath': profilePicPath,
      };

  static Review fromJson(Map<String, dynamic> json) => Review(
        rating: json['rating'],
        comment: json['comment'],
        username: json['username'],
        profilePicPath: json['profilePicPath'],
      );
}
