import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class PhotoSliderBanner extends StatefulWidget {
  final List<String> photos;
  final double? height;

  const PhotoSliderBanner({super.key, required this.photos, this.height});

  @override
  State<PhotoSliderBanner> createState() => _PhotoSliderBannerState();
}

class _PhotoSliderBannerState extends State<PhotoSliderBanner> {
  var activeIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.photos.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl =
                "https://shyeyes-b.onrender.com/uploads/${widget.photos[index]}";
            return SizedBox(
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 50),
                  );
                },
              ),
            );
          },
          options: CarouselOptions(
            height: widget.height ?? 180,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              activeIndex.value = index;
            },
          ),
        ),

        // Pagination lines on top
        Positioned(
          top: 8,
          left: 16,
          right: 16,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.photos.length, (index) {
                bool isActive = index == activeIndex.value;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 3,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ],
    );
  }
}
