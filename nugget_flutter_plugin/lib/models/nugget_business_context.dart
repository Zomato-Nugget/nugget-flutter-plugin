
class NuggetBusinessContext {
  String? channelHandle;
  String? ticketGroupingId;
  Map<String, List<String>>? ticketProperties;
  Map<String, List<String>>? botProperties;

  NuggetBusinessContext({this.channelHandle, this.ticketGroupingId, this.ticketProperties, this.botProperties});

  Map<String, dynamic> toJson() => {
    'channelHandle': channelHandle,
    'ticketGroupingId': ticketGroupingId,
    'ticketProperties': ticketProperties,
    'botProperties': botProperties,
  };
}