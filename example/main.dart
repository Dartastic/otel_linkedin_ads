// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_linkedin_ads/otel_linkedin_ads.dart';

/// Traces Linkedin Ads calls with OpenTelemetry.
///
/// `otel_linkedin_ads` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Linkedin Ads call in
/// [tracedLinkedinAds]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'linkedin-ads-example');

  // Wraps a LinkedIn Ads (Marketing Developer Platform) call in a CLIENT span.
  final linkedinAdsId = await tracedLinkedinAds<String>(
    operation: 'campaigns.create',
    invoke: () async {
      // Make the Linkedin Ads call here, then report what it returned.
      const id = 'linkedin_ads_8f3a2c';
      return const LinkedinAdsCallResult(
          value: id,
          result: LinkedinAdsResult(
              adAccountId: 'adaccount_8f3a2c',
              campaignGroupId: 'campaigngroup_8f3a2c',
              campaignId: 'campaign_8f3a2c',
              creativeId: 'creative_8f3a2c',
              objectiveType: 'BRAND_AWARENESS',
              campaignType: 'SPONSORED_UPDATES',
              costType: 'CPC',
              targetAudienceSize: 512,
              spendMinor: 1,
              currencyCode: 'usd',
              impressions: 1,
              clicks: 1,
              oneClickLeadFormOpens: 1,
              oneClickLeads: 1,
              conversionValueMinor: 1,
              statusCode: 201));
    },
  );
  OTelLog.info('tracedLinkedinAds campaigns.create returned $linkedinAdsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutLinkedinAdsInstrumentationAsync.
  await runWithoutLinkedinAdsInstrumentationAsync(
    () => tracedLinkedinAds<String>(
      operation: 'campaigns.create',
      invoke: () async {
        const id = 'linkedin_ads_8f3a2c';
        return const LinkedinAdsCallResult(
            value: id,
            result: LinkedinAdsResult(
                adAccountId: 'adaccount_8f3a2c',
                campaignGroupId: 'campaigngroup_8f3a2c',
                campaignId: 'campaign_8f3a2c',
                creativeId: 'creative_8f3a2c',
                objectiveType: 'BRAND_AWARENESS',
                campaignType: 'SPONSORED_UPDATES',
                costType: 'CPC',
                targetAudienceSize: 512,
                spendMinor: 1,
                currencyCode: 'usd',
                impressions: 1,
                clicks: 1,
                oneClickLeadFormOpens: 1,
                oneClickLeads: 1,
                conversionValueMinor: 1,
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
