import 'dart:convert';
import 'dart:typed_data';
int hHeaderSize = 2, headerLenSize = 1, payloadLenSize = 1, flagsSize = 1;

class OutboundMessage {
  static const int hHeader = 0x5555; // Fixed header value
  late int headerLen;               // Set to the size of the header (32 bytes)
  late int payloadLen;              // Length of the payload
  final int flags = 0;              // Set to 0
  late Uint8List payload;           // Payload data

  OutboundMessage(String payloadSource) {
    // Convert the payload from string to bytes
    Uint8List payloadBytes = Uint8List.fromList(utf8.encode(payloadSource));

    // Set header length to the size of the header (32 bytes)
    headerLen = 32;

    // Set payload length
    payloadLen = payloadBytes.length;

    // Store the payload
    payload = payloadBytes;
  }

  // Method to generate the full packet with header
  Uint8List toStream() {
    // Create a ByteData object to construct the header (8 + 8 + 8 + 8 bytes = 32 bytes)
    ByteData headerData = ByteData(32);
    headerData.setUint16(0, hHeader, Endian.little);
    headerData.setUint64(8, headerLen, Endian.little);
    headerData.setUint64(16, payloadLen, Endian.little);
    headerData.setUint8(24, flags);

    // Combine the header and payload into one stream
    Uint8List headerBytes = headerData.buffer.asUint8List();
    Uint8List fullPacket = Uint8List(headerBytes.length + payload.length);
    fullPacket.setRange(0, headerBytes.length, headerBytes);       // Add header
    fullPacket.setRange(headerBytes.length, fullPacket.length, payload); // Add payload

    return fullPacket;
  }
}

class InboundMessage {
  static const int headerSize = 32; // Header size in bytes
  static const int validHeaderValue = 0x5555; // Expected hHeader value
  int? hHeader;
  int? headerLen;
  int? payloadLen;
  int? flags;
  final List<int> payload = []; // List to store payload segments dynamically
  bool isHeaderProcessed = false; // Tracks if the header has been processed

  // Process the first segment containing the header
  void processFirstSegment(Uint8List message) {
    if (message.length < headerSize) {
      throw ArgumentError('First segment must be at least $headerSize bytes long.');
    }

    // Extract the header (using host byte order)
    ByteData headerData = ByteData.sublistView(message);
    hHeader = headerData.getUint16(0, Endian.little); // Host format (little-endian)
    headerLen = headerData.getUint64(8, Endian.little); // Header length
    payloadLen = headerData.getUint64(16, Endian.little); // Expected payload length
    flags = headerData.getUint64(24, Endian.little); // Flags
    print("Header: " + hHeader.toString());
    print(headerLen);
    print(payloadLen);
    print(flags);
    print("valid header: "+validHeaderValue.toString());

    // Validate hHeader
    if (hHeader != validHeaderValue) {
      reset(); // Discard the message by resetting the instance
      throw StateError('Invalid hHeader value. Discarding the message.');
    }

    // Append the payload from the first segment (after the header)
    payload.addAll(message.sublist(headerSize));
    isHeaderProcessed = true;
  }

  // Process subsequent segments containing only the payload
  void processPayloadSegment(Uint8List segment) {
    if (!isHeaderProcessed) {
      throw StateError('Header must be processed first before adding payload segments.');
    }
    payload.addAll(segment);
  }

  void processSegment(Uint8List segment){
    if (isHeaderProcessed){
      processPayloadSegment(segment);
    }
    else{
      processFirstSegment(segment);
    }
  }

  bool complete(){
    return payloadLen != null && payloadLen! > 0 && payloadLen == payload.length;
  }

  // Validate and return the complete payload as a string
  String getPayloadAsString() {
    if (payloadLen == null || payload.length != payloadLen) {
      reset(); // Discard the message
      throw StateError('Payload size mismatch. Discarding the message.');
    }
    return utf8.decode(payload);
  }

  // Reset the instance in case of an invalid message
  void reset() {
    hHeader = null;
    headerLen = null;
    payloadLen = null;
    flags = null;
    payload.clear();
    isHeaderProcessed = false;
  }
}