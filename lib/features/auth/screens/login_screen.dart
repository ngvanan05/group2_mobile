import 'package:flutter/material.dart';
import 'package:group2_mobile/features/auth/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng LayoutBuilder để xác định kích thước màn hình
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Nếu màn hình rộng hơn 800px, chúng ta coi là Desktop/Tablet ngang
          bool isWideScreen = constraints.maxWidth > 800;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                constraints: BoxConstraints(
                  // Nếu màn hình rộng thì container to hơn, nếu hẹp thì tối đa 430px
                  maxWidth: isWideScreen ? 900 : 430,
                ),
                padding: const EdgeInsets.all(30),
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
                  ? Row( // Chế độ màn hình ngang
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildLogoSection()),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: VerticalDivider(thickness: 1),
                        ),
                        Expanded(child: _buildFormSection()),
                      ],
                    )
                  : Column( // Chế độ màn hình dọc (Mobile)
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLogoSection(),
                        const SizedBox(height: 40),
                        _buildFormSection(),
                      ],
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Tách riêng phần Logo để tái sử dụng
  Widget _buildLogoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF192580),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.apartment, color: Colors.white, size: 60),
        ),
        const SizedBox(height: 20),
        const Text(
          "FP FourPoint Hotel",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF192580),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Hệ thống quản lý khách sạn thông minh",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // Tách riêng phần Form đăng nhập
  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Đăng nhập",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 25),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(
                controller: emailController,
                label: "Email",
                hint: "Email của bạn",
                icon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập email";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildInput(
                controller: passwordController,
                label: "Mật khẩu",
                hint: "Mật khẩu",
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Vui lòng nhập mật khẩu";
                  return null;
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text("Quên mật khẩu?", style: TextStyle(color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading ? null : handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF192580),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text("Đăng nhập", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 25),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Hoặc", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _socialButton("Google", Icons.g_mobiledata)),
            const SizedBox(width: 12),
            Expanded(child: _socialButton("Facebook", Icons.facebook)),
          ],
        ),
        const SizedBox(height: 25),
        Center(
          child: Wrap( // Wrap để tránh tràn chữ trên màn hình cực nhỏ
            alignment: WrapAlignment.center,
            children: [
              const Text("Chưa có tài khoản? "),
              GestureDetector(
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                child: const Text(
                  "Đăng ký ngay",
                  style: TextStyle(color: Color(0xFF192580), fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? isObscure : false,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => isObscure = !isObscure),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _socialButton(String text, IconData icon) {
    return InkWell( // Dùng InkWell để có hiệu ứng bấm
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 6),
            Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}