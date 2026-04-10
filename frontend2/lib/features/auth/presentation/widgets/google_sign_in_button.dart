import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsly/l10n/app_localizations.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: () =>
          context.read<AuthBloc>().add(const SignInWithGoogleEvent()),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: cs.onSurface.withValues(alpha: 0.3)),
        foregroundColor: cs.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GoogleLogo(),
          const SizedBox(width: 12),
          Text(
            l10n.signInWithGoogle,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Draw colored arcs (simplified Google "G" logo using quadrants)
    final colors = [
      const Color(0xFF4285F4), // blue  (top-right)
      const Color(0xFF34A853), // green (bottom-right)
      const Color(0xFFFBBC05), // yellow (bottom-left)
      const Color(0xFFEA4335), // red   (top-left)
    ];

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      final startAngle = (i * 90 - 45) * 3.14159 / 180;
      final sweepAngle = 90 * 3.14159 / 180;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }

    // White inner circle to create ring effect
    paint.color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r * 0.55, paint);

    // White notch for the "G" right bar
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.2, r, r * 0.4),
      paint,
    );

    // Re-draw inner white circle
    paint.color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r * 0.55, paint);
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter oldDelegate) => false;
}
