import './tron_goi_models.dart';

class BaoGiaDraft {
  final TronGoiDto tronGoi;                     // Combo gốc
  final List<VatTuTronGoiDto> mainDevices;      // Tấm pin, biến tần, pin lưu trữ (đã đổi số lượng)
  final List<VatTuTronGoiDto> extraMaterials;   // Vật tư phụ (đã đổi số lượng)
  final num giaBanKhungSat;                     // Giá bán khung sắt
  final num giaNhanCongKhungSat;               // Giá nhân công khung sắt
  final num tongTien;                           // Tổng cuối cùng

  const BaoGiaDraft({
    required this.tronGoi,
    required this.mainDevices,
    required this.extraMaterials,
    required this.giaBanKhungSat,
    required this.giaNhanCongKhungSat,
    required this.tongTien,
  });
}
