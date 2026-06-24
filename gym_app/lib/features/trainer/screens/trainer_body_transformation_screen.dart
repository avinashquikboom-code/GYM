import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../../core/constants/app_colors.dart';
import '../providers/trainer_providers.dart';

class TrainerBodyTransformationScreen extends ConsumerStatefulWidget {
  final String memberId;

  const TrainerBodyTransformationScreen({super.key, required this.memberId});

  @override
  ConsumerState<TrainerBodyTransformationScreen> createState() => _TrainerBodyTransformationScreenState();
}

class _TrainerBodyTransformationScreenState extends ConsumerState<TrainerBodyTransformationScreen> {
  double _rotationY = 0.0; // in radians
  double _scale = 1.0;
  String _activeModel = 'Current'; // 'Before', 'Current', 'Goal'
  String _activeView = 'Front'; // 'Front', 'Side', 'Back'

  void _setView(String view) {
    setState(() {
      _activeView = view;
      if (view == 'Front') {
        _rotationY = 0.0;
      } else if (view == 'Side') {
        _rotationY = math.pi / 2;
      } else if (view == 'Back') {
        _rotationY = math.pi;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final members = ref.watch(trainerMembersProvider);
    final member = members.firstWhere((m) => m.id == widget.memberId, orElse: () => members.first);

    // Mock Before, Current, Goal values
    final double beforeWeight = member.startWeight;
    final double currentWeight = member.currentWeight;
    final double goalWeight = member.targetWeight;

    final double beforeFat = member.bodyFat + 5.0; // mock before fat
    final double currentFat = member.bodyFat;
    final double goalFat = member.bodyFat - 6.0; // mock goal fat

    final double beforeWaist = member.waist + 8.0;
    final double currentWaist = member.waist;
    final double goalWaist = member.waist - 8.0;

    final double beforeChest = member.chest - 4.0;
    final double currentChest = member.chest;
    final double goalChest = member.chest + 4.0;

    final double beforeMuscle = member.muscleMass - 3.0;
    final double currentMuscle = member.muscleMass;
    final double goalMuscle = member.muscleMass + 5.0;

    final double beforeBmi = member.bmi + 2.0;
    final double currentBmi = member.bmi;
    final double goalBmi = member.bmi - 2.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Body Transformation'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Model Selector (Before, Current, Goal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightInput,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: ['Before', 'Current', 'Goal'].map((model) {
                    final isSelected = _activeModel == model;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeModel = model),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            model,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // 3D Canvas Viewport
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  // Interactive Gestures Area
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _rotationY += details.delta.dx * 0.01;
                      });
                    },
                    onScaleUpdate: (details) {
                      setState(() {
                        _scale = details.scale.clamp(0.6, 1.8);
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: CustomPaint(
                          size: const Size(180, 360),
                          painter: TransformationBodyPainter(
                            rotationY: _rotationY,
                            scale: _scale,
                            bodyState: _activeModel, // Controls size/shape in painter
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Rotation Instructions Overlay
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.sync_rounded, color: AppColors.primaryGreen, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Drag to Rotate | Pinch to Zoom',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // View Presets (Front, Side, Back)
                  Positioned(
                    top: 16,
                    right: 20,
                    child: Column(
                      children: ['Front', 'Side', 'Back'].map((view) {
                        final isSelected = _activeView == view;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: () => _setView(view),
                            child: Container(
                              width: 50,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryGreen : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                view,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected ? Colors.black : null,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Comparison Metrics Panel
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transformation Statistics',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildCompareRow(context, 'Weight', '${beforeWeight}kg', '${currentWeight}kg', '${goalWeight}kg'),
                          const Divider(height: 16),
                          _buildCompareRow(context, 'Chest', '${beforeChest}cm', '${currentChest}cm', '${goalChest}cm'),
                          const Divider(height: 16),
                          _buildCompareRow(context, 'Waist', '${beforeWaist}cm', '${currentWaist}cm', '${goalWaist}cm'),
                          const Divider(height: 16),
                          _buildCompareRow(context, 'Body Fat', '${beforeFat}%', '${currentFat}%', '${goalFat}%'),
                          const Divider(height: 16),
                          _buildCompareRow(context, 'BMI', '$beforeBmi', '$currentBmi', '$goalBmi'),
                          const Divider(height: 16),
                          _buildCompareRow(context, 'Muscle Mass', '${beforeMuscle}kg', '${currentMuscle}kg', '${goalMuscle}kg'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareRow(
    BuildContext context,
    String metric,
    String before,
    String current,
    String goal,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              metric,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              before,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              current,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              goal,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.secondaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3D-simulated Wireframe Mesh Body Custom Painter
class TransformationBodyPainter extends CustomPainter {
  final double rotationY;
  final double scale;
  final String bodyState;

  TransformationBodyPainter({
    required this.rotationY,
    required this.scale,
    required this.bodyState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    final wireframePaint = Paint()
      ..color = AppColors.primaryGreen.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final contourPaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Body dimensions modifier based on state (Before = bulkier/higher fat, Goal = shred/fit, Current = halfway)
    double widthMod = 1.0;
    double waistMod = 1.0;
    double shoulderMod = 1.0;

    if (bodyState == 'Before') {
      widthMod = 1.2;
      waistMod = 1.25;
      shoulderMod = 1.05;
    } else if (bodyState == 'Goal') {
      widthMod = 0.95;
      waistMod = 0.85;
      shoulderMod = 1.15;
    }

    // 3D Points simulation for muscular silhouette
    // Points defined as (X, Y, Z) relative to center
    final List<List<double>> localPoints = [
      // Head sphere points
      [0, -140, 0],    // 0: top of head
      [0, -110, 0],    // 1: neck base
      [-20, -125, 0],  // 2: left head
      [20, -125, 0],   // 3: right head
      [0, -125, 18],   // 4: face nose
      [0, -125, -18],  // 5: back of head

      // Shoulders & Chest
      [-42 * shoulderMod, -90, 0],   // 6: left shoulder
      [42 * shoulderMod, -90, 0],    // 7: right shoulder
      [-18, -90, 20],               // 8: left pec front
      [18, -90, 20],                // 9: right pec front

      // Torso & Waist
      [-26 * widthMod, -40, 0],     // 10: left ribcage
      [26 * widthMod, -40, 0],      // 11: right ribcage
      [-20 * waistMod, 10, 0],      // 12: left waist
      [20 * waistMod, 10, 0],       // 13: right waist
      [0, -40, 22 * widthMod],      // 14: abs center front
      [0, 10, 18 * waistMod],       // 15: lower belly front

      // Hips & Pelvis
      [-26 * widthMod, 30, 0],      // 16: left hip
      [26 * widthMod, 30, 0],       // 17: right hip

      // Arms (Left)
      [-52, -40, -5],               // 18: left elbow
      [-58, 10, -8],                // 19: left wrist
      // Arms (Right)
      [52, -40, -5],                // 20: right elbow
      [58, 10, -8],                 // 21: right wrist

      // Legs (Left)
      [-24 * widthMod, 90, 0],      // 22: left knee
      [-20, 150, 0],                // 23: left ankle
      // Legs (Right)
      [24 * widthMod, 90, 0],       // 24: right knee
      [20, 150, 0],                 // 25: right ankle
    ];

    // Project 3D points to 2D after Y-rotation and scale
    final List<Offset> projected = [];
    final cosY = math.cos(rotationY);
    final sinY = math.sin(rotationY);

    for (final pt in localPoints) {
      final x = pt[0];
      final y = pt[1];
      final z = pt[2];

      // Rotate around Y-axis
      final rx = x * cosY - z * sinY;

      // Project using scale
      final px = cx + rx * scale;
      final py = cy + y * scale;

      projected.add(Offset(px, py));
    }

    // Drawing helper: Draw line between projected points
    void drawEdge(int p1, int p2, Paint p) {
      canvas.drawLine(projected[p1], projected[p2], p);
    }

    // Draw Wireframe Mesh Edges
    // Head structure
    drawEdge(0, 2, wireframePaint);
    drawEdge(0, 3, wireframePaint);
    drawEdge(0, 4, wireframePaint);
    drawEdge(0, 5, wireframePaint);
    drawEdge(1, 2, wireframePaint);
    drawEdge(1, 3, wireframePaint);
    drawEdge(1, 4, wireframePaint);
    drawEdge(1, 5, wireframePaint);
    drawEdge(2, 4, wireframePaint);
    drawEdge(3, 4, wireframePaint);
    drawEdge(2, 5, wireframePaint);
    drawEdge(3, 5, wireframePaint);

    // Torso cage
    drawEdge(1, 6, wireframePaint);
    drawEdge(1, 7, wireframePaint);
    drawEdge(6, 8, wireframePaint);
    drawEdge(7, 9, wireframePaint);
    drawEdge(8, 14, wireframePaint);
    drawEdge(9, 14, wireframePaint);
    drawEdge(6, 10, wireframePaint);
    drawEdge(7, 11, wireframePaint);
    drawEdge(10, 12, wireframePaint);
    drawEdge(11, 13, wireframePaint);
    drawEdge(14, 15, wireframePaint);
    drawEdge(12, 16, wireframePaint);
    drawEdge(13, 17, wireframePaint);
    drawEdge(15, 16, wireframePaint);
    drawEdge(15, 17, wireframePaint);

    // Grid cross-lines (torso horizontal meshes)
    drawEdge(10, 14, wireframePaint);
    drawEdge(11, 14, wireframePaint);
    drawEdge(12, 15, wireframePaint);
    drawEdge(13, 15, wireframePaint);
    drawEdge(6, 7, wireframePaint);
    drawEdge(10, 11, wireframePaint);
    drawEdge(12, 13, wireframePaint);

    // Arms
    drawEdge(6, 18, wireframePaint);
    drawEdge(18, 19, wireframePaint);
    drawEdge(7, 20, wireframePaint);
    drawEdge(20, 21, wireframePaint);

    // Legs
    drawEdge(16, 22, wireframePaint);
    drawEdge(22, 23, wireframePaint);
    drawEdge(17, 24, wireframePaint);
    drawEdge(24, 25, wireframePaint);
    drawEdge(22, 24, wireframePaint); // pelvis connect knee

    // Draw solid contours on outer edges to create depth
    drawEdge(6, 10, contourPaint);
    drawEdge(7, 11, contourPaint);
    drawEdge(10, 12, contourPaint);
    drawEdge(11, 13, contourPaint);
    drawEdge(12, 16, contourPaint);
    drawEdge(13, 17, contourPaint);
    
    // Arm contours
    drawEdge(6, 18, contourPaint);
    drawEdge(18, 19, contourPaint);
    drawEdge(7, 20, contourPaint);
    drawEdge(20, 21, contourPaint);

    // Leg contours
    drawEdge(16, 22, contourPaint);
    drawEdge(22, 23, contourPaint);
    drawEdge(17, 24, contourPaint);
    drawEdge(24, 25, contourPaint);

    // Head outer contour
    canvas.drawCircle(projected[1] + (projected[0] - projected[1]) * 0.5, 20 * scale, contourPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
