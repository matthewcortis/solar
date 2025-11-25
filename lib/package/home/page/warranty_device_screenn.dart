import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/warranty_widget.dart';
import '../widgets/warranty_contract.dart';

class WarrantyDeviceScreen extends StatelessWidget {
  const WarrantyDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double scale(double v) => v * width / 430;
    final hopDongId = ModalRoute.of(context)!.settings.arguments as int;

    // Debug
    print("ID nhận tại màn warranty: $hopDongId");
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          /// ================= HEADER =================
          Positioned(
            top: scale(60),
            left: scale(14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(256),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: scale(48),
                  height: scale(48),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(256),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26D1D1D1),
                        blurRadius: 34,
                        offset: Offset(0, 15),
                      ),
                      BoxShadow(
                        color: Color(0x21D1D1D1),
                        blurRadius: 61,
                        offset: Offset(0, 61),
                      ),
                      BoxShadow(
                        color: Color(0x14D1D1D1),
                        blurRadius: 82,
                        offset: Offset(0, 137),
                      ),
                      BoxShadow(
                        color: Color(0x0DD1D1D1),
                        blurRadius: 98,
                        offset: Offset(0, 244),
                      ),
                    ],
                  ),
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color.fromARGB(221, 255, 0, 0),
                        size: 18,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// ======= TITLE =======
          Positioned(
            top: scale(70),
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Thiết bị bảo hành",
                style: TextStyle(
                  fontFamily: 'SFProDisplay',
                  fontWeight: FontWeight.w600,
                  fontSize: scale(20),
                  height: 25 / 20,
                  color: const Color(0xFF4F4F4F),
                ),
              ),
            ),
          ),

          /// ================= CONTENT =================
          Positioned.fill(
            top: scale(140),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: scale(16)),
                child: Column(
                  children: [
                  
                    SizedBox(height: scale(20)),
                    WarrantyWidget(hopDongId: hopDongId),
                    SizedBox(height: scale(20)),
                    WarrantyContractCard(hopDongId: hopDongId),
                    SizedBox(height: scale(20)),
                    DetailInfoCard(hopDongId: hopDongId),
                    SizedBox(height: scale(20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
