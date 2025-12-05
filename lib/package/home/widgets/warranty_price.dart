import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ContractValueCard extends StatefulWidget {
  final String deliveryDate;
  final String totalValue;
  final VoidCallback? onView;
 
  const ContractValueCard({
    super.key,
    required this.deliveryDate,
    required this.totalValue,
    this.onView,
  });

  @override
  State<ContractValueCard> createState() => _ContractValueCardState();
}

class _ContractValueCardState extends State<ContractValueCard> {
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Center(
      child: Container(
        width: scale(398),
        height: scale(93),
        padding: EdgeInsets.all(scale(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF3F3F3), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 20,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bên trái: ngày bàn giao + label
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: scale(8),
                    vertical: scale(4),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x33E6E6E6),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFF3F3F3)),
                  ),
                  child: Text(
                    'Ngày bàn giao: ${widget.deliveryDate}',
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w400,
                      fontSize: scale(10),
                      height: 18 / 12,
                      color: const Color(0xFF4F4F4F),
                    ),
                  ),
                ),
                SizedBox(height: scale(8)),
                Text(
                  'Tổng giá trị hợp đồng',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 20 / 14,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
              ],
            ),

            // Bên phải: số tiền + icon ẩn/hiện
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onView,
                  child: Text(
                    isHidden ? '••••••••' : widget.totalValue,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(24),
                      height: 30 / 24,
                      color: const Color(0xFFEE4037),
                    ),
                  ),
                ),
                SizedBox(width: scale(6)),
                GestureDetector(
                  onTap: () => setState(() => isHidden = !isHidden),
                  child: Icon(
                    isHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: const Color(0xFF7B7B7B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading cho ContractValueCard – dùng trong FutureBuilder khi đang load
class ContractValueCardShimmer extends StatelessWidget {
  const ContractValueCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Center(
      child: Shimmer(
        duration: const Duration(milliseconds: 1500),
        interval: const Duration(milliseconds: 300),
        color: Colors.grey.shade300,
        colorOpacity: 0.4,
        enabled: true,
        child: Container(
          width: scale(398),
          height: scale(93),
          padding: EdgeInsets.all(scale(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF3F3F3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bên trái: pill ngày + label skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: scale(170),
                    height: scale(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  SizedBox(height: scale(8)),
                  Container(
                    width: scale(150),
                    height: scale(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),

              // Bên phải: số tiền + icon skeleton
              Row(
                children: [
                  Container(
                    width: scale(120),
                    height: scale(26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: scale(6)),
                  Container(
                    width: scale(22),
                    height: scale(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
