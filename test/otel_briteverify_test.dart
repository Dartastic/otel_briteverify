// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_briteverify/otel_briteverify.dart';
import 'package:test/test.dart';

void main() {
  group('otel_briteverify', () {
    test('suppression toggles in zone', () async {
      expect(briteVerifyInstrumentationSuppressed(), isFalse);
      await runWithoutBriteVerifyInstrumentationAsync(() async {
        expect(briteVerifyInstrumentationSuppressed(), isTrue);
      });
      expect(briteVerifyInstrumentationSuppressed(), isFalse);
    });

    test('BriteVerifyResult fields default null', () {
      const r = BriteVerifyResult();
      expect(r.statusCode, isNull);
    });
  });
}
