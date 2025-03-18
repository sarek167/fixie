import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/card.dart';


class ExpandableCardGrid extends StatefulWidget {
  final String title;
  final List<CardItem> initialCards;

  const ExpandableCardGrid({
    super.key,
    required this.title,
    required this.initialCards,
  });

  @override
  _ExpandableCardGridState createState() => _ExpandableCardGridState();
}

class _ExpandableCardGridState extends State<ExpandableCardGrid>{
  List<CardItem> displayedCards = [];
  bool isLoading = false;
  bool showMoreButton = true;

  @override
  void initState() {
    super.initState();
    displayedCards = List.from(widget.initialCards);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title.toUpperCase(),
            style: TextStyle(
              color: ColorConstants.whiteColor,
              fontSize: FontConstants.headerFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1
            ),
            itemCount: displayedCards.length,
            itemBuilder: (context, index) {
              return displayedCards[index];
            },
          ),
          const SizedBox(height: 20),
          if (showMoreButton)
            CustomButton(text: "WIĘCEJ", onPressed: ()=>{}),
          const SizedBox(height: 20),
        ]
      )
    );
  }
}