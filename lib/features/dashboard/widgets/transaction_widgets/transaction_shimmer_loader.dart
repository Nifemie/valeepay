import 'package:flutter/material.dart';

class TransactionShimmerLoader extends StatefulWidget {
  final int itemCount;

  const TransactionShimmerLoader({Key? key, this.itemCount = 8})
    : super(key: key);

  @override
  State<TransactionShimmerLoader> createState() =>
      _TransactionShimmerLoaderState();
}

class _TransactionShimmerLoaderState extends State<TransactionShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: widget.itemCount,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Icon placeholder
                  _buildShimmerBox(40, 40, isCircle: true),
                  const SizedBox(width: 12),

                  // Text placeholders
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerBox(double.infinity, 14),
                        const SizedBox(height: 6),
                        _buildShimmerBox(150, 12),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Amount and status placeholder
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildShimmerBox(80, 14),
                      const SizedBox(height: 6),
                      _buildShimmerBox(60, 20),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerBox(
    double width,
    double height, {
    bool isCircle = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          stops: [
            (_animation.value - 1).clamp(0.0, 1.0),
            _animation.value.clamp(0.0, 1.0),
            (_animation.value + 1).clamp(0.0, 1.0),
          ],
        ),
        borderRadius:
            isCircle
                ? BorderRadius.circular(height / 2)
                : BorderRadius.circular(4),
      ),
    );
  }
}
