// import 'package:beejora_ecommerce/data/model/response/language_model.dart';

import '../models/language_model.dart';

class AppConstants {
  static const String BASE_URL = 'https://app.aapjob.com/';
  // static const String USER_ID = 'userId';
  // static const String NAME = 'name';
  static const String HR_PLAN_URI = 'apii/hrplan';
  static const String HR_CURRENT_PLAN_URI = 'apii/hrcurrentplan?userid=';
  static const String HR_RECRUITER_PLAN_URI = 'apii/getrecruiterplans';
  static const String HR_CONSULTANCY_PLAN_URI = 'apii/getconsultancyplans';
  static const String HR_UPDATE_CURRENT_PLAN_URI = 'apii/updateHrPlan';
  static const String CATEGORIES_URI = 'apii/categories';
  static const String CATEGORIES2_URI = 'apii/categories2';
  static const String CATEGORY_URI = 'apii/category';
  static const String ADS_URI = 'apii/get_ads';
  static const String CONFIG_URI = 'apii/getAppSettings';
  static const String CITIES_URI = 'apii/get_cities';
  static const String CITY_LOCATION_URI = 'apii/getCityLocationsByCityId?cityid=';
  static const String RESUME_TUTORIAL_URI = 'apii/get_video_resume_tut';
  static const String HR_RESUME_TUTORIAL_URI = 'apii/get_video_resume_tut_hr';
  static const String HOMEPAGE_AD_URI = 'apii/get_homepage_tut';
  static const String CONTENT_URI = 'apii/get_content';
  static const String HOMEPAGE_FRONT_URI = 'apii/get_homepage_front';
  static const String HR_HOMEPAGE_AD_URI = 'apii/get_homepage_tut_hr';
  static const String HR_HOMEPAGE_FRONT_URI = 'apii/get_homepage_front_hr';
  static const String JOB_TITLE_URI = 'apii/get_jobtitles';
  static const String JOB_CAT_SKILL_URI = 'apii/getJobSkillByJobCatId?jobcatid=';
  static const String JOB_TITLE_SKILL_URI = 'apii/getJobSkillByJobTitle?jobtitleid=';
  static const String HR_JOBS_URI = 'apii/getjobsbyhr?userid=';
  static const String HR_CLOSED_JOBS_URI = 'apii/getclosedjobsbyhr?userid=';
  static const String CLOSE_JOBS_URI = 'apii/closejob?jobid=';
  static const String CAT_JOBS_URI = 'apii/catjobs?';
  static const String SEARCH_JOBS_URI = 'apii/searchjob?';
  static const String APPLIED_JOBS_URI = 'apii/appliedjobs?userid=';
  static const String MY_INTERVIEW_CALLS_URI = 'apii/myinterviewcalls?userid=';
  static const String SELECT_CANDIDATE_URI = 'apii/selectcandidate';
  static const String SUBMIT_COMPLAINT = 'apii/submitComplaint';
  static const String GET_JOB_DETAILS_URI = 'apii/getjobdetails?jobid=';

  static const String SELECTED_CANDIDATES_URI = 'apii/getselectedCandidatesByJobId?jobid=';
  static const String UNSELECTED_CANDIDATES_URI = 'apii/getunselectedCandidatesByJobId?jobid=';

