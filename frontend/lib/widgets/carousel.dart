import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/widgets/card.dart';

class CustomImageCarousel extends StatefulWidget {
  final List<CardItem> slides;

  const CustomImageCarousel({
    Key? key,
    required this.slides,
  }) : super(key: key);

  @override
  _CustomImageCarouselState createState() => _CustomImageCarouselState();
}

class _CustomImageCarouselState extends State<CustomImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[800],
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "TWOJE ŚCIEŻKI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CarouselSlider.builder(
            itemCount: widget.slides.length,
            itemBuilder: (context, index, realIndex) {
              final slide = widget.slides[index];
              return CardItem(
                imageUrl: slide.imageUrl,
                text: slide.text,
                backgroundColor: slide.backgroundColor,
              );
            },
            options: CarouselOptions(
              height: 250,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              viewportFraction: 0.75,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildCustomIndicator(),
        ],
      ),
    );
  }

  Widget _buildCustomIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.slides.asMap().entries.map((entry) {
        int index = entry.key;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: _currentIndex == index ? 16 : 8,
          height: 8,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
            color: _currentIndex == index ? Colors.orange : Colors.white,
          ),
        );
      }).toList(),
    );
  }
}