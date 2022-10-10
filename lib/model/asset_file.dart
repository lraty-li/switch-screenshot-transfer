class AssetFile {
  String? fileName;
  String? localPath;
  String? url;

  AssetFile({this.fileName, this.url});

  AssetFile.fromJson(Map<String, dynamic> json)
      : fileName = json['fileName'],
        localPath = json['localPath'],
        url = json['url'];

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'localPath': localPath,
      'url': url,
    };
  }
}
