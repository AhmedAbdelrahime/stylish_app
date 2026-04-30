import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(Localizations.localeOf(context));
  }

  String translate(String key, [Map<String, Object?> values = const {}]) {
    var value =
        _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;

    for (final entry in values.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value.toString());
    }

    return value;
  }
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String tr(String key, [Map<String, Object?> values = const {}]) {
    return l10n.translate(key, values);
  }

  bool get isArabicLocale => l10n.locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

const Map<String, Map<String, String>> _localizedValues = {
  'en': {},
  'ar': {
    'English': 'الإنجليزية',
    'Arabic': 'العربية',
    'Language': 'اللغة',
    'Choose the app language': 'اختر لغة التطبيق',
    'Home': 'الرئيسية',
    'Cart': 'السلة',
    'Search': 'البحث',
    'Account': 'الحساب',
    'Settings': 'الإعدادات',
    'Wishlist': 'المفضلة',
    'My Orders': 'طلباتي',
    'Logout': 'تسجيل الخروج',
    'Menu': 'القائمة',
    'Account, language, support, and order shortcuts.':
        'الحساب واللغة والدعم واختصارات الطلبات.',
    'Shortcuts': 'اختصارات',
    'Quick Actions': 'إجراءات سريعة',
    'Open the sections people usually need most.':
        'افتح الأقسام التي تحتاجها غالبا بسرعة.',
    'See your saved items': 'شاهد المنتجات المحفوظة',
    'Review your bag items': 'راجع عناصر السلة',
    'Track status and delivery': 'تابع الحالة والتوصيل',
    'Manage profile and address': 'إدارة الملف الشخصي والعنوان',
    'Manage profile, address, and payment':
        'إدارة الملف الشخصي والعنوان والدفع',
    'Sign out of this account': 'الخروج من هذا الحساب',
    'Shop By Category': 'تسوق حسب الفئة',
    'Start with a department and explore curated products.':
        'ابدأ بقسم واستكشف منتجات مختارة.',
    'Trending Now': 'الأكثر رواجا الآن',
    'Popular picks customers are opening first.':
        'اختيارات شائعة يفتحها العملاء أولا.',
    'More products selected from this category.':
        'منتجات أخرى مختارة من هذه الفئة.',
    'No categories found': 'لا توجد فئات',
    'Loading categories...': 'جاري تحميل الفئات...',
    'No offers found': 'لا توجد عروض',
    'Loading offers...': 'جاري تحميل العروض...',
    'No products found': 'لا توجد منتجات',
    'Loading products...': 'جاري تحميل المنتجات...',
    'View All': 'عرض الكل',
    'Discover Products': 'استكشف المنتجات',
    'Use sorting and filters to narrow the catalog fast.':
        'استخدم الترتيب والفلاتر للوصول للمنتج بسرعة.',
    'Browsing {category} products with quick controls.':
        'تصفح منتجات {category} مع أدوات تحكم سريعة.',
    'Search products, styles, and brands':
        'ابحث عن المنتجات والأنماط والماركات',
    'Search for products, brands, and styles':
        'ابحث عن المنتجات والماركات والأنماط',
    'Sort Products': 'ترتيب المنتجات',
    'Filter Products': 'تصفية المنتجات',
    'Minimum Rating': 'أقل تقييم',
    'Budget friendly: under {amount}': 'مناسب للميزانية: أقل من {amount}',
    'Only show top rated products (4.0+)':
        'عرض المنتجات الأعلى تقييما فقط (4.0+)',
    'Apply': 'تطبيق',
    'Featured': 'مميز',
    'Price: Low to High': 'السعر: من الأقل للأعلى',
    'Price: High to Low': 'السعر: من الأعلى للأقل',
    'Top Rated': 'الأعلى تقييما',
    'Name': 'الاسم',
    'Filter': 'فلتر',
    'Filter ({count})': 'فلتر ({count})',
    'No products match these filters': 'لا توجد منتجات تطابق هذه الفلاتر',
    'Try a broader search, lower the minimum rating, or clear active filters.':
        'جرب بحثا أوسع، أو خفض أقل تقييم، أو امسح الفلاتر النشطة.',
    'Welcome': 'مرحبا',
    'Back!': 'بعودتك!',
    'Login': 'تسجيل الدخول',
    'Create Account': 'إنشاء حساب',
    'Submit': 'إرسال',
    'Update Password': 'تحديث كلمة المرور',
    'Username or Email': 'اسم المستخدم أو البريد الإلكتروني',
    'Password': 'كلمة المرور',
    'Confirm Password': 'تأكيد كلمة المرور',
    'Full Name': 'الاسم بالكامل',
    'Email': 'البريد الإلكتروني',
    'Forget Password?': 'نسيت كلمة المرور؟',
    'By creating an account, you agree to the app terms and privacy policy.':
        'بإنشاء حساب، أنت توافق على شروط التطبيق وسياسة الخصوصية.',
    'Please enter your email or username':
        'من فضلك أدخل البريد الإلكتروني أو اسم المستخدم',
    'Email or username cannot be more than 50 characters':
        'لا يمكن أن يتجاوز البريد أو اسم المستخدم 50 حرفا',
    'Email or username must be at least 5 characters':
        'يجب ألا يقل البريد أو اسم المستخدم عن 5 أحرف',
    'Please enter your password': 'من فضلك أدخل كلمة المرور',
    'Password must be at least 8 characters':
        'يجب ألا تقل كلمة المرور عن 8 أحرف',
    'Password cannot be more than 20 characters':
        'لا يمكن أن تتجاوز كلمة المرور 20 حرفا',
    'Please enter your full name': 'من فضلك أدخل الاسم بالكامل',
    'Full name must be at least 2 characters': 'يجب ألا يقل الاسم عن حرفين',
    'Full name cannot be more than 50 characters':
        'لا يمكن أن يتجاوز الاسم 50 حرفا',
    'Please enter your email': 'من فضلك أدخل البريد الإلكتروني',
    'Please enter a valid email address': 'من فضلك أدخل بريدا إلكترونيا صحيحا',
    'Email cannot be more than 100 characters':
        'لا يمكن أن يتجاوز البريد الإلكتروني 100 حرف',
    'Please confirm your password': 'من فضلك أكد كلمة المرور',
    'Passwords do not match': 'كلمتا المرور غير متطابقتين',
    'Personal Details': 'البيانات الشخصية',
    'UserName': 'اسم المستخدم',
    'Contact Number': 'رقم الهاتف',
    'Business Address Details': 'بيانات عنوان التوصيل',
    'Pincode': 'الرمز البريدي',
    ' Address': 'العنوان',
    ' City': 'المدينة',
    ' State': 'المحافظة',
    'Country': 'الدولة',
    'Detecting': 'جاري التحديد',
    'Use GPS': 'استخدم GPS',
    'Pick Map': 'اختيار من الخريطة',
    'Profile updated successfully.': 'تم تحديث الملف الشخصي بنجاح.',
    'Address detected successfully.': 'تم تحديد العنوان بنجاح.',
    'Could not detect your address.': 'تعذر تحديد عنوانك.',
    'Address selected from map.': 'تم اختيار العنوان من الخريطة.',
    'Track delivery status and payment details':
        'تابع حالة التوصيل وتفاصيل الدفع',
    'update Profile ': 'تحديث الملف ',
    'Shopping Bag': 'حقيبة التسوق',
    'Checkout': 'الدفع',
    'Total Payable': 'الإجمالي المستحق',
    'Start by adding products': 'ابدأ بإضافة المنتجات',
    'Add an address before checkout': 'أضف عنوانا قبل الدفع',
    'Standard delivery available': 'التوصيل العادي متاح',
    'Review saved items, update quantities, and move to checkout when everything looks right.':
        'راجع العناصر المحفوظة، وعدل الكميات، ثم انتقل للدفع عندما يصبح كل شيء جاهزا.',
    '{count} items': '{count} عناصر',
    '{amount} saved': 'وفرت {amount}',
    'No active savings': 'لا توجد خصومات نشطة',
    'Delivery Address': 'عنوان التوصيل',
    'Add': 'إضافة',
    'Edit': 'تعديل',
    'No address selected yet': 'لم يتم اختيار عنوان بعد',
    'Add your delivery address in Settings so checkout can calculate the right destination.':
        'أضف عنوان التوصيل في الإعدادات حتى يتم تحديد وجهة الطلب بشكل صحيح.',
    'Add your delivery address in Account so checkout can calculate the right destination.':
        'أضف عنوان التوصيل في الحساب حتى يتم تحديد وجهة الطلب بشكل صحيح.',
    'Open Settings': 'فتح الإعدادات',
    'Open Account': 'فتح الحساب',
    'Delivery destination': 'وجهة التوصيل',
    'Delivery Details': 'تفاصيل التوصيل',
    'Add products to see a live order summary here.':
        'أضف منتجات لعرض ملخص الطلب هنا.',
    'Shipping is {fee} for this order. Item pricing and discounts are pulled from your real product data.':
        'تكلفة التوصيل لهذا الطلب {fee}. الأسعار والخصومات مأخوذة من بيانات المنتجات الفعلية.',
    'Bag Items': 'عناصر السلة',
    '{count} products': '{count} منتجات',
    'We could not load your cart': 'تعذر تحميل السلة',
    'Try Again': 'حاول مرة أخرى',
    'Your cart is empty': 'سلتك فارغة',
    'Products you add from the catalog will appear here with their real pricing and stock status.':
        'المنتجات التي تضيفها من الكتالوج ستظهر هنا بأسعارها وحالة المخزون.',
    'Order Summary': 'ملخص الطلب',
    'Subtotal': 'المجموع الفرعي',
    'Shipping': 'الشحن',
    'Savings': 'التوفير',
    'Total': 'الإجمالي',
    'Remove': 'إزالة',
    'Order Amount': 'قيمة الطلب',
    'Delivery Fee': 'رسوم التوصيل',
    'Discount': 'الخصم',
    'Order Total': 'إجمالي الطلب',
    'Enter coupon code': 'أدخل كود الخصم',
    'Done': 'تم',
    'Track Order': 'تتبع الطلب',
    'Order Details': 'تفاصيل الطلب',
    'Order unavailable': 'الطلب غير متاح',
    'Items': 'العناصر',
    'Order placed': 'تم إنشاء الطلب',
    'We received your order.': 'استلمنا طلبك.',
    'Packed': 'تم التجهيز',
    'Your items are being prepared.': 'يتم تجهيز منتجاتك.',
    'Shipped': 'تم الشحن',
    'The order is on the way.': 'الطلب في الطريق.',
    'Delivered': 'تم التوصيل',
    'The order reached your address.': 'وصل الطلب إلى عنوانك.',
    'Tracking': 'التتبع',
    'Payment Summary': 'ملخص الدفع',
    'Orders could not load': 'تعذر تحميل الطلبات',
    'No orders yet': 'لا توجد طلبات بعد',
    'Delivery Location': 'موقع التوصيل',
    'GPS': 'GPS',
    'Phone number': 'رقم الهاتف',
    'Sign in again to save your number.': 'سجل الدخول مرة أخرى لحفظ رقمك.',
    'Contact number saved.': 'تم حفظ رقم الهاتف.',
    'Add your delivery address in Settings first.':
        'أضف عنوان التوصيل في الإعدادات أولا.',
    'Add your delivery address in Account first.':
        'أضف عنوان التوصيل في الحساب أولا.',
    'Your cart is empty.': 'سلتك فارغة.',
    'View Cart': 'عرض السلة',
    'Add to Cart': 'إضافة للسلة',
    'Buy Now': 'اشتر الآن',
    'Size': 'المقاس',
    'Quantity': 'الكمية',
    'Product Details': 'تفاصيل المنتج',
    'Similar Products': 'منتجات مشابهة',
    'Reviews': 'التقييمات',
    'Delivery': 'التوصيل',
    'Cash on Delivery': 'الدفع عند الاستلام',
    'Contact us': 'تواصل معنا',
    'Payment Details': 'تفاصيل الدفع',
    'Add Payment Card': 'إضافة بطاقة دفع',
    'Change Password': 'تغيير كلمة المرور',
    'Cancel': 'إلغاء',
    'Save': 'حفظ',
    'Confirm Logout': 'تأكيد تسجيل الخروج',
    'Are you sure you want to logout?': 'هل أنت متأكد من تسجيل الخروج؟',
    'Are you sure you want to delete this card?':
        'هل أنت متأكد من حذف هذه البطاقة؟',
    'Go Back': 'رجوع',
    'Delete': 'حذف',
    'Logout ': 'تسجيل الخروج ',
    'Address location': 'موقع العنوان',
    'Accurate delivery details for faster order handling.':
        'تفاصيل توصيل دقيقة لمعالجة الطلب بشكل أسرع.',
    'See all': 'عرض الكل',
    'Products': 'المنتجات',
    'Sort': 'ترتيب',
    'Refined collections with a cleaner storefront layout.':
        'تشكيلات منسقة بواجهة متجر أكثر وضوحا.',
    'Back': 'رجوع',
    'Create An Account': 'إنشاء حساب',
    'Create an ': 'إنشاء ',
    'account': 'حساب',
    'Sign Up': 'تسجيل',
    'I Already Have an Account': 'لدي حساب بالفعل',
    'Forgot': 'نسيت',
    'password?': 'كلمة المرور؟',
    'Reset': 'إعادة تعيين',
    'Enter your email address': 'أدخل بريدك الإلكتروني',
    'Please enter your email ': 'من فضلك أدخل بريدك الإلكتروني',
    'Email  cannot be more than 50 characters':
        'لا يمكن أن يتجاوز البريد الإلكتروني 50 حرفا',
    'Email  must be at least 5 characters':
        'يجب ألا يقل البريد الإلكتروني عن 5 أحرف',
    'We will send you a message to set or reset your new password':
        'سنرسل لك رسالة لتعيين أو إعادة تعيين كلمة المرور الجديدة',
    'Reset Password': 'إعادة تعيين كلمة المرور',
    'Enter New Password': 'أدخل كلمة مرور جديدة',
    ' Confirm Password': 'تأكيد كلمة المرور',
    'Password must Machted ': 'يجب أن تكون كلمة المرور متطابقة',
    '- OR Continue with -': '- أو المتابعة باستخدام -',
    'Login successful': 'تم تسجيل الدخول بنجاح',
    'Account created successfully': 'تم إنشاء الحساب بنجاح',
    'Password reset email sent': 'تم إرسال بريد إعادة تعيين كلمة المرور',
    'Password updated successfully': 'تم تحديث كلمة المرور بنجاح',
    'Password updateded Please login again.':
        'تم تحديث كلمة المرور. من فضلك سجل الدخول مرة أخرى.',
    'Email or password is incorrect':
        'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'This account is still unconfirmed in Supabase. Confirm it in Auth Users, or delete it and sign up again.':
        'هذا الحساب لم يتم تأكيده بعد. يرجى تأكيده أو إنشاء حساب جديد.',
    'Could not open Google sign-in': 'تعذر فتح تسجيل الدخول عبر Google',
    'Google sign-in is not enabled yet': 'تسجيل الدخول عبر Google غير مفعل بعد',
    'This email is already registered': 'هذا البريد الإلكتروني مسجل بالفعل',
    'Password is too weak': 'كلمة المرور ضعيفة',
    'Account creation is currently disabled': 'إنشاء الحسابات غير متاح حاليا',
    'No account found with this email': 'لا يوجد حساب بهذا البريد الإلكتروني',
    ' New password should be different \n from the old password':
        'يجب أن تكون كلمة المرور الجديدة مختلفة\nعن كلمة المرور القديمة',
    'Session expired. Please login again':
        'انتهت الجلسة. من فضلك سجل الدخول مرة أخرى',
    'This record already exists': 'هذا السجل موجود بالفعل',
    'You are not allowed to perform this action':
        'غير مسموح لك بتنفيذ هذا الإجراء',
    'Required information is missing': 'توجد معلومات مطلوبة غير مكتملة',
    'No internet connection.': 'لا يوجد اتصال بالإنترنت.',
    'Unable to connect to server. \nPlease try again later.':
        'تعذر الاتصال بالخادم.\nيرجى المحاولة لاحقا.',
    'User not logged in': 'المستخدم غير مسجل الدخول',
    'Something went wrong. Please try again.':
        'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
    'Contact Us': 'تواصل معنا',
    'Need help with an order, delivery, or product? Reach us directly.':
        'تحتاج مساعدة في طلب أو توصيل أو منتج؟ تواصل معنا مباشرة.',
    'WhatsApp': 'واتساب',
    'Call': 'اتصال',
    'Could not open WhatsApp.': 'تعذر فتح واتساب.',
    'Could not open phone dialer.': 'تعذر فتح الاتصال.',
    'Could not open email app.': 'تعذر فتح تطبيق البريد.',
    'Could not open your current location.': 'تعذر فتح موقعك الحالي.',
    'Set delivery address': 'حدد عنوان التوصيل',
    'Place the pin on the right door or building entrance.':
        'ضع العلامة على الباب أو مدخل المبنى الصحيح.',
    'Saving...': 'جاري الحفظ...',
    'Use Address': 'استخدم العنوان',
    'Contact number required': 'رقم الهاتف مطلوب',
    'Add a phone number so the delivery team can confirm your order if needed.':
        'أضف رقم هاتف حتى يتمكن فريق التوصيل من تأكيد الطلب عند الحاجة.',
    'Not now': 'ليس الآن',
    'Save Number': 'حفظ الرقم',
    'Enter your contact number.': 'أدخل رقم التواصل.',
    'Enter a valid phone number.': 'أدخل رقم هاتف صحيح.',
    'Pay in cash when your order arrives.': 'ادفع نقدا عند وصول الطلب.',
    'Place Order': 'تنفيذ الطلب',
    'Opening WhatsApp...': 'جاري فتح واتساب...',
    'Order on WhatsApp': 'اطلب عبر واتساب',
    'Confirm your delivery details and payment method before placing this order.':
        'أكد تفاصيل التوصيل وطريقة الدفع قبل تنفيذ الطلب.',
    'Review your delivery details and payment before placing the order.':
        'راجع تفاصيل التوصيل والدفع قبل تنفيذ الطلب.',
    'Manage': 'إدارة',
    'Address missing': 'العنوان غير موجود',
    'Add your address in Settings so we can deliver this order correctly.':
        'أضف عنوانك في الإعدادات حتى نتمكن من توصيل الطلب بشكل صحيح.',
    'Add your address in Account so we can deliver this order correctly.':
        'أضف عنوانك في الحساب حتى نتمكن من توصيل الطلب بشكل صحيح.',
    'Payment Method': 'طريقة الدفع',
    'Coupon Applied': 'تم تطبيق الكوبون',
    'Apply Coupon': 'تطبيق كوبون',
    'Remove coupon': 'إزالة الكوبون',
    'Coupon applied successfully': 'تم تطبيق الكوبون بنجاح',
    'Enter a coupon code first': 'أدخل كود الخصم أولا',
    'Coupon code not found': 'كود الخصم غير موجود',
    'This coupon is not active': 'هذا الكوبون غير نشط',
    'This coupon is not active yet': 'هذا الكوبون لم يبدأ بعد',
    'This coupon has expired': 'انتهت صلاحية هذا الكوبون',
    'This coupon has reached its usage limit':
        'وصل هذا الكوبون إلى حد الاستخدام',
    'Coupon requires a minimum order of {amount}':
        'يتطلب هذا الكوبون طلبا بحد أدنى {amount}',
    'Item Savings': 'توفير المنتجات',
    'Coupon': 'كوبون',
    'Order Payment Details': 'تفاصيل دفع الطلب',
    'Phone: {phone}': 'الهاتف: {phone}',
    'Contact: {phone}': 'التواصل: {phone}',
    'Discount included in total': 'الخصم محسوب ضمن الإجمالي',
    'Includes shipping charges': 'يشمل رسوم الشحن',
    'Proceed to Payment': 'المتابعة للدفع',
    'Delivery by ': 'التوصيل خلال ',
    '1-3 business days': '1-3 أيام عمل',
    'Card deleted successfully': 'تم حذف البطاقة بنجاح',
    'Failed to delete card': 'فشل حذف البطاقة',
    'Bank Account Details': 'بيانات الدفع',
    'Add Card': 'إضافة بطاقة',
    'Card added successfully.': 'تمت إضافة البطاقة بنجاح.',
    'Failed to add card.': 'فشل إضافة البطاقة.',
    'Save Card': 'حفظ البطاقة',
    'Number': 'رقم البطاقة',
    'Expired Date': 'تاريخ الانتهاء',
    'CVV': 'رمز CVV',
    'CARD HOLDER NAME': 'اسم حامل البطاقة',
    'Failed to upload image': 'فشل رفع الصورة',
    'Address:': 'العنوان:',
    'Contact :  +44-784232': 'التواصل: +44-784232',
    'Pending': 'قيد الانتظار',
    'Processing': 'قيد المعالجة',
    'Paid': 'مدفوع',
    'Unpaid': 'غير مدفوع',
    'Failed': 'فشل',
    'Confirmed': 'تم التأكيد',
    'Cancelled': 'ملغي',
    'Qty {count}': 'الكمية {count}',
    'Size {size}': 'المقاس {size}',
    'Size: {size}': 'المقاس: {size}',
    'Size {size} UK': 'المقاس {size} UK',
    'Size: {size} UK': 'المقاس: {size} UK',
    'Qty {count} · Size {size}': 'الكمية {count} · المقاس {size}',
    'Coupon {code} applied successfully': 'تم تطبيق كوبون {code} بنجاح',
    'Secure checkout with protected order records and delivery details saved to your account.':
        'دفع آمن مع حفظ بيانات الطلب والتوصيل في حسابك.',
    'Ready to add this item': 'جاهز لإضافة هذا المنتج',
    'Selected size: {size}': 'المقاس المختار: {size}',
    'Selected size: {size} UK': 'المقاس المختار: {size} UK',
    'Only {count} left': 'متبقي {count} فقط',
    'In stock': 'متوفر',
    'In stock ({count} available)': 'متوفر ({count} قطعة)',
    'Out of stock': 'غير متوفر',
    'Featured Product': 'منتج مميز',
    'Sale {price}': 'عرض {price}',
    'SKU: {sku}': 'رمز المنتج: {sku}',
    '{percent}% off': 'خصم {percent}%',
    'Line total': 'إجمالي المنتج',
    'Cart updated. You now have {count} of this item.':
        'تم تحديث السلة. لديك الآن {count} من هذا المنتج.',
    'Added to cart.': 'تمت الإضافة إلى السلة.',
    'This product is currently out of stock.': 'هذا المنتج غير متوفر حاليا.',
    'Could not open WhatsApp on this device.':
        'تعذر فتح واتساب على هذا الجهاز.',
    'Similar To This': 'منتجات مشابهة',
    'Related picks based on the current product category.':
        'اختيارات مرتبطة بفئة المنتج الحالية.',
    'More picks from the same style direction.': 'اختيارات أخرى من نفس النمط.',
    'Order placed successfully.': 'تم إنشاء الطلب بنجاح.',
    'Your placed orders will appear here with live status updates.':
        'ستظهر طلباتك هنا مع تحديثات الحالة.',
    'Refresh': 'تحديث',
    'Payment': 'الدفع',
    'Placed {date}': 'تم في {date}',
    'No delivery address saved for this order.':
        'لا يوجد عنوان توصيل محفوظ لهذا الطلب.',
    'This order was cancelled.': 'تم إلغاء هذا الطلب.',
    'Current status': 'الحالة الحالية',
    'WhatsApp Support': 'دعم واتساب',
    'Send this order summary to the store.': 'أرسل ملخص الطلب إلى المتجر.',
    'Order not found.': 'لم يتم العثور على الطلب.',
    'This order could not be loaded.': 'تعذر تحميل هذا الطلب.',
    'pending': 'قيد الانتظار',
    'packed': 'تم التجهيز',
    'shipped': 'تم الشحن',
    'delivered': 'تم التوصيل',
    'cancelled': 'ملغي',
    'paid': 'مدفوع',
    'Discover New Trends': 'اكتشف أحدث الصيحات',
    'Secure Checkout': 'دفع آمن',
    'Fast Delivery': 'توصيل سريع',
    'Browse curated fashion, accessories, and everyday essentials picked to match your style.':
        'تصفح أزياء وإكسسوارات واحتياجات يومية مختارة لتناسب أسلوبك.',
    'Pay safely with a smooth checkout experience designed to make every order quick and easy.':
        'ادفع بأمان من خلال تجربة دفع سهلة تجعل كل طلب سريع وبسيط.',
    'Track your package and get your favorite items delivered right to your door without the wait.':
        'تتبع شحنتك واستلم منتجاتك المفضلة حتى بابك بدون انتظار.',
    'Everything you need, all in one place.': 'كل ما تحتاجه في مكان واحد.',
    'Shop smart, checkout fast, and enjoy a better way to buy.':
        'تسوق بذكاء، ادفع بسرعة، واستمتع بطريقة أفضل للشراء.',
    'Your saved favorites in one place.': 'مفضلاتك المحفوظة في مكان واحد.',
    'Loading wishlist...': 'جاري تحميل المفضلة...',
    'Your wishlist is empty': 'قائمة المفضلة فارغة',
    'Tap the heart on any product card to save it here for later.':
        'اضغط على القلب في أي منتج لحفظه هنا لاحقا.',
    'Standard delivery in 1 to 3 business days. Tracking details appear after checkout.':
        'توصيل عادي خلال 1 إلى 3 أيام عمل. تظهر تفاصيل التتبع بعد الدفع.',
    'Standard delivery in {days}. Tracking details appear after checkout.':
        'توصيل عادي خلال {days}. تظهر تفاصيل التتبع بعد الدفع.',
    'Customer Reviews': 'آراء العملاء',
    '{count} recent comments from real shoppers.':
        '{count} تعليقات حديثة من متسوقين حقيقيين.',
    'Recent review': 'تقييم حديث',
    'Refund Policy': 'سياسة الاسترداد',
    'Return Policy': 'سياسة الإرجاع',
    'Terms': 'الشروط',
    'Skip': 'تخطي',
    'Next': 'التالي',
    'Get Started': 'ابدأ الآن',
  },
};
