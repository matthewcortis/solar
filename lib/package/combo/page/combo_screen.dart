import 'package:flutter/material.dart';
import '../widgets/combo_card.dart';
import './tron_goi_list.dart';
import '../../model/tron_goi_models.dart';
import '../repository/nhom_tron_goi_repo.dart';

class ComboListScreen extends StatefulWidget {
  const ComboListScreen({super.key});

  @override
  State<ComboListScreen> createState() => _ComboListScreenState();
}

class _ComboListScreenState extends State<ComboListScreen> {
  late Future<List<NhomTronGoiDto>> _futureCombos;
  final _repo = NhomTronGoiRepository();

  @override
  void initState() {
    super.initState();
    _futureCombos = _repo.getAllNhomTronGoi();
  }



  void _handleTap(NhomTronGoiDto combo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductListScreen(
          nhomTronGoiId: combo.id, 
          comboName: combo.ten, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: scale(16),
            vertical: scale(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Danh sách Combo',
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(20),
                  height: 25 / 20,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
              SizedBox(height: scale(24)),
              Expanded(
                child: FutureBuilder<List<NhomTronGoiDto>>(
                  future: _futureCombos,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Lỗi tải dữ liệu nhóm trọn gói',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: scale(14),
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    final combos = snapshot.data ?? [];

                    if (combos.isEmpty) {
                      return Center(
                        child: Text(
                          'Không có nhóm trọn gói',
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: scale(14),
                            color: const Color(0xFF828282),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 191 / 126,
                          ),
                      itemCount: combos.length,
                      itemBuilder: (context, index) {
                        final combo = combos[index];

                        return GestureDetector(
                          onTap: () => _handleTap(combo),
                          child: BrandCard(
                           
                            iconPath: 'assets/icons/file-validation.svg',
                            text: combo.ten, // lấy "ten" từ API
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
