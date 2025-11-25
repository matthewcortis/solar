import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CustomerFeedbackCard extends StatefulWidget {
  final String title;        // tiêu đề
  final String content;      // nội dung text
  final String mediaAsset;   // ảnh hoặc video
  final bool isVideo;        // true nếu là video
  final String caption;      // chú thích ảnh/video

  const CustomerFeedbackCard({
    super.key,
    required this.title,
    required this.content,
    required this.mediaAsset,
    required this.caption,
    this.isVideo = false,
  });

  @override
  State<CustomerFeedbackCard> createState() => _CustomerFeedbackCardState();
}

class _CustomerFeedbackCardState extends State<CustomerFeedbackCard> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset(widget.mediaAsset);
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFFEE4037), // màu thanh tua chính
        handleColor: Colors.white,
        backgroundColor: Colors.grey.shade400,
        bufferedColor: Colors.grey.shade300,
      ),
      errorBuilder: (context, errorMessage) => Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(vertical: scale(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Tiêu đề =====
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600, // Semibold
              fontSize: scale(16),
              height: 1.5,
              color: const Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(12)),

          // ===== Nội dung =====
          Text(
            widget.content,
            style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w400,
              fontSize: scale(14),
              height: 1.6,
              color: const Color(0xFF4F4F4F),
            ),
          ),
          SizedBox(height: scale(12)),

          // ===== Ảnh hoặc Video =====
          ClipRRect(
            borderRadius: BorderRadius.circular(scale(20)),
            child: Container(
              width: scale(398),
              height: scale(190),
              color: Colors.black,
              child: widget.isVideo
                  ? (_chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized)
                      ? Chewie(controller: _chewieController!)
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFEE4037),
                          ),
                        )
                  : Image.asset(
                      widget.mediaAsset,
                      width: scale(398),
                      height: scale(190),
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          SizedBox(height: scale(8)),

          // ===== Caption ảnh/video =====
          SizedBox(
            width: scale(398),
            child: Text(
              widget.caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SFProDisplay',
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                fontSize: scale(12),
                height: 1.5,
                color: const Color(0xFF4F4F4F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
