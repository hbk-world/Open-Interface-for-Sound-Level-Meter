--[[

    This is a Wireshark dissector for the HBK WebXi streaming protocol.

    To use, copy the webxi.lua file to the Wireshark plugins folder. The location of
    the plugins folder might be:
        
        - Windows: C:\Users\<user>\AppData\Roaming\Wireshark\plugins

        - Linux: /home/<user>/.local/lib/wireshark/plugins

        (alternatively, open Wireshark and look up the folder that it uses:
         Help -> About Wireshark, Folders tab, Global/Personal Lua Plugins)

    It's a heuristic dissector, which means it is not associated with any TCP or UDP
    port number. Instead, Wireshark will call its dissector function for every packet
    and the dissector function will return a value that indicates whether the packet
    was recognized as WebXi.

    The dissector is implemented in the Lua scripting language.    

    To modify or extend the dissector, make modifications to this file and then press
    Ctrl+Shift+L in Wireshark to reload the script.

    For documentation see

        - fpm.lua sample that this dissector was based on:
            https://wiki.wireshark.org/Lua/Examples#A_dissector_tutorial_with_TCP-reassembly

        - Wireshark Lua API:
            https://www.wireshark.org/docs/wsdg_html_chunked/wsluarm_modules.html

]]--

webxi_protocol = Proto("WebXi", "WebXi Streaming Protocol")

-- Define the protocol fields, which specify how values are named and displayed in wireshark

-- WebXi header
f_hd_magic = ProtoField.uint16("webxi.header.magic", "Magic", base.HEX)
f_hd_header_length = ProtoField.uint16("webxi.header.header_length", "Header Length", base.DEC)
f_hd_message_type = ProtoField.uint16("webxi.header.message_type", "Message Type", base.DEC)
f_hd_content_version = ProtoField.uint16("webxi.header.content_version", "Content Version", base.DEC)
f_hd_reserved2 = ProtoField.uint32("webxi.header.reserved2", "Reserved 2", base.HEX)
f_hd_time = ProtoField.uint64("webxi.header.time", "Time", base.DEC)
f_hd_content_length = ProtoField.uint32("webxi.header.content_length", "Content Length", base.DEC)

-- SequenceData message
f_sd_number_of_blocks = ProtoField.uint16("webxi.sequence_data.number_of_blocks", "Number Of Blocks", base.DEC)
f_sd_message_format = ProtoField.uint8("webxi.sequence_data.message_format", "Message Format", base.DEC)
f_sd_reserved = ProtoField.uint8("webxi.sequence_data.reserved", "Reserved", base.HEX)
-- Raw format
f_sd_sequence_id = ProtoField.uint16("webxi.sequence_data.sequence_id", "Sequence ID", base.DEC)
f_sd_value_length = ProtoField.uint16("webxi.sequence_data.value_length", "Number Of Values", base.DEC)
f_sd_values = ProtoField.bytes("webxi.sequence_data.values", "Values", base.SPACE)
-- Non-raw format
f_sd_number_of_sequences = ProtoField.uint16("webxi.sequence_data.number_of_sequences", "Number Of Sequences", base.DEC)
f_sd_frame_length = ProtoField.uint32("webxi.sequence_data.frame_length", "Frame Length", base.DEC)
f_sd_frame = ProtoField.bytes("webxi.sequence_data.frame", "Frame", base.SPACE)

-- DataQuality message
f_dq_number_of_qualities = ProtoField.uint16("webxi.data_quality.number_of_qualities", "Number Of Qualities", base.DEC)
f_dq_reserved1 = ProtoField.uint16("webxi.data_quality.reserved1", "Reserved", base.HEX)
f_dq_quality_id = ProtoField.uint16("webxi.data_quality.quality_id", "Quality ID", base.DEC)
f_dq_validity = ProtoField.uint16("webxi.data_quality.validity", "Validity", base.HEX)
f_dq_reserved2 = ProtoField.uint16("webxi.data_quality.reserved2", "Reserved", base.HEX)

-- State message
f_st_state = ProtoField.string("webxi.state.state", "State", base.UNICODE)
f_st_application_name = ProtoField.string("webxi.state.application_name", "Application Name", base.UNICODE)

-- Status message
f_ss_channel_type = ProtoField.uint16("webxi.status.channel_type", "Channel Type", base.DEC)
f_ss_channel_id = ProtoField.uint16("webxi.status.channel_id", "Channel ID", base.DEC)
f_ss_status_type = ProtoField.uint16("webxi.status.status_type", "Status Type", base.DEC)
f_ss_reserved = ProtoField.uint16("webxi.status.reserved", "Reserved", base.HEX)
f_ss_value1 = ProtoField.uint32("webxi.status.value1", "Value 1", base.HEX)
f_ss_value2 = ProtoField.uint32("webxi.status.value2", "Value 2", base.HEX)
f_ss_string = ProtoField.string("webxi.status.string", "String", base.UNICODE)

-- Trigger message
f_tr_sequence_id = ProtoField.uint16("webxi.trigger.sequence_id", "Sequence ID", base.DEC)
f_tr_trigger_type = ProtoField.uint16("webxi.trigger.trigger_type", "Trigger Type", base.DEC)

-- Node message
f_no_number_of_changes = ProtoField.uint16("webxi.node.number_of_changes", "Number Of Changes", base.DEC)
f_no_reserved1 = ProtoField.uint16("webxi.node.reserved1", "Reserved", base.HEX)
f_no_flags = ProtoField.uint16("webxi.node.flags", "Flags", base.HEX)
f_no_reserved2 = ProtoField.uint16("webxi.node.reserved2", "Reserved", base.HEX)
f_no_path = ProtoField.string("webxi.node.path", "Path", base.UNICODE)
f_no_json_string = ProtoField.string("webxi.node.json_string", "Json String", base.UNICODE)

