// import 'package:beejora_ecommerce/data/model/response/language_model.dart';

import '../models/language_model.dart';

class AppConstants {
  static const String BASE_URL = 'https://app.aapjob.com/';
  // static const String USER_ID = 'userId';
  // static const String NAME = 'name';
  static const String HR_PLAN_URI = 'api/hrplan';
  static const String HR_CURRENT_PLAN_URI = 'api/hrcurrentplan?userid=';
  static const String HR_RECRUITER_PLAN_URI = 'api/getrecruiterplans';
  static const String HR_CONSULTANCY_PLAN_URI = 'api/getconsultancyplans';
  static const String HR_UPDATE_CURRENT_PLAN_URI = 'api/updateHrPlan';
  static const String CATEGORIES_URI = 'api/categories';
  static const String CATEGORY_URI = 'api/category';
  static const String ADS_URI = 'api/get_ads';
  static const String CONFIG_URI = 'api/getAppSettings';
  static const String CITIES_URI = 'api/get_cities';
  static const String CITY_LOCATION_URI = 'api/getCityLocationsByCityId?cityid=';
  static const String RESUME_TUTORIAL_URI = 'api/get_video_resume_tut';
  static const String HR_RESUME_TUTORIAL_URI = 'api/get_video_resume_tut_hr';
  static const String HOMEPAGE_AD_URI = 'api/get_homepage_tut';
  static const String CONTENT_URI = 'api/get_content';
  static const String HOMEPAGE_FRONT_URI = 'api/get_homepage_front';
  static const String HR_HOMEPAGE_AD_URI = 'api/get_homepage_tut_hr';
  static const String HR_HOMEPAGE_FRONT_URI = 'api/get_homepage_front_hr';
  static const String JOB_TITLE_URI = 'api/get_jobtitles';
  static const String JOB_CAT_SKILL_URI = 'api/getJobSkillByJobCatId?jobcatid=';
  static const String JOB_TITLE_SKILL_URI = 'api/getJobSkillByJobTitle?jobtitleid=';
  static const String HR_JOBS_URI = 'api/getjobsbyhr?userid=';
  static const String HR_CLOSED_JOBS_URI = 'api/getclosedjobsbyhr?userid=';
  static const String CLOSE_JOBS_URI = 'api/closejob?jobid=';
  static const String CAT_JOBS_URI = 'api/catjobs?';
  static const String SEARCH_JOBS_URI = 'api/searchjob?';
  static const String APPLIED_JOBS_URI = 'api/appliedjobs?userid=';
  static const String MY_INTERVIEW_CALLS_URI = 'api/myinterviewcalls?userid=';
  static const String SELECT_CANDIDATE_URI = 'api/selectcandidate';
  static const String SUBMIT_COMPLAINT = 'api/submitComplaint';
  static const String GET_JOB_DETAILS_URI = 'api/getjobdetails?jobid=';

  static const String SELECTED_CANDIDATES_URI = 'api/getselectedCandidatesByJobId?jobid=';
  static const String UNSELECTED_CANDIDATES_URI = 'api/getunselectedCandidatesByJobId?jobid=';

