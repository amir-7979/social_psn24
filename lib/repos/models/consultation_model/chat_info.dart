class ChatInfo {
  final String? uuid;
  final String? wsDomain;
  final String? wsChannel;

  ChatInfo({
    this.uuid,
    this.wsDomain,
    this.wsChannel,
  });

  factory ChatInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ChatInfo();
    return ChatInfo(
      uuid: json['uuid'] as String?,
      wsDomain: removePortFromUrl(json['ws_domain'] as String?),
      wsChannel: json['ws_channel'] as String?,
    );
  }
}
String? removePortFromUrl(String? url) {
  if (url == null) return null;
  final uri = Uri.parse(url);
  // Rebuild URI without port, keep everything else
  final cleaned = Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    query: uri.hasQuery ? uri.query : null,
    fragment: uri.hasFragment ? uri.fragment : null,
    userInfo: uri.userInfo.isNotEmpty ? uri.userInfo : null,
  );
  return cleaned.toString();
}
