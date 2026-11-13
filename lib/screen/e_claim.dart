import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sso/models/user.dart';

class EClaimPage extends StatefulWidget {
  final User? user;
  const EClaimPage({super.key, this.user});

  @override
  State<EClaimPage> createState() => _EClaimPageState();
}

class ClaimTypeOption {
  final String id;
  final String title;
  final String subtitle;
  final String maxAmount;
  final IconData icon;
  final Color color;
  final List<String> requiredDocs;

  ClaimTypeOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.maxAmount,
    required this.icon,
    required this.color,
    required this.requiredDocs,
  });
}

class ClaimHistoryRecord {
  final String trackingNo;
  final String title;
  final String claimType;
  final double amount;
  final DateTime submitDate;
  final int currentStep; // 1: ยื่นคำขอ, 2: ตรวจสอบเอกสาร, 3: อนุมัติ, 4: โอนเงินสำเร็จ
  final String statusText;
  final Color statusColor;
  final String bankDetail;

  ClaimHistoryRecord({
    required this.trackingNo,
    required this.title,
    required this.claimType,
    required this.amount,
    required this.submitDate,
    required this.currentStep,
    required this.statusText,
    required this.statusColor,
    required this.bankDetail,
  });
}

class _EClaimPageState extends State<EClaimPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form selections & controllers
  String _selectedClaimTypeId = 'dental';
  String _payoutMethod = 'promptpay'; // 'promptpay' or 'bank'
  String _selectedBank = 'ธนาคารกรุงไทย';
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _claimAmountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<XFile> _attachedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  final List<ClaimTypeOption> _claimTypes = [
    ClaimTypeOption(
      id: 'dental',
      title: 'ทันตกรรม (สำรองจ่าย)',
      subtitle: 'ถอนฟัน อุดฟัน ขูดหินปูน ผ่าฟันคุด',
      maxAmount: 'ไม่เกิน 900 บาท/ปี',
      icon: Icons.medical_services_outlined,
      color: const Color(0xFF00897B),
      requiredDocs: ['ใบเสร็จรับเงินฉบับจริง', 'ใบรับรองแพทย์'],
    ),
    ClaimTypeOption(
      id: 'maternity',
      title: 'คลอดบุตร',
      subtitle: 'เหมาจ่ายต่อครั้ง + เงินสงเคราะห์การหยุดงาน',
      maxAmount: '15,000 บาท/ครั้ง',
      icon: Icons.child_friendly_outlined,
      color: const Color(0xFFE91E63),
      requiredDocs: ['สูติบัตรบุตร', 'สำเนาสมุดบัญชีเงินฝาก'],
    ),
    ClaimTypeOption(
      id: 'child_allowance',
      title: 'สงเคราะห์บุตร',
      subtitle: 'แรกเกิดจนถึงอายุ 6 ปีบริบูรณ์',
      maxAmount: '800 บาท/เดือน/คน',
      icon: Icons.family_restroom_outlined,
      color: const Color(0xFF3F51B5),
      requiredDocs: ['สูติบัตรบุตร', 'ทะเบียนสมรส/รับรองบุตร', 'สำเนาสมุดบัญชี'],
    ),
    ClaimTypeOption(
      id: 'unemployment',
      title: 'ว่างงาน / เลิกจ้าง / ลาออก',
      subtitle: 'เงินชดเชยการขาดรายได้ระหว่างหางาน',
      maxAmount: '30% - 50% ของค่าจ้าง (สูงสุด 7,500 บ./ด.)',
      icon: Icons.work_history_outlined,
      color: const Color(0xFFF57C00),
      requiredDocs: ['หนังสือรับรองการออกจากงาน', 'หนังสือรายงานตัวว่างงาน'],
    ),
  ];

  final List<String> _bankOptions = [
    'ธนาคารกรุงไทย',
    'ธนาคารกสิกรไทย',
    'ธนาคารไทยพาณิชย์',
    'ธนาคารกรุงเทพ',
    'ธนาคารกรุงศรีอยุธยา',
    'ธนาคารออมสิน',
    'ธนาคารทหารไทยธนชาต (ttb)',
  ];

  final List<ClaimHistoryRecord> _claimHistory = [
    ClaimHistoryRecord(
      trackingNo: 'SSO-CLM-2568-00412',
      title: 'ยื่นเบิกทันตกรรม (ขูดหินปูนและอุดฟัน)',
      claimType: 'dental',
      amount: 900.0,
      submitDate: DateTime.now().subtract(const Duration(days: 4)),
      currentStep: 3,
      statusText: 'อนุมัติแล้ว - รอสั่งจ่ายเงิน',
      statusColor: const Color(0xFF005C9E),
      bankDetail: 'พร้อมเพย์เลขบัตร ปชช.',
    ),
    ClaimHistoryRecord(
      trackingNo: 'SSO-CLM-2567-98213',
      title: 'เงินสงเคราะห์บุตร ประจำเดือน',
      claimType: 'child_allowance',
      amount: 800.0,
      submitDate: DateTime.now().subtract(const Duration(days: 35)),
      currentStep: 4,
      statusText: 'โอนเงินเข้าบัญชีสำเร็จ',
      statusColor: const Color(0xFF00897B),
      bankDetail: 'ธนาคารกรุงไทย xxx-x-x1420-x',
    ),
    ClaimHistoryRecord(
      trackingNo: 'SSO-CLM-2567-51209',
      title: 'เงินค่าคลอดบุตรเหมาจ่าย',
      claimType: 'maternity',
      amount: 15000.0,
      submitDate: DateTime.now().subtract(const Duration(days: 180)),
      currentStep: 4,
      statusText: 'โอนเงินเข้าบัญชีสำเร็จ',
      statusColor: const Color(0xFF00897B),
      bankDetail: 'พร้อมเพย์เลขบัตร ปชช.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.user != null && widget.user!.phone.isNotEmpty) {
      _phoneController.text = widget.user!.phone;
    } else {
      _phoneController.text = '0812345678';
    }
    _claimAmountController.text = '900';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bankAccountController.dispose();
    _phoneController.dispose();
    _claimAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  ClaimTypeOption get _selectedOption =>
      _claimTypes.firstWhere((element) => element.id == _selectedClaimTypeId);

  Future<void> _pickAttachment(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (image != null) {
        setState(() {
          _attachedFiles.add(image);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _submitClaim() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากดยินยอมเงื่อนไขและข้อกำหนดก่อนส่งคำขอ'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      final newTrackingNo =
          'SSO-CLM-2568-${(10000 + _claimHistory.length * 137).toString()}';
      final newRecord = ClaimHistoryRecord(
        trackingNo: newTrackingNo,
        title: 'ยื่นเบิก${_selectedOption.title}',
        claimType: _selectedClaimTypeId,
        amount: double.tryParse(_claimAmountController.text.replaceAll(',', '')) ?? 0.0,
        submitDate: DateTime.now(),
        currentStep: 1,
        statusText: 'ยื่นคำขอสำเร็จ (รอเจ้าหน้าที่ตรวจสอบ)',
        statusColor: const Color(0xFFF57C00),
        bankDetail: _payoutMethod == 'promptpay'
            ? 'พร้อมเพย์เลขบัตร ปชช.'
            : '$_selectedBank ${_bankAccountController.text}',
      );

      setState(() {
        _claimHistory.insert(0, newRecord);
        _attachedFiles.clear();
        _agreedToTerms = false;
      });

      _showSuccessDialog(newTrackingNo);
    });
  }

  void _showSuccessDialog(String trackingNo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 56),
            ),
            const SizedBox(height: 18),
            const Text(
              'ยื่นคำขอสำเร็จแล้ว!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
            ),
            const SizedBox(height: 8),
            Text(
              'ระบบได้รับข้อมูลคำขอเบิกสิทธิประโยชน์เรียบร้อยแล้ว เจ้าหน้าที่จะดำเนินการตรวจสอบภายใน 3-5 วันทำการ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('รหัสติดตามคำขอ: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    trackingNo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005C9E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005C9E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _tabController.animateTo(1);
              },
              child: const Text('ดูสถานะคำขอ', style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackingTimelineModal(ClaimHistoryRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102F30),
                          ),
                        ),
                        Text(
                          'เลขคำขอ: ${record.trackingNo}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: record.statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: record.statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('ยอดเงินเบิกจ่าย', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          '฿${NumberFormat('#,##0.00').format(record.amount)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005C9E),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 30, width: 1, color: Colors.grey[300]),
                    Column(
                      children: [
                        const Text('ช่องทางโอนเงิน', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          record.bankDetail,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102F30),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ไทม์ไลน์กระบวนการพิจารณา',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
              ),
              const SizedBox(height: 16),
              _buildTimelineStep(
                stepIndex: 1,
                currentStep: record.currentStep,
                title: 'ยื่นคำขอผ่านระบบ SSO e-Claim',
                time: DateFormat('d MMM yyyy, HH:mm น.', 'th').format(record.submitDate),
                description: 'ระบบรับข้อมูลและเอกสารประกอบเรียบร้อยแล้ว',
              ),
              _buildTimelineStep(
                stepIndex: 2,
                currentStep: record.currentStep,
                title: 'เจ้าหน้าที่ สปส. รับเรื่องและตรวจสอบ',
                time: record.currentStep >= 2
                    ? DateFormat('d MMM yyyy, HH:mm น.', 'th')
                        .format(record.submitDate.add(const Duration(days: 1)))
                    : 'รอการดำเนินการ',
                description: 'ตรวจสอบสิทธิประกันตน ความครบถ้วนของเอกสารและใบเสร็จ',
              ),
              _buildTimelineStep(
                stepIndex: 3,
                currentStep: record.currentStep,
                title: 'อนุมัติการจ่ายเงินสิทธิประโยชน์',
                time: record.currentStep >= 3
                    ? DateFormat('d MMM yyyy, HH:mm น.', 'th')
                        .format(record.submitDate.add(const Duration(days: 3)))
                    : 'รอการดำเนินการ',
                description: 'คณะกรรมการอนุมัติสั่งจ่ายตามสิทธิประโยชน์ที่ยื่น',
              ),
              _buildTimelineStep(
                stepIndex: 4,
                currentStep: record.currentStep,
                title: 'โอนเงินเข้าบัญชี / พร้อมเพย์สำเร็จ',
                time: record.currentStep >= 4
                    ? DateFormat('d MMM yyyy, HH:mm น.', 'th')
                        .format(record.submitDate.add(const Duration(days: 4)))
                    : 'รอการดำเนินการ',
                description: 'โอนเงินเข้า ${record.bankDetail} เรียบร้อยแล้ว',
                isLast: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.file_download_outlined, color: Color(0xFF005C9E)),
                  label: const Text(
                    'ดาวน์โหลดหนังสือรับรอง / ใบเสร็จรับเงิน',
                    style: TextStyle(color: Color(0xFF005C9E)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF005C9E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('กำลังดาวน์โหลดหนังสือรับรอง e-Document จากสำนักงานประกันสังคม...'),
                        backgroundColor: Color(0xFF005C9E),
                      ),
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

  Widget _buildTimelineStep({
    required int stepIndex,
    required int currentStep,
    required String title,
    required String time,
    required String description,
    bool isLast = false,
  }) {
    final isDone = currentStep >= stepIndex;
    final isCurrent = currentStep == stepIndex;
    final stepColor = isDone ? const Color(0xFF00897B) : Colors.grey[400]!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? const Color(0xFF00897B) : Colors.white,
                  border: Border.all(
                    color: stepColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '$stepIndex',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: stepColor),
                        ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone && currentStep > stepIndex ? const Color(0xFF00897B) : Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDone ? const Color(0xFF102F30) : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      color: isCurrent ? const Color(0xFF005C9E) : Colors.grey[500],
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          'ยื่นเบิกสิทธิประโยชน์ (e-Claim)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF005C9E),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF005C9E),
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'ยื่นคำขอใหม่'),
            Tab(text: 'ติดตามสถานะคำขอ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNewClaimForm(),
          _buildClaimHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildNewClaimForm() {
    final fullName = widget.user != null && widget.user!.firstName.isNotEmpty
        ? '${widget.user!.prefixName} ${widget.user!.firstName} ${widget.user!.lastName}'
        : 'นาย สมชาย ผู้ประกันตน';
    final idCard = widget.user != null && widget.user!.idcard.isNotEmpty
        ? widget.user!.idcard
        : '1-1004-99882-12-3';
    final sectionName = widget.user?.category == '39'
        ? 'ผู้ประกันตน มาตรา 39'
        : widget.user?.category == '40'
            ? 'ผู้ประกันตน มาตรา 40'
            : 'ผู้ประกันตน มาตรา 33';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Applicant Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF005C9E).withOpacity(0.1),
                    child: const Icon(Icons.person, color: Color(0xFF005C9E), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'เลขบัตร ปชช.: $idCard',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F0F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            sectionName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF005C9E)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Select Benefit Type
            const Text(
              '1. เลือกประเภทสิทธิประโยชน์ที่ต้องการยื่นเบิก',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemCount: _claimTypes.length,
              itemBuilder: (context, index) {
                final option = _claimTypes[index];
                final isSelected = option.id == _selectedClaimTypeId;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedClaimTypeId = option.id;
                      if (option.id == 'dental') {
                        _claimAmountController.text = '900';
                      } else if (option.id == 'maternity') {
                        _claimAmountController.text = '15,000';
                      } else if (option.id == 'child_allowance') {
                        _claimAmountController.text = '800';
                      } else {
                        _claimAmountController.text = '7,500';
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF005C9E).withOpacity(0.06) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF005C9E) : Colors.grey[200]!,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: option.color.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(option.icon, color: option.color, size: 22),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Color(0xFF005C9E), size: 20),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? const Color(0xFF005C9E) : const Color(0xFF102F30),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              option.maxAmount,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: option.color,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 3. Claim Details & Amount
            const Text(
              '2. ระบุข้อมูลการยื่นเบิก',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _claimAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'จำนวนเงินที่ขอเบิก (บาท)',
                      labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      suffixText: 'บาท',
                      filled: true,
                      fillColor: const Color(0xFFF9FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF005C9E)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'กรุณาระบุจำนวนเงิน';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'เบอร์โทรศัพท์สำหรับติดต่อกลับและรับ SMS แจ้งผล',
                      labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF005C9E)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'กรุณาระบุเบอร์โทรศัพท์';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'หมายเหตุเพิ่มเติม (ถ้ามี เช่น ชื่อคลินิกทันตกรรม หรือสาเหตุ)',
                      labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      prefixIcon: const Icon(Icons.notes, color: Color(0xFF005C9E)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Payout Method
            const Text(
              '3. ช่องทางการรับเงินประโยชน์ทดแทน',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'promptpay',
                    groupValue: _payoutMethod,
                    onChanged: (val) => setState(() => _payoutMethod = val!),
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF005C9E),
                    title: const Text('พร้อมเพย์ (ผูกกับเลขประจำตัวประชาชน)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text(
                      'โอนเงินเข้าบัญชีรวดเร็วที่สุด ไม่ต้องแนบหน้าสมุดบัญชีธนาคาร',
                      style: TextStyle(fontSize: 11, color: Color(0xFF00897B)),
                    ),
                  ),
                  const Divider(height: 20),
                  RadioListTile<String>(
                    value: 'bank',
                    groupValue: _payoutMethod,
                    onChanged: (val) => setState(() => _payoutMethod = val!),
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF005C9E),
                    title: const Text('โอนเข้าบัญชีเงินฝากธนาคาร',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text('โอนเข้าบัญชีออมทรัพย์ที่ระบุ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ),
                  if (_payoutMethod == 'bank') ...[
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedBank,
                      items: _bankOptions
                          .map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13))))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedBank = val!),
                      decoration: InputDecoration(
                        labelText: 'เลือกธนาคาร',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _bankAccountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'เลขที่บัญชีเงินฝาก',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                      validator: (v) {
                        if (_payoutMethod == 'bank' && (v == null || v.isEmpty)) {
                          return 'กรุณาระบุเลขที่บัญชี';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Document Attachments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '4. แนบเอกสารประกอบการเบิกจ่าย',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
                ),
                Text(
                  'แนบแล้ว ${_attachedFiles.length} รูป',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF005C9E), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFFF57C00), size: 16),
                      SizedBox(width: 6),
                      Text('เอกสารที่จำเป็นสำหรับการยื่นเรื่องนี้:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFF57C00))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ..._selectedOption.requiredDocs.map(
                    (doc) => Padding(
                      padding: const EdgeInsets.only(left: 22, bottom: 2),
                      child: Text('• $doc', style: const TextStyle(fontSize: 11, color: Color(0xFF5D4037))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF005C9E)),
                          label: const Text('ถ่ายรูปเอกสาร', style: TextStyle(color: Color(0xFF005C9E), fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF005C9E)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _pickAttachment(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.photo_library_outlined, color: Color(0xFF005C9E)),
                          label: const Text('เลือกจากคลังรูป', style: TextStyle(color: Color(0xFF005C9E), fontSize: 13)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF005C9E)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _pickAttachment(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                  if (_attachedFiles.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _attachedFiles.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final file = _attachedFiles[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(file.path),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _attachedFiles.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 6. PDPA and Consent Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: const Color(0xFF005C9E),
                  onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'ข้าพเจ้าขอรับรองว่าข้อความและเอกสารที่แนบมาทั้งหมดเป็นความจริงทุกประการ และยินยอมให้สำนักงานประกันสังคมตรวจสอบข้อมูลตาม พ.ร.บ. คุ้มครองข้อมูลส่วนบุคคล (PDPA)',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C9E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: _isSubmitting ? null : _submitClaim,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'ส่งคำขอเบิกสิทธิประโยชน์',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimHistoryTab() {
    if (_claimHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('ยังไม่มีประวัติการยื่นคำขอ', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _claimHistory.length,
      itemBuilder: (context, index) {
        final record = _claimHistory[index];
        final typeOpt = _claimTypes.firstWhere(
          (element) => element.id == record.claimType,
          orElse: () => _claimTypes[0],
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showTrackingTimelineModal(record),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: typeOpt.color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(typeOpt.icon, color: typeOpt.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102F30),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'รหัส: ${record.trackingNo}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: record.statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            record.statusText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: record.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('วันที่ยื่นคำขอ', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(
                              DateFormat('d MMM yyyy', 'th').format(record.submitDate),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF102F30)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('ยอดเงินเบิกจ่าย', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(
                              '฿${NumberFormat('#,##0.00').format(record.amount)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005C9E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'แตะเพื่อดูขั้นตอนการอนุมัติ',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

