// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_briteverify/otel_briteverify.dart';

/// Traces Briteverify calls with OpenTelemetry.
///
/// `otel_briteverify` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Briteverify call in
/// [tracedBriteVerify]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'briteverify-example');

  // Traces a Briteverify call.
  final briteVerifyId = await tracedBriteVerify<String>(
    operation: 'create',
    invoke: () async {
      // Make the Briteverify call here, then report what it returned.
      const id = 'briteverify_8f3a2c';
      return const BriteVerifyCallResult(
          value: id,
          result: BriteVerifyResult(
              listId: 'list_8f3a2c',
              emailAddress: 'ada@example.com',
              verificationResult: 'example',
              verificationDisposable: true,
              verificationRoleAddress: true,
              creditsUsed: 1,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedBriteVerify create returned $briteVerifyId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutBriteVerifyInstrumentationAsync.
  await runWithoutBriteVerifyInstrumentationAsync(
    () => tracedBriteVerify<String>(
      operation: 'create',
      invoke: () async {
        const id = 'briteverify_8f3a2c';
        return const BriteVerifyCallResult(
            value: id,
            result: BriteVerifyResult(
                listId: 'list_8f3a2c',
                emailAddress: 'ada@example.com',
                verificationResult: 'example',
                verificationDisposable: true,
                verificationRoleAddress: true,
                creditsUsed: 1,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
