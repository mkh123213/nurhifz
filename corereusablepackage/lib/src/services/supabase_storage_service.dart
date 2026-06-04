import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client;

  SupabaseStorageService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  StorageFileApi _bucket(String bucket) => _client.storage.from(bucket);

  Future<String> uploadFile({
    required String bucket,
    required String path,
    required File file,
    String? contentType,
  }) async {
    await _bucket(bucket).upload(
      path,
      file,
      fileOptions: FileOptions(
        upsert: true,
        contentType: contentType,
      ),
    );
    return getPublicUrl(bucket: bucket, path: path);
  }

  Future<String> uploadImage({
    required String bucket,
    required String path,
    required File file,
  }) {
    return uploadFile(
      bucket: bucket,
      path: path,
      file: file,
      contentType: 'image/jpeg',
    );
  }

  Future<String> uploadVideo({
    required String bucket,
    required String path,
    required File file,
  }) {
    return uploadFile(
      bucket: bucket,
      path: path,
      file: file,
      contentType: 'video/mp4',
    );
  }

  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _bucket(bucket).getPublicUrl(path);
  }

  Future<void> deleteFile({
    required String bucket,
    required List<String> paths,
  }) async {
    await _bucket(bucket).remove(paths);
  }

  Future<List<FileObject>> listFiles({
    required String bucket,
    String path = '',
  }) async {
    return _bucket(bucket).list(path: path);
  }
}
