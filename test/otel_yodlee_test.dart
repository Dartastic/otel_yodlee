// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_yodlee/otel_yodlee.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_yodlee-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('transactions.get records provider + counts', () async {
    await tracedYodlee<String>(
      operation: 'transactions.get',
      invoke: () async => const YodleeCallResult(
        value: 'ok',
        result: YodleeResult(
          providerName: 'Chase',
          providerCountry: 'US',
          accountContainer: 'bank',
          transactionsCount: 120,
          daysReturned: 90,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('yodlee transactions.get')!);
    expect(a['yodlee.provider.name'], 'Chase');
    expect(a['yodlee.transactions.count'], 120);
    expect(a['yodlee.days_returned'], 90);
  });

  test('refresh FAILED sets span error', () async {
    await tracedYodlee<String>(
      operation: 'providerAccounts.refresh',
      invoke: () async => const YodleeCallResult(
        value: 'ok',
        result: YodleeResult(
          providerAccountStatus: 'FAILED',
          refreshStatus: 'FAILED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('yodlee providerAccounts.refresh')!.status,
      SpanStatusCode.Error,
    );
  });

  test('FastLink launch records flow + mfa', () async {
    await tracedYodlee<String>(
      operation: 'fastlink.token',
      invoke: () async => const YodleeCallResult(
        value: 'ok',
        result: YodleeResult(
          fastLinkFlow: 'aggregation',
          mfaRequired: true,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('yodlee fastlink.token')!);
    expect(a['yodlee.fastlink.flow'], 'aggregation');
    expect(a['yodlee.mfa.required'], true);
  });

  test('suppression skips spans', () async {
    await runWithoutYodleeInstrumentationAsync(() async {
      await tracedYodlee<String>(
        operation: 'user.get',
        invoke: () async => const YodleeCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('yodlee '), isEmpty);
  });
}
