import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.imagePath, required this.name});

  final String imagePath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blue, // Set the border color
                width: 4, // Set the border width
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5), // Set the shadow color
                  blurRadius: 5, // Set the blur radius
                  spreadRadius: 2, // Set the spread radius
                  offset: const Offset(0, 2), // Set the shadow offset
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imagePath),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