  static const String GET_LANG_URI = 'api/getlang';
  static const String COMPLAINT_REASONS_URI = 'api/get_comp_reasons';
  static const String JOB_CLOSE_REASONS_URI = 'api/get_job_close_reasons';
  // static const String BRAND_PRODUCT_URI = 'api/v1/brands/products/';
  static const String HOME_CATEGORY_JOBS_URI = 'api/homecategoryjobs?catid=';
  static const String CATEGORY_JOBS_URI = 'api/categoryjobs/catid=';
  static const String REGISTRATION_URI = 'api/auth/register';
  static const String SEND_OTP_URI = 'api/sendotp';
  static const String LOGIN_URI = 'api/login';
  static const String HR_LOGIN_URI = 'api/hrlogin';
  static const String CHECKACC_URI = 'api/checkacc2';
  // static const String LATEST_PRODUCTS_URI = 'api/v1/products/latest?limit=10&&offset=';
  // static const String FEATURES_PRODUCTS_URI = 'api/v1/products/feature?limit=10&&offset=';
  // static const String PRODUCT_DETAILS_URI = 'api/v1/products/details/';
  // static const String PRODUCT_REVIEW_URI = 'api/v1/products/reviews/';
  // static const String SEARCH_URI = 'api/v1/products/search?name=';
  // static const String CONFIG_URI = 'api/v1/config';
  // static const String ADD_WISH_LIST_URI = 'api/v1/customer/wish-list/add?product_id=';
  // static const String REMOVE_WISH_LIST_URI = 'api/v1/customer/wish-list/remove?product_id=';
  static const String PROFILE_STEP2_URI = 'api/profilestep2';
  static const String SAVE_PROFILE_DATA_URI = 'api/saveprofile';
  static const String SAVE_JOB_DATA_URI = 'api/savejob';
  static const String SAVE_HR_PROFILE_DATA_URI = 'api/hrsaveprofile';
  static const String SAVE_HR_PROFILE_VIDEO_DATA_URI = 'api/hrsaveprofileVideo';
  static const String SAVE_HR_PROFILE_IMAGE_DATA_URI = 'api/hrsaveprofileImage';
  static const String UPDATE_HR_COMPANY_PROFILE = 'api/hrUpdateCompanyDetails';
  static const String SAVE_RESUME_DATA_URI = 'api/updateresume';
  static const String SAVE_HR_PROFILE_DETAIL_DATA_URI = 'api/hrsaveprofileDetail';
  static const String SAVE_PROFILE_DETAIL_DATA_URI = 'api/saveprofileDetail';
  static const String UPDATE_VIEW_URI = 'api/addview?jobid=';
  static const String UPDATE_CATEGORY_URI = 'api/addcategory?catid=';
  static const String APPLY_JOB_URI = 'api/applyjob?jobid=';
  static const String CHECK_APPLY_JOB_URI = 'api/checkapplied?jobid=';
  static const String CHECK_HR_PROFILE_STATUS_URI = 'api/getprofilestatus?userid=';
  // static const String GET_SHORTLISTED_COUNT_URI = 'api/getprofilestatus?userid=';
  // static const String ADDRESS_LIST_URI = 'api/v1/customer/address/list';
  // static const String REMOVE_ADDRESS_URI = 'api/v1/customer/address?address_id=';
  // static const String ADD_ADDRESS_URI = 'api/v1/customer/address/add';
  // static const String WISH_LIST_GET_URI = 'api/v1/customer/wish-list';
  // static const String SUPPORT_TICKET_URI = 'api/v1/customer/support-ticket/create';
  // static const String MAIN_BANNER_URI = 'api/v1/banners?banner_type=main_banner';
  // static const String FOOTER_BANNER_URI = 'api/v1/banners?banner_type=footer_banner';
  // static const String RELATED_PRODUCT_URI = 'api/v1/products/related-products/';
  // static const String ORDER_URI = 'api/v1/customer/order/list';
  // static const String ORDER_DETAILS_URI = 'api/v1/customer/order/details?order_id=';
  // static const String ORDER_PLACE_URI = 'api/v1/customer/order/place';
  // static const String SELLER_URI = 'api/v1/seller?seller_id=';
  // static const String SELLER_PRODUCT_URI = 'api/v1/seller/';
  // static const String TRACKING_URI = 'api/v1/order/track?order_id=';
  // static const String FORGET_PASSWORD_URI = 'api/v1/auth/forgot-password';
  // static const String SUPPORT_TICKET_GET_URI = 'api/v1/customer/support-ticket/get';
  // static const String SUBMIT_REVIEW_URI = 'api/v1/products/reviews/submit';
  // static const String FLASH_DEAL_URI = 'api/v1/flash-deals';
  // static const String FLASH_DEAL_PRODUCT_URI = 'api/v1/flash-deals/products/';
  // static const String COUNTER_URI = 'api/v1/products/counter/';
  // static const String SOCIAL_LINK_URI = 'api/v1/products/social-share-link/';
  // static const String SHIPPING_URI = 'api/v1/products/shipping-methods';
  // static const String COUPON_URI = 'api/v1/coupon/apply?code=';
  // static const String MESSAGES_URI = 'api/v1/customer/chat/messages?shop_id=';
  // static const String CHAT_INFO_URI = 'api/v1/customer/chat';
  // static const String SEND_MESSAGE_URI = 'api/v1/customer/chat/send-message';
  static const String TOKEN_URI = 'api/cm_firebase_token';
  static const String NOTIFICATION_URI = 'api/notifications';
  static const String HR_NOTIFICATION_URI = 'api/hrnotifications';
  //
  // // sharePreference
  static const String TOKEN = 'token';
  // static const String USER = 'user';
  // static const String USER_EMAIL = 'user_email';
  // static const String USER_PASSWORD = 'user_password';
  // static const String HOME_ADDRESS = 'home_address';
  // static const String SEARCH_ADDRESS = 'search_address';
  // static const String OFFICE_ADDRESS = 'office_address';
  // static const String CART_LIST = 'cart_list';
  // static const String CONFIG = 'config';
  // static const String GUEST_MODE = 'guest_mode';
  // static const String CURRENCY = 'currency';
  static const String LANG_KEY = 'lang';
  //
  // // order status
  // static const String PENDING = 'pending';
  // static const String CONFIRMED = 'confirmed';
  // static const String PROCESSING = 'processing';
  // static const String PROCESSED = 'processed';
  // static const String DELIVERED = 'delivered';
  // static const String FAILED = 'failed';
  // static const String RETURNED = 'returned';
  // static const String CANCELLED = 'cancelled';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  // static const String THEME = 'theme';
  static const String TOPIC = 'aapjob';
  static const String HRTOPIC = 'aapjobhr';
  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Hindi', countryCode: 'IN', languageCode: 'hi'),
    LanguageModel(imageUrl: '', languageName: 'Kannada', countryCode: 'IN', languageCode: 'kn'),
    LanguageModel(imageUrl: '', languageName: 'Bengali', countryCode: 'IN', languageCode: 'bn'),
    LanguageModel(imageUrl: '', languageName: 'Telugu', countryCode: 'IN', languageCode: 'te'),
    LanguageModel(imageUrl: '', languageName: 'Tamil', countryCode: 'IN', languageCode: 'ta'),
    LanguageModel(imageUrl: '', languageName: 'Gujarati', countryCode: 'IN', languageCode: 'gu'),
    LanguageModel(imageUrl: '', languageName: 'Marathi', countryCode: 'IN', languageCode: 'mr'),
    LanguageModel(imageUrl: '', languageName: 'Oriya', countryCode: 'IN', languageCode: 'or'),
    LanguageModel(imageUrl: '', languageName: 'Assamese', countryCode: 'IN', languageCode: 'as'),
    LanguageModel(imageUrl: '', languageName: 'Malayalam', countryCode: 'IN', languageCode: 'ml'),
    LanguageModel(imageUrl: '', languageName: 'Punjabi', countryCode: 'IN', languageCode: 'pa'),
  ];
}
