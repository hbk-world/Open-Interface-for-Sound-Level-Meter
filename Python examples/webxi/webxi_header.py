# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

from pkg_resources import parse_version
import kaitaistruct
from kaitaistruct import KaitaiStruct, KaitaiStream, BytesIO
from enum import Enum


if parse_version(kaitaistruct.__version__) < parse_version('0.9'):
    raise Exception("Incompatible Kaitai Struct Python API: 0.9 or later is required, but you have %s" % (kaitaistruct.__version__))

class WebxiHeader(KaitaiStruct):

    class EMessageType(Enum):
        e_sequence_data = 1
        e_data_quality = 2
        state = 3
        status = 4
        trigger = 5
        node = 6
        sync = 7
        debug = 9
        package = 10
        aux_sequence_data = 11
    def __init__(self, _io, _parent=None, _root=None):
        self._io = _io
        self._parent = _parent
        self._root = _root if _root else self
        self._read()

    def _read(self):
        self.magic = self._io.read_bytes(2)
        if not self.magic == b"\x42\x4B":
            raise kaitaistruct.ValidationNotEqualError(b"\x42\x4B", self.magic, self._io, u"/seq/0")
        self.header_length = self._io.read_u2le()
        self.message_type = KaitaiStream.resolve_enum(self._root.EMessageType, self._io.read_u2le())
        self.content_version = self._io.read_u2le()
        self.reserved2 = self._io.read_u4le()
        self.time = self._io.read_u8le()
        self.content_length = self._io.read_u4le()


