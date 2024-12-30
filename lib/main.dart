import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sliderValue = 6.0;
  final Color _activeColor = const Color.fromARGB(255, 157, 0, 255);
  
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfSliderTheme(
          data: SfSliderThemeData(
              activeTrackHeight: 18,
              inactiveTrackHeight: 18,
              activeTrackColor: _activeColor.withOpacity(0.5),
              inactiveTrackColor: _activeColor.withOpacity(0.1),
              overlayColor: _activeColor.withOpacity(0.1),
              overlayRadius: 35),
          child: SfSlider(
            max: 10.0,
            interval: 1,
            showDividers: true,
            value: _sliderValue,
            onChanged: (dynamic newValue) {
              setState(() {
                if(newValue <= _sliderValue){
                  _active = true;
                } else{
                  _active = false;
                }
                _sliderValue = newValue;
              });
            },
            dividerShape: _DividerShape(_activeColor),
            thumbShape: _ThumbShape(_activeColor, _active),
          ),
        ),
      ),
    );
  }
}

class _DividerShape extends SfDividerShape {
  final Color _activeColor;

  _DividerShape(this._activeColor);

  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
        isActive = center.dx <= thumbCenter!.dx;
        break;
      case TextDirection.rtl:
        isActive = center.dx >= thumbCenter!.dx;
    }

    Path innerPath = Path()
      ..moveTo(center.dx, center.dy - 7)
      ..lineTo(center.dx + 7, center.dy)
      ..lineTo(center.dx, center.dy + 7)
      ..lineTo(center.dx - 7, center.dy)
      ..close();

    context.canvas.drawPath(
        innerPath,
        Paint()
          ..color = isActive ? _activeColor : Colors.white
          ..style = PaintingStyle.fill);
  }
}

class _ThumbShape extends SfThumbShape {
  final Color _activeColor;
  final bool _active;

  _ThumbShape(this._activeColor, this._active);

  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required RenderBox? child,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required SfThumb? thumb}) {
    super.paint(context, center,
        parentBox: parentBox,
        child: child,
        themeData: themeData,
        currentValues: currentValues,
        currentValue: currentValue,
        paint: paint,
        enableAnimation: enableAnimation,
        textDirection: textDirection,
        thumb: thumb);

        context.canvas.drawCircle(center, 25, 
          Paint()
            ..color = _activeColor
            ..style = PaintingStyle.fill);
        
        final arrowPathRight = Path()
          ..moveTo(center.dx - 13, center.dy - 13) // Starting point (left side)
          ..lineTo(center.dx + 17, center.dy) // Tip of the arrow (right side)
          ..lineTo(center.dx - 13, center.dy + 13) // Bottom left corner
          ..lineTo(center.dx - 7, center.dy) // Middle left to complete the arrow
          ..close();

        final arrowPathLeft = Path()
          ..moveTo(center.dx + 13, center.dy - 13) // Starting point (top right side)
          ..lineTo(center.dx - 17, center.dy) // Tip of the arrow (left side)
          ..lineTo(center.dx + 13, center.dy + 13) // Bottom right corner
          ..lineTo(center.dx + 7, center.dy) // Middle right to complete the arrow
          ..close();

        context.canvas.drawPath(
          _active? arrowPathLeft: arrowPathRight, 
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill
            ..strokeWidth = 2);
  }
}
