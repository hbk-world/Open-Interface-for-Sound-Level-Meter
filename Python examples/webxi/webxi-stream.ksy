meta:
  id: webxi_stream
  endian: le


types:
  time_family:
    seq:
      - id: k
        type: u1
      - id: l
        type: u1
      - id: m
        type: u1
      - id: n
        type: u1
  header:
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
        3: e_state
        4: e_status
        5: e_trigger
        6: e_node
        7: e_sync
        9: e_debug
        10: e_package
        11: e_aux_sequence_data
  value:
    seq:
      - id: value1
        type: u1
      - id: value2
        type: u1
      - id: value3
        type: s1
      - id: value4
        type: s1
    instances:
      calc_value:
        value: value1 + (value2 << 8) + (value3 << 16)


  string:
    seq:
      - id: count
        type: u4
      - id: content
        type: str
        encoding: UTF-8
        size: count


  raw_sequence_data_block:
    seq:
      - id: sequence_id
        type: u2
      - id: value_length
        type: u4
      - id: values
        type: u1
        repeat: expr
        repeat-expr: value_length


  mp3_sequence_data_block:
    seq:
      - id: number_of_sequences
        type: u2
      - id: sequence_ids
        type: u2
        repeat: expr
        repeat-expr: number_of_sequences
      - id: frame_length
        type: u4
      - id: frame
        type: u1
        repeat: expr
        repeat-expr: frame_length


  flac_sequence_data_block:
    seq:
      - id: number_of_sequences
        type: u2
      - id: sequence_ids
        type: u2
        repeat: expr
        repeat-expr: number_of_sequences
      - id: frame_length
        type: u4
      - id: frame
        type: u1
        repeat: expr
        repeat-expr: frame_length


  # sequence_block:
  #   seq:
  #     - id: signal_id
  #       type: u2
  #     - id: number_of_values
  #       type: u2
  #     - id: values
  #       type: value
  #       repeat: expr
  #       repeat-expr: number_of_values


  sequence_data:
    seq:
      - id: number_of_blocks
        type: u2
      - id: message_format
        type: u1
        enum: e_message_format
      - id: reserved
        type: u1
      - id: sequence_blocks
        type: 
          switch-on: message_format
          cases:
            'e_message_format::raw'  : raw_sequence_data_block
            'e_message_format::mp3'  : mp3_sequence_data_block
            'e_message_format::flac' : flac_sequence_data_block
        repeat: expr
        repeat-expr: number_of_blocks
    enums:
      e_message_format:
        0: raw
        1: mp3
        2: flac


##TODO: This block poorly specifies the type of value in it
  aux_value:
    seq:
      - id: relative_time
        type: u4
      - id: values
        type: value

  aux_sequence_data_block:
    seq:
      - id: sequence_id
        type: u2
      - id: number_of_values
        type: u2
      - id: values
        type: aux_value
        repeat: expr
        repeat-expr: number_of_values


  aux_sequence_data:
    seq:
      - id: number_of_sequences
        type: u2
      - id: reserved
        type: u2
      - id: aux_sequence_data_blocks
        type: aux_sequence_data_block
        repeat: expr
        repeat-expr: number_of_sequences


  quality_block:
    seq:
      - id: quality_id
        type: u2
      - id: validity
        type: u2
      - id: reserved
        type: u4


  data_quality:
    seq:
      - id: number_of_qualities
        type: u2
      - id: reserved
        type: u2
      - id: qualities
        type: quality_block
        repeat: expr
        repeat-expr: number_of_qualities


  state:
    seq:
      - id: state
        type: u2
        enum: e_state
      - id: reserved
        type: u2
      - id: application_name
        type: string
    enums:
      e_state:
        0: initial
        1: error
        2: deactivated
        3: activated
        4: running
        5: ramping_down
        6: pause
        7: stopping
        8: result_measured
        9: result_loaded

  status:
    seq:
      - id: channel_type
        type: u2
        enum: e_channel_type
      - id: channel_id
        type: u2
      - id: status_type
        type: u2
        enum: e_status_type
      - id: reserved
        type: u2
      - id: value1
        type: s4
      - id: value2
        type: s4
      - id: str
        type: string
    enums:
      e_channel_type:
        0: todo
      e_status_type:
        0: todo1


  node_change:
    seq:
      - id: flags
        type: u2
      - id: reserved
        type: u2
      - id: path
        type: string
      - id: json
        type: string
  node:
    seq:
      - id: n_changes
        type: u2
      - id: reserved
        type: u2
      - id: changes
        type: node_change
        repeat: expr
        repeat-expr: n_changes


  debug:
    seq:
      - id: message
        type: string


  sync:
    seq:
      - id: sync_id
        type: u4


  package_block:
    seq:
      - id: package_id
        type: u2
      - id: data_length
        type: u2
      - id: data
        type: u1
        repeat: expr
        repeat-expr: data_length


  package:
    seq:
      - id: number_of_packages
        type: u2
      - id: reserved
        type: u2
      - id: packages
        type: package_block
        repeat: expr
        repeat-expr: number_of_packages


  trigger:
    seq:
      - id: sequence_id
        type: u2
      - id: trigger_type
        type: u2
        enum: e_trigger_type
    enums:
      e_trigger_type:
        0: unkown
        1: level
        2: start


seq:
  - id: header
    type: header
  - id: content
    size: header.content_length
    type: 
      switch-on: header.message_type
      cases:
        'header::e_message_type::e_sequence_data': sequence_data
        'header::e_message_type::e_data_quality': data_quality
        'header::e_message_type::e_state': state
        'header::e_message_type::e_status': status
        'header::e_message_type::e_trigger': trigger
        'header::e_message_type::e_node': node
        'header::e_message_type::e_sync': sync
        'header::e_message_type::e_debug': debug
        'header::e_message_type::e_package': package
        'header::e_message_type::e_aux_sequence_data': aux_sequence_data
