import 'package:flutter/material.dart';
// Andrew nhớ kiểm tra lại đường dẫn import này nhé
import 'register_screen.dart';
import 'setting_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final Color primaryColor = const Color(0xFF192580);
  final Color backgroundColor = const Color(0xFFF6F6F8);

  bool isObscure = true;
  bool isLoading = false;

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng nhập thành công")),
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 900 : 450,
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
                  ? IntrinsicHeight( // Để Divider cao bằng nội dung
                      child: Row(
                        children: [
                          Expanded(child: _buildLogoSection()),
                          VerticalDivider(width: 1, thickness: 1, color: Colors.blueGrey.shade50),
                          Expanded(child: _buildFormSection()),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLogoSection(),
                          const SizedBox(height: 20),
                          _buildFormSection(),
                        ],
                      ),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "FOURpoint",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Hệ thống quản lý\nkhách sạn thông minh",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Đăng nhập",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 32),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildInput(
                  controller: emailController,
                  label: "Email",
                  hint: "alex.thompson@fourpoint.com",
                  validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập email" : null,
                ),
                _buildInput(
                  controller: passwordController,
                  label: "Mật khẩu",
                  hint: "••••••",
                  isPassword: true,
                  validator: (value) => (value == null || value.isEmpty) ? "Vui lòng nhập mật khẩu" : null,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text("Quên mật khẩu?", style: TextStyle(color: primaryColor.withOpacity(0.6))),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("ĐĂNG NHẬP", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("HOẶC", style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade300, fontWeight: FontWeight.bold)),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _socialButton("Google", Icons.g_mobiledata)),
              const SizedBox(width: 12),
              Expanded(child: _socialButton("Facebook", Icons.facebook)),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
              },
              child: Text.rich(
                TextSpan(
                  text: "Chưa có tài khoản? ",
                  style: const TextStyle(color: Colors.blueGrey),
                  children: [
                    TextSpan(
                      text: "Đăng ký ngay",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: isPassword ? isObscure : false,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.blueGrey.shade200, fontSize: 14),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(String text, IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
          ],
        ),
      ),
    );
  }
}