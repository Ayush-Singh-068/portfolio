import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../constants/app_constants.dart';

class AnimatedSection extends HookWidget {
  final Widget child;
  final String id;
  final double padding;

  const AnimatedSection({
    super.key,
    required this.child,
    required this.id,
    this.padding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = useState(0.0);
    final offset = useState(50.0);

    useEffect(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        opacity.value = 1.0;
        offset.value = 0.0;
      });
      return null;
    }, []);

    return AnimatedOpacity(
      opacity: opacity.value,
      duration: AppConstants.animationDuration,
      child: Transform.translate(
        offset: Offset(0, offset.value),
        child: AnimatedContainer(
          duration: AppConstants.animationDuration,
          curve: Curves.easeOut,
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      ),
    );
  }
}

