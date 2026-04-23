import 'package:flutter/material.dart';
import '../models/pet.dart';

class ComparisonTab extends StatefulWidget {
  final List<Pet> pokedex;
  final Color accentColor;

  const ComparisonTab({
    super.key,
    required this.pokedex,
    required this.accentColor,
  });

  @override
  State<ComparisonTab> createState() => _ComparisonTabState();
}

class _ComparisonTabState extends State<ComparisonTab> {


  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D),
        borderRadius: BorderRadius.all(Radius.circular(35)),
      ),
      
    );
  }

}