import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sso/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class DigitalCardPage extends StatefulWidget {
  final User? user;
  const DigitalCardPage({super.key, this.user});

  @override
  State<DigitalCardPage> createState() => _DigitalCardPageState();
}

class _DigitalCardPageState extends State<DigitalCardPage> {
  Timer? _timer;
  int _secondsRemaining = 60;
  String _qrTicket = '';
  bool _isCardFlipped = false;

  @override
  void initState() {
    super.initState();
    _generateNewQrTicket();
    _startTimer();
  }

  void _generateNewQrTicket() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final code = widget.user?.code.isNotEmpty == true
        ? widget.user!.code
        : 'SSO-${DateTime.now().year}';
    final idCard = widget.user?.idcard.isNotEmpty == true
        ? widget.user!.idcard
        : '1100400000000';
    // Generate a temporary one-time ticket
    _qrTicket = 'SSO-PASS|$code|$idCard|$now';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 1) {
          _secondsRemaining--;
        } else {
          _secondsRemaining = 60;
          _generateNewQrTicket();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatIdCard(String id) {
    if (id.length != 13) return id.isEmpty ? '1-1004-xxxxx-xx-x' : id;
    return '${id.substring(0, 1)}-${id.substring(1, 5)}-xxxxx-${id.substring(10, 12)}-${id.substring(12, 13)}';
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch phone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullName = widget.user != null && widget.user!.firstName.isNotEmpty
        ? '${widget.user!.prefixName} ${widget.user!.firstName} ${widget.user!.lastName}'
        : 'นาย สมชาย ผู้ประกันตน';
    final idCard = widget.user != null ? widget.user!.idcard : '';
    final section = widget.user?.category == '39'
        ? 'มาตรา 39'
        : widget.user?.category == '40'
            ? 'มาตรา 40'
            : 'มาตรา 33';
    const hospitalName = 'โรงพยาบาลจุฬาลงกรณ์ สภากาชาดไทย';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'บัตรผู้ประกันตนดิจิทัล',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isCardFlipped ? Icons.credit_card : Icons.info_outline,
              color: const Color(0xFF005C9E),
            ),
            tooltip: 'พลิกบัตรดูข้อมูล',
            onPressed: () {
              setState(() {
                _isCardFlipped = !_isCardFlipped;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            // SSO Digital Card
            _isCardFlipped
                ? _buildCardBack(fullName, idCard, hospitalName, section)
                : _buildCardFront(fullName, idCard, hospitalName, section),
            const SizedBox(height: 20),

            // Dynamic QR Pass Section
            _buildQrSection(),
            const SizedBox(height: 20),

            // Emergency & Quick Actions
            _buildEmergencyActions(hospitalName),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFront(String name, String idCard, String hospital, String section) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF00447C), Color(0xFF005C9E), Color(0xFF0E7CB9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005C9E).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Emblem / Watermark
          Positioned(
            right: -25,
            bottom: -25,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/logo/sso.png',
                width: 200,
                height: 200,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.shield,
                  size: 180,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row: Logo & Section Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/logo/sso_only.png',
                          width: 36,
                          height: 36,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.verified,
                            color: Color(0xFFFFC324),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'สำนักงานประกันสังคม',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                              ),
                            ),
                            Text(
                              'Social Security Office',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC324),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        section,
                        style: const TextStyle(
                          color: Color(0xFF003865),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ],
                ),

                // Middle: Insured Person Name & ID
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'เลขประจำตัว: ${_formatIdCard(idCard)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 0.5,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ],
                ),

                // Bottom: Hospital & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'สถานพยาบาลหลัก',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          Text(
                            hospital,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 16),
                        SizedBox(width: 4),
                        Text(
                          'มีสิทธิรักษา',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(String name, String idCard, String hospital, String section) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'เงื่อนไขการใช้สิทธิรักษาพยาบาล',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Kanit',
                ),
              ),
              Icon(Icons.help_outline, color: Colors.white54, size: 20),
            ],
          ),
          const Text(
            '• โปรดแสดงบัตรนี้หรือ QR Code ณ แผนกเวชระเบียนของสถานพยาบาล\n'
            '• กรณีอุบัติเหตุหรือเจ็บป่วยฉุกเฉินวิกฤต (UCEP) เข้ารักษาได้ทุก รพ. ภายใน 72 ชม. แรกโดยไม่ต้องสำรองจ่าย\n'
            '• ตรวจสอบข้อมูลสิทธิประโยชน์เพิ่มเติมได้ที่สายด่วน 1506 ตลอด 24 ชม.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              height: 1.5,
              fontFamily: 'Kanit',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'สายด่วนประกันสังคม: 1506',
                style: TextStyle(
                  color: Color(0xFFFFC324),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'Kanit',
                ),
              ),
              Text(
                'ปีที่เริ่มสิทธิ: ${(DateTime.now().year + 543) - 3}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontFamily: 'Kanit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.qr_code_scanner, color: Color(0xFF005C9E), size: 20),
              SizedBox(width: 8),
              Text(
                'Dynamic Hospital Pass',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF005C9E),
                  fontFamily: 'Kanit',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'ยื่นให้เจ้าหน้าที่ รพ. สแกนเพื่อยืนยันตัวตน (เปลี่ยนรหัสอัตโนมัติ)',
            style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Kanit'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // QR Code Render
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: _qrTicket,
              version: QrVersions.auto,
              size: 180.0,
              gapless: true,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF003865),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF005C9E),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Countdown Timer Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  value: _secondsRemaining / 60,
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _secondsRemaining <= 10 ? Colors.red : const Color(0xFF005C9E),
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'รหัสจะหมดอายุใน $_secondsRemaining วินาที',
                style: TextStyle(
                  fontSize: 12,
                  color: _secondsRemaining <= 10 ? Colors.red : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Kanit',
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _secondsRemaining = 60;
                    _generateNewQrTicket();
                  });
                },
                child: const Icon(Icons.refresh, size: 18, color: Color(0xFF005C9E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyActions(String hospital) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'บริการฉุกเฉินและติดต่อด่วน',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Kanit',
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('1506'),
                  icon: const Icon(Icons.support_agent, size: 18),
                  label: const Text('สายด่วน 1506'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005C9E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makePhoneCall('1669'),
                  icon: const Icon(Icons.local_hospital, size: 18, color: Colors.red),
                  label: const Text(
                    'แพทย์ฉุกเฉิน 1669',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

