    import 'package:flutter/material.dart';
    // ignore: unused_import
    import 'package:good2go_app/sender/sender_home.dart';
    import 'package:good2go_app/register_chose.dart';
    import 'package:good2go_app/rider/rider_send_state.dart';
    import 'package:good2go_app/services/apiServices.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
    import 'package:provider/provider.dart' as provider;
    
    void main() {
      runApp(
        riverpod.ProviderScope(
          child: provider.ChangeNotifierProvider<AppState>(
            create: (_) => AppState(),
            child: const MyApp(),
          ),
        ),
      );
    }
    
    class AppState extends ChangeNotifier {
      // Add your app state variables and methods here
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Good2Go',
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
        );
      }
    }
    
    class SplashScreen extends StatefulWidget {
      const SplashScreen({super.key});
    
      @override
      State<SplashScreen> createState() => _SplashScreenState();
    }
    
    class _SplashScreenState extends State<SplashScreen> {
      @override
      void initState() {
        super.initState();
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        });
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE6E6FA), // Light lavender
                  Color(0xFF5300F9), // Deep purple
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'Good2Go',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
    }
    
    class LoginPage extends riverpod.ConsumerStatefulWidget {
      const LoginPage({super.key});
    
      @override
      riverpod.ConsumerState<LoginPage> createState() => _LoginPageState();
    }
    
    class _LoginPageState extends riverpod.ConsumerState<LoginPage> {
      final TextEditingController _phoneController = TextEditingController();
      final TextEditingController _passwordController = TextEditingController();
      bool _isLoading = false;
      String? _errorMessage;
    
      @override
      void dispose() {
        _phoneController.dispose();
        _passwordController.dispose();
        super.dispose();
      }
    
      Future<void> _login() async {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
        try {
          final apiService = ref.read(apiServiceProvider);
          await apiService.login(
            _phoneController.text,
            _passwordController.text,
          );
          // Handle successful login
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SenderHome()),
            );
          }
        } catch (e) {
          setState(() {
            _errorMessage = 'An error occurred. Please try again.';
          });
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE6E6FA), // Light lavender
                  Color(0xFF5300F9), // Deep purple
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Good2Go',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'เบอร์โทรศัพท์',
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontFamily: 'Roboto'),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'รหัสผ่าน',
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontFamily: 'Roboto'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF5300F9),
                                    minimumSize: const Size(double.infinity, 50),
                                  ),
                                  child: const Text(
                                    'เข้าสู่ระบบ',
                                    style: TextStyle(fontFamily: 'Roboto'),
                                  ),
                                ),
                          const SizedBox(height: 10),
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterSelectPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF5300F9),
                            ),
                            child: const Text(
                              'สมัครสมาชิก',
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }