import '../../family/domain/contact.dart';

/// What the parent asked for, worked out from what the phone heard.
sealed class Command {
  const Command();
}

/// "Call Ravi", "రవికి ఫోన్ చెయ్యి", "बेटे को फोन लगाओ".
final class CallContact extends Command {
  const CallContact(this.contact);

  final Contact contact;

  @override
  bool operator ==(Object other) =>
      other is CallContact && other.contact.id == contact.id;

  @override
  int get hashCode => contact.id.hashCode;
}

/// "Call" without a name we know: the app asks whom to call.
final class CallWhom extends Command {
  const CallWhom();

  @override
  bool operator ==(Object other) => other is CallWhom;

  @override
  int get hashCode => (CallWhom).hashCode;
}

/// "Help", "కాపాడండి", "बचाओ".
final class AskHelp extends Command {
  const AskHelp();

  @override
  bool operator ==(Object other) => other is AskHelp;

  @override
  int get hashCode => (AskHelp).hashCode;
}

/// "What time is it?"
final class TellTime extends Command {
  const TellTime();

  @override
  bool operator ==(Object other) => other is TellTime;

  @override
  int get hashCode => (TellTime).hashCode;
}

/// "What day is today?"
final class TellDate extends Command {
  const TellDate();

  @override
  bool operator ==(Object other) => other is TellDate;

  @override
  int get hashCode => (TellDate).hashCode;
}

/// "How much battery?"
final class TellBattery extends Command {
  const TellBattery();

  @override
  bool operator ==(Object other) => other is TellBattery;

  @override
  int get hashCode => (TellBattery).hashCode;
}

/// "My reminders", "మందులు", "दवाई": what is left to do today.
final class TellReminders extends Command {
  const TellReminders();

  @override
  bool operator ==(Object other) => other is TellReminders;

  @override
  int get hashCode => (TellReminders).hashCode;
}

/// "Light on" / "light off".
final class SetTorch extends Command {
  const SetTorch({required this.on});

  final bool on;

  @override
  bool operator ==(Object other) => other is SetTorch && other.on == on;

  @override
  int get hashCode => Object.hash(SetTorch, on);
}

/// Nothing we recognise.
final class NotUnderstood extends Command {
  const NotUnderstood();

  @override
  bool operator ==(Object other) => other is NotUnderstood;

  @override
  int get hashCode => (NotUnderstood).hashCode;
}
