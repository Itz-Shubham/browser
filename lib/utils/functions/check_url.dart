bool isValidUrl({required String url}) {
  return Uri.tryParse(url)?.hasAbsolutePath ?? false;
}