-- Debug message
f_de_string = ProtoField.string("webxi.debug.string", "String", base.UNICODE)

-- Sync message
f_sy_sync_id = ProtoField.uint32("webxi.sync.sync_id", "Sync ID", base.DEC)

-- Package message
f_pa_number_of_packages = ProtoField.uint16("webxi.package.number_of_packages", "Number Of Packages", base.DEC)
f_pa_reserved = ProtoField.uint16("webxi.package.reserved", "Reserved", base.HEX)
f_pa_package_id = ProtoField.uint16("webxi.package.package_id", "Package ID", base.DEC)
f_pa_data_length = ProtoField.uint16("webxi.package.data_length", "Data Length", base.DEC)
f_pa_data = ProtoField.bytes("webxi.package.data", "Data", base.SPACE)

-- AuxSequenceData message
f_au_number_of_sequences = ProtoField.uint16("webxi.aux_sequence_data.number_of_sequences", "Number Of Sequences", base.DEC)
f_au_reserved = ProtoField.uint16("webxi.aux_sequence_data.reserved", "Reserved", base.HEX)
f_au_sequence_id = ProtoField.uint16("webxi.aux_sequence_data.sequence_id", "Sequence ID", base.DEC)
f_au_number_of_values = ProtoField.uint16("webxi.aux_sequence_data.number_of_values", "Number Of Values", base.DEC)
f_au_relative_time = ProtoField.uint32("webxi.aux_sequence_data.relative_time", "Relative Time", base.DEC)
f_au_value = ProtoField.uint8("webxi.aux_sequence_data.value", "Value", base.HEX)

webxi_protocol.fields = {
    f_hd_magic,
    f_hd_header_length,
    f_hd_message_type,
    f_hd_content_version,
    f_hd_reserved2,
    f_hd_time,
    f_hd_content_length,
    f_sd_number_of_blocks,
    f_sd_message_format,
    f_sd_reserved,
    f_sd_sequence_id,
    f_sd_value_length,
    f_sd_values,
    f_sd_number_of_sequences,
    f_sd_frame_length,
    f_sd_frame,
    f_dq_number_of_qualities,
    f_dq_reserved1,
    f_dq_quality_id,
    f_dq_validity,
    f_dq_reserved2,
    f_st_state,
    f_st_reserved,
    f_st_application_name,
    f_ss_channel_type,
    f_ss_channel_id,
    f_ss_status_type,
    f_ss_reserved,
    f_ss_value1,
    f_ss_value2,
    f_ss_string,
    f_tr_sequence_id,
    f_tr_trigger_type,
    f_no_number_of_changes,
    f_no_reserved1,
    f_no_flags,
    f_no_reserved2,
    f_no_path,
    f_no_json_string,
    f_de_string,
    f_sy_sync_id,
    f_pa_number_of_packages,
    f_pa_reserved,
    f_pa_package_id,
    f_pa_data_length,
    f_pa_data,
    f_au_number_of_sequences,
    f_au_reserved,
    f_au_sequence_id,
    f_au_number_of_values,
    f_au_relative_time,
    f_au_value
}

-- This is the size of a WebXi message header (24 bytes) and the minimum number
-- of bytes we require to figure out how many bytes the rest of the message will be.
local WEBXI_HDR_LEN = 24

-- Keeps track of the previous message type we've processed
local globals = {
    prev_message_string = ""
}

-- Maps the message type from the WebXi header to a descriptive string
local function message_string(val)

    local strings = {
        [1] = "SequenceData",
        [2] = "DataQuality",
        [3] = "State",
        [4] = "Status",
        [5] = "Trigger",
        [6] = "Node",
        [7] = "Sync",
        [9] = "Debug",
        [10] = "Package",
        [11] = "AuxSequenceData"
    }

    return strings[val] or "Unknown"
end

-- Maps the message format from the SequenceData message to a descriptive string
local function message_format_string(val)

    local strings = {
        [0] = "Raw",
        [1] = "Mp3",
        [2] = "Flac"
    }

    return strings[val] or "Unknown"
end

-- Maps the validity flags from the DataQuality message to a string
local function data_quality_validity_string(val)

    local string = "Valid"

    if val ~= 0 then

        string = ""
        local separator = ""

        if bit32.band(val, 1) ~= 0 then
            string = string .. separator .. "Unknown"
            separator = ", "
        end

        if bit32.band(val, 2) ~= 0 then
            string = string .. separator .. "Clipped"
            separator = ", "
        end

        if bit32.band(val, 4) ~= 0 then
            string = string .. separator .. "Settling"
            separator = ", "
        end

        if bit32.band(val, 8) ~= 0 then
            string = string .. separator .. "Invalid"
            separator = ", "
        end

        if bit32.band(val, 16) ~= 0 then
            string = string .. separator .. "Overrun"
            separator = ", "
        end
    end

    return string
end

