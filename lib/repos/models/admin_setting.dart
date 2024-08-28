class AdminSettings {
  final int? maxSizeForMediaMb;
  final int? maxSizeForPicMB;
  final int? maxSizeForPicPrivateMB;
  final int? maxSizeForVideoMB;
  final int? maxSizeForVideoPrivateMB;
  final int? maxSizeForVoiceMB;
  final int? maxSizeForVoicePrivateMB;
  final int? maxTimeForVideoPrivateSec;
  final int? maxTimeForVideoSec;
  final int? maxTimeForVoicePrivateSec;
  final int? maxTimeForVoiceSec;
  final List<String>? allowedFormatsForPic;
  final List<String>? allowedFormatsForVideo;
  final List<String>? allowedFormatsForVoice;
  final List<String>? allowedFormatsForPrivatePic;
  final List<String>? allowedFormatsForPrivateVideo;
  final List<String>? allowedFormatsForPrivateVoice;
  final int? maxCountForPicPrivateSlide;
  final int? maxCountForPicSlide;
  final int? maxCountForTextPrivateSlide;
  final int? maxCountForTextSlide;
  final int? maxCountForVideoPrivateSlide;
  final int? maxCountForVideoSlide;
  final int? maxCountForVoicePrivateSlide;
  final int? maxCountForVoiceSlide;
  final int? maxCharactersForPicPost;
  final int? maxCharactersForPicPrivatePost;
  final int? maxCharactersForPost;
  final int? maxCharactersForTextPost;
  final int? maxCharactersForVideoPost;
  final int? maxCharactersForVideoPrivatePost;
  final int? maxCharactersForVoicePost;
  final int? maxCharactersForVoicePrivatePost;
  final int? maxCharactersForComment;
  final int? maxSessionCount;
  final int? resendSmsTimeSec;
  final int? timeToSetOfflineSec;
  final int? tokenExpireTimeSec;
  final int? draftStorageMaxTimeSec;
  final int? failedLoginMaxCount;
  final String? id;
  final bool? isActive;
  final String? typename;

  AdminSettings({
    this.maxSizeForMediaMb,
    this.maxSizeForPicMB,
    this.maxSizeForPicPrivateMB,
    this.maxSizeForVideoMB,
    this.maxSizeForVideoPrivateMB,
    this.maxSizeForVoiceMB,
    this.maxSizeForVoicePrivateMB,
    this.maxTimeForVideoPrivateSec,
    this.maxTimeForVideoSec,
    this.maxTimeForVoicePrivateSec,
    this.maxTimeForVoiceSec,
    this.allowedFormatsForPic,
    this.allowedFormatsForVideo,
    this.allowedFormatsForVoice,
    this.allowedFormatsForPrivatePic,
    this.allowedFormatsForPrivateVideo,
    this.allowedFormatsForPrivateVoice,
    this.maxCountForPicPrivateSlide,
    this.maxCountForPicSlide,
    this.maxCountForTextPrivateSlide,
    this.maxCountForTextSlide,
    this.maxCountForVideoPrivateSlide,
    this.maxCountForVideoSlide,
    this.maxCountForVoicePrivateSlide,
    this.maxCountForVoiceSlide,
    this.maxCharactersForPicPost,
    this.maxCharactersForPicPrivatePost,
    this.maxCharactersForPost,
    this.maxCharactersForTextPost,
    this.maxCharactersForVideoPost,
    this.maxCharactersForVideoPrivatePost,
    this.maxCharactersForVoicePost,
    this.maxCharactersForVoicePrivatePost,
    this.maxCharactersForComment,
    this.maxSessionCount,
    this.resendSmsTimeSec,
    this.timeToSetOfflineSec,
    this.tokenExpireTimeSec,
    this.draftStorageMaxTimeSec,
    this.failedLoginMaxCount,
    this.id,
    this.isActive,
    this.typename,
  });

  factory AdminSettings.fromJson(Map<String, dynamic> json) {
    List<String>? parseList(String? value) {
      return value?.split(',').map((e) => e.toString().trim()).toList();
    }

    return AdminSettings(
      maxSizeForMediaMb: int.tryParse(json['max_size_for_media_mb']),
      maxSizeForPicMB: int.tryParse(json['max_size_for_pic_MB']),
      maxSizeForPicPrivateMB: int.tryParse(json['max_size_for_pic_PrivateMB']),
      maxSizeForVideoMB: int.tryParse(json['max_size_for_video_MB']),
      maxSizeForVideoPrivateMB: int.tryParse(json['max_size_for_video_PrivateMB']),
      maxSizeForVoiceMB: int.tryParse(json['max_size_for_voice_MB']),
      maxSizeForVoicePrivateMB: int.tryParse(json['max_size_for_voice_PrivateMB']),
      maxTimeForVideoPrivateSec: int.tryParse(json['max_time_for_video_PrivateSec']),
      maxTimeForVideoSec: int.tryParse(json['max_time_for_video_Sec']),
      maxTimeForVoicePrivateSec: int.tryParse(json['max_time_for_voice_PrivateSec']),
      maxTimeForVoiceSec: int.tryParse(json['max_time_for_voice_Sec']),
      allowedFormatsForPic: parseList(json['allowed_formats_for_Pic']),
      allowedFormatsForVideo: parseList(json['allowed_formats_for_Video']),
      allowedFormatsForVoice: parseList(json['allowed_formats_for_Voice']),
      allowedFormatsForPrivatePic: parseList(json['allowed_formats_for_PrivatePic']),
      allowedFormatsForPrivateVideo: parseList(json['allowed_formats_for_PrivateVideo']),
      allowedFormatsForPrivateVoice: parseList(json['allowed_formats_for_PrivateVoice']),
      maxCountForPicPrivateSlide: int.tryParse(json['max_count_for_pic_PrivateSlide']),
      maxCountForPicSlide: int.tryParse(json['max_count_for_pic_Slide']),
      maxCountForTextPrivateSlide: int.tryParse(json['max_count_for_text_PrivateSlide']),
      maxCountForTextSlide: int.tryParse(json['max_count_for_text_Slide']),
      maxCountForVideoPrivateSlide: int.tryParse(json['max_count_for_video_PrivateSlide']),
      maxCountForVideoSlide: int.tryParse(json['max_count_for_video_Slide']),
      maxCountForVoicePrivateSlide: int.tryParse(json['max_count_for_voice_PrivateSlide']),
      maxCountForVoiceSlide: int.tryParse(json['max_count_for_voice_Slide']),
      maxCharactersForPicPost: int.tryParse(json['max_characters_for_pic_Post']),
      maxCharactersForPicPrivatePost: int.tryParse(json['max_characters_for_pic_PrivatePost']),
      maxCharactersForPost: int.tryParse(json['max_characters_for_post']),
      maxCharactersForTextPost: int.tryParse(json['max_characters_for_text_Post']),
      maxCharactersForVideoPost: int.tryParse(json['max_characters_for_video_Post']),
      maxCharactersForVideoPrivatePost: int.tryParse(json['max_characters_for_video_PrivatePost']),
      maxCharactersForVoicePost: int.tryParse(json['max_characters_for_voice_Post']),
      maxCharactersForVoicePrivatePost: int.tryParse(json['max_characters_for_voice_PrivatePost']),
      maxCharactersForComment: int.tryParse(json['max_characters_for_comment']),
      maxSessionCount: int.tryParse(json['max_session_count']),
      resendSmsTimeSec: int.tryParse(json['resend_sms_time_sec']),
      timeToSetOfflineSec: int.tryParse(json['time_to_set_offline_sec']),
      tokenExpireTimeSec: int.tryParse(json['token_expire_time_sec']),
      draftStorageMaxTimeSec: int.tryParse(json['draft_storage_max_time_sec']),
      failedLoginMaxCount: int.tryParse(json['failed_login_max_count']),
      id: json['id'],
      isActive: json['is_active'] == '1',
      typename: json['__typename'],
    );
  }
  String getConcatenatedAllowedFormats({
    List<String>? picFormats,
    List<String>? videoFormats,
    List<String>? voiceFormats,
  }) {
    final List<String> concatenatedFormats = [];
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
