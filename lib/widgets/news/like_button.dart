import 'package:flutter/material.dart';
import 'package:uas/services/news/news_owner_services.dart';

class LikeButton extends StatefulWidget {
  final String beritaId; // ID berita
  final bool isLiked; // Apakah sudah di-like
  final int initialLikes; // Jumlah likes awal

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
  bool _isLoading = false; // Status loading

  final NewsOwnerServices _newsOwnerServices = NewsOwnerServices();

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likesCount = widget.initialLikes;
  }

  void _handleLike() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _newsOwnerServices.toggleLike(widget.beritaId);

      if (response['status'] == false) {
        // Jika user tidak login, arahkan ke login page
        Navigator.pushNamed(context, '/login');
      } else {
        setState(() {
          _isLiked = response['liked'];
          _likesCount = response['likes'];
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


// import 'package:flutter/material.dart';

// class LikeButton extends StatefulWidget {
//   final bool isLiked; // State awal, apakah sudah di-like atau belum
//   final VoidCallback onLike; // Callback untuk aksi like
//   const LikeButton({Key? key, required this.isLiked, required this.onLike})
//       : super(key: key);

//   @override
//   _LikeButtonState createState() => _LikeButtonState();
// }

// class _LikeButtonState extends State<LikeButton> {
//   bool _isHovered = false; // Untuk efek hover
//   late bool _isLiked;

//   @override
//   void initState() {
//     super.initState();
//     _isLiked = widget.isLiked; // Set state awal
//   }

//   void _toggleLike() {
//     setState(() {
//       _isLiked = !_isLiked; // Toggle state liked
//     });
//     widget.onLike(); // Panggil callback untuk aksi like
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) {
//         setState(() {
//           _isHovered = true; // Aktifkan hover
//         });
//       },
//       onExit: (_) {
//         setState(() {
//           _isHovered = false; // Nonaktifkan hover
//         });
//       },
//       child: ElevatedButton.icon(
//         onPressed: _toggleLike,
//         icon: Icon(
//           _isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
//           color: Color(0xFF5F4D40),
//         ),
//         label: Text(
//           _isLiked ? "Liked" : "Like",
//           style: const TextStyle(
//             fontSize: 16,
//             fontStyle: FontStyle.normal,
//             fontWeight: FontWeight.w500,
//             height: 1.4,
//             color: Color(0xFF5F4D40),
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: _isHovered
//               ? (_isLiked ? const Color(0xFFDECDBE) : const Color(0xFFE8D7C0))
//               : (_isLiked ? const Color(0xFFC4B09D) : const Color(0xFFE5D2B0)),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(40),
//           ),
//         ),
//       ),
//     );
//   }
// }