-- Maps the status type from the Status message to a string
local function status_type_string(val)

    local strings = {
        [1] = "AnalogOverload",
        [2] = "DigitalOverload",
        [3] = "CCLDOverload",
        [4] = "CVLDOverload",
        [5] = "CommonModeOverload",
        [6] = "InputProtection",
        [7] = "CableBreak",
        [8] = "Fan",
        [9] = "Temperature",
        [10] = "Power",
        [11] = "PowerAlarm",
        [12] = "Synchronization",
        [13] = "CommandCompleted",
        [14] = "Vts",
        [15] = "Overrun",
        [16] = "MessageNotSent",
        [17] = "Debug",
        [18] = "PowerLoss",
        [19] = "CriticalError",
        [20] = "GpioState",
        [21] = "TransducerDetect",
        [22] = "GpioFault",
        [23] = "SLM",
        [24] = "ConnectionTimeout",
        [25] = "Calibration",
        [26] = "CurrentOverload",
        [27] = "SlewRateLimit",
        [28] = "PowerSupply",
        [29] = "DiskSpaceAlarm"
    }

    return strings[val] or "Unknown"
end

-- Maps the Overload enum from the Status message to a string
local function status_overload_string(val)

    local strings = {
        [0] = "OK",
        [1] = "Invalid",
        [2] = "Low",
        [3] = "High",
        [4] = "UnderRange",
        [5] = "OverRange"
    }

    return strings[val] or "Unknown"
end

-- Maps the Fan Status enum from the Status message to a string
local function status_fan_status_string(val)

    local strings = {
        [1] = "ControlModeChanged",
        [2] = "Speed",
        [3] = "SilentOverrule"
    }

    return strings[val] or "Unknown"
end

-- Maps the Fan Speed enum from the Status message to a string
local function status_fan_speed_string(val)

    local strings = {
        [1] = "Off",
        [2] = "Low",
        [3] = "Middle",
        [4] = "High"
    }

    return strings[val] or "Unknown"
end

-- Maps the Fan Control Mode enum from the Status message to a string
local function status_fan_control_mode_string(val)

    local strings = {
        [1] = "Auto",
        [2] = "Manual"
    }

    return strings[val] or "Unknown"
end

-- Maps the Temperature Status enum from the Status message to a string
local function status_temperature_status_string(val)

    local strings = {
        [1] = "ControlModeChanged",
        [2] = "LevelChanged",
        [3] = "Overheat",
        [4] = "Shutdown",
        [5] = "ShutdownCancelled",
        [6] = "TooManyReadError",
        [7] = "AllThermoFailure"
    }

    return strings[val] or "Unknown"
end

-- Maps the Temperature Shutdown Reason enum from the Status message to a string
local function status_temperature_shutdown_reason_string(val)

    local strings = {
        [0] = "None",
        [1] = "HighTemp",
        [2] = "NoSensor"
    }

    return strings[val] or "Unknown"
end

-- Maps the Temperature Level enum from the Status message to a string
local function status_temperature_level_string(val)

    local strings = {
        [1] = "Off",
        [2] = "Low",
        [3] = "Middle",
        [4] = "High",
        [5] = "Overheat",
        [6] = "PowerOff"
    }

    return strings[val] or "Unknown"
end

-- Maps the Temperature Control Mode enum from the Status message to a string
local function status_temperature_control_mode_string(val)

    local strings = {
        [1] = "Auto",
        [2] = "Manual"
    }

    return strings[val] or "Unknown"
end

-- Maps the Power Source enum from the Status message to a string
local function status_power_source_string(val)

    local strings = {
        [1] = "PoE",
        [2] = "DC",
        [3] = "AC",
        [4] = "Battery",
        [5] = "USB",
        [6] = "Backup"
    }

    return strings[val] or "Unknown"
end

-- Maps the Power Mode enum from the Status message to a string
local function status_power_mode_string(val)

    local strings = {
        [1] = "Normal",
        [2] = "PowerSave",
        [3] = "Off"
    }

    return strings[val] or "Unknown"
end

-- Maps the Synchronization State enum from the Status message to a string
local function status_synchronization_state_string(val)

    local strings = {
        [1] = "OutOfLock",
        [2] = "Locking",
        [3] = "Locked"
    }

    return strings[val] or "Unknown"
end

-- Maps the Transducer Detect Status enum from the Status message to a string
local function status_transducer_detect_status_string(val)

    local strings = {
        [1] = "Start",
        [2] = "Done",
        [3] = "Fail"
    }

    return strings[val] or "Unknown"
end

-- Maps the Vts Status enum from the Status message to a string
local function status_vts_status_string(val)

    local string

    if val == 0 then
        string = "None"
    else
        string = ""
        local separator = ""

        if bit32.band(val, 1) ~= 0 then
            string = string .. separator .. "RmsHigh"
            separator = ", "
        end

        if bit32.band(val, 2) ~= 0 then
            string = string .. separator .. "RmsLow"
            separator = ", "
        end

        if bit32.band(val, 4) ~= 0 then
            string = string .. separator .. "LineHigh"
            separator = ", "
        end

        if bit32.band(val, 8) ~= 0 then
            string = string .. separator .. "LineLow"
            separator = ", "
        end

        if bit32.band(val, 0x10) ~= 0 then
            string = string .. separator .. "DataQuality"
            separator = ", "
        end

        if bit32.band(val, 0x20) ~= 0 then
            string = string .. separator .. "DriveMax"
            separator = ", "
        end

        if bit32.band(val, 0x40) ~= 0 then
            string = string .. separator .. "SigmaClip"
            separator = ", "
        end

        if bit32.band(val, 0x80) ~= 0 then
            string = string .. separator .. "OpenLoop"
            separator = ", "
        end

        if bit32.band(val, 0x100) ~= 0 then
            string = string .. separator .. "MeasurementNoisy"
            separator = ", "
        end

        if bit32.band(val, 0x200) ~= 0 then
            string = string .. separator .. "ForcedStop"
            separator = ", "
        end

        if bit32.band(val, 0x400) ~= 0 then
            string = string .. separator .. "DriveNotch"
            separator = ", "
        end

        if bit32.band(val, 0x800) ~= 0 then
            string = string .. separator .. "UnderRange"
            separator = ", "
        end

        if bit32.band(val, 0x1000) ~= 0 then
            string = string .. separator .. "LinesWrong"
            separator = ", "
        end

        if bit32.band(val, 0x2000) ~= 0 then
            string = string .. separator .. "GoalLevelReached"
            separator = ", "
        end

        if bit32.band(val, 0x4000) ~= 0 then
            string = string .. separator .. "MeasurementNotNoisy"
            separator = ", "
        end

        if bit32.band(val, 0x8000) ~= 0 then
            string = string .. separator .. "ExternalAbort"
            separator = ", "
        end

        if string == "" then
            string = "Unknown"
        end
    end

    return string
