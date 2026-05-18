// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
