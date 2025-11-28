import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/quote/step_progress.dart';
import './combo_selection_fragment.dart';
import './equipment_selection_fragment.dart'; // chứa DanhMucScreen
import '../../../model/tron_goi_models.dart';

class TaoBaoGiaScreen extends StatefulWidget {
  const TaoBaoGiaScreen({super.key});

  @override
  State<TaoBaoGiaScreen> createState() => _TaoBaoGiaScreenState();
}

class _TaoBaoGiaScreenState extends State<TaoBaoGiaScreen> {
  int _step = 1; // 1: chọn combo, 2: chọn loại (Hy-Brid/On-grid), 3: danh mục

  bool _hasSelection = false;
  Map<String, dynamic>? _selectedCombo;

  String? _selectedType; // 'Hy-Brid' | 'On-grid'
  bool _hasType = false; // có sản phẩm thuộc loại đang chọn
  bool _hasProductSelection = false;

  TronGoiDto? _selectedProduct;
  num _currentTotal = 0;

 

  String get _totalDisplay {
    final num value = _currentTotal;
    final s = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    final reversed = buffer.toString().split('').reversed.join();
    return '$reversed đ';
  }

  void _handleSelectionChanged(bool hasSelection, Map<String, dynamic>? combo) {
    setState(() {
      _hasSelection = hasSelection;
      _selectedCombo = combo;

      // reset state step 2 & 3 khi đổi combo
      _selectedType = null;
      _hasType = false;
      _hasProductSelection = false;
      _selectedProduct = null;
    });
  }

  // nhận từ ProductListScreen khi user đổi tab loại
  void _onTypeSelected(String type, bool hasAny) {
    setState(() {
      _selectedType = hasAny ? type : null;
      _hasType = hasAny;

      // đổi type thì bỏ chọn sản phẩm cũ
      _selectedProduct = null;
      _hasProductSelection = false;
    });
  }
    // callback nhận tổng tiền mới từ DanhMucScreen
  void _onTotalChanged(num newTotal) {
    setState(() {
      _currentTotal = newTotal;
    });
  }


  // nhận từ ProductListScreen khi chọn combo cụ thể
    void _onProductSelected(TronGoiDto? product) {
    setState(() {
      _selectedProduct = product;
      _hasProductSelection = product != null;

      // GÁN TỔNG BAN ĐẦU TỪ TỔNG GIÁ CỦA TRỌN GÓI
      _currentTotal = product?.tongGia ?? 0;
    });
  }


  void _goNext() {
    switch (_step) {
      case 1:
        if (_hasSelection && _selectedCombo != null) {
          // ĐÃ CHỌN NHÓM TRỌN GÓI → SANG BƯỚC 2
          setState(() {
            _step = 2;
            // type sẽ được ProductListScreen báo về qua _onTypeSelected
          });
        }
        break;
      case 2:
        if (_selectedType != null && _hasType && _hasProductSelection) {
          setState(() => _step = 3);
        }
        break;
      case 3:
        _submitQuote();
        break;
    }
  }

  void _submitQuote() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã tạo báo giá')));
  }

  void _handleBack() {
    if (_step > 1) {
      setState(() {
        if (_step == 3) {
          // Back từ bước 3 về bước 2:
          _step = 2;
          _selectedProduct = null;
          _hasProductSelection = false;

          // nếu muốn giữ type thì bỏ 2 dòng dưới
          _selectedType = null;
          _hasType = false;
        } else {
          // Bước 2 -> 1
          _step -= 1;
        }
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String ctaLabel = _step == 3 ? 'Tạo báo giá' : 'Tiếp tục';
    final bool ctaEnabled = switch (_step) {
      1 => _hasSelection && _selectedCombo != null,
      2 => _selectedType != null && _hasType && _hasProductSelection,
      _ => true,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER
              Container(
                height: 48.w,
                margin: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: _CircleButton(
                        size: 48.w,
                        onTap: _handleBack,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18.w,
                          color: const Color(0xFFFF3B30),
                        ),
                      ),
                    ),
                    const Text(
                      'Tạo báo giá',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                    SizedBox(width: 48.w),
                  ],
                ),
              ),

              // STEP PROGRESS
              Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: StepProgressHeader(currentStep: _step),
              ),

              // NỘI DUNG
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8.h),
                  child: _buildBody(),
                ),
              ),

              // BOTTOM BAR (CTA)
              Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 12.h,
                  bottom: 12.h,
                ),
                child: _buildBottomBar(ctaLabel, ctaEnabled),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(String ctaLabel, bool ctaEnabled) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: child,
        );
      },
      child: _step == 3
          ? _buildQuoteSummaryBar()
          : _buildNormalCtaBar(ctaLabel, ctaEnabled),
    );
  }

  Widget _buildNormalCtaBar(String ctaLabel, bool ctaEnabled) {
    return SizedBox(
      key: const ValueKey('cta-normal'),
      width: double.infinity,
      height: 56.h,
      child: PrimaryButton(
        label: ctaLabel,
        enabled: ctaEnabled,
        onPressed: ctaEnabled ? _goNext : null,
      ),
    );
  }

  Widget _buildQuoteSummaryBar() {
    return SizedBox(
      key: const ValueKey('cta-summary'),
      width: double.infinity,
      height: 64.h,
      child: Row(
        children: [
          // Tổng tạm tính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tổng tạm tính (bao gồm VAT)',
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    height: 18 / 12,
                    color: const Color(0xFF848484),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _totalDisplay,
                  style: TextStyle(
                    fontFamily: 'SFProDisplay',
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    height: 24 / 20,
                    color: const Color(0xFFEE4037),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          SizedBox(
            width: 190.w,
            height: 56.h,
            child: PrimaryButton(
              label: 'Tạo báo giá',
              enabled: true,
              onPressed: _goNext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_step == 1) {
      return ComboSelectionFragment(
        onSelectionChanged: _handleSelectionChanged,
      );
    }

    if (_step == 2) {
      final int? nhomId = _selectedCombo?['id'] as int?;
      final String? comboName = _selectedCombo?['text'] as String?;

      if (nhomId == null) {
        return ComboSelectionFragment(
          onSelectionChanged: _handleSelectionChanged,
        );
      }

      return ProductListScreen(
        nhomTronGoiId: nhomId,
        comboName: comboName,
        onBack: () {
          setState(() {
            _step = 1;
          });
        },
        onTypeSelected: _onTypeSelected,
        initialIsHybrid: _selectedType == null
            ? true
            : _selectedType == 'Hy-Brid',
        onProductSelected: _onProductSelected,
      );
    }

        return DanhMucScreen(
      selectedType: _selectedType,
      selectedPhase: _selectedProduct?.loaiHeThong,
      tronGoi: _selectedProduct!,
      comboId: _selectedProduct!.id,
      // THÊM CALLBACK
      onTotalChanged: _onTotalChanged,
    );

  }
}

// Button tròn tái sử dụng
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.size,
    required this.onTap,
    required this.child,
  });

  final double size;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}
