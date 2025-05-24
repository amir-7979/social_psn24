class AdminSettings {
  final int? tokenExpireTimeSec;
  final int? timeToSetOfflineSec;
  final int? resendSmsTimeSec;
  final int? maxSessionCount;
  final int? failedLoginMaxCount;
  final int? draftStorageMaxTimeSec;
  final int? maxCharactersForPost;
  final int? maxSizeForMediaMb;
  final int? maxDayKeepUserData;
  final int? maxCharactersForPicPrivatePost;
  final int? maxCountForPicPrivateSlide;
  final int? maxSizeForPicPrivateMB;
  final List<String>? allowedFormatsForPrivatePic;
  final int? maxCharactersForVideoPrivatePost;
  final int? maxCountForVideoPrivateSlide;
  final int? maxSizeForVideoPrivateMB;
  final List<String>? allowedFormatsForPrivateVideo;
  final int? maxTimeForVideoPrivateSec;
  final int? maxCharactersForTextPrivatePost;
  final int? maxCountForTextPrivateSlide;
  final int? maxCharactersForVoicePrivatePost;
  final int? maxCountForVoicePrivateSlide;
  final int? maxSizeForVoicePrivateMB;
  final List<String>? allowedFormatsForPrivateVoice;
  final int? maxTimeForVoicePrivateSec;
  final int? maxCharactersForPrivateComment;
  final int? maxCharactersForPicPost;
  final int? maxCountForPicSlide;
  final int? maxSizeForPicMB;
  final List<String>? allowedFormatsForPic;
  final int? maxCharactersForVideoPost;
  final int? maxCountForVideoSlide;
  final int? maxSizeForVideoMB;
  final List<String>? allowedFormatsForVideo;
  final int? maxTimeForVideoSec;
  final int? maxCharactersForTextPost;
  final int? maxCountForTextSlide;
  final int? maxCharactersForVoicePost;
  final int? maxCountForVoiceSlide;
  final int? maxSizeForVoiceMB;
  final List<String>? allowedFormatsForVoice;
  final int? maxTimeForVoiceSec;
  final int? maxCharactersForComment;

  AdminSettings({
    this.tokenExpireTimeSec,
    this.timeToSetOfflineSec,
    this.resendSmsTimeSec,
    this.maxSessionCount,
    this.failedLoginMaxCount,
    this.draftStorageMaxTimeSec,
    this.maxCharactersForPost,
    this.maxSizeForMediaMb,
    this.maxDayKeepUserData,
    this.maxCharactersForPicPrivatePost,
    this.maxCountForPicPrivateSlide,
    this.maxSizeForPicPrivateMB,
    this.allowedFormatsForPrivatePic,
    this.maxCharactersForVideoPrivatePost,
    this.maxCountForVideoPrivateSlide,
    this.maxSizeForVideoPrivateMB,
    this.allowedFormatsForPrivateVideo,
    this.maxTimeForVideoPrivateSec,
    this.maxCharactersForTextPrivatePost,
    this.maxCountForTextPrivateSlide,
    this.maxCharactersForVoicePrivatePost,
    this.maxCountForVoicePrivateSlide,
    this.maxSizeForVoicePrivateMB,
    this.allowedFormatsForPrivateVoice,
    this.maxTimeForVoicePrivateSec,
    this.maxCharactersForPrivateComment,
    this.maxCharactersForPicPost,
    this.maxCountForPicSlide,
    this.maxSizeForPicMB,
    this.allowedFormatsForPic,
    this.maxCharactersForVideoPost,
    this.maxCountForVideoSlide,
    this.maxSizeForVideoMB,
    this.allowedFormatsForVideo,
    this.maxTimeForVideoSec,
    this.maxCharactersForTextPost,
    this.maxCountForTextSlide,
    this.maxCharactersForVoicePost,
    this.maxCountForVoiceSlide,
    this.maxSizeForVoiceMB,
    this.allowedFormatsForVoice,
    this.maxTimeForVoiceSec,
    this.maxCharactersForComment,
  });

  factory AdminSettings.fromJson(Map<String, dynamic> json) {
    List<String>? parseList(String? value) {
      return value?.split(',').map((e) => e.trim()).toList();
    }
    print('AdminSettings.fromJson: $json');

    return AdminSettings(
      tokenExpireTimeSec: json['token_expire_time_sec'],
      timeToSetOfflineSec: json['time_to_set_offline_sec'],
      resendSmsTimeSec: json['resend_sms_time_sec'],
      maxSessionCount: json['max_session_count'],
      failedLoginMaxCount: json['failed_login_max_count'],
      draftStorageMaxTimeSec: json['draft_storage_max_time_sec'],
      maxCharactersForPost: json['max_characters_for_post'],
      maxSizeForMediaMb: json['max_size_for_media_mb'],
      maxDayKeepUserData: json['max_day_keep_user_data'],
      maxCharactersForPicPrivatePost: json['max_characters_for_pic_PrivatePost'],
      maxCountForPicPrivateSlide: json['max_count_for_pic_PrivateSlide'],
      maxSizeForPicPrivateMB: json['max_size_for_pic_PrivateMB'],
      allowedFormatsForPrivatePic: parseList(json['allowed_formats_for_PrivatePic']),
      maxCharactersForVideoPrivatePost: json['max_characters_for_video_PrivatePost'],
      maxCountForVideoPrivateSlide: json['max_count_for_video_PrivateSlide'],
      maxSizeForVideoPrivateMB: json['max_size_for_video_PrivateMB'],
      allowedFormatsForPrivateVideo: parseList(json['allowed_formats_for_PrivateVideo']),
      maxTimeForVideoPrivateSec: json['max_time_for_video_PrivateSec'],
      maxCharactersForTextPrivatePost: json['max_characters_for_text_PrivatePost'],
      maxCountForTextPrivateSlide: json['max_count_for_text_PrivateSlide'],
      maxCharactersForVoicePrivatePost: json['max_characters_for_voice_PrivatePost'],
      maxCountForVoicePrivateSlide: json['max_count_for_voice_PrivateSlide'],
      maxSizeForVoicePrivateMB: json['max_size_for_voice_PrivateMB'],
      allowedFormatsForPrivateVoice: parseList(json['allowed_formats_for_PrivateVoice']),
      maxTimeForVoicePrivateSec: json['max_time_for_voice_PrivateSec'],
      maxCharactersForPrivateComment: json['max_characters_for_private_comment'],
      maxCharactersForPicPost: json['max_characters_for_pic_Post'],
      maxCountForPicSlide: json['max_count_for_pic_Slide'],
      maxSizeForPicMB: json['max_size_for_pic_MB'],
      allowedFormatsForPic: parseList(json['allowed_formats_for_Pic']),
      maxCharactersForVideoPost: json['max_characters_for_video_Post'],
      maxCountForVideoSlide: json['max_count_for_video_Slide'],
      maxSizeForVideoMB: json['max_size_for_video_MB'],
      allowedFormatsForVideo: parseList(json['allowed_formats_for_Video']),
      maxTimeForVideoSec: json['max_time_for_video_Sec'],
      maxCharactersForTextPost: json['max_characters_for_text_Post'],
      maxCountForTextSlide: json['max_count_for_text_Slide'],
      maxCharactersForVoicePost: json['max_characters_for_voice_Post'],
      maxCountForVoiceSlide: json['max_count_for_voice_Slide'],
      maxSizeForVoiceMB: json['max_size_for_voice_MB'],
      allowedFormatsForVoice: parseList(json['allowed_formats_for_Voice']),
      maxTimeForVoiceSec: json['max_time_for_voice_Sec'],
      maxCharactersForComment: json['max_characters_for_comment'],
    );
  }

  String getConcatenatedAllowedFormats({
    List<String>? picFormats,
    List<String>? videoFormats,
    List<String>? voiceFormats,
  }) {
    final List<String> concatenatedFormats = [];
    if (picFormats != null) picFormats.add('jpg');
    if (picFormats != null) concatenatedFormats.addAll(picFormats);
    if (videoFormats != null) concatenatedFormats.addAll(videoFormats);
    if (voiceFormats != null) concatenatedFormats.addAll(voiceFormats);
    return concatenatedFormats.join(', ');
  }

  // Function to get public allowed formats as a comma-separated string
  String getPublicAllowedFormats() {
    return getConcatenatedAllowedFormats(
      picFormats: allowedFormatsForPic,
      videoFormats: allowedFormatsForVideo,
      voiceFormats: allowedFormatsForVoice,
    );
  }

  // Function to get private allowed formats as a comma-separated string
  String getPrivateAllowedFormats() {
    return getConcatenatedAllowedFormats(
      picFormats: allowedFormatsForPrivatePic,
      videoFormats: allowedFormatsForPrivateVideo,
      voiceFormats: allowedFormatsForPrivateVoice,
    );
  }
}