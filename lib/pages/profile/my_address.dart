import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/custom_dialog.dart';
import 'package:sso/shared/api_provider.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({super.key});

  @override
  State<MyAddressPage> createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();
  final TextEditingController _subDistrictController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  final TextEditingController _currentAddressController = TextEditingController();
  bool _sameAsPermanent = true;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAddressData();
  }

  @override
  void dispose() {
    _houseNoController.dispose();
    _villageController.dispose();
    _roadController.dispose();
    _subDistrictController.dispose();
    _districtController.dispose();
    _provinceController.dispose();
    _zipCodeController.dispose();
    _currentAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadAddressData() async {
    setState(() => _isLoading = true);
    try {
      final savedAddress = await storage.read(key: 'userAddressData');
      if (savedAddress != null && savedAddress.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(savedAddress);
        _houseNoController.text = data['houseNo'] ?? '';
        _villageController.text = data['village'] ?? '';
        _roadController.text = data['road'] ?? '';
        _subDistrictController.text = data['subDistrict'] ?? '';
        _districtController.text = data['district'] ?? '';
        _provinceController.text = data['province'] ?? '';
        _zipCodeController.text = data['zipCode'] ?? '';
        _sameAsPermanent = data['sameAsPermanent'] ?? true;
        _currentAddressController.text = data['currentAddress'] ?? '';
      } else {
        // Fallback default address for We Build Operate / Insured Person
        _houseNoController.text = '123/45 อาคารวิลด์ทาวเวอร์';
        _villageController.text = 'หมู่ 2';
        _roadController.text = 'ถนนพหลโยธิน';
        _subDistrictController.text = 'สามเสนใน';
        _districtController.text = 'พญาไท';
        _provinceController.text = 'กรุงเทพมหานคร';
        _zipCodeController.text = '10400';
        _currentAddressController.text =
            '123/45 อาคารวิลด์ทาวเวอร์ หมู่ 2 ถนนพหลโยธิน แขวงสามเสนใน เขตพญาไท กรุงเทพฯ 10400';
      }
    } catch (e) {
      debugPrint('Error loading address: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveAddressData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final Map<String, dynamic> data = {
        'houseNo': _houseNoController.text.trim(),
        'village': _villageController.text.trim(),
        'road': _roadController.text.trim(),
        'subDistrict': _subDistrictController.text.trim(),
        'district': _districtController.text.trim(),
        'province': _provinceController.text.trim(),
        'zipCode': _zipCodeController.text.trim(),
        'sameAsPermanent': _sameAsPermanent,
        'currentAddress': _sameAsPermanent
            ? '${_houseNoController.text.trim()} ${_villageController.text.trim()} ถนน${_roadController.text.trim()} แขวง${_subDistrictController.text.trim()} เขต${_districtController.text.trim()} ${_provinceController.text.trim()} ${_zipCodeController.text.trim()}'
            : _currentAddressController.text.trim(),
      };

      await storage.write(key: 'userAddressData', value: json.encode(data));

      if (!mounted) return;

      await showSSODialog(
        context,
        title: 'บันทึกข้อมูลเรียบร้อยแล้ว',
        message: 'ข้อมูลที่อยู่ของท่านได้รับการบันทึกลงในระบบเรียบร้อยแล้ว',
        type: SSODialogType.success,
        confirmText: 'ตกลง',
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error saving address: $e');
      if (mounted) {
        await showSSODialog(
          context,
          title: 'เกิดข้อผิดพลาด',
          message: 'ไม่สามารถบันทึกข้อมูลที่อยู่ได้ กรุณาลองใหม่อีกครั้ง',
          type: SSODialogType.error,
          confirmText: 'ตกลง',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        title: const Text(
          'ที่อยู่ของฉัน',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102F30),
            fontFamily: 'Kanit',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF005C9E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Permanent Address
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF005C9E).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.home_outlined,
                                    color: Color(0xFF005C9E), size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'ที่อยู่ตามทะเบียนบ้าน',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102F30),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField('บ้านเลขที่ / อาคาร / ห้อง', _houseNoController),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('หมู่ที่ / ซอย', _villageController)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField('ถนน', _roadController)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('ตำบล / แขวง', _subDistrictController)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField('อำเภอ / เขต', _districtController)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('จังหวัด', _provinceController)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(
                                  'รหัสไปรษณีย์',
                                  _zipCodeController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Contact / Current Address
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00897B).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.markunread_mailbox_outlined,
                                    color: Color(0xFF00897B), size: 22),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'ที่อยู่สำหรับติดต่อและจัดส่งเอกสาร',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF102F30),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: const Color(0xFF005C9E),
                            title: const Text(
                              'ใช้ที่อยู่เดียวกับที่อยู่ตามทะเบียนบ้าน',
                              style: TextStyle(fontSize: 14),
                            ),
                            value: _sameAsPermanent,
                            onChanged: (val) {
                              setState(() => _sameAsPermanent = val ?? true);
                            },
                          ),
                          if (!_sameAsPermanent) ...[
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _currentAddressController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'ระบุที่อยู่ปัจจุบัน / ที่อยู่จัดส่งเอกสาร',
                                filled: true,
                                fillColor: const Color(0xFFF9FAFC),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (val) {
                                if (!_sameAsPermanent && (val == null || val.isEmpty)) {
                                  return 'กรุณาระบุที่อยู่ปัจจุบัน';
                                }
                                return null;
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005C9E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 1,
                        ),
                        onPressed: _isSaving ? null : _saveAddressData,
                        child: _isSaving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'บันทึกข้อมูลที่อยู่',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'กรุณากรอกข้อมูล';
        }
        return null;
      },
    );
  }
}
