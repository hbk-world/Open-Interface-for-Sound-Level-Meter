# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

from pkg_resources import parse_version
import kaitaistruct
from kaitaistruct import KaitaiStruct, KaitaiStream, BytesIO
from enum import Enum


if parse_version(kaitaistruct.__version__) < parse_version('0.9'):
    raise Exception("Incompatible Kaitai Struct Python API: 0.9 or later is required, but you have %s" % (kaitaistruct.__version__))

class WebxiStream(KaitaiStruct):
    def __init__(self, _io, _parent=None, _root=None):
        self._io = _io
        self._parent = _parent
        self._root = _root if _root else self
        self._read()

    def _read(self):
        self.header = self._root.Header(self._io, self, self._root)
        _on = self.header.message_type
        if _on == self._root.Header.EMessageType.e_state:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.State(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_sequence_data:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.SequenceData(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_debug:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.Debug(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_sync:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.Sync(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_aux_sequence_data:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.AuxSequenceData(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_package:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.Package(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_data_quality:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.DataQuality(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_node:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.Node(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_status:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.Status(_io__raw_content, self, self._root)
        elif _on == self._root.Header.EMessageType.e_trigger:
            self._raw_content = self._io.read_bytes(self.header.content_length)
            _io__raw_content = KaitaiStream(BytesIO(self._raw_content))
            self.content = self._root.Trigger(_io__raw_content, self, self._root)
        else:
            self.content = self._io.read_bytes(self.header.content_length)

    class NodeChange(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.flags = self._io.read_u2le()
            self.reserved = self._io.read_u2le()
            self.path = self._root.String(self._io, self, self._root)
            self.json = self._root.String(self._io, self, self._root)


    class Package(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.number_of_packages = self._io.read_u2le()
            self.reserved = self._io.read_u2le()
            self.packages = [None] * (self.number_of_packages)
            for i in range(self.number_of_packages):
                self.packages[i] = self._root.PackageBlock(self._io, self, self._root)



    class AuxValue(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.relative_time = self._io.read_u4le()
            self.values = self._root.Value(self._io, self, self._root)


    class FlacSequenceDataBlock(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.number_of_sequences = self._io.read_u2le()
            self.sequence_ids = [None] * (self.number_of_sequences)
            for i in range(self.number_of_sequences):
                self.sequence_ids[i] = self._io.read_u2le()

            self.frame_length = self._io.read_u4le()
            self.frame = [None] * (self.frame_length)
            for i in range(self.frame_length):
                self.frame[i] = self._io.read_u1()



    class AuxSequenceDataBlock(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.sequence_id = self._io.read_u2le()
            self.number_of_values = self._io.read_u2le()
            self.values = [None] * (self.number_of_values)
            for i in range(self.number_of_values):
                self.values[i] = self._root.AuxValue(self._io, self, self._root)



    class State(KaitaiStruct):

        class EState(Enum):
            initial = 0
            error = 1
            deactivated = 2
            activated = 3
            running = 4
            ramping_down = 5
            pause = 6
            stopping = 7
            result_measured = 8
            result_loaded = 9
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.state = KaitaiStream.resolve_enum(self._root.State.EState, self._io.read_u2le())
            self.reserved = self._io.read_u2le()
            self.application_name = self._root.String(self._io, self, self._root)


    class DataQuality(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.number_of_qualities = self._io.read_u2le()
            self.reserved = self._io.read_u2le()
            self.qualities = [None] * (self.number_of_qualities)
            for i in range(self.number_of_qualities):
                self.qualities[i] = self._root.QualityBlock(self._io, self, self._root)



    class AuxSequenceData(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.number_of_sequences = self._io.read_u2le()
            self.reserved = self._io.read_u2le()
            self.aux_sequence_data_blocks = [None] * (self.number_of_sequences)
            for i in range(self.number_of_sequences):
                self.aux_sequence_data_blocks[i] = self._root.AuxSequenceDataBlock(self._io, self, self._root)



    class SequenceData(KaitaiStruct):

        class EMessageFormat(Enum):
            raw = 0
            mp3 = 1
            flac = 2
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.number_of_blocks = self._io.read_u2le()
            self.message_format = KaitaiStream.resolve_enum(self._root.SequenceData.EMessageFormat, self._io.read_u1())
            self.reserved = self._io.read_u1()
            self.sequence_blocks = [None] * (self.number_of_blocks)
            for i in range(self.number_of_blocks):
                _on = self.message_format
                if _on == self._root.SequenceData.EMessageFormat.raw:
                    self.sequence_blocks[i] = self._root.RawSequenceDataBlock(self._io, self, self._root)
                elif _on == self._root.SequenceData.EMessageFormat.mp3:
                    self.sequence_blocks[i] = self._root.Mp3SequenceDataBlock(self._io, self, self._root)
                elif _on == self._root.SequenceData.EMessageFormat.flac:
                    self.sequence_blocks[i] = self._root.FlacSequenceDataBlock(self._io, self, self._root)



    class String(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.count = self._io.read_u4le()
            self.content = (self._io.read_bytes(self.count)).decode(u"UTF-8")


    class PackageBlock(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.package_id = self._io.read_u2le()
            self.data_length = self._io.read_u2le()
            self.data = [None] * (self.data_length)
            for i in range(self.data_length):
                self.data[i] = self._io.read_u1()



    class Debug(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.message = self._root.String(self._io, self, self._root)


    class TimeFamily(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.k = self._io.read_u1()
            self.l = self._io.read_u1()
            self.m = self._io.read_u1()
            self.n = self._io.read_u1()


    class Status(KaitaiStruct):

        class EChannelType(Enum):
            todo = 0

        class EStatusType(Enum):
            todo1 = 0
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.channel_type = KaitaiStream.resolve_enum(self._root.Status.EChannelType, self._io.read_u2le())
            self.channel_id = self._io.read_u2le()
            self.status_type = KaitaiStream.resolve_enum(self._root.Status.EStatusType, self._io.read_u2le())
            self.reserved = self._io.read_u2le()
            self.value1 = self._io.read_s4le()
            self.value2 = self._io.read_s4le()
            self.str = self._root.String(self._io, self, self._root)


    class QualityBlock(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.quality_id = self._io.read_u2le()
            self.validity = self._io.read_u2le()
            self.reserved = self._io.read_u4le()


    class Sync(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.sync_id = self._io.read_u4le()


    class Header(KaitaiStruct):

        class EMessageType(Enum):
            e_sequence_data = 1
            e_data_quality = 2
            e_state = 3
            e_status = 4
            e_trigger = 5
            e_node = 6
            e_sync = 7
            e_debug = 9
            e_package = 10
            e_aux_sequence_data = 11
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.magic = self._io.read_bytes(2)
            if not self.magic == b"\x42\x4B":
                raise kaitaistruct.ValidationNotEqualError(b"\x42\x4B", self.magic, self._io, u"/types/header/seq/0")
            self.header_length = self._io.read_u2le()
            self.message_type = KaitaiStream.resolve_enum(self._root.Header.EMessageType, self._io.read_u2le())
            self.content_version = self._io.read_u2le()
            self.reserved2 = self._io.read_u4le()
            self.time = self._io.read_u8le()
            self.content_length = self._io.read_u4le()


    class Node(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.n_changes = self._io.read_u2le()
            self.reserved = self._io.read_u2le()
            self.changes = [None] * (self.n_changes)
            for i in range(self.n_changes):
                self.changes[i] = self._root.NodeChange(self._io, self, self._root)



    class Value(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.value1 = self._io.read_u1()
            self.value2 = self._io.read_u1()
            self.value3 = self._io.read_s1()
            self.value4 = self._io.read_s1()

        @property
        def calc_value(self):
            if hasattr(self, '_m_calc_value'):
                return self._m_calc_value if hasattr(self, '_m_calc_value') else None

            self._m_calc_value = ((self.value1 + (self.value2 << 8)) + (self.value3 << 16))
            return self._m_calc_value if hasattr(self, '_m_calc_value') else None


    class Mp3SequenceDataBlock(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.number_of_sequences = self._io.read_u2le()
            self.sequence_ids = [None] * (self.number_of_sequences)
            for i in range(self.number_of_sequences):
                self.sequence_ids[i] = self._io.read_u2le()

            self.frame_length = self._io.read_u4le()
            self.frame = [None] * (self.frame_length)
            for i in range(self.frame_length):
                self.frame[i] = self._io.read_u1()



    class RawSequenceDataBlock(KaitaiStruct):
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.sequence_id = self._io.read_u2le()
            self.value_length = self._io.read_u4le()
            self.values = [None] * (self.value_length)
            for i in range(self.value_length):
                self.values[i] = self._io.read_u1()



    class Trigger(KaitaiStruct):

        class ETriggerType(Enum):
            unkown = 0
            level = 1
            start = 2
        def __init__(self, _io, _parent=None, _root=None):
            self._io = _io
            self._parent = _parent
            self._root = _root if _root else self
            self._read()

        def _read(self):
            self.sequence_id = self._io.read_u2le()
            self.trigger_type = KaitaiStream.resolve_enum(self._root.Trigger.ETriggerType, self._io.read_u2le())