end

-- Maps the Gpio Fault value from the Status message to a string
local function status_gpio_fault_string(val)

    local strings = {
        [0] = "No Fault",
        [1] = "Fault"
    }

    return strings[val] or "Unknown"
end

-- Maps the SLM Status enum from the Status message to a string
local function status_slm_status_string(val)

    local strings = {
        [0] = "None",
        [1] = "ProjectCreated",
        [2] = "ProjectDeleted"
    }

    return strings[val] or "Unknown"
end

-- Maps the status type from the Status message to a string
local function status_value_strings(type_string, value1, value2)

    local value1_string
    local value2_string

    if type_string == "AnalogOverload"
    or type_string == "DigitalOverload"
    or type_string == "CCLDOverload"
    or type_string == "CVLDOverload"
    or type_string == "CommonModeOverload"
    or type_string == "InputProtection"
    or type_string == "CableBreak" then
        value1_string = status_overload_string(value1)
    elseif type_string == "Fan" then
        value1_string = "Status " .. status_fan_status_string(value1)
        value2_string = "Speed " .. status_fan_status_string(bit32.band(value2, 0xff)) ..
            ", Control Mode " .. status_fan_control_mode_string(bit32.rshift(bit32.band(value1, 0xff), 16))
    elseif type_string == "Temperature" then
        value1_string = "Status " .. status_temperature_status_string(bit32.band(value1, 0xff)) ..
            ", Shutdown Time " .. bit32.rshift(bit32.band(value1, 0xffff00), 8) .. " s" ..
            ", Shutdown Reason " .. status_temperature_shutdown_reason_string(bit32.rshift(bit32.band(value1, 0xff000000), 24))
        value2_string = "Temperature " .. bit32.band(value2, 0xffff) .. " C" ..
            ", Level " .. status_temperature_level_string(bit32.rshift(bit32.band(value2, 0xff0000), 16)) ..
            ", Control Mode " .. status_temperature_control_mode_string(bit32.rshift(bit32.band(value2, 0xff000000), 24))
    elseif type_string == "Power" then
        value1_string = "Source " .. status_power_source_string(bit32.rshift(bit32.band(value1, 0xffff0000), 16)) ..
            ", Mode " status_power_mode_string(bit32.band(value1, 0xffff))
        value2_string = "Consumption " .. value2 .. " mW"
    elseif type_string == "PowerAlarm" then
        value1_string = "Remaining Time " .. value1 .. " seconds"
    elseif type_string == "Synchronization" then
        value1_string = "Precision " .. value1 .. " ns"
        value2_string = "State " .. status_synchronization_state_string(value2)
    elseif type_string == "CommandCompleted" then
        value1_string = "Status " .. value1
    elseif type_string == "Vts" then
        value1_string = "Abort Status " .. status_vts_status_string(value1)
        value2_string = "Alarm Status " .. status_vts_status_string(value2)
    elseif type_string == "Overrun" then
        value1_string = status_overload_string(value1)
    elseif type_string == "TransducerDetect" then
        value1_string = "Status " .. status_transducer_detect_status_string(value1)
    elseif type_string == "GpioFault" then
        value1_string = "Status " .. status_gpio_fault_string(value1)
    elseif type_string == "SLM" then
        value1_string = status_slm_status_string(bit32.band(value1, 0xffff))
    elseif type_string == "DiskSpaceAlarm" then
        value1_string = "Free Space " .. value1 .. " MB"
    end

    return value1_string, value2_string
end

-- Maps the trigger type enum from the Trigger message to a string
local function trigger_type_string(val)

    local strings = {
        [1] = "Level",
        [2] = "Start"
    }

    return strings[val] or "Unknown"
end

-- Maps the Flags enum from the Node message to a string
local function node_flags_string(val)

    local string = ""
    local separator = ""

    if bit32.band(val, 1) ~= 0 then
        string = string .. separator .. "Value Changed"
        separator = ", "
    end

    if bit32.band(val, 2) ~= 0 then
        string = string .. separator .. "Metadata Changed"
        separator = ", "
    end

    if bit32.band(val, 4) ~= 0 then
        string = string .. separator .. "Created"
        separator = ", "
    end

    if bit32.band(val, 8) ~= 0 then
        string = string .. separator .. "Deleted"
        separator = ", "
    end

    if string == "" then
        string = "Unknown"
    end

    return string
end

-- Given a packet buffer (tvbuf), returns true if the buffer contains a WebXi message
local function is_webxi(tvbuf, offset)

    local length = tvbuf:len()
    if length < WEBXI_HDR_LEN then return false end

    local magic = tvbuf(offset, 2):string()
    if magic ~= "BK" then return false end

    local header_length = tvbuf(offset + 2, 2):le_uint()
    if header_length ~= 16 then return false end

    local message_type = tvbuf(offset + 4, 2):le_uint()
    local message_string = message_string(message_type)
    if message_string == "Unknown" then return false end

    local reserved1 = tvbuf(offset + 6, 2):le_uint()
    if reserved1 ~= 0 then return false end

    local reserved2 = tvbuf(offset + 8, 4):le_uint()
    if reserved2 ~= 0 then return false end

    return true
