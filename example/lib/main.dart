import 'package:draggable_carousel_slider/draggable_carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Widget _image(
    String path,
    double width,
    double height, [
    bool shimmer = false,
  ]) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          path,
          width: width,
          height: height,
          fit: BoxFit.cover,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) => AnimatedCrossFade(
              firstChild: child,
              secondChild: Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade700,
                enabled: true,
                period: const Duration(seconds: 2),
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.black,
                ),
              ),
              crossFadeState: shimmer ||
                      ((child as Semantics).child as RawImage).image == null
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: DraggableSlider(
                loop: true,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade400,
                    ),
                    width: 300,
                    height: 300,
                    child: const Center(child: Text("1"),)
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade400,
                      ),
                      width: 300,
                      height: 300,
                      child: const Center(child: Text("2"),)
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade400,
                      ),
                      width: 300,
                      height: 300,
                      child: const Center(child: Text("3"),)
                  ),

                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade400,
                      ),
                      width: 300,
                      height: 300,
                      child: const Center(child: Text("4"),)
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade400,
                      ),
                      width: 300,
                      height: 300,
                      child: const Center(child: Text("5"),)
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade400,
                      ),
                      width: 300,
                      height: 300,
                      child: const Center(child: Text("6"),)
                  ),
                  // _image('https://picsum.photos/id/230/600/600', 300, 300),
                  // _image(
                  //     'https://picsum.photos/id/431/600/600', 300, 300, true),
                  // _image('https://picsum.photos/id/232/600/600', 300, 300),
                  // _image('https://picsum.photos/id/433/600/600', 300, 300),
                  // _image('https://picsum.photos/id/234/600/600', 300, 300),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
