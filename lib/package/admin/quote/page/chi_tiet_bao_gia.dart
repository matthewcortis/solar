import 'package:flutter/material.dart';
import '../../../model/bao_gia_draft.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../product/page/bao_gia_screen.dart';
import '../../../../routes.dart';

class QuoteSuccessScreen extends StatelessWidget {
  const QuoteSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final BaoGiaDraft? draft = args is BaoGiaDraft ? args : null;

    if (draft != null) {
      print('===== QuoteSuccessScreen – BaoGiaDraft =====');
      print('Tổng tiền: ${draft.tongTien}');
      print('Thiết bị chính:');
      for (final m in draft.mainDevices) {
        print('- ${m.vatTu.ten} | SL: ${m.soLuong} | Giá: ${m.gia}');
      }
      print('Vật tư phụ:');
      for (final m in draft.extraMaterials) {
        print('- ${m.vatTu.ten} | SL: ${m.soLuong} | Giá: ${m.gia}');
      }
      print('Giá khung sắt: ${draft.giaBanKhungSat}');
      print('Giá nhân công: ${draft.giaNhanCongKhungSat}');
    }

    if (draft == null) {
      return const Scaffold(
        body: Center(child: Text('Không nhận được dữ liệu báo giá')),
      );
    }

    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: scale(430),
              padding: EdgeInsets.only(
                left: scale(16),
                right: scale(16),
                bottom: scale(24),
                top: scale(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SuccessHeader(scale: scale),
                  SizedBox(height: scale(16)),
                  _CustomerInfoCard(scale: scale, draft: draft),
                  SizedBox(height: scale(12)),
                  _QuoteDetailCard(scale: scale, draft: draft),
                  SizedBox(height: scale(24)),
                  _BottomButtons(
                    scale: scale,
                    draft: draft, // <-- TRUYỀN THÊM Ở ĐÂY
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessHeader extends StatelessWidget {
  final double Function(double) scale;

  const _SuccessHeader({required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(horizontal: scale(4), vertical: scale(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Báo giá đã được tạo thành công!',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              fontSize: scale(18),
              height: 26 / 18,
              color: const Color(0xFF111111),
            ),
          ),
          SizedBox(height: scale(4)),
          Text(
            'Vui lòng kiểm tra thông tin tóm tắt của báo giá bên dưới. '
            'Bạn có thể tải về bản báo giá dưới dạng PDF để gửi đến khách hàng.',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              fontSize: scale(14),
              height: 16 / 14,
              color: const Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerInfoCard extends StatelessWidget {
  final double Function(double) scale;
  final BaoGiaDraft draft;

  const _CustomerInfoCard({required this.scale, required this.draft});

  TextStyle get _titleStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600,
    fontSize: scale(16),
    height: 24 / 16,
    color: const Color(0xFF111111),
  );

  TextStyle get _labelStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w400,
    fontSize: scale(13),
    height: 20 / 13,
    color: const Color(0xFF828282),
  );

  TextStyle get _valueStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w500,
    fontSize: scale(13),
    height: 20 / 13,
    color: const Color(0xFF111111),
  );

  String _formatMoney(num value) {
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
    return '$reversed VND';
  }

  @override
  Widget build(BuildContext context) {
    final tronGoi = draft.tronGoi;

    final productName = tronGoi.ten;
    final classification = [
      tronGoi.loaiHeThong,
      tronGoi.loaiPha,
    ].where((e) => e.toString().isNotEmpty).join(' · ');

    final powerText = tronGoi.congSuatHeThong != null
        ? '${(tronGoi.congSuatHeThong! / 1000).toStringAsFixed(1)} kW'
        : '--';

    return Container(
      width: scale(430),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(scale(12)),
      ),
      padding: EdgeInsets.all(scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin khách hàng', style: _titleStyle),
          SizedBox(height: scale(12)),
          _RowItem(
            scale: scale,
            label: 'Sản phẩm',
            value: productName,
            labelStyle: _labelStyle,
            valueStyle: _valueStyle,
          ),
          _RowItem(
            scale: scale,
            label: 'Phân loại',
            value: classification.isEmpty ? '—' : classification,
            labelStyle: _labelStyle,
            valueStyle: _valueStyle,
          ),
          _RowItem(
            scale: scale,
            label: 'Công suất',
            value: powerText,
            labelStyle: _labelStyle,
            valueStyle: _valueStyle,
          ),
          _RowItem(
            scale: scale,
            label: 'Giá trị đơn hàng (Bao gồm VAT)',
            value: _formatMoney(draft.tongTien),
            labelStyle: _labelStyle,
            valueStyle: _valueStyle.copyWith(
              color: const Color(0xFFEE4037),
              fontWeight: FontWeight.w600,
            ),
            isLast: true,
            height: 58,
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final double Function(double) scale;
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final bool isLast;
  final double height;

  const _RowItem({
    required this.scale,
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
    this.isLast = false,
    this.height = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scale(398),
      height: scale(height),
      padding: EdgeInsets.symmetric(vertical: scale(12)),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          SizedBox(width: scale(12)),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(value, style: valueStyle, textAlign: TextAlign.right),
            ),
          ),
        ],
      ),
    );
  }
}

/// ĐỔI SANG StatefulWidget ĐỂ BẬT/TẮT DROPDOWN
/// ĐỔI SANG StatefulWidget ĐỂ BẬT/TẮT HIỂN THỊ CHI TIẾT
class _QuoteDetailCard extends StatefulWidget {
  final double Function(double) scale;
  final BaoGiaDraft draft;

  const _QuoteDetailCard({required this.scale, required this.draft});

  @override
  State<_QuoteDetailCard> createState() => _QuoteDetailCardState();
}

class _QuoteDetailCardState extends State<_QuoteDetailCard> {
  double get _scaleFactor => widget.scale(1);

  double scale(double v) => widget.scale(v);

  TextStyle get _titleStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w600,
    fontSize: scale(16),
    height: 24 / 16,
    color: const Color(0xFF4F4F4F),
  );

  TextStyle get _headerRightStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w500,
    fontSize: scale(12),
    height: 18 / 12,
    color: const Color(0xFF828282),
  );

  TextStyle get _itemTitleStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w500,
    fontSize: scale(13),
    height: 20 / 13,
    color: const Color(0xFF111111),
  );

  TextStyle get _itemSubStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w400,
    fontSize: scale(12),
    height: 18 / 12,
    color: const Color(0xFF828282),
  );

  TextStyle get _qtyStyle => TextStyle(
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w500,
    fontSize: scale(13),
    height: 20 / 13,
    color: const Color(0xFF111111),
  );

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;

    return Container(
      width: scale(430),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(scale(12)),
      ),
      padding: EdgeInsets.all(scale(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Chi tiết báo giá', style: _titleStyle),
              const Spacer(),
              Text('Số lượng', style: _headerRightStyle),
            ],
          ),
          SizedBox(height: scale(12)),

          // THIẾT BỊ CHÍNH
          if (draft.mainDevices.isNotEmpty) ...[
            Text(
              'Thiết bị chính',
              style: _itemTitleStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: scale(4)),
            ...draft.mainDevices.asMap().entries.map((entry) {
              final index = entry.key;
              final m = entry.value;
              final title = '${index + 1}. ${m.vatTu.ten}';
              final subtitle = m.vatTu.nhomVatTu.ten;
              final qtyText =
                  '${m.soLuong.toStringAsFixed(0)} ${m.vatTu.donVi}';

              // Nếu không còn phần vật tư phía sau thì dòng cuối của mainDevices là last
              final isLast =
                  draft.extraMaterials.isEmpty &&
                  index == draft.mainDevices.length - 1;

              return _DetailItem(
                scale: widget.scale,
                title: title,
                subtitle1: subtitle,
                quantity: qtyText,
                itemTitleStyle: _itemTitleStyle,
                itemSubStyle: _itemSubStyle,
                qtyStyle: _qtyStyle,
                isLast: isLast,
              );
            }),
          ],