end

-- Function to check and return the message length as well as
-- a boolean specifying whether the message was identified as
-- WebXi
local function check_message_length(tvbuf, offset)

    -- "msglen" is the number of bytes remaining in the tv buffer which we
    -- have available to dissect in this run
    local msglen = tvbuf:len() - offset

    -- check if capture only contains partial packet
    if msglen ~= tvbuf:reported_length_remaining(offset) then
        -- captured packets are being sliced/cut-off, so don't try to desegment/reassemble
        return 0, false
    end

    if msglen < WEBXI_HDR_LEN then
        -- we need more bytes, so tell the main dissector function that we
        -- didn't dissect anything, and we need an unknown number of more
        -- bytes (which is what "DESEGMENT_ONE_MORE_SEGMENT" is used for)
        -- return as a negative number
        return -DESEGMENT_ONE_MORE_SEGMENT, false
    end

    -- we have enough bytes to check if this is a WebXi message
    if is_webxi(tvbuf, offset) then
        -- if we got here, then we know we have enough bytes in the Tvb buffer
        -- to at least figure out the full length of this WebXi messsage 
        -- (the length is the 32-bit integer in bytes 20 to 23)

        -- get the TvbRange of bytes 20-23
        local length_tvbr = tvbuf:range(offset + 20, 4)

        -- get the total WebXi message length as an unsigned integer, in little endian byte order
        local length_val = length_tvbr:le_uint() + WEBXI_HDR_LEN

        if msglen < length_val then
            -- we need more bytes to get the whole WebXi message
            return -(length_val - msglen), false
        end

        -- got a complete WebXi message, return number of bytes (length_val), is WebXi (true)
        return length_val, true
    end

    -- not recognized as WebXi
    return 0, false
end

-- Dissects a WebXi SequenceData message
local function webxi_dissect_sequence_data(tvbuf, pktinfo, root, bytes_total, offset)

    local number_of_blocks = tvbuf(offset, 2):le_uint()
    local tree_title = "WebXi SequenceData Header, Number Of Blocks: " .. number_of_blocks

    local message_format = tvbuf(offset + 2, 1):le_uint()
    local message_format_string = message_format_string(message_format)

    local number_of_blocks = tvbuf(offset, 2):le_uint()

    local top_tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    top_tree:add_le(f_sd_number_of_blocks, tvbuf(offset, 2))
    top_tree:add_le(f_sd_message_format, tvbuf(offset + 2, 1)):append_text(" (" .. message_format_string .. ")")
    top_tree:add_le(f_sd_reserved, tvbuf(offset + 3, 1))

    local header_length = 4
    local bytes_consumed = header_length
    offset = offset + header_length

    local sequence_ids = {}

    if message_format_string == "Raw" then
        while bytes_consumed < bytes_total do
            local sequence_id = tvbuf(offset, 2):le_uint()
            local value_length = tvbuf(offset + 2, 4):le_uint()

            local tree_title = "WebXi " .. message_format_string .. " SequenceData Descriptor, Sequence ID: " .. sequence_id .. ", Value Length: " .. value_length .. " bytes"

            local msg_len = 2 + 4 + value_length

            local tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)
    
            tree:add_le(f_sd_sequence_id, tvbuf(offset, 2))
            tree:add_le(f_sd_value_length, tvbuf(offset + 2, 4))
            tree:add(f_sd_values, tvbuf(offset + 6, value_length))
    
            bytes_consumed = bytes_consumed + msg_len
            offset = offset + msg_len
    
            sequence_ids[sequence_id] = 0
        end
    else
        while bytes_consumed < bytes_total do
            local number_of_sequences = tvbuf(offset, 2):le_uint()
            local sequence_ids_length = number_of_sequences * 2
            local frame_length = tvbuf(offset + 2 + sequence_ids_length, 4):le_uint()

            local tree_title = "WebXi " .. message_format_string .. " SequenceData Descriptor, Number Of Sequences: " .. number_of_sequences .. ", Frame Length: " .. frame_length .. " bytes"

            local msg_len = 2 + sequence_ids_length + 4 + frame_length

            local tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)
    
            tree:add_le(f_sd_number_of_sequences, tvbuf(offset, 2))

            for i = 0, number_of_sequences - 1 do

                tree:add_le(f_sd_sequence_id, tvbuf(offset + 2 + i * 2, 2))

                local sequence_id = tvbuf(offset + 2 + i * 2, 2):le_uint()
                sequence_ids[sequence_id] = 0
            end

            tree:add_le(f_sd_frame_length, tvbuf(offset + 2 + sequence_ids_length, 4))
            tree:add(f_sd_frame, tvbuf(offset + 2 + sequence_ids_length + 4, frame_length))
    
            bytes_consumed = bytes_consumed + msg_len
            offset = offset + msg_len
        end
    end

    local info = "(" .. message_format_string .. ")"

    return sequence_ids, info
end

