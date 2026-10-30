// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'dart:async';

const _key = #dartastic_otel_libs_linkedin_ads_suppress;

/// Whether instrumentation is suppressed in the current zone.
bool linkedinAdsInstrumentationSuppressed() => Zone.current[_key] == true;

/// Runs [body] without creating spans for calls made inside it.
T runWithoutLinkedinAdsInstrumentation<T>(T Function() body) =>
    runZoned(body, zoneValues: {_key: true});

/// Runs [body] without creating spans for calls made inside it.
Future<T> runWithoutLinkedinAdsInstrumentationAsync<T>(
  Future<T> Function() body,
) =>
    runZoned(body, zoneValues: {_key: true});
