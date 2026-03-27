import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF0F2F5), // Màu nền nhẹ nhàng hơn
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 850;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 1000 : 500,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: isWideScreen
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildInfoSide()),
                          const VerticalDivider(width: 1),
                          Expanded(child: _buildFormSide()),
                        ],
                      )
                    : _buildFormSide(), // Mobile thì chỉ hiện Form
              ),
            ),
          );
        },
      ),
    );
  }

  // Phần hiển thị thông tin bên trái (chỉ xuất hiện trên màn hình rộng)
  Widget _buildInfoSide() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF192580),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.apartment, color: Colors.white, size: 80),
          ),
          const SizedBox(height: 30),
          const Text(
            "FourPoint Hotel",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF192580),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Gia nhập cộng đồng quản lý khách sạn chuyên nghiệp. Đăng ký ngay để trải nghiệm các tính năng tuyệt vời.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }

  // Phần Form đăng ký
  Widget _buildFormSide() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút quay lại cho Mobile hoặc khi cần
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            const SizedBox(height: 10),
            const Text(
              "Đăng ký tài khoản",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("Vui lòng điền thông tin bên dưới", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            _buildInput(
              controller: nameController,
              label: "Họ và tên",
              hint: "Nhập họ và tên",
              icon: Icons.person_outline,
              validator: (value) => value!.isEmpty ? "Vui lòng nhập tên" : null,
            ),
            _buildInput(
              controller: emailController,
              label: "Email",
              hint: "example@gmail.com",
              icon: Icons.email_outlined,
              validator: (value) => (value == null || !value.contains("@")) ? "Email không hợp lệ" : null,
            ),
            _buildInput(
              controller: phoneController,
              label: "Số điện thoại",
              hint: "Nhập số điện thoại",
              icon: Icons.phone_android_outlined,
              validator: (value) => value!.length < 9 ? "SĐT không hợp lệ" : null,
            ),
            _buildInput(
              controller: passwordController,
              label: "Mật khẩu",
              hint: "******",
              icon: Icons.lock_outline,
              isPassword: true,
              validator: (value) => value!.length < 6 ? "Ít nhất 6 ký tự" : null,
            ),
            _buildInput(
              controller: confirmPasswordController,
              label: "Xác nhận mật khẩu",
              hint: "******",
              icon: Icons.lock_reset_outlined,
              isPassword: true,
              validator: (value) => value != passwordController.text ? "Mật khẩu không khớp" : null,
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF192580),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Đăng ký", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    text: "Đã có tài khoản? ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Đăng nhập ngay",
                        style: TextStyle(color: Color(0xFF192580), fontWeight: FontWeight.bold),
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
    required IconData icon,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? isObscure : false,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, size: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, size: 20),
                      onPressed: () => setState(() => isObscure = !isObscure),
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(height: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}