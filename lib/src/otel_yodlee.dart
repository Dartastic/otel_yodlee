// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_yodlee_suppression.dart';

class YodleeResult {
  const YodleeResult({
    this.cobrand,
    this.environment,
    this.surface,
    this.providerId,
    this.providerName,
    this.providerCountry,
    this.providerAccountId,
    this.providerAccountStatus,
    this.refreshStatus,
    this.aggregationMode,
    this.accountId,
    this.accountType,
    this.accountContainer,
    this.transactionsCount,
    this.daysReturned,
    this.holdingsCount,
    this.statementsCount,
    this.documentsCount,
    this.mfaRequired,
    this.fastLinkFlow,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? cobrand;
  final String? environment;
  final String? surface;
  final String? providerId;
  final String? providerName;
  final String? providerCountry;
  final String? providerAccountId;
  final String? providerAccountStatus;
  final String? refreshStatus;
  final String? aggregationMode;
  final String? accountId;
  final String? accountType;
  final String? accountContainer;
  final int? transactionsCount;
  final int? daysReturned;
  final int? holdingsCount;
  final int? statementsCount;
  final int? documentsCount;
  final bool? mfaRequired;
  final String? fastLinkFlow;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class YodleeCallResult<T> {
  const YodleeCallResult({required this.value, this.result});
  final T value;
  final YodleeResult? result;
}

Future<T> tracedYodlee<T>({
  required String operation,
  required Future<YodleeCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (yodleeInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_yodlee');
  final span = t.startSpan('yodlee $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.system', 'yodlee')]));
    span.addAttributes(
        OTel.attributes([OTel.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.cobrand != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.cobrand', res.cobrand!)]));
      }
      if (res.environment != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.environment', res.environment!)]));
      }
      if (res.surface != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.surface', res.surface!)]));
      }
      if (res.providerId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.provider.id', res.providerId!)]));
      }
      if (res.providerName != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.provider.name', res.providerName!)]));
      }
      if (res.providerCountry != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('yodlee.provider.country', res.providerCountry!)
        ]));
      }
      if (res.providerAccountId != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'yodlee.provider_account.id', res.providerAccountId!)
        ]));
      }
      if (res.providerAccountStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'yodlee.provider_account.status', res.providerAccountStatus!)
        ]));
      }
      if (res.refreshStatus != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('yodlee.refresh.status', res.refreshStatus!)
        ]));
      }
      if (res.aggregationMode != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString('yodlee.aggregation.mode', res.aggregationMode!)
        ]));
      }
      if (res.accountId != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.account.id', res.accountId!)]));
      }
      if (res.accountType != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.account.type', res.accountType!)]));
      }
      if (res.accountContainer != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              'yodlee.account.container', res.accountContainer!)
        ]));
      }
      if (res.transactionsCount != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('yodlee.transactions.count', res.transactionsCount!)
        ]));
      }
      if (res.daysReturned != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('yodlee.days_returned', res.daysReturned!)]));
      }
      if (res.holdingsCount != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('yodlee.holdings.count', res.holdingsCount!)]));
      }
      if (res.statementsCount != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('yodlee.statements.count', res.statementsCount!)
        ]));
      }
      if (res.documentsCount != null) {
        span.addAttributes(OTel.attributes([
          OTel.attributeInt('yodlee.documents.count', res.documentsCount!)
        ]));
      }
      if (res.mfaRequired != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeBool('yodlee.mfa.required', res.mfaRequired!)]));
      }
      if (res.fastLinkFlow != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.fastlink.flow', res.fastLinkFlow!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeInt('http.response.status_code', res.statusCode!)]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTel.attributes(
            [OTel.attributeString('yodlee.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.refreshStatus == 'FAILED' ||
          res.providerAccountStatus == 'FAILED' ||
          res.providerAccountStatus == 'LOGIN_IN_PROGRESS_FAILED';
      if (fail) {
        span.addAttributes(OTel.attributes([
          OTel.attributeString(
              ErrorResource.errorType.key, res.errorCode ?? 'yodlee.error')
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
