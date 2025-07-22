import 'package:chesstrainer/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class Coach extends StatelessWidget {
  const Coach({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        spacing: 8,
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.brown,
            child: Image(
              image: AssetImage('assets/images/coach.png'),
              width: 28,
              height: 28,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Triangle pointer sur la gauche
                Positioned(
                  left: 0,
                  top: 12,
                  child: CustomPaint(
                    painter: BubbleTrianglePainter(
                      color: AppColors.primaryColor,
                    ),
                    size: const Size(8, 16),
                  ),
                ),
                // Container principal avec marge à gauche pour le triangle
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BubbleTrianglePainter extends CustomPainter {
  final Color color;

  BubbleTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Créer un triangle pointant vers la gauche
    path.moveTo(size.width, 0); // Point en haut à droite
    path.lineTo(0, size.height / 2); // Point à gauche (milieu)
    path.lineTo(size.width, size.height); // Point en bas à droite
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
