import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_screen.dart'; // Nhập trang login của bạn

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Khởi tạo VideoPlayerController từ assets
    _controller = VideoPlayerController.asset('assets/videos/mp4_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Tự động phát video khi vào trang
        });
      });

    // Lắng nghe khi video phát xong
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // Điều hướng sang trang login khi video kết thúc
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen()), // Thay LoginScreen bằng tên màn hình login của bạn
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width, // Chiều rộng full màn hình
                height: 600, // Có thể điều chỉnh chiều cao theo nhu cầu
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(), // Hiển thị loading khi video đang load
      ),
    );
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Giải phóng VideoPlayerController khi không cần thiết
    super.dispose();
  }
}