-- Dissects a WebXi DataQuality message
local function webxi_dissect_data_quality(tvbuf, pktinfo, root, bytes_total, offset)

    local header_length = 4

    local number_of_qualities = tvbuf(offset, 2):le_uint()

    local tree_title = "WebXi DataQuality Header, Number Of Qualities: " .. number_of_qualities

    local top_tree = root:add(webxi_protocol, tvbuf:range(offset, header_length), tree_title)

    top_tree:add_le(f_dq_number_of_qualities, tvbuf(offset, 2))
    top_tree:add_le(f_dq_reserved1, tvbuf(offset + 2, 2))

    local bytes_consumed = header_length
    offset = offset + header_length

    local msg_len = 8
    
    local quality_ids = {}

    while bytes_consumed < bytes_total do

        local quality_id = tvbuf(offset, 2):le_uint()
        local tree_title = "WebXi DataQuality Descriptor, Quality ID: " .. quality_id

        local validity = tvbuf(offset + 2, 2):le_uint()
        local validity_string = data_quality_validity_string(validity)

        local tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)

        tree:add_le(f_dq_quality_id, tvbuf(offset, 2))
        tree:add_le(f_dq_validity, tvbuf(offset + 2, 2)):append_text(" (" .. validity_string .. ")")
        tree:add_le(f_dq_reserved2, tvbuf(offset + 4, 2))

        bytes_consumed = bytes_consumed + msg_len
        offset = offset + msg_len

        quality_ids[quality_id] = 0
    end

    return quality_ids, nil
end

-- Dissects a WebXi State message
local function webxi_dissect_state(tvbuf, pktinfo, root, bytes_total, offset)

    -- note 2245 does not follow DD17323 here
    local application_name_length = tvbuf(offset, 4):le_uint()
    local application_name_start = offset + 4
    local application_name = tvbuf(application_name_start, application_name_length):string()

    local state_string_length = tvbuf(application_name_start + application_name_length, 4):le_uint()
    local state_string_start = application_name_start + application_name_length + 4
    local state_string = tvbuf(state_string_start, state_string_length):string()

    local tree_title = "WebXi State Header, Application Name: " .. application_name .. ", State: " .. state_string

    local msg_len = 4 + application_name_length + 4 + state_string_length

    local top_tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)

    top_tree:add_le(f_st_application_name, tvbuf(application_name_start, application_name_length))
    top_tree:add_le(f_st_state, tvbuf(state_string_start, state_string_length))

    local info = application_name .. " " .. state_string

    return nil, info
end

-- Dissects a WebXi Status message
local function webxi_dissect_status(tvbuf, pktinfo, root, bytes_total, offset)

    local channel_type_val = tvbuf(offset, 2):le_uint()
    local channel_id = tvbuf(offset + 2, 2):le_uint()
    local status_type_val = tvbuf(offset + 4, 2):le_uint()
    local status_type_string = status_type_string(status_type_val)

    local value1_val = tvbuf(offset + 8, 4):le_uint()
    local value2_val = tvbuf(offset + 12, 4):le_uint()
    local value1_string, value2_string = status_value_strings(status_type_string, value1_val, value2_val)

    local tree_title = "WebXi Status Header, Channel Type: " .. channel_type_val .. ", Channel ID: " .. channel_id .. ", Status Type: " .. status_type_string

    local top_tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    local string_length = tvbuf(offset + 16, 4):le_uint()

    top_tree:add_le(f_ss_channel_type, tvbuf(offset, 2)) -- DD17323 doesn't document this enum, so we can't present a string
    top_tree:add_le(f_ss_channel_id, tvbuf(offset + 2, 2))
    top_tree:add_le(f_ss_status_type, tvbuf(offset + 4, 2)):append_text(" (" .. status_type_string .. ")")
    top_tree:add_le(f_ss_reserved, tvbuf(offset + 6, 2))

    local value1_tree_item = top_tree:add_le(f_ss_value1, tvbuf(offset + 8, 4))
    if root.visible and value1_tree_item then
        value1_tree_item:append_text(" (" .. value1_string .. ")")
    end

    local value1_tree_item = top_tree:add_le(f_ss_value2, tvbuf(offset + 12, 4))
    if root.visible and value2_tree_item then
        value2_tree_item:append_text(" (" .. value2_string .. ")")
    end

    if string_length > 0 then
        top_tree:add_le(f_ss_string, tvbuf(offset + 20, string_length))
    end

    local info = status_type_string
    if value1_string then info = info .. " " .. value1_string end
    if value2_string then info = info .. " " .. value2_string end

    return nil, info
end

-- Dissects a WebXi Trigger message
local function webxi_dissect_trigger(tvbuf, pktinfo, root, bytes_total, offset)

    local sequence_id = tvbuf(offset, 2):le_uint()

    local trigger_type_val = tvbuf(offset + 2, 2):le_uint()
    local trigger_type_string = trigger_type_string(trigger_type_val)

    local tree_title = "WebXi Trigger Header, Sequence ID: " .. sequence_id .. ", Type: " .. trigger_type_string

    local tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    tree:add_le(f_tr_sequence_id, tvbuf(offset, 2))
    tree:add_le(f_tr_trigger_type, tvbuf(offset + 2, 2)):append_text(" (" .. trigger_type_string .. ")")

    local info = "Sequence ID " .. sequence_id .. " Type " .. trigger_type_string

    return nil, info
end

