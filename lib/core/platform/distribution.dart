import 'package:flutter/services.dart';

/// Whether this build may send SMS by itself.
///
/// The Google Play build (`--flavor play`) has no SEND_SMS permission, since
/// Play allows it only for default SMS apps. There, an SMS family check opens
/// the SMS app with the message ready and the setup person taps Send.
const bool canSendSmsAutomatically = appFlavor != 'play';
