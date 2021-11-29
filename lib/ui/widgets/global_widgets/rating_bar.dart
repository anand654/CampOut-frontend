import 'package:flutter/material.dart';

class MyRatingBar extends StatelessWidget {
  const MyRatingBar({
    Key key,
    @required this.rating,
    this.color = Colors.black,
    this.iconSize = 20,
  }) : super(key: key);
  final double rating;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final int _stars = rating.toInt();
    final int _halfstars = rating > _stars ? 1 : 0;
    final int _nostars = 5 - _stars - _halfstars;
    return Container(
      child: Row(
        children: [
          ...stars(_stars, Icons.star, iconSize, color),
          ...stars(_halfstars, Icons.star_half, iconSize, color),
          ...stars(_nostars, Icons.star_outline, iconSize, color),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$rating',
            style: Theme.of(context).textTheme.bodyText2.copyWith(color: color),
          )
        ],
      ),
    );
  }

  List<Icon> stars(int rating, IconData icon, double sz, Color clr) {
    return List.generate(
      rating,
      (index) => Icon(
        icon,
        size: sz,
        color: clr,
      ),
    );
  }
}
