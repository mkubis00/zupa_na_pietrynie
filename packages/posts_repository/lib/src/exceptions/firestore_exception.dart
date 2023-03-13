class FireStoreException implements Exception {
  const FireStoreException([
    this.message = 'An unknown error occurred.',
  ]);

  factory FireStoreException.fromCode(String code) {
    switch (code) {
      case 'object-not-found':
        return const FireStoreException(
          'No object exists at the desired reference',
        );
      case 'bucket-not-found':
        return const FireStoreException(
          'No bucket is configured for Cloud Storage'
        );
      case 'project-not-found':
        return const FireStoreException(
            'No project is configured for Cloud Storage'
        );
      case 'quota-exceeded':
        return const FireStoreException(
            '	Quota on your Cloud Storage bucket has been exceeded. '
                'If you\'re on the no-cost tier, upgrade to a paid plan. '
                'If you\'re on a paid plan, reach out to Firebase support.'
        );
      case 'unauthenticated':
        return const FireStoreException(
            'User is unauthenticated, please authenticate and try again.'
        );
      case 'unauthorized':
        return const FireStoreException(
            'User is not authorized to perform the desired action,'
                ' check your security rules to ensure they are correct.'
        );
      case 'retry-limit-exceeded':
        return const FireStoreException(
            'The maximum time limit on an operation '
                '(upload, download, delete, etc.) has been excceded.'
                ' Try uploading again.'
        );
      case 'invalid-checksum':
        return const FireStoreException(
            'File on the client does not match the checksum of the file'
                ' received by the server. Try uploading again.'
        );
      case 'canceled':
        return const FireStoreException(
            'User canceled the operation.'
        );
      case 'invalid-event-name':
        return const FireStoreException(
            'Invalid event name provided. '
                'Must be one of [running, progress, pause]'
        );
      case 'invalid-url':
        return const FireStoreException(
            'Invalid URL provided to refFromURL(). '
                'Must be of the form: '
                'gs://bucket/object or https://firebasestorage.googleapis.com'
                '/v0/b/bucket/o/object?token=<TOKEN>'
        );
      case 'invalid-argument':
        return const FireStoreException(
            'The argument passed to put() must be File, Blob, or UInt8 Array. '
                'The argument passed to putString() must be a raw, '
                'Base64, or Base64URL string.'
        );
      case 'no-default-bucket':
        return const FireStoreException(
            'No bucket has been set in your config\'s storageBucket property.'
        );
      case 'cannot-slice-blob':
        return const FireStoreException(
            '	Commonly occurs when the local file has changed '
                '(deleted, saved again, etc.). Try uploading again after '
                'verifying that the file hasn\'t changed.'
        );
      case 'server-file-wrong-size':
        return const FireStoreException(
            'File on the client does not match the size of '
                'the file recieved by the server. Try uploading again.'
        );
      default:
        return const FireStoreException();
    }
  }

  final String message;
}
