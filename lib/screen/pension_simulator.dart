import 'package:flutter/material.dart';
import 'package:sso/models/user.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';

class PensionSimulatorPage extends StatefulWidget {
  final User? user;
  const PensionSimulatorPage({super.key, this.user});

  @override
  State<PensionSimulatorPage> createState() => _PensionSimulatorPageState();
}

class _PensionSimulatorPageState extends State<PensionSimulatorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Real or initial user contribution data
  double _employeeContribution = 42500;
  double _employerContribution = 42500;
  double _govContribution = 12000;
  double _dividendReturn = 8450;
  int _accumulatedMonths = 185;
  bool _isLoading = true;

  // Simulator parameters
  double _targetRetireAge = 55;
  double _avgSalary = 15000;
  double _projectedYears = 20;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadContributionData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadContributionData() async {
    setState(() => _isLoading = true);
    try {
      // Fetch available data from backend fund API
      final res = await postDio('${server}m/fund/read', {'limit': 10});
      if (res != null && res is List && res.isNotEmpty) {
        // If API returns historical records, calculate totals
        double total = 0;
        for (var item in res) {
          if (item is Map && item['amount'] != null) {
            total += double.tryParse(item['amount'].toString()) ?? 0;
          }
        }
        if (total > 0) {
          setState(() {
            _employeeContribution = total * 0.45;
            _employerContribution = total * 0.45;
            _govContribution = total * 0.10;
          });
        }
      }
    } catch (e) {
      debugPrint('Pension data load exception: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double get _totalAccumulated =>
      _employeeContribution +
      _employerContribution +
      _govContribution +
      _dividendReturn;

  // Official SSO Pension Formula:
  // If months >= 180: Pension = 20% + 1.5% for every 12 months beyond 180 months.
  // If months < 180: Lump sum payout.
  double get _calculatedMonthlyPension {
    final totalMonths = (_projectedYears * 12).toInt();
    if (totalMonths < 180) {
      return 0.0;
    }
    final extraYears = (totalMonths - 180) / 12;
    final totalRate = 20.0 + (extraYears * 1.5);
    final cappedWage = _avgSalary > 15000 ? 15000.0 : _avgSalary;
    return (totalRate / 100.0) * cappedWage;
  }

  double get _calculatedLumpSum {
    final monthlyTotal = _avgSalary * 0.06; // Estimated employee + employer part
    final totalMonths = (_projectedYears * 12).toInt();
    return (monthlyTotal * totalMonths) * 1.08; // With estimated yield
  }

  @override
  Widget build(BuildContext context) {
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
          'เงินสะสมชราภาพ & บำนาญ',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF005C9E),
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Kanit',
          ),
          indicatorColor: const Color(0xFF005C9E),
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'ยอดเงินสะสม'),
            Tab(text: 'จำลองคำนวณบำนาญ'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildSimulatorTab(),
              ],
            ),
    );
  }

  Widget _buildSummaryTab() {
    final hasPension = _accumulatedMonths >= 180;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Balance Highlight Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF005C9E), Color(0xFF0979BA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF005C9E).withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ยอดเงินสมทบชราภาพสะสมรวม',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${moneyFormat(_totalAccumulated.toStringAsFixed(0))} บาท',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasPension ? Icons.stars : Icons.info,
                        color: const Color(0xFFFFC324),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        hasPension
                            ? 'ส่งครบ $_accumulatedMonths งวด (มีสิทธิรับบำนาญตลอดชีพ)'
                            : 'ส่งไปแล้ว $_accumulatedMonths งวด (ครบ 180 งวดรับบำนาญ)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3-Part Contribution Breakdown Card
          const Text(
            'สัดส่วนเงินสมทบ 3 ฝ่าย',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildBreakdownRow(
                  'ผู้ประกันตนจ่ายสมทบ',
                  _employeeContribution,
                  const Color(0xFF005C9E),
                ),
                const Divider(height: 24),
                _buildBreakdownRow(
                  'นายจ้างสมทบ',
                  _employerContribution,
                  const Color(0xFF2E7D32),
                ),
                const Divider(height: 24),
                _buildBreakdownRow(
                  'รัฐบาลร่วมสมทบ',
                  _govContribution,
                  const Color(0xFFE65100),
                ),
                const Divider(height: 24),
                _buildBreakdownRow(
                  'ผลประโยชน์ตอบแทนสะสม',
                  _dividendReturn,
                  const Color(0xFFE4A025),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Benefit Explanation Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0F6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFBED6E8)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.lightbulb_outline, color: Color(0xFF005C9E)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'เกร็ดความรู้: หากส่งเงินสมทบไม่ครบ 180 เดือน จะได้รับเป็น "เงินบำเหน็จชราภาพ" (เงินก้อนครั้งเดียว) แต่หากส่งครบ 180 เดือนขึ้นไป จะได้รับเป็น "เงินบำนาญชราภาพ" จ่ายเป็นรายเดือนตลอดชีวิตเมื่ออายุครบ 55 ปีบริบูรณ์',
                    style: TextStyle(fontSize: 12, height: 1.5, fontFamily: 'Kanit'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String title, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontFamily: 'Kanit'),
            ),
          ],
        ),
        Text(
          '${moneyFormat(amount.toStringAsFixed(0))} บาท',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Kanit',
          ),
        ),
      ],
    );
  }

  Widget _buildSimulatorTab() {
    final isPension = (_projectedYears * 12) >= 180;
    final projectedPension = _calculatedMonthlyPension;
    final projectedLumpSum = _calculatedLumpSum;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Projected Result Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPension
                    ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                    : [const Color(0xFFE65100), const Color(0xFFF57C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (isPension ? Colors.green : Colors.orange).withOpacity(0.3),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPension ? 'ประมาณการเงินบำนาญรายเดือน' : 'ประมาณการเงินบำเหน็จ (เงินก้อน)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isPension ? 'รับตลอดชีพ' : 'รับครั้งเดียว',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isPension
                      ? '${moneyFormat(projectedPension.toStringAsFixed(0))} บาท/เดือน'
                      : '${moneyFormat(projectedLumpSum.toStringAsFixed(0))} บาท',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'เมื่ออายุครบ ${_targetRetireAge.toInt()} ปี (ส่งสมทบรวม ${_projectedYears.toInt()} ปี / ${(_projectedYears * 12).toInt()} งวด)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Simulation Sliders Card
          const Text(
            'ปรับแต่งตัวแปรเพื่อจำลองผลลัพธ์',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Target Retirement Age
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('อายุเกษียณเป้าหมาย', style: TextStyle(fontFamily: 'Kanit')),
                    Text(
                      '${_targetRetireAge.toInt()} ปี',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005C9E),
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _targetRetireAge,
                  min: 55,
                  max: 65,
                  divisions: 10,
                  activeColor: const Color(0xFF005C9E),
                  label: '${_targetRetireAge.toInt()} ปี',
                  onChanged: (val) => setState(() => _targetRetireAge = val),
                ),
                const SizedBox(height: 12),

                // Projected Contribution Years
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ระยะเวลาส่งเงินสมทบรวม', style: TextStyle(fontFamily: 'Kanit')),
                    Text(
                      '${_projectedYears.toInt()} ปี (${(_projectedYears * 12).toInt()} งวด)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005C9E),
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _projectedYears,
                  min: 5,
                  max: 35,
                  divisions: 30,
                  activeColor: const Color(0xFF005C9E),
                  label: '${_projectedYears.toInt()} ปี',
                  onChanged: (val) => setState(() => _projectedYears = val),
                ),
                const SizedBox(height: 12),

                // Last 60 Months Average Salary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ค่าจ้างเฉลี่ย 60 เดือนสุดท้าย', style: TextStyle(fontFamily: 'Kanit')),
                    Text(
                      '${moneyFormat(_avgSalary.toStringAsFixed(0))} บาท',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005C9E),
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _avgSalary,
                  min: 4500,
                  max: 15000,
                  divisions: 21,
                  activeColor: const Color(0xFF005C9E),
                  label: '${_avgSalary.toInt()} บาท',
                  onChanged: (val) => setState(() => _avgSalary = val),
                ),
                const Text(
                  '* เพดานค่าจ้างสูงสุดในการคำนวณของประกันสังคมคือ 15,000 บาท',
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'Kanit'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