-- Dissects a WebXi Node message
local function webxi_dissect_node(tvbuf, pktinfo, root, bytes_total, offset)

    local number_of_changes = tvbuf(offset, 2):le_uint()

    local tree_title = "WebXi Node Header, Number Of Changes: " .. number_of_changes

    local tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    tree:add_le(f_no_number_of_changes, tvbuf(offset, 2))
    tree:add_le(f_no_reserved1, tvbuf(offset + 2, 2))

    offset = offset + 4

    local info

    local n = 0
    while n < number_of_changes do

        local flags_val = tvbuf(offset, 2):le_uint()
        local flags_string = node_flags_string(flags_val)

        local path_start = offset + 8
        local path_length = tvbuf(offset + 4, 4):le_uint()
        local path = tvbuf(path_start, path_length):string()

        local json_string_start = path_start + path_length + 4
        local json_string_length = tvbuf(path_start + path_length, 4):le_uint()

        local tree_title = "WebXi Node Change, Path: " .. path .. ", Flags: " .. flags_string

        -- Return the first change as our info string
        if n == 0 then info = path .. " " .. flags_string end

        local msg_len = 2 + 2 + 4 + path_length + 4 + json_string_length

        local sub_tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)

        sub_tree:add_le(f_no_flags, tvbuf(offset, 2)):append_text(" (" .. flags_string .. ")")
        sub_tree:add_le(f_no_reserved2, tvbuf(offset + 2, 2))
        sub_tree:add_le(f_no_path, tvbuf(path_start, path_length))
        sub_tree:add_le(f_no_json_string, tvbuf(json_string_start, json_string_length))

        offset = offset + msg_len
        n = n + 1
    end

    if number_of_changes > 1 then info = info .. " (and " .. number_of_changes - 1 .. " more changes)" end

    return nil, info
end

-- Dissects a WebXi Sync message
local function webxi_dissect_sync(tvbuf, pktinfo, root, bytes_total, offset)

    local sync_id = tvbuf(offset, 4):le_uint()

    local tree_title = "WebXi Sync Header, Sync ID: " .. sync_id

    local tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    tree:add_le(f_sy_sync_id, tvbuf(offset, 4))

    local info = "ID " .. sync_id

    return nil, info
end

-- Dissects a WebXi Debug message
local function webxi_dissect_debug(tvbuf, pktinfo, root, bytes_total, offset)

    local string_start = offset + 4
    local string_length = tvbuf(offset, 4):le_uint()
    local string = tvbuf(string_start, string_length):string()

    local tree_title = "WebXi Debug Header, String: " .. string

    local msg_len = 4 + string_length

    local tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)

    tree:add_le(f_de_string, tvbuf(string_start, string_length))

    return nil, string
end

-- Dissects a WebXi Package message
local function webxi_dissect_package(tvbuf, pktinfo, root, bytes_total, offset)

    local number_of_packages = tvbuf(offset, 2):le_uint()
    local tree_title = "WebXi Package Header, Number Of Packages: " .. number_of_packages

    local top_tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    top_tree:add_le(f_pa_number_of_packages, tvbuf(offset, 2))
    top_tree:add_le(f_pa_reserved, tvbuf(offset + 2, 2))

    local header_length = 4
    offset = offset + header_length
    local bytes_consumed = header_length

    while bytes_consumed < bytes_total do

        local package_id = tvbuf(offset, 2):le_uint()
        local tree_title = "WebXi Package Header, ID: " .. package_id

        local data_length = tvbuf(offset + 2, 2):le_uint()
        local msg_len = 2 + 2 + data_length

        local tree = root:add(webxi_protocol, tvbuf:range(offset, msg_len), tree_title)

        tree:add_le(f_pa_package_id, tvbuf(offset, 2))
        tree:add_le(f_pa_data_length, tvbuf(offset + 2, 2))
        tree:add(f_pa_data, tvbuf(offset + 4, data_length))

        bytes_consumed = bytes_consumed + msg_len
        offset = offset + msg_len
    end

    local info = number_of_packages .. "Packages"

    return nil, info
end

-- Dissects a WebXi AuxSequenceData message
local function webxi_dissect_aux_sequence_data(tvbuf, pktinfo, root, bytes_total, offset, family, ticks)

    local number_of_sequences = tvbuf(offset, 2):le_uint()
    local tree_title = "WebXi AuxSequenceData Header, Number Of Sequences: " .. number_of_sequences

    local top_tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

    top_tree:add_le(f_au_number_of_sequences, tvbuf(offset, 2))
    top_tree:add_le(f_au_reserved, tvbuf(offset + 2, 2))

    offset = offset + 4

    local sequence_ids = {}

    local sequence = 0
    while sequence < number_of_sequences do

        local sequence_id = tvbuf(offset, 2):le_uint()
        local number_of_values = tvbuf(offset + 2, 2):le_uint()

        local tree_title = "WebXi AuxSequenceData Descriptor, Sequence ID: " .. sequence_id .. ", Number Of Values: " .. number_of_values

        local tree = root:add(webxi_protocol, tvbuf:range(offset, 4), tree_title)

        tree:add_le(f_au_sequence_id, tvbuf(offset, 2))
        tree:add_le(f_au_number_of_values, tvbuf(offset + 2, 2))

        offset = offset + 4

        local value = 0
        while value < number_of_values do

            local val_tree = root:add(webxi_protocol, tvbuf:range(offset, value_size), "WebXi AuxSequenceData Value (experimental)")

            --[[

                No idea how to calculate the size, in bytes, of an AuxSequenceData value.

                In WebXi SequenceData messages we have a ValueLength, but there's no such thing here.

                What is the size of a single value? In OpenAPI, the Interpretation message would tell us,
                but DD17323 does not document the Interpretation message or any equivalent. Does it exist
                in WebXi?
            
                And if we're dealing with an array of values, the "actual number of scalar values
                (e.g. floats) transmitted is NumberOfValues * VectorLength from the interpretation message",
                but again the Interpretation message is not anywhere to be found in DD17323.

                For now we'll wing it and assume that any value is a single 32-bit float, as sort of hinted
                in the quote above.

            ]]--

            local value_size = 4 -- Assume a value is a single 32-bit float

            val_tree:add_le(f_au_relative_time, tvbuf(offset, 4))
            val_tree:add_le(f_au_value, tvbuf(offset + 4, 4))

            local msg_size = 4 + value_size
            offset = offset + msg_size
            value = value + 1
        end

        sequence = sequence + 1

        sequence_ids[sequence_id] = 0
    end

    return sequence_ids, nil
