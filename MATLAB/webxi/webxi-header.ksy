meta:
  id: webxi_header
  endian: le
seq:
  - id: magic
    contents: [0x42, 0x4b]
  - id: header_length
    type: u2
  - id: message_type
    type: u2
    enum: e_message_type
  - id: content_version
    type: u2
  - id: reserved2
    type: u4
  - id: time
    type: u8
  - id: content_length
    type: u4

enums:
  e_message_type:
    1: e_sequence_data
    2: e_data_quality
    3: state
    4: status
    5: trigger
    6: node
    7: sync
    9: debug
    10: package
    11: aux_sequence_data
