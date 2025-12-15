import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String? title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _hasError = false;
  String _errorMessage = '';
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _videoController!.initialize();

      if (!mounted) return;

      _totalDuration = _videoController!.value.duration;

      _videoController!.addListener(_videoListener);

      setState(() {
        _isInitialized = true;
        _hasError = false;
      });

      // Auto play
      _videoController!.play();

      // Auto hide controls after 3 seconds
      _startHideControlsTimer();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = "Failed to load video. Please check your connection.";
      });
      print("Video initialization error: $e");
    }
  }

  void _videoListener() {
    if (!mounted || _videoController == null) return;

    final value = _videoController!.value;

    setState(() {
      _currentPosition = value.position;
      _isPlaying = value.isPlaying;
    });

    // Check for errors
    if (value.hasError) {
      setState(() {
        _hasError = true;
        _errorMessage = value.errorDescription ?? "Video playback error";
      });
    }

    // Auto replay or show controls when video ends
    if (_currentPosition >= _totalDuration && _totalDuration.inSeconds > 0) {
      setState(() {
        _showControls = true;
      });
    }
  }

  void _startHideControlsTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  void _togglePlayPause() {
    if (_videoController == null) return;

    setState(() {
      if (_isPlaying) {
        _videoController!.pause();
      } else {
        // If video ended, restart from beginning
        if (_currentPosition >= _totalDuration) {
          _videoController!.seekTo(Duration.zero);
        }
        _videoController!.play();
        _startHideControlsTimer();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls && _isPlaying) {
      _startHideControlsTimer();
    }
  }

  void _seekForward() {
    if (_videoController == null) return;
    final newPosition = _currentPosition + const Duration(seconds: 10);
    _videoController!.seekTo(
      newPosition > _totalDuration ? _totalDuration : newPosition,
    );
  }

  void _seekBackward() {
    if (_videoController == null) return;
    final newPosition = _currentPosition - const Duration(seconds: 10);
    _videoController!.seekTo(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  void _retryVideo() {
    setState(() {
      _hasError = false;
      _isInitialized = false;
    });
    _videoController?.dispose();
    _initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player or Error/Loading
            GestureDetector(
              onTap: _toggleControls,
              onDoubleTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                if (details.globalPosition.dx < screenWidth / 2) {
                  _seekBackward();
                } else {
                  _seekForward();
                }
              },
              child: Center(
                child: _buildVideoContent(),
              ),
            ),

            // Controls Overlay
            if (_showControls && !_hasError) ...[
              // Top Bar
              _buildTopBar(),

              // Center Controls
              if (_isInitialized) _buildCenterControls(),

              // Bottom Controls
              if (_isInitialized) _buildBottomControls(),
            ],

            // Always show back button on error
            if (_hasError) _buildTopBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) {
      return _buildErrorWidget();
    }

    if (!_isInitialized) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF4EFFEE),
          ),
          SizedBox(height: 16.h),
          Text(
            "Loading video...",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.withOpacity(0.7),
            size: 60.w,
          ),
          SizedBox(height: 16.h),
          Text(
            _errorMessage,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: _retryVideo,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 32.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF4EFFEE),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "Retry",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                widget.title ?? "Playing Video",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls() {
    return Positioned.fill(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rewind 10s
            GestureDetector(
              onTap: _seekBackward,
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Icon(
                  Icons.replay_10,
                  color: Colors.white,
                  size: 28.w,
                ),
              ),
            ),

            SizedBox(width: 32.w),

            // Play/Pause
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 40.w,
                ),
              ),
            ),

            SizedBox(width: 32.w),

            // Forward 10s
            GestureDetector(
              onTap: _seekForward,
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Icon(
                  Icons.forward_10,
                  color: Colors.white,
                  size: 28.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 20.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress Bar
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF4EFFEE),
                inactiveTrackColor: Colors.white.withOpacity(0.3),
                thumbColor: const Color(0xFF4EFFEE),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 6.r,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 12.r,
                ),
                trackHeight: 3.h,
              ),
              child: Slider(
                value: _currentPosition.inMilliseconds
                    .clamp(0, _totalDuration.inMilliseconds)
                    .toDouble(),
                min: 0,
                max: _totalDuration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  _videoController?.seekTo(
                    Duration(milliseconds: value.toInt()),
                  );
                },
                onChangeStart: (_) {
                  _videoController?.pause();
                },
                onChangeEnd: (_) {
                  _videoController?.play();
                },
              ),
            ),

            SizedBox(height: 8.h),

            // Time Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  _formatDuration(_totalDuration),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}