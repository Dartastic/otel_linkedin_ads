// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_linkedin_ads_suppression.dart';

const _tracerName = 'dartastic_otel_libs_linkedin_ads';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class LinkedinAdsResult {
  const LinkedinAdsResult({
    this.adAccountId,
    this.campaignGroupId,
    this.campaignId,
    this.creativeId,
    this.objectiveType,
    this.campaignType,
    this.costType,
    this.targetAudienceSize,
    this.spendMinor,
    this.currencyCode,
    this.impressions,
    this.clicks,
    this.oneClickLeadFormOpens,
    this.oneClickLeads,
    this.conversionValueMinor,
    this.statusCode,
  });

  /// LinkedIn ad account URN suffix (numeric id).
  final String? adAccountId;

  /// Campaign group (folder containing campaigns).
  final String? campaignGroupId;

  final String? campaignId;
  final String? creativeId;

  /// `BRAND_AWARENESS` / `ENGAGEMENT` / `JOB_APPLICANT` /
  /// `LEAD_GENERATION` / `WEBSITE_CONVERSION` / `WEBSITE_VISIT` /
  /// `VIDEO_VIEW` / `TALENT_LEAD`.
  final String? objectiveType;

  /// `SPONSORED_UPDATES` / `TEXT_AD` / `DYNAMIC` / `SPONSORED_INMAILS`
  /// / `SPONSORED_MESSAGE`.
  final String? campaignType;

  /// `CPC` / `CPM` / `CPV`.
  final String? costType;

  /// Estimated reach of the targeting criteria. Critical for B2B
  /// audience-size monitoring — narrow audiences spend faster.
  final int? targetAudienceSize;

  /// Spend in minor units (cents).
  final int? spendMinor;

  final String? currencyCode;
  final int? impressions;
  final int? clicks;

  /// LinkedIn Lead Gen Form opens (one-click).
  final int? oneClickLeadFormOpens;

  /// Submitted lead-gen forms.
  final int? oneClickLeads;

  /// Conversion value in minor units (offline + tracked conversions).
  final int? conversionValueMinor;

  final int? statusCode;
}

class LinkedinAdsCallResult<T> {
  const LinkedinAdsCallResult({required this.value, this.result});
  final T value;
  final LinkedinAdsResult? result;
}

/// Wraps a LinkedIn Ads (Marketing Developer Platform) call in a
/// CLIENT span. [operation] is one of `adAnalytics.get`,
/// `campaigns.create`, `campaign_groups.create`,
/// `creatives.create`, `audiences.create`, `lead_forms.list`,
/// `conversion_events.send`.
Future<T> tracedLinkedinAds<T>({
  required String operation,
  required Future<LinkedinAdsCallResult<T>> Function() invoke,
}) async {
  if (linkedinAdsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'linkedin_ads',
    'rpc.method': operation,
    'linkedin_ads.operation': operation,
  };

  final span = _tracer().startSpan(
    'linkedin_ads $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.adAccountId != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.ad_account.id',
          r.result!.adAccountId!,
        ));
      }
      if (r.result!.campaignGroupId != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.campaign_group.id',
          r.result!.campaignGroupId!,
        ));
      }
      if (r.result!.campaignId != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.campaign.id',
          r.result!.campaignId!,
        ));
      }
      if (r.result!.creativeId != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.creative.id',
          r.result!.creativeId!,
        ));
      }
      if (r.result!.objectiveType != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.objective.type',
          r.result!.objectiveType!,
        ));
      }
      if (r.result!.campaignType != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.campaign.type',
          r.result!.campaignType!,
        ));
      }
      if (r.result!.costType != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.cost.type',
          r.result!.costType!,
        ));
      }
      if (r.result!.targetAudienceSize != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.target_audience.size',
          r.result!.targetAudienceSize!,
        ));
      }
      if (r.result!.spendMinor != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.spend.minor',
          r.result!.spendMinor!,
        ));
      }
      if (r.result!.currencyCode != null) {
        extras.add(OTel.attributeString(
          'linkedin_ads.currency.code',
          r.result!.currencyCode!,
        ));
      }
      if (r.result!.impressions != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.impressions',
          r.result!.impressions!,
        ));
      }
      if (r.result!.clicks != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.clicks',
          r.result!.clicks!,
        ));
      }
      if (r.result!.oneClickLeadFormOpens != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.one_click_lead_form_opens',
          r.result!.oneClickLeadFormOpens!,
        ));
      }
      if (r.result!.oneClickLeads != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.one_click_leads',
          r.result!.oneClickLeads!,
        ));
      }
      if (r.result!.conversionValueMinor != null) {
        extras.add(OTel.attributeInt(
          'linkedin_ads.conversion_value.minor',
          r.result!.conversionValueMinor!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTel.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'LinkedIn Ads HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