  static const String GET_LANG_URI = 'apii/getlang';
  static const String COMPLAINT_REASONS_URI = 'apii/get_comp_reasons';
  static const String JOB_CLOSE_REASONS_URI = 'apii/get_job_close_reasons';
  // static const String BRAND_PRODUCT_URI = 'apii/v1/brands/products/';
  static const String HOME_CATEGORY_JOBS_URI = 'apii/homecategoryjobs?catid=';
  static const String CATEGORY_JOBS_URI = 'apii/categoryjobs/catid=';
  static const String REGISTRATION_URI = 'apii/auth/register';
  static const String SEND_OTP_URI = 'apii/sendotp';
  static const String SEND_MY_OTP_URI = 'apii/sendmyotp';
  static const String LOGIN_URI = 'apii/login';
  static const String MY_LOGIN_URI = 'apii/mylogin';
  static const String HR_LOGIN_URI = 'apii/hrlogin';
  static const String CHECKACC_URI = 'apii/checkacc2';
  static const String CHECKACCC_URI = 'apii/checkaccc';
  // static const String LATEST_PRODUCTS_URI = 'apii/v1/products/latest?limit=10&&offset=';
  // static const String FEATURES_PRODUCTS_URI = 'apii/v1/products/feature?limit=10&&offset=';
  // static const String PRODUCT_DETAILS_URI = 'apii/v1/products/details/';
  // static const String PRODUCT_REVIEW_URI = 'apii/v1/products/reviews/';
  // static const String SEARCH_URI = 'apii/v1/products/search?name=';
  // static const String CONFIG_URI = 'apii/v1/config';
  // static const String ADD_WISH_LIST_URI = 'apii/v1/customer/wish-list/add?product_id=';
  // static const String REMOVE_WISH_LIST_URI = 'apii/v1/customer/wish-list/remove?product_id=';
  static const String PROFILE_STEP2_URI = 'apii/profilestep2';
  static const String SAVE_PROFILE_DATA_URI = 'apii/saveprofile';
  static const String SAVE_EDUCATION_DATA_URI = 'apii/saveeducation';
  static const String SAVE_EXP_DATA_URI = 'apii/saveexperience';
  static const String SAVE_JOB_DATA_URI = 'apii/savejob';
  static const String SAVE_HR_PROFILE_DATA_URI = 'apii/hrsaveprofile';
  static const String SAVE_HR_PROFILE_VIDEO_DATA_URI = 'apii/hrsaveprofileVideo';
  static const String SAVE_HR_PROFILE_IMAGE_DATA_URI = 'apii/hrsaveprofileImage';
  static const String UPDATE_HR_COMPANY_PROFILE = 'apii/hrUpdateCompanyDetails';
  static const String SAVE_RESUME_DATA_URI = 'apii/updateresume';
  static const String SAVE_HR_PROFILE_DETAIL_DATA_URI = 'apii/hrsaveprofileDetail';
  static const String SAVE_HR_CITY_DATA_URI = 'apii/hrsavecity';
  static const String SAVE_PROFILE_DETAIL_DATA_URI = 'apii/saveprofileDetail';
  static const String SAVE_CITY_DATA_URI = 'apii/savecity';
  static const String UPDATE_VIEW_URI = 'apii/addview?jobid=';
  static const String UPDATE_CATEGORY_URI = 'apii/addcategory?catid=';
  static const String APPLY_JOB_URI = 'apii/applyjob?jobid=';
  static const String CHECK_APPLY_JOB_URI = 'apii/checkapplied?jobid=';
  static const String CHECK_HR_PROFILE_STATUS_URI = 'apii/getprofilestatus?userid=';
  static const String CHECK_CANDIDATE_PROFILE_STATUS_URI = 'apii/getprofilestatuscandidate?userid=';
  // static const String GET_SHORTLISTED_COUNT_URI = 'apii/getprofilestatus?userid=';
  // static const String ADDRESS_LIST_URI = 'apii/v1/customer/address/list';
  // static const String REMOVE_ADDRESS_URI = 'apii/v1/customer/address?address_id=';
  // static const String ADD_ADDRESS_URI = 'apii/v1/customer/address/add';
  // static const String WISH_LIST_GET_URI = 'apii/v1/customer/wish-list';
  // static const String SUPPORT_TICKET_URI = 'apii/v1/customer/support-ticket/create';
  // static const String MAIN_BANNER_URI = 'apii/v1/banners?banner_type=main_banner';
  // static const String FOOTER_BANNER_URI = 'apii/v1/banners?banner_type=footer_banner';
  // static const String RELATED_PRODUCT_URI = 'apii/v1/products/related-products/';
  // static const String ORDER_URI = 'apii/v1/customer/order/list';
  // static const String ORDER_DETAILS_URI = 'apii/v1/customer/order/details?order_id=';
  // static const String ORDER_PLACE_URI = 'apii/v1/customer/order/place';
  // static const String SELLER_URI = 'apii/v1/seller?seller_id=';
  // static const String SELLER_PRODUCT_URI = 'apii/v1/seller/';
  // static const String TRACKING_URI = 'apii/v1/order/track?order_id=';
  // static const String FORGET_PASSWORD_URI = 'apii/v1/auth/forgot-password';
  // static const String SUPPORT_TICKET_GET_URI = 'apii/v1/customer/support-ticket/get';
  // static const String SUBMIT_REVIEW_URI = 'apii/v1/products/reviews/submit';
  // static const String FLASH_DEAL_URI = 'apii/v1/flash-deals';
  // static const String FLASH_DEAL_PRODUCT_URI = 'apii/v1/flash-deals/products/';
  // static const String COUNTER_URI = 'apii/v1/products/counter/';
  // static const String SOCIAL_LINK_URI = 'apii/v1/products/social-share-link/';
  // static const String SHIPPING_URI = 'apii/v1/products/shipping-methods';
  // static const String COUPON_URI = 'apii/v1/coupon/apply?code=';
  // static const String MESSAGES_URI = 'apii/v1/customer/chat/messages?shop_id=';
  // static const String CHAT_INFO_URI = 'apii/v1/customer/chat';
  // static const String SEND_MESSAGE_URI = 'apii/v1/customer/chat/send-message';
  static const String TOKEN_URI = 'apii/cm_firebase_token';
  static const String NOTIFICATION_URI = 'apii/notifications';
  static const String HR_NOTIFICATION_URI = 'apii/hrnotifications';
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
