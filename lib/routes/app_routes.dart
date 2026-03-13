import 'package:flutter/material.dart';
import '../models/insurance_plan_model.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/phone_sign_in_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/create_account_screen.dart';
import '../screens/auth/verify_email_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/simple_sign_up_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/forgot_password_otp_screen.dart';
import '../screens/auth/create_new_password_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/invite_friends/invite_friends_screen.dart';
import '../screens/feedback/feedback_screen.dart';
import '../screens/health_insurance/health_insurance_step1_screen.dart';
import '../screens/health_insurance/health_insurance_step2_screen.dart';
import '../screens/health_insurance/health_insurance_step3_screen.dart';
import '../screens/health_insurance/health_insurance_step4_screen.dart';
import '../screens/motor_insurance/motor_insurance_step1_screen.dart';
import '../screens/motor_insurance/motor_insurance_step2_screen.dart';
import '../screens/insurance_quotes/insurance_quotes_screen.dart';
import '../screens/package_details/package_details_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/subscription/subscription_screen.dart';
import '../screens/my_insurance/my_insurance_screen.dart';
import '../screens/hospitals/hospitals_screen.dart';
import '../screens/econsultation/econsultation_screen.dart';
import '../screens/my_policies/my_policies_screen.dart';
import '../screens/reminders/reminders_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/pending_orders/pending_orders_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/about/about_us_screen.dart';
import '../screens/legal/terms_conditions_screen.dart';
import '../screens/legal/privacy_policy_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String phoneSignIn = '/phone-sign-in';
  static const String otpVerification = '/otp-verification';
  static const String createAccount = '/create-account';
  static const String verifyEmail = '/verify-email';
  static const String login = '/login';
  static const String simpleSignUp = '/simple-sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordOtp = '/forgot-password-otp';
  static const String createNewPassword = '/create-new-password';
  static const String dashboard = '/dashboard';
  static const String settingsScreen = '/settings';
  static const String inviteFriends = '/invite-friends';
  static const String feedback = '/feedback';
  static const String healthInsuranceStep1 = '/health-insurance-step1';
  static const String healthInsuranceStep2 = '/health-insurance-step2';
  static const String healthInsuranceStep3 = '/health-insurance-step3';
  static const String healthInsuranceStep4 = '/health-insurance-step4';
  static const String motorInsuranceStep1 = '/motor-insurance-step1';
  static const String motorInsuranceStep2 = '/motor-insurance-step2';
  static const String insuranceQuotes = '/insurance-quotes';
  static const String packageDetails = '/package-details';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String subscription = '/subscription';
  static const String myInsurance = '/my-insurance';
  static const String hospitals = '/hospitals';
  static const String econsultation = '/econsultation';
  static const String myPolicies = '/my-policies';
  static const String reminders = '/reminders';
  static const String wallet = '/wallet';
  static const String pendingOrders = '/pending-orders';
  static const String help = '/help';
  static const String aboutUs = '/about-us';
  static const String termsConditions = '/terms-conditions';
  static const String privacyPolicy = '/privacy-policy';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case phoneSignIn:
        return MaterialPageRoute(builder: (_) => const PhoneSignInScreen());
      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
          ),
        );
      case createAccount:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CreateAccountScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
          ),
        );
      case verifyEmail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(
            email: args?['email'] ?? '',
          ),
        );
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case simpleSignUp:
        return MaterialPageRoute(builder: (_) => const SimpleSignUpScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case forgotPasswordOtp:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordOtpScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
          ),
        );
      case createNewPassword:
        return MaterialPageRoute(
            builder: (_) => const CreateNewPasswordScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case settingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case inviteFriends:
        return MaterialPageRoute(builder: (_) => const InviteFriendsScreen());
      case feedback:
        return MaterialPageRoute(builder: (_) => const FeedbackScreen());
      case healthInsuranceStep1:
        return MaterialPageRoute(
            builder: (_) => const HealthInsuranceStep1Screen());
      case healthInsuranceStep2:
        return MaterialPageRoute(
            builder: (_) => const HealthInsuranceStep2Screen());
      case healthInsuranceStep3:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => HealthInsuranceStep3Screen(
            members: (args?['members'] as List<String>?) ?? ['Self'],
          ),
        );
      case healthInsuranceStep4:
        return MaterialPageRoute(
            builder: (_) => const HealthInsuranceStep4Screen());
      case motorInsuranceStep1:
        return MaterialPageRoute(
            builder: (_) => const MotorInsuranceStep1Screen());
      case motorInsuranceStep2:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MotorInsuranceStep2Screen(
            brand: args?['brand'] ?? '',
          ),
        );
      case insuranceQuotes:
        return MaterialPageRoute(
            builder: (_) => const InsuranceQuotesScreen());
      case packageDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (_) => PackageDetailsScreen(
              plan: args?['plan'] as InsurancePlanModel?,
            ));
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case payment:
        return MaterialPageRoute(
          builder: (_) => const PaymentScreen(),
          settings: settings,
        );
      case subscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      case myInsurance:
        return MaterialPageRoute(builder: (_) => const MyInsuranceScreen());
      case hospitals:
        return MaterialPageRoute(builder: (_) => const HospitalsScreen());
      case econsultation:
        return MaterialPageRoute(builder: (_) => const EConsultationScreen());
      case myPolicies:
        return MaterialPageRoute(builder: (_) => const MyPoliciesScreen());
      case reminders:
        return MaterialPageRoute(builder: (_) => const RemindersScreen());
      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case pendingOrders:
        return MaterialPageRoute(builder: (_) => const PendingOrdersScreen());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case aboutUs:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());
      case termsConditions:
        return MaterialPageRoute(builder: (_) => const TermsConditionsScreen());
      case privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
