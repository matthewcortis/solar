
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/equipment/card_item_product_hy_on.dart';

import '../../../combo/repository/nhom_tron_goi_repo.dart';
import '../../../combo/model/nhom_tron_goi_model.dart';
import '../../../combo/model/tron_goi_model.dart';
import '../../../combo/repository/tron_goi_repo.dart';

typedef OnComboSelectionChanged =
    void Function(bool hasSelection, Map<String, dynamic>? combo);

class ComboSelectionFragment extends StatefulWidget {
  const ComboSelectionFragment({super.key, required this.onSelectionChanged});

  final OnComboSelectionChanged onSelectionChanged;

  @override
  State<ComboSelectionFragment> createState() => _ComboSelectionFragmentState();
}

class _ComboSelectionFragmentState extends State<ComboSelectionFragment> {
  final _repo = NhomTronGoiRepository();
  late Future<List<NhomTronGoiModel>> _futureCombos;
 
  NhomTronGoiModel? selectedCombo;

  @override
  void initState() {
    super.initState();
    _futureCombos = _repo.getAllNhomTronGoi();
    // lúc mới vào chưa chọn gì
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged(false, null);
    });
  }

  void _toggleSelect(NhomTronGoiModel combo) {
    setState(() {
      if (selectedCombo?.id == combo.id) {
        selectedCombo = null; // đang chọn -> bỏ chọn
      } else {
        selectedCombo = combo; // chọn item mới
      }
    });

    if (selectedCombo != null) {
      // Map trả ra giống cấu trúc cũ: id, text, icon
      widget.onSelectionChanged(true, {
        'id': selectedCombo!.id,
        'text': selectedCombo!.ten,
        'icon': 'assets/icons/file-validation.svg',
      });
    } else {
      widget.onSelectionChanged(false, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            width: 402,
            height: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lựa chọn loại Combo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    height: 28 / 18,
                    color: Color(0xFF4F4F4F),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Chọn 1 loại combo để tiếp tục',
                  style: TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    color: Color(0xFF848484),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // PHẦN GRIDVIEW GIỮ NGUYÊN GIAO DIỆN, CHỈ THAY DATA
        Expanded(
          child: FutureBuilder<List<NhomTronGoiModel>>(
            future: _futureCombos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Lỗi tải dữ liệu nhóm trọn gói',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                );
              }

              final combos = snapshot.data ?? [];
              if (combos.isEmpty) {
                return const Center(
                  child: Text(
                    'Không có nhóm trọn gói',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF828282),
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 191 / 110,
                ),
                itemCount: combos.length,
                itemBuilder: (context, index) {
                  final combo = combos[index];
                  final isSelected = selectedCombo?.id == combo.id;

                  return GestureDetector(
                    onTap: () => _toggleSelect(combo),
                    child: SelectableBrandCard(
                      label: combo.ten, // tương đương combo['text']
                      iconPath:
                          'assets/icons/file-validation.svg', // tương đương combo['icon']
                      selected: isSelected,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
// Card như bạn đã có
class SelectableBrandCard extends StatelessWidget {
  const SelectableBrandCard({
    super.key,
    required this.label,
    this.iconPath,
    this.selected = false,
  });

  final String label;
  final String? iconPath;
  final bool selected;

  static const Color gray100 = Color(0xFFE6E6E6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green100 = Color(0xFFDBEBDD);
  static const Color green500 = Color(0xFF4D9A56);
  static const Color grayG5 = Color(0xFF4F4F4F);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 191,
      height: 110,
      padding: const EdgeInsets.all(16), // => content width 191-32 = 159
      decoration: BoxDecoration(
        color: selected ? gray100 : white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? green100 : gray100, width: 1),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // frame 159×24, space-between
          SizedBox(
            width: 159,
            height: 24,
            child: _IconRadioRow.explicit(
              selected: selected,
              iconPath: iconPath,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600, // ~590 Semibold
              fontSize: 12,
              height: 20 / 14,
              letterSpacing: 0,
              color: grayG5,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconRadioRow extends StatelessWidget {
  const _IconRadioRow({super.key})
    : _selected = null,
      _iconPath = null;

  const _IconRadioRow.explicit({
    super.key,
    required bool selected,
    String? iconPath,
  }) : _selected = selected,
       _iconPath = iconPath;

  final bool? _selected;
  final String? _iconPath;

  @override
  Widget build(BuildContext context) {
    bool selected =
        _selected ??
        context.findAncestorWidgetOfExactType<SelectableBrandCard>()!.selected;
    String? iconPath =
        _iconPath ??
        context.findAncestorWidgetOfExactType<SelectableBrandCard>()!.iconPath;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (iconPath != null && iconPath.isNotEmpty)
          SvgPicture.asset(iconPath, width: 20, height: 20)
        else
          const Icon(Icons.settings_outlined, size: 20, color: Colors.black),

        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: selected
                ? const Color.fromARGB(255, 242, 250, 243)
                : const Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: selected
              ? Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: SelectableBrandCard.green500,
                    shape: BoxShape.circle,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final int nhomTronGoiId; // ID nhóm trọn gói truyền từ màn trước
  final String? comboName;
  final VoidCallback? onBack;

  final bool? initialIsHybrid;
  final void Function(String type, bool hasAny)? onTypeSelected;
  final void Function(TronGoiModel? product)? onProductSelected;

  const ProductListScreen({
    super.key,
    required this.nhomTronGoiId,
    this.comboName,
    this.onBack,
    this.initialIsHybrid,
    this.onTypeSelected,
    this.onProductSelected,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late bool isHybridSelected;
  int? selectedIndex;

  final _repo = TronGoiRepository();

  List<TronGoiModel> _hybridList = [];
  List<TronGoiModel> _onGridList = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    isHybridSelected = widget.initialIsHybrid ?? true;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
      selectedIndex = null;
    });

    try {
      final hybridFuture = _repo.fetchTronGoi(
        nhomTronGoiId: widget.nhomTronGoiId,
        loaiHeThong: 'Hy-Brid',
      );

      final onGridFuture = _repo.fetchTronGoi(
        nhomTronGoiId: widget.nhomTronGoiId,
        loaiHeThong: 'On-Grid',
      );

      final results = await Future.wait([hybridFuture, onGridFuture]);
      _hybridList = results[0];
      _onGridList = results[1];

      _notifyType();
      widget.onProductSelected?.call(null);
    } catch (e) {
      _error = 'Lỗi tải danh sách trọn gói';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _notifyType() {
    final type = isHybridSelected ? 'Hy-Brid' : 'On-Grid';
    final list = isHybridSelected ? _hybridList : _onGridList;
    final hasAny = list.isNotEmpty;
    widget.onTypeSelected?.call(type, hasAny);
  }

  @override
  Widget build(BuildContext context) {
    final list = isHybridSelected ? _hybridList : _onGridList;

    return SafeArea(
      child: Column(
        children: [
          // --- Header ---
       

          // --- Tabs ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildTabButton('Hy-Brid', true),
                  _buildTabButton('On-Grid', false),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- Product List ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : list.isEmpty
                        ? const Center(
                            child: Text(
                              'Không có trọn gói nào',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF828282),
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 cột
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 202 / 355,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final tronGoi = list[index];
                              final bool isSelected = selectedIndex == index;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedIndex == index) {
                                      selectedIndex = null; // bỏ chọn
                                    } else {
                                      selectedIndex = index; // chọn mới
                                    }
                                  });

                                  TronGoiModel? selectedProduct;
                                  if (selectedIndex != null) {
                                    selectedProduct = list[selectedIndex!];
                                  } else {
                                    selectedProduct = null;
                                  }

                                  widget.onProductSelected
                                      ?.call(selectedProduct);
                                },
                                child: ProductItemCard(
                                  combo: tronGoi,
                                  // nếu ProductItemCard chưa có isSelected,
                                  // thêm tham số này vào widget để tô viền / đổi màu
                                  isSelected: isSelected,
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  // đổi tab
  Widget _buildTabButton(String title, bool isHybrid) {
    final selected = isHybrid ? isHybridSelected : !isHybridSelected;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isHybridSelected != isHybrid) {
            setState(() {
              isHybridSelected = isHybrid;
              selectedIndex = null; // đổi loại thì bỏ chọn product cũ
            });
            _notifyType();
            widget.onProductSelected?.call(null);
          }
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF00D26A) : Colors.transparent,
            borderRadius: BorderRadius.circular(23),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF666666),
              ),
            ),
          ),
        ),
      ),
    );
  }
}