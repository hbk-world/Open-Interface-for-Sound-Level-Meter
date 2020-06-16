// This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild



namespace Kaitai
{
    public partial class WebxiHeader : KaitaiStruct
    {
        public static WebxiHeader FromFile(string fileName)
        {
            return new WebxiHeader(new KaitaiStream(fileName));
        }


        public enum EMessageType
        {
            ESequenceData = 1,
            EDataQuality = 2,
            State = 3,
            Status = 4,
            Trigger = 5,
            Node = 6,
            Sync = 7,
            Debug = 9,
            Package = 10,
            AuxSequenceData = 11,
        }
        public WebxiHeader(KaitaiStream p__io, KaitaiStruct p__parent = null, WebxiHeader p__root = null) : base(p__io)
        {
            m_parent = p__parent;
            m_root = p__root ?? this;
            _read();
        }
        private void _read()
        {
            _magic = m_io.ReadBytes(2);
            if (!((KaitaiStream.ByteArrayCompare(Magic, new byte[] { 66, 75 }) == 0)))
            {
                throw new ValidationNotEqualError(new byte[] { 66, 75 }, Magic, M_Io, "/seq/0");
            }
            _headerLength = m_io.ReadU2le();
            _messageType = ((EMessageType) m_io.ReadU2le());
            _contentVersion = m_io.ReadU2le();
            _reserved2 = m_io.ReadU4le();
            _time = m_io.ReadU8le();
            _contentLength = m_io.ReadU4le();
        }
        private byte[] _magic;
        private ushort _headerLength;
        private EMessageType _messageType;
        private ushort _contentVersion;
        private uint _reserved2;
        private ulong _time;
        private uint _contentLength;
        private WebxiHeader m_root;
        private KaitaiStruct m_parent;
        public byte[] Magic { get { return _magic; } }
        public ushort HeaderLength { get { return _headerLength; } }
        public EMessageType MessageType { get { return _messageType; } }
        public ushort ContentVersion { get { return _contentVersion; } }
        public uint Reserved2 { get { return _reserved2; } }
        public ulong Time { get { return _time; } }
        public uint ContentLength { get { return _contentLength; } }
        public WebxiHeader M_Root { get { return m_root; } }
        public KaitaiStruct M_Parent { get { return m_parent; } }
    }
}
