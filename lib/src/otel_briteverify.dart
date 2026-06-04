// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_briteverify_suppression.dart';

class BriteVerifyResult {
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

class BriteVerifyCallResult<T> {
  const BriteVerifyCallResult({required this.value, this.result});
  final T value;
  final BriteVerifyResult? result;
}

Future<T> tracedBriteVerify<T>({
  required String operation,
  required Future<BriteVerifyCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (briteVerifyInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_briteverify');
  final span = t.startSpan('briteverify $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'briteverify')]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.listId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('briteverify.list.id', res.listId!)]));
      }
      if (res.emailAddress != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('email.address', res.emailAddress!)]));
      }
      if (res.verificationResult != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('briteverify.result', res.verificationResult!)
        ]));
      }
      if (res.verificationDisposable != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeBool(
            'briteverify.disposable',
            res.verificationDisposable!,
          )
        ]));
      }
      if (res.verificationRoleAddress != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeBool(
            'briteverify.role_address',
            res.verificationRoleAddress!,
          )
        ]));
      }
      if (res.creditsUsed != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('briteverify.credits', res.creditsUsed!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('briteverify.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
            ErrorResource.errorType.key,
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