          // PHỤ KIỆN, VẬT TƯ – HIỂN THỊ THEO HỆ (KHÔNG DROPDOWN)
          if (draft.extraMaterials.isNotEmpty) ...[
            SizedBox(height: scale(12)),
            Text(
              'Phụ kiện, vật tư',
              style: _itemTitleStyle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: scale(4)),
            ..._buildAccessorySystemRows(),
          ],
        ],
      ),
    );
  }

  /// Gom vật tư phụ theo HỆ, đánh số 1–7, loại bỏ TRON_GOI_LAP_DAT
  List<Widget> _buildAccessorySystemRows() {
    final extras = widget.draft.extraMaterials;
    if (extras.isEmpty) return [];

    // Cấu hình thứ tự & tên hiển thị cho 7 hệ (bỏ TRON_GOI_LAP_DAT)
    final List<_SystemGroupConfig> configs = [
      _SystemGroupConfig(code: 'TAM_PIN', label: 'Hệ tấm pin'),
      _SystemGroupConfig(code: 'BIEN_TAN', label: 'Hệ biến tần'),
      _SystemGroupConfig(code: 'PIN_LUU_TRU', label: 'Hệ pin lưu trữ'),
      _SystemGroupConfig(code: 'HE_KHUNG_NHOM', label: 'Hệ khung nhôm'),
      _SystemGroupConfig(code: 'HE_DAY_DIEN', label: 'Hệ dây điện'),
      _SystemGroupConfig(code: 'TU_DIEN', label: 'Tủ điện'),
      _SystemGroupConfig(code: 'HE_TIEP_DIA', label: 'Hệ tiếp địa'),
    ];

    final List<_SystemSummary> summaries = [];

    for (final cfg in configs) {
      num totalQty = 0;
      for (final m in extras) {
        final nhomMa = m.vatTu.nhomVatTu.ma;
        if (nhomMa == cfg.code) {
          totalQty += m.soLuong;
        }
      }
      if (totalQty > 0) {
        summaries.add(_SystemSummary(label: cfg.label, quantity: totalQty));
      }
    }

    if (summaries.isEmpty) return [];

    final List<Widget> rows = [];
    for (int i = 0; i < summaries.length; i++) {
      final s = summaries[i];
      final isLast = i == summaries.length - 1;

      rows.add(
        _DetailItem(
          scale: widget.scale,
          title: '${i + 1}. ${s.label}', // index 1..7
          subtitle1: '', // chỉ hiển thị tên hệ + số lượng
          // quantity: '${s.quantity.toStringAsFixed(0)} bộ',
          quantity: '1',

          itemTitleStyle: _itemTitleStyle,
          itemSubStyle: _itemSubStyle,
          qtyStyle: _qtyStyle,
          isLast: isLast,
        ),
      );
    }

    return rows;
  }
}

/// Cấu hình cho từng hệ
class _SystemGroupConfig {
  final String code;
  final String label;

  _SystemGroupConfig({required this.code, required this.label});
}

/// Tóm tắt số lượng theo hệ
class _SystemSummary {
  final String label;
  final num quantity;

  _SystemSummary({required this.label, required this.quantity});
}

class _DetailItem extends StatelessWidget {
  final double Function(double) scale;
  final String title;
  final String subtitle1;
  final String? subtitle2;
  final String quantity;
  final bool isLast;
  final TextStyle itemTitleStyle;
  final TextStyle itemSubStyle;
  final TextStyle qtyStyle;

  const _DetailItem({
    required this.scale,
    required this.title,
    required this.subtitle1,
    this.subtitle2,
    required this.quantity,
    required this.itemTitleStyle,
    required this.itemSubStyle,
    required this.qtyStyle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: scale(398),
      padding: EdgeInsets.symmetric(vertical: scale(12)),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: itemTitleStyle),
                SizedBox(height: scale(4)),
                Text(subtitle1, style: itemSubStyle),
                if (subtitle2 != null) ...[
                  SizedBox(height: scale(2)),
                  Text(subtitle2!, style: itemSubStyle),
                ],
              ],
            ),
          ),
          SizedBox(width: scale(8)),
          SizedBox(
            width: scale(80),
            child: Text(quantity, style: qtyStyle, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final double Function(double) scale;
  final BaoGiaDraft draft; // <-- nhận draft

  const _BottomButtons({required this.scale, required this.draft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale(398),
      child: Column(
        children: [
          // Nút thông tin báo giá
          SizedBox(
            width: scale(398),
            height: scale(48),
            child: ElevatedButton(
              onPressed: () {
                // Điều hướng sang màn thông tin báo giá và truyền draft
                // Navigator.pushNamed(
                //   context,
                //   '/thong-tin-bao-gia', // đổi theo route thực tế của bạn
                //   arguments: draft,
                // );

                // Nếu bạn dùng push thẳng widget:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ThongTinBaoGiaScreen(),
                    settings: RouteSettings(arguments: draft),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6E6E6),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(scale(12)),
                ),
                shadowColor: const Color(0x26D1D1D1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/baogia.svg', // thay path theo project
                    width: scale(20),
                    height: scale(20),
                  ),
                  SizedBox(width: scale(8)),
                  Text(
                    'Thông tin báo giá',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w500,
                      fontSize: scale(16),
                      color: const Color(0xFF111111),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: scale(12)),
          // Nút về trang chủ
          SizedBox(
            width: scale(398),
            height: scale(48),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.bottomNav,
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEE4037),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(scale(12)),
                ),
                shadowColor: const Color(0x26D1D1D1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/home.svg',
                    width: scale(20),
                    height: scale(20),
                    color: Colors.white,
                  ),
                  SizedBox(width: scale(8)),
                  Text(
                    'Về trang chủ',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w600,
                      fontSize: scale(16),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// 