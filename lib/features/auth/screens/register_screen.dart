import 'package:flutter/material.dart';
import '../../../core/widgets/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final Color primaryColor = const Color(0xFF192580);
  final Color backgroundColor = const Color(0xFFF6F6F8);

  bool isObscure = true;
  bool isLoading = false;

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng ký thành công")),
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 850;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 1000 : 450,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    )
                  ],
                ),
                child: isWideScreen
                    ? Row(
                        children: [
                          Expanded(child: _buildInfoSide()),
                          Container(width: 1, height: 600, color: Colors.grey.shade100),
                          Expanded(child: _buildFormSide()),
                        ],
                      )
                    : _buildFormSide(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSide() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'FP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "FourPoint Hotel",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Gia nhập cộng đồng quản lý khách sạn chuyên nghiệp.\nĐăng ký để bắt đầu ngay.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blueGrey.shade400,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSide() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                "← Quay lại",
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Đăng ký",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 32),
            
            _buildInput(
              controller: nameController,
              label: "Họ và tên",
              hint: "Nhập họ và tên đầy đủ",
              validator: (value) => value!.isEmpty ? "Vui lòng nhập tên" : null,
            ),
            _buildInput(
              controller: emailController,
              label: "Email",
              hint: "alex.thompson@fourpoint.com",
              validator: (value) => (value == null || !value.contains("@")) ? "Email không hợp lệ" : null,
            ),
            _buildInput(
              controller: phoneController,
              label: "Số điện thoại",
              hint: "Nhập số điện thoại liên lạc",
              validator: (value) => value!.length < 9 ? "SĐT không hợp lệ" : null,
            ),
            _buildInput(
              controller: passwordController,
              label: "Mật khẩu",
              hint: "••••••",
              isPassword: true,
              validator: (value) => value!.length < 6 ? "Ít nhất 6 ký tự" : null,
            ),
            _buildInput(
              controller: confirmPasswordController,
              label: "Xác nhận mật khẩu",
              hint: "••••••",
              isPassword: true,
              validator: (value) => value != passwordController.text ? "Mật khẩu không khớp" : null,
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("ĐĂNG KÝ NGAY", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text.rich(
                  TextSpan(
                    text: "Đã có tài khoản? ",
                    style: const TextStyle(color: Colors.blueGrey),
                    children: [
                      TextSpan(
                        text: "Đăng nhập",
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(), 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey, letterSpacing: 1.2)
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? isObscure : false,
            validator: validator,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.blueGrey.shade200, fontSize: 14),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: primaryColor.withOpacity(0.5)),
                      onPressed: () => setState(() => isObscure = !isObscure),
                    )
                  : null,
              filled: true,
              fillColor: Colors.blueGrey.shade50.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}