import 'package:flutter/material.dart';

class AnimationUtils {
  static const int transitionSpeed = 500; //ms

  static Route<T> slideBTWithFade<T>(Widget screen) {
    const begin = Offset(0.0, 1.0);
    const end = Offset(0.0, 0.0);
    return _slideWithFade(screen, begin, end);
  }

  static Route<T> slideTBWithFade<T>(Widget screen) {
    const begin = Offset(0.0, -1.0);
    const end = Offset(0.0, 0.0);
    return _slideWithFade(screen, begin, end);
  }

  static Route<T> scaleWithFade<T>(Widget screen) {
    const begin = 0.0; // Start from top
    const end = 1.0; // Move to normal position
    return _scaleWithFade(screen, begin, end);
  }
  
  static Route<T> rotate<T>(Widget screen) {
    const begin = 0.25; 
    const end = 0.0; 
    return _rotate(screen, begin, end);
  }

  static Route<T> rotateWithFade<T>(Widget screen) {
    const begin = 0.25; 
    const end = 0.0; 
    return _rotateWithFade(screen, begin, end);
  }

  static Route<T> _scaleWithFade<T>(
      Widget screen, double begin, double end) {
    return PageRouteBuilder<T>(
      transitionDuration:
          const Duration(milliseconds: transitionSpeed), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var scale = Tween<double>(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        var fade = Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut));
        return ScaleTransition(
          scale: animation.drive(scale),
          child: FadeTransition(
            opacity: animation.drive(fade), 
            child: child
          ),
        );
      },
    );
  }

  static Route<T> _slideWithFade<T>(
      Widget screen, Offset begin, Offset end) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: transitionSpeed), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var slide = Tween<Offset>(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        var fade = Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(slide),
          child: FadeTransition(
            opacity: animation.drive(fade), 
            child: child
          ),
        );
      },
    );
  }

  static Route<T> _rotate<T>(Widget screen, double begin, double end) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: transitionSpeed), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var rotate = Tween<double>(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        return RotationTransition(
          turns: animation.drive(rotate),
          child: child,
        );
      },
    );
  }

  static Route<T> _rotateWithFade<T>(Widget screen, double begin, double end) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: transitionSpeed), // Animation speed
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var rotate = Tween<double>(begin: begin, end: end)
            .chain(CurveTween(curve: Curves.easeInOut));
        var fade = Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut));
        return RotationTransition(
          turns: animation.drive(rotate),
          child: FadeTransition(
            opacity: animation.drive(fade), 
            child: child
          ),
        );
      },
    );
  }





  ////
  /// Slide given screen from top to a fixed height (not fullscreen)
  ///
  // static Route<T> fromBottomHalfScreen<T>(Widget screen,
  //     {double maxHeightFactor = 0.5}) {
  //   return PageRouteBuilder<T>(
  //     opaque: false, // Allows previous screen to be visible
  //     transitionDuration: const Duration(milliseconds: transitionSpeed),
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return GestureDetector(
  //         onTap: () => Navigator.pop(context), // Close when tapping outside
  //         child: Scaffold(
  //           // ignore: deprecated_member_use
  //           backgroundColor: Colors.black.withOpacity(0.5), // Semi-transparent overlay
  //           body: Align(
  //             alignment: Alignment.bottomCenter,
  //             child: FractionallySizedBox(
  //               widthFactor: 1, // Full width
  //               heightFactor: maxHeightFactor, // Customizable height
  //               child: Material(
  //                 color: Colors.white,
  //                 borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
  //                 child: screen, // Embed your custom content
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
  //           .chain(CurveTween(curve: Curves.easeInOut));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }
}
