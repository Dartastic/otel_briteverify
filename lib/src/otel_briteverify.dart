// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_briteverify_suppression.dart';

class BriteVerifyResult {
  /// Creates a result.
  const BriteVerifyResult({
    this.listId,
    this.emailAddress,
    this.verificationResult,
    this.verificationDisposable,
    this.verificationRoleAddress,
    this.creditsUsed,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? listId;
  final String? emailAddress;
  final String? verificationResult;
  final bool? verificationDisposable;
  final bool? verificationRoleAddress;
  final int? creditsUsed;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class BriteVerifyCallResult<T> {
  /// Creates a call result.
  const BriteVerifyCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final BriteVerifyResult? result;
}

Future<T> tracedBriteVerify<T>({
  required String operation,
  required Future<BriteVerifyCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (briteVerifyInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_briteverify');
  final span = t.startSpan('briteverify $operation', kind: SpanKind.client);
  try {
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.system', 'briteverify')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.listId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('briteverify.list.id', res.listId!)]));
      }
      if (res.emailAddress != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('email.address', res.emailAddress!)]));
      }
      if (res.verificationResult != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('briteverify.result', res.verificationResult!)
        ]));
      }
      if (res.verificationDisposable != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeBool(
            'briteverify.disposable',
            res.verificationDisposable!,
          )
        ]));
      }
      if (res.verificationRoleAddress != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeBool(
            'briteverify.role_address',
            res.verificationRoleAddress!,
          )
        ]));
      }
      if (res.creditsUsed != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('briteverify.credits', res.creditsUsed!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('briteverify.error.code', res.errorCode!)
        ]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
            ErrorAttributes.errorType.key,
            res.errorCode ?? 'briteverify.error',
          )
        ]));
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
