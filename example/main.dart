// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_yodlee/otel_yodlee.dart';

/// Traces Yodlee calls with OpenTelemetry.
///
/// `otel_yodlee` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Yodlee call in
/// [tracedYodlee]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'yodlee-example');

  // Traces a Yodlee call.
  final yodleeId = await tracedYodlee<String>(
    operation: 'create',
    invoke: () async {
      // Make the Yodlee call here, then report what it returned.
      const id = 'yodlee_8f3a2c';
      return const YodleeCallResult(
          value: id,
          result: YodleeResult(
              cobrand: 'example',
              environment: 'example',
              surface: 'example',
              providerId: 'provider_8f3a2c',
              providerName: 'example',
              providerCountry: 'example',
              providerAccountId: 'provideraccount_8f3a2c',
              providerAccountStatus: 'succeeded',
              refreshStatus: 'succeeded',
              aggregationMode: 'example',
              accountId: 'account_8f3a2c',
              accountType: 'standard',
              accountContainer: 'example',
              transactionsCount: 3,
              daysReturned: 1,
              holdingsCount: 3,
              statementsCount: 3,
              documentsCount: 3,
              mfaRequired: true,
              fastLinkFlow: 'example',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedYodlee create returned $yodleeId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutYodleeInstrumentationAsync.
  await runWithoutYodleeInstrumentationAsync(
    () => tracedYodlee<String>(
      operation: 'create',
      invoke: () async {
        const id = 'yodlee_8f3a2c';
        return const YodleeCallResult(
            value: id,
            result: YodleeResult(
                cobrand: 'example',
                environment: 'example',
                surface: 'example',
                providerId: 'provider_8f3a2c',
                providerName: 'example',
                providerCountry: 'example',
                providerAccountId: 'provideraccount_8f3a2c',
                providerAccountStatus: 'succeeded',
                refreshStatus: 'succeeded',
                aggregationMode: 'example',
                accountId: 'account_8f3a2c',
                accountType: 'standard',
                accountContainer: 'example',
                transactionsCount: 3,
                daysReturned: 1,
                holdingsCount: 3,
                statementsCount: 3,
                documentsCount: 3,
                mfaRequired: true,
                fastLinkFlow: 'example',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
