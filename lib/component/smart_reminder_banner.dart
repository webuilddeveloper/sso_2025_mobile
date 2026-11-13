import 'package:flutter/material.dart';
import 'package:sso/models/user.dart';
import 'package:sso/screen/dental.dart';
import 'package:sso/screen/hospital.dart';

class SmartReminderItem {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final IconData icon;
  final List<Color> gradientColors;
  final String actionText;
  final VoidCallback onTap;

  SmartReminderItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.icon,
    required this.gradientColors,
    required this.actionText,
    required this.onTap,
  });
}

class SmartReminderBanner extends StatefulWidget {
  final User? user;
  final VoidCallback? onPayContribution;

  const SmartReminderBanner({
    super.key,
    this.user,
    this.onPayContribution,
  });

  @override
  State<SmartReminderBanner> createState() => _SmartReminderBannerState();
}

class _SmartReminderBannerState extends State<SmartReminderBanner> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Set<String> _dismissedIds = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<SmartReminderItem> _getReminders() {
    final now = DateTime.now();
    final thaiYear = now.year + 543;
    final List<SmartReminderItem> list = [];

    // 1. Payment reminder for M.39 or M.40
    final isM39 = widget.user?.category == '39';
    final isM40 = widget.user?.category == '40';
    if (isM39 || isM40) {
      final amount = isM39 ? '432 บาท' : '70-300 บาท';
      list.add(
        SmartReminderItem(
          id: 'payment_reminder',
          title: 'เตือนชำระเงินสมทบ ${isM39 ? "ม.39" : "ม.40"}',
          subtitle: 'ครบกำหนดชำระภายในวันที่ 15 ของเดือน ($amount) เพื่อรักษาสิทธิความคุ้มครอง',
          tag: 'สำคัญมาก',
          tagColor: const Color(0xFFE53935),
          icon: Icons.payments_outlined,
          gradientColors: [const Color(0xFF1E3C72), const Color(0xFF2A5298)],
          actionText: 'ชำระเงิน',
          onTap: () {
            if (widget.onPayContribution != null) {
              widget.onPayContribution!();
            } else {
              _showPaymentDialog(context, isM39 ? '39' : '40', amount);
            }
          },
        ),
      );
    }

    // 2. Annual Hospital Transfer Window (16 Dec - 31 Mar)
    final isHospitalTransferWindow = (now.month >= 12 && now.day >= 16) || (now.month <= 3 && now.day <= 31);
    list.add(
      SmartReminderItem(
        id: 'hospital_transfer',
        title: isHospitalTransferWindow ? 'เปิดเปลี่ยนสถานพยาบาลประจำปี $thaiYear' : 'ยื่นเปลี่ยนสถานพยาบาลประจำปี',
        subtitle: isHospitalTransferWindow
            ? 'ยื่นเปลี่ยนโรงพยาบาลได้ถึง 31 มี.ค. ตรวจสอบสิทธิและทำรายการได้ทันที'
            : 'ระบบเปิดรับยื่นเปลี่ยนสถานพยาบาลประจำปีช่วง 16 ธ.ค. - 31 มี.ค.',
        tag: isHospitalTransferWindow ? 'เปิดรับสิทธิ' : 'สิทธิประจำปี',
        tagColor: const Color(0xFF00897B),
        icon: Icons.local_hospital_outlined,
        gradientColors: [const Color(0xFF0F9B0F), const Color(0xFF00897B)],
        actionText: 'เปลี่ยน รพ.',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HospitalPage()),
          );
        },
      ),
    );

    // 3. Annual Dental Allowance reminder
    list.add(
      SmartReminderItem(
        id: 'dental_reminder',
        title: 'สิทธิทันตกรรม 900 บาท/ปี',
        subtitle: 'คุณมีสิทธิทำฟัน อุดฟัน ถอนฟัน ขูดหินปูน ประจำปี $thaiYear โดยไม่ต้องสำรองจ่าย',
        tag: 'สิทธิประโยชน์',
        tagColor: const Color(0xFFF57C00),
        icon: Icons.medical_services_outlined,
        gradientColors: [const Color(0xFFF2994A), const Color(0xFFF2C94C)],
        actionText: 'ดูสิทธิทันตกรรม',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DentalPage()),
          );
        },
      ),
    );

    return list.where((item) => !_dismissedIds.contains(item.id)).toList();
  }

  void _showPaymentDialog(BuildContext context, String category, String amount) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005C9E).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.qr_code_2, color: Color(0xFF005C9E), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชำระเงินสมทบ ผู้ประกันตน ม.$category',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF102F30),
                        ),
                      ),
                      Text(
                        'ยอดชำระ: $amount / เดือน',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF707070),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Color(0xFF00897B), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ชำระผ่าน Mobile Banking ทุกธนาคาร (PromptPay)',
                          style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Color(0xFF00897B), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'เคาน์เตอร์เซอร์วิส (7-Eleven), Big C, Lotus หรือไปรษณีย์ไทย',
                          style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Color(0xFF00897B), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'หักบัญชีเงินฝากธนาคารอัตโนมัติ (Direct Debit)',
                          style: TextStyle(fontSize: 13, color: Color(0xFF333333)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code, color: Colors.white),
                label: const Text(
                  'สร้าง QR Code ชำระเงินทันที',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C9E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กำลังเชื่อมต่อระบบชำระเงิน e-Payment สำนักงานประกันสังคม...'),
                      backgroundColor: Color(0xFF005C9E),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _getReminders();
    if (reminders.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 125,
          child: PageView.builder(
            controller: _pageController,
            itemCount: reminders.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final item = reminders[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: item.gradientColors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: item.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(item.icon, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        item.tag,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: item.tagColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withOpacity(0.9),
                                    height: 1.25,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: item.onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF005C9E),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.actionText,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 9),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (reminders.length > 1) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              reminders.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _currentIndex == index ? 16 : 6,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? const Color(0xFF005C9E)
                      : const Color(0xFF005C9E).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

