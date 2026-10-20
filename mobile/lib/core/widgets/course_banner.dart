import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../theme/course_themes.dart';
import '../theme/tokens.dart';

/// Latar header kelas: warna tema + pola geometris 12% di 40% sisi kanan,
/// memudar sebelum area teks (docs/design.md, Aturan pola).
class CourseBanner extends StatelessWidget {
  const CourseBanner({super.key, required this.themeKey, this.child, this.borderRadius});

  final String themeKey;
  final Widget? child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = CourseTheme.of(themeKey);
    final color = theme.headerFor(Theme.of(context).brightness);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: ColoredBox(
        color: color,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: ExcludeSemantics(
                child: ShaderMask(
                  // Pola memudar ke kiri agar tidak pernah berada di belakang teks.
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    stops: [0, 0.75, 1],
                    colors: [Colors.white, Colors.white, Colors.transparent],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerRight,
                    widthFactor: Sizes.patternWidthFactor,
                    child: CustomPaint(
                      painter: _PatternPainter(theme.pattern, theme.onHeader.withValues(alpha: Sizes.patternOpacity)),
                    ),
                  ),
                ),
              ),
            ),
            ?child,
          ],
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  _PatternPainter(this.pattern, this.color);

  final CoursePattern pattern;
  final Color color;

  static const double _cell = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (var y = 0.0; y < size.height + _cell; y += _cell) {
      for (var x = 0.0; x < size.width + _cell; x += _cell) {
        final odd = ((x + y) / _cell).round().isOdd;
        final c = Offset(x + (odd ? _cell / 2 : 0), y);
        switch (pattern) {
          case CoursePattern.dots:
            canvas.drawCircle(c, 3, fill);
          case CoursePattern.circles:
            canvas.drawCircle(c, 8, stroke);
          case CoursePattern.waves:
            final path = Path()..moveTo(x, y);
            path.quadraticBezierTo(x + _cell / 4, y - 6, x + _cell / 2, y);
            path.quadraticBezierTo(x + 3 * _cell / 4, y + 6, x + _cell, y);
            canvas.drawPath(path, stroke);
          case CoursePattern.diagonals:
            canvas.drawLine(Offset(x, y + _cell), Offset(x + _cell, y), stroke);
          case CoursePattern.triangles:
            canvas.drawPath(
              Path()
                ..moveTo(c.dx, c.dy - 7)
                ..lineTo(c.dx + 7, c.dy + 6)
                ..lineTo(c.dx - 7, c.dy + 6)
                ..close(),
              fill,
            );
          case CoursePattern.stars:
            canvas.drawPath(_star(c, 7), fill);
          case CoursePattern.sun:
            canvas.drawCircle(c, 4, fill);
            for (var i = 0; i < 8; i++) {
              final a = i * math.pi / 4;
              canvas.drawLine(c + Offset.fromDirection(a, 7), c + Offset.fromDirection(a, 11), stroke);
            }
          case CoursePattern.leaves:
            canvas.save();
            canvas.translate(c.dx, c.dy);
            canvas.rotate(odd ? 0.6 : -0.6);
            canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 8, height: 18), fill);
            canvas.restore();
        }
      }
    }
  }

  Path _star(Offset c, double r) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? r : r * 0.45;
      final p = c + Offset.fromDirection(-math.pi / 2 + i * math.pi / 5, radius);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_PatternPainter old) => old.pattern != pattern || old.color != color;
}
