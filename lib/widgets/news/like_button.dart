import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/news/news_owner_services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class LikeButton extends StatefulWidget {
  final String beritaId;
  final bool isLiked;
  final int initialLikes;

  const LikeButton({
    Key? key,
    required this.beritaId,
    required this.isLiked,
    required this.initialLikes,
  }) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool _isLiked;
  late int _likesCount;
  bool _isLoading = false;

  final NewsOwnerServices _newsOwnerServices = NewsOwnerServices();

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likesCount = widget.initialLikes;
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Perbarui state jika properti widget berubah
    if (oldWidget.isLiked != widget.isLiked ||
        oldWidget.initialLikes != widget.initialLikes) {
      setState(() {
        _isLiked = widget.isLiked;
        _likesCount = widget.initialLikes;
      });
    }
  }

  void _handleLike() async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await _newsOwnerServices.toggleLike(request, widget.beritaId);

      final loggedIn = response['logged_in'] ?? false;
      final liked = response['liked'] ?? false;
      final likes = response['likes'] ?? _likesCount;

      if (!loggedIn) {
        Navigator.pushNamed(context, '/login');
      } else {
        setState(() {
          _isLiked = liked;
          _likesCount = likes;
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _handleLike,
      icon: Icon(
        _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
        color: Color(0xFF5F4D40),
      ),
      label: Text(
        '$_likesCount Likes',
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5F4D40),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _isLiked ? const Color(0xFFC4B09D) : const Color(0xFFE5D2B0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}