end

-- Main WebXi dissector function, dissects the WebXi message header
-- and then calls out to other dissector functions depending on the
-- type of message
local function dissect_webxi(tvbuf, pktinfo, root, offset, length_val)

    -- main window 'Protocol' and 'Info' columns
    pktinfo.cols.protocol = "WebXi"

    if offset == 0 then 
        globals.prev_message_string = ""
        pktinfo.cols.info:clear()
    end

    local message_type = tvbuf(offset + 4, 2):le_uint()
    local message_string = message_string(message_type)
    local magic_string = tvbuf(offset, 2):string()

    -- we will append more information as soon as we've figured out the message type
    local tree = root:add(webxi_protocol, tvbuf:range(offset, WEBXI_HDR_LEN), "WebXi Message Header")

    tree:add(f_hd_magic, tvbuf(offset, 2)):append_text(" (\"" .. magic_string .. "\")")
    tree:add_le(f_hd_header_length, tvbuf(offset + 2, 2))
    tree:add_le(f_hd_message_type, tvbuf(offset + 4, 2)):append_text(" (" .. message_string .. ")")
    tree:add_le(f_hd_content_version, tvbuf(offset + 6, 2))
    tree:add_le(f_hd_reserved2, tvbuf(offset + 8, 4))
    tree:add_le(f_hd_time, tvbuf(offset + 12, 8))
    tree:add_le(f_hd_content_length, tvbuf(offset + 20, 4))

    local msg_len = tvbuf(offset + 20, 4):le_uint()

    local sequence_ids, info

    if message_string == "SequenceData" then
        sequence_ids, info = webxi_dissect_sequence_data(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "DataQuality" then
        sequence_ids, info = webxi_dissect_data_quality(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "State" then
        sequence_ids, info = webxi_dissect_state(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "Status" then
        sequence_ids, info = webxi_dissect_status(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "Trigger" then
        sequence_ids, info = webxi_dissect_trigger(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "Node" then
        sequence_ids, info = webxi_dissect_node(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "Sync" then
        sequence_ids, info = webxi_dissect_sync(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "Debug" then
        sequence_ids, info = webxi_dissect_debug(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "Package" then
        sequence_ids, info = webxi_dissect_package(tvbuf, pktinfo, root, msg_len, offset + 24)
    elseif message_string == "AuxSequenceData" then
        sequence_ids, info = webxi_dissect_aux_sequence_data(tvbuf, pktinfo, root, msg_len, offset + 24, family, ticks)
    end

    -- update 'Info' column with the message type
    if globals.prev_message_string ~= message_string then
        globals.prev_message_string = message_string
        pktinfo.cols.info:append(message_string)
        if sequence_ids ~= nil then
            pktinfo.cols.info:append(" ID")
        end
    end

    -- add list of Sequence ID's in this message to Wireshark 'Info' column
    if sequence_ids ~= nil then
        for i, v in pairs(sequence_ids) do
            pktinfo.cols.info:append(" " .. i)
        end
    end

    if info ~= nil then
        pktinfo.cols.info:append(" " .. info)
    end

    -- return the number of bytes we've dissected
    return length_val
end

-- Dissects a WebXi message, calling other dissector functions depending
-- on the message type
local function dissect_message(tvbuf, pktinfo, root, offset)

    local length_val, is_webxi = check_message_length(tvbuf, offset)

    if length_val < 0 then
        -- need more bytes to determine the protocol
        return length_val
    end

    if is_webxi then
        return dissect_webxi(tvbuf, pktinfo, root, offset, length_val)
    end

    -- not recognized as WebXi
    return 0
end

-- Wireshark calls this function once per captured TCP segment, passing a
-- 'tvbuf' (testy virtual buffer in Wireshark lingo) containing the data.
-- If we recognize the data in the buffer as WebXi data, then we should
-- dissect the data and return the number of bytes we recognized.
-- Otherwise, if the data is not WebXi (or an error occurred), we should
-- return 0 which will make Wireshark look for another dissector to handle
-- the buffer.
function webxi_protocol.dissector(tvbuf, pktinfo, root)

    local buffer_length = tvbuf:len()

    -- there could be multiple messages in the buffer so set up a loop
    local bytes_consumed = 0
    while bytes_consumed < buffer_length do

        local result = dissect_message(tvbuf, pktinfo, root, bytes_consumed)

        if result > 0 then
            -- we dissected a WebXi message of 'result' length
            bytes_consumed = bytes_consumed + result
        elseif result == 0 then
            -- The packet is not for us or we hit an error
            return 0
        else
            -- We need more bytes.
            -- Set desegment_offset to what we already consumed,
            -- and desegment_len to how many more are needed
            pktinfo.desegment_offset = bytes_consumed
            pktinfo.desegment_len = -result
            -- tell Wireshark that all the bytes in the buffer are for us
            return buffer_length
        end        
    end

    return bytes_consumed
end

webxi_protocol:register_heuristic("tcp", webxi_protocol.dissector)

-- Register webxi as a chained dissector for websocket port 80, so that
-- we can dissect WebXi streams encapsulated in websocket traffic.
local ws_dissector_table = DissectorTable.get("ws.port")
ws_dissector_table:add(80, webxi_protocol)
