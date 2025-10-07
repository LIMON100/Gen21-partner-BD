import 'package:get/get.dart' show GetPage, Transition;

import '../middlewares/auth_middleware.dart';
import '../modules/WebView/bindings/custom_webview_binding.dart';
import '../modules/WebView/custom_webview.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/phone_verification_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/bookings/bindings/booking_binding.dart';
import '../modules/bookings/views/booking_details_view.dart';
import '../modules/bookings/views/booking_view.dart';
import '../modules/bookings/views/bookings_view_new.dart';
import '../modules/custom_pages/bindings/custom_pages_binding.dart';
import '../modules/custom_pages/views/custom_pages_view.dart';
import '../modules/e_services/bindings/e_services_binding.dart';
import '../modules/e_services/views/e_service_form_view.dart';
import '../modules/e_services/views/e_service_view.dart';
import '../modules/e_services/views/e_services_view.dart';
import '../modules/e_services/views/options_form_view.dart';
import '../modules/gallery/bindings/gallery_binding.dart';
import '../modules/gallery/views/gallery_view.dart';
import '../modules/global_widgets/no_internet_connection.dart';
import '../modules/help_privacy/bindings/help_privacy_binding.dart';
import '../modules/help_privacy/views/help_screen_view.dart';
import '../modules/help_privacy/views/help_view.dart';
import '../modules/help_privacy/views/privacy_view.dart';
import '../modules/messages/views/chats_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/onboard/OnboardingScreen.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reviews/views/review_view.dart';
import '../modules/root/bindings/root_binding.dart';
import '../modules/root/views/root_view.dart';
import '../modules/search/views/search_view.dart';
import '../modules/service_request/bindings/service_request_binding.dart';
import '../modules/service_request/views/service_request_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/addresses_view.dart';
import '../modules/settings/views/language_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_mode_view.dart';
import '../modules/update_provider/bindings/update_profile_binding.dart';
import '../modules/update_provider/views/update_provider_info_view.dart';
import '../testing2/example_page.dart';
import 'app_routes.dart';

class Theme1AppPages {
  // static const INITIAL = Routes.ROOT;
  // static const INITIAL2 = Routes.ROOT2;
  static const NO_INTERNET = Routes.NO_INTERNET;

  static final routes = [
    // GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.ROOT, page: () => ExampleApp(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    // GetPage(name: Routes.ROOT2, page: () => ExampleApp(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.CHAT, page: () => ChatsView(), binding: RootBinding()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_LANGUAGE, page: () => LanguageView(), binding: SettingsBinding()),
    GetPage(name: Routes.PROFILE, page: () => ProfileView(), binding: ProfileBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding()),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding()),
    GetPage(name: Routes.FORGOT_PASSWORD, page: () => ForgotPasswordView(), binding: AuthBinding()),
    GetPage(name: Routes.PHONE_VERIFICATION, page: () => PhoneVerificationView(), binding: AuthBinding()),
    GetPage(name: Routes.E_SERVICE, page: () => EServiceView(), binding: EServicesBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.SERVICE_REQUESTS, page: () => ServiceRequestsView(), binding: ServiceRequestsBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.E_SERVICE_FORM, page: () => EServiceFormView(), binding: EServicesBinding()),
    GetPage(name: Routes.OPTIONS_FORM, page: () => OptionsFormView(), binding: EServicesBinding()),
    GetPage(name: Routes.E_SERVICES, page: () => EServicesView(), binding: EServicesBinding()),
    GetPage(name: Routes.SEARCH, page: () => SearchView(), binding: RootBinding(), transition: Transition.downToUp),
    GetPage(name: Routes.NOTIFICATIONS, page: () => NotificationsView(), binding: NotificationsBinding()),
    GetPage(name: Routes.PRIVACY, page: () => PrivacyView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.HELP, page: () => HelpView(), binding: HelpPrivacyBinding()),
    GetPage(name: Routes.CUSTOM_PAGES, page: () => CustomPagesView(), binding: CustomPagesBinding()),
    GetPage(name: Routes.CUSTOM_WEBVIEW, page: () => CustomWebView(), binding: CustomWebViewBinding()),

    GetPage(name: Routes.REVIEW, page: () => ReviewView(), binding: RootBinding()),
    // GetPage(name: Routes.BOOKING, page: () => BookingView(), binding: RootBinding()),
    GetPage(name: Routes.BOOKINGS_NEW, page: () => BookingsViewNew(), binding: BookingBinding()),
    GetPage(name: Routes.BOOKING_DETAILS, page: () => BookingDetailsView(), binding: RootBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.GALLERY, page: () => GalleryView(), binding: GalleryBinding(), transition: Transition.fadeIn),
    GetPage(name: Routes.NO_INTERNET, page: () => NoInternetConnection()),
    GetPage(name: Routes.SETTINGS_ADDRESSES, page: () => AddressesView(), binding: SettingsBinding(), middlewares: [AuthMiddleware()]),
    GetPage(name: Routes.updateProviderInfo, page: () => UpdateProviderInfoView(), binding: UpdateProfileBinding()),

    GetPage(name: Routes.ONBOARDING, page: () => OnboardingScreen()),
  ];
}
