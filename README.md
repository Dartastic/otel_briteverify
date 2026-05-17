# otel_briteverify

Dartastic OpenTelemetry bridge for BriteVerify (email verification).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_briteverify/otel_briteverify.dart';

await tracedBriteVerify<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return BriteVerifyCallResult(value: r, result: BriteVerifyResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutBriteVerifyInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
