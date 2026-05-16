// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_linkedin_ads/otel_linkedin_ads.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_linkedin_ads-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('adAnalytics.get records B2B audience + lead gen', () async {
    await tracedLinkedinAds<String>(
      operation: 'adAnalytics.get',
      invoke: () async => const LinkedinAdsCallResult(
        value: 'ok',
        result: LinkedinAdsResult(
          adAccountId: '111222333',
          campaignGroupId: '500',
          campaignId: '600',
          objectiveType: 'LEAD_GENERATION',
          campaignType: 'SPONSORED_UPDATES',
          costType: 'CPM',
          targetAudienceSize: 45000,
          spendMinor: 350000,
          currencyCode: 'USD',
          impressions: 18000,
          clicks: 420,
          oneClickLeadFormOpens: 85,
          oneClickLeads: 32,
          statusCode: 200,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('linkedin_ads adAnalytics.get')!);
    expect(a['linkedin_ads.objective.type'], 'LEAD_GENERATION');
    expect(a['linkedin_ads.campaign.type'], 'SPONSORED_UPDATES');
    expect(a['linkedin_ads.target_audience.size'], 45000);
    expect(a['linkedin_ads.spend.minor'], 350000);
    expect(a['linkedin_ads.one_click_leads'], 32);
  });

  test('HTTP 429 sets span error', () async {
    await tracedLinkedinAds<String>(
      operation: 'campaigns.create',
      invoke: () async => const LinkedinAdsCallResult(
        value: 'ok',
        result: LinkedinAdsResult(statusCode: 429),
      ),
    );
    expect(
      spans.findSpanByName('linkedin_ads campaigns.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutLinkedinAdsInstrumentationAsync(() async {
      await tracedLinkedinAds<String>(
        operation: 'lead_forms.list',
        invoke: () async => const LinkedinAdsCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('linkedin_ads '), isEmpty);
  });
}
