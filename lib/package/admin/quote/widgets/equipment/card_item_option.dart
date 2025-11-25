import 'package:flutter/material.dart';

class OptionCard extends StatefulWidget {
  const OptionCard({
    super.key,
    required this.title,
    this.items = const [],        // danh sách widget hiển thị khi mở (SolarMaxCartCard, v.v.)
    this.onChange,               // callback khi bấm nút Thay đổi
  });

  final String title;
  final List<Widget> items;
  final VoidCallback? onChange;

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER: thanh tiêu đề + icon mũi tên
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            height: 64,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x42D1D1D1),
                  offset: Offset(0, 15),
                  blurRadius: 34,
                ),
                BoxShadow(
                  color: Color(0x36D1D1D1),
                  offset: Offset(0, 61),
                  blurRadius: 61,
                ),
                BoxShadow(
                  color: Color(0x24D1D1D1),
                  offset: Offset(0, 137),
                  blurRadius: 82,
                ),
                BoxShadow(
                  color: Color(0x14D1D1D1),
                  offset: Offset(0, 244),
                  blurRadius: 98,
                ),
                BoxShadow(
                  color: Color(0x00D1D1D1),
                  offset: Offset(0, 382),
                  blurRadius: 107,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      height: 24 / 16,
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 24,
                  color: const Color(0xFF8E8E93),
                ),
              ],
            ),
          ),
        ),

        // NỘI DUNG MỞ RỘNG: list item + nút Thay đổi
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      // List item (SolarMaxCartCard...)
                      if (widget.items.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              widget.items[index],
                        ),

                      if (widget.items.isNotEmpty)
                        const SizedBox(height: 12),

                      _ChangeButton(onTap: widget.onChange),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _ChangeButton extends StatelessWidget {
  const _ChangeButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: scale(398),
        height: scale(40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6E6), // Gray-G2
          borderRadius: BorderRadius.circular(scale(12)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26D1D1D1),
              offset: Offset(0, 15),
              blurRadius: 34,
            ),
            BoxShadow(
              color: Color(0x21D1D1D1),
              offset: Offset(0, 61),
              blurRadius: 61,
            ),
            BoxShadow(
              color: Color(0x14D1D1D1),
              offset: Offset(0, 137),
              blurRadius: 82,
            ),
            BoxShadow(
              color: Color(0x0DD1D1D1),
              offset: Offset(0, 244),
              blurRadius: 98,
            ),
            BoxShadow(
              color: Color(0x00D1D1D1),
              offset: Offset(0, 382),
              blurRadius: 107,
            ),
          ],
        ),
        child: const Text(
          'Thay đổi',
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF3B30), // đỏ như hình
          ),
        ),
      ),
    );
  }
}

//=====================================================================================================

class SegmentPill extends StatelessWidget {
  const SegmentPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const _bgSelected = Color(0xFFE6E6E6);
  static const _bgUnselected = Colors.white;
  static const _borderSelected = Color(0xFFDBEBDD);
  static const _borderUnselected = Color.fromARGB(255, 250, 250, 250);
  static const _activeGreen = Color(0xFF34C759);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 191,
        height: 56,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? _bgSelected : _bgUnselected,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _borderSelected : _borderUnselected,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x42D1D1D1),
              offset: Offset(0, 15),
              blurRadius: 34,
            ),
            BoxShadow(
              color: Color(0x36D1D1D1),
              offset: Offset(0, 61),
              blurRadius: 61,
            ),
            BoxShadow(
              color: Color(0x24D1D1D1),
              offset: Offset(0, 137),
              blurRadius: 82,
            ),
            BoxShadow(
              color: Color(0x14D1D1D1),
              offset: Offset(0, 244),
              blurRadius: 98,
            ),
            BoxShadow(
              color: Color(0x00D1D1D1),
              offset: Offset(0, 382),
              blurRadius: 107,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF4F4F4F),
              ),
            ),

            // Dot indicator
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: _borderUnselected),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: selected ? _activeGreen : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? _activeGreen : _borderSelected,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
