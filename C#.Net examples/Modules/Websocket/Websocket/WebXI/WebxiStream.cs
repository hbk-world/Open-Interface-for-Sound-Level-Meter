// This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

using System.Collections.Generic;

namespace Kaitai
{
    public partial class WebxiStream : KaitaiStruct
    {
        public static WebxiStream FromFile(string fileName)
        {
            return new WebxiStream(new KaitaiStream(fileName));
        }

        public WebxiStream(KaitaiStream p__io, KaitaiStruct p__parent = null, WebxiStream p__root = null) : base(p__io)
        {
            m_parent = p__parent;
            m_root = p__root ?? this;
            _read();
        }
        private void _read()
        {
            _header = new Header(m_io, this, m_root);
            switch (header.MessageType) {
            case Header.EMessageType.EState: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new State(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.ESequenceData: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new SequenceData(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.EDebug: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new Debug(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.ESync: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new Sync(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.EAuxSequenceData: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new AuxSequenceData(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.EPackage: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new Package(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.EDataQuality: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new DataQuality(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.ENode: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new Node(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.EStatus: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new Status(io___raw_content, this, m_root);
                break;
            }
            case Header.EMessageType.ETrigger: {
                __raw_content = m_io.ReadBytes(header.ContentLength);
                var io___raw_content = new KaitaiStream(__raw_content);
                _content = new Trigger(io___raw_content, this, m_root);
                break;
            }
            default: {
                _content = m_io.ReadBytes(header.ContentLength);
                break;
            }
            }
        }
        public partial class NodeChange : KaitaiStruct
        {
            public static NodeChange FromFile(string fileName)
            {
                return new NodeChange(new KaitaiStream(fileName));
            }

            public NodeChange(KaitaiStream p__io, WebxiStream.Node p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _flags = m_io.ReadU2le();
                _reserved = m_io.ReadU2le();
                _path = new String(m_io, this, m_root);
                _json = new String(m_io, this, m_root);
            }
            private ushort _flags;
            private ushort _reserved;
            private String _path;
            private String _json;
            private WebxiStream m_root;
            private WebxiStream.Node m_parent;
            public ushort Flags { get { return _flags; } }
            public ushort Reserved { get { return _reserved; } }
            public String Path { get { return _path; } }
            public String Json { get { return _json; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.Node M_Parent { get { return m_parent; } }
        }
        public partial class Package : KaitaiStruct
        {
            public static Package FromFile(string fileName)
            {
                return new Package(new KaitaiStream(fileName));
            }

            public Package(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numberOfPackages = m_io.ReadU2le();
                _reserved = m_io.ReadU2le();
                _packages = new List<PackageBlock>((int) (NumberOfPackages));
                for (var i = 0; i < NumberOfPackages; i++)
                {
                    _packages.Add(new PackageBlock(m_io, this, m_root));
                }
            }
            private ushort _numberOfPackages;
            private ushort _reserved;
            private List<PackageBlock> _packages;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public ushort NumberOfPackages { get { return _numberOfPackages; } }
            public ushort Reserved { get { return _reserved; } }
            public List<PackageBlock> Packages { get { return _packages; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class AuxValue : KaitaiStruct
        {
            public static AuxValue FromFile(string fileName)
            {
                return new AuxValue(new KaitaiStream(fileName));
            }

            public AuxValue(KaitaiStream p__io, WebxiStream.AuxSequenceDataBlock p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _relativeTime = m_io.ReadU4le();
                _values = new Value(m_io, this, m_root);
            }
            private uint _relativeTime;
            private Value _values;
            private WebxiStream m_root;
            private WebxiStream.AuxSequenceDataBlock m_parent;
            public uint RelativeTime { get { return _relativeTime; } }
            public Value Values { get { return _values; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.AuxSequenceDataBlock M_Parent { get { return m_parent; } }
        }
        public partial class FlacSequenceDataBlock : KaitaiStruct
        {
            public static FlacSequenceDataBlock FromFile(string fileName)
            {
                return new FlacSequenceDataBlock(new KaitaiStream(fileName));
            }

            public FlacSequenceDataBlock(KaitaiStream p__io, WebxiStream.SequenceData p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numberOfSequences = m_io.ReadU2le();
                _sequenceIds = new List<ushort>((int) (NumberOfSequences));
                for (var i = 0; i < NumberOfSequences; i++)
                {
                    _sequenceIds.Add(m_io.ReadU2le());
                }
                _frameLength = m_io.ReadU4le();
                _frame = new List<byte>((int) (FrameLength));
                for (var i = 0; i < FrameLength; i++)
                {
                    _frame.Add(m_io.ReadU1());
                }
            }
            private ushort _numberOfSequences;
            private List<ushort> _sequenceIds;
            private uint _frameLength;
            private List<byte> _frame;
            private WebxiStream m_root;
            private WebxiStream.SequenceData m_parent;
            public ushort NumberOfSequences { get { return _numberOfSequences; } }
            public List<ushort> SequenceIds { get { return _sequenceIds; } }
            public uint FrameLength { get { return _frameLength; } }
            public List<byte> Frame { get { return _frame; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.SequenceData M_Parent { get { return m_parent; } }
        }
        public partial class AuxSequenceDataBlock : KaitaiStruct
        {
            public static AuxSequenceDataBlock FromFile(string fileName)
            {
                return new AuxSequenceDataBlock(new KaitaiStream(fileName));
            }

            public AuxSequenceDataBlock(KaitaiStream p__io, WebxiStream.AuxSequenceData p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _sequenceId = m_io.ReadU2le();
                _numberOfValues = m_io.ReadU2le();
                _values = new List<AuxValue>((int) (NumberOfValues));
                for (var i = 0; i < NumberOfValues; i++)
                {
                    _values.Add(new AuxValue(m_io, this, m_root));
                }
            }
            private ushort _sequenceId;
            private ushort _numberOfValues;
            private List<AuxValue> _values;
            private WebxiStream m_root;
            private WebxiStream.AuxSequenceData m_parent;
            public ushort SequenceId { get { return _sequenceId; } }
            public ushort NumberOfValues { get { return _numberOfValues; } }
            public List<AuxValue> Values { get { return _values; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.AuxSequenceData M_Parent { get { return m_parent; } }
        }
        public partial class State : KaitaiStruct
        {
            public static State FromFile(string fileName)
            {
                return new State(new KaitaiStream(fileName));
            }


            public enum EState
            {
                Initial = 0,
                Error = 1,
                Deactivated = 2,
                Activated = 3,
                Running = 4,
                RampingDown = 5,
                Pause = 6,
                Stopping = 7,
                ResultMeasured = 8,
                ResultLoaded = 9,
            }
            public State(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _state = ((EState) m_io.ReadU2le());
                _reserved = m_io.ReadU2le();
                _applicationName = new String(m_io, this, m_root);
            }
            private EState _state;
            private ushort _reserved;
            private String _applicationName;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            //public EState State { get { return _state; } }
            public ushort Reserved { get { return _reserved; } }
            public String ApplicationName { get { return _applicationName; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class DataQuality : KaitaiStruct
        {
            public static DataQuality FromFile(string fileName)
            {
                return new DataQuality(new KaitaiStream(fileName));
            }

            public DataQuality(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numberOfQualities = m_io.ReadU2le();
                _reserved = m_io.ReadU2le();
                _qualities = new List<QualityBlock>((int) (NumberOfQualities));
                for (var i = 0; i < NumberOfQualities; i++)
                {
                    _qualities.Add(new QualityBlock(m_io, this, m_root));
                }
            }
            private ushort _numberOfQualities;
            private ushort _reserved;
            private List<QualityBlock> _qualities;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public ushort NumberOfQualities { get { return _numberOfQualities; } }
            public ushort Reserved { get { return _reserved; } }
            public List<QualityBlock> Qualities { get { return _qualities; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class AuxSequenceData : KaitaiStruct
        {
            public static AuxSequenceData FromFile(string fileName)
            {
                return new AuxSequenceData(new KaitaiStream(fileName));
            }

            public AuxSequenceData(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numberOfSequences = m_io.ReadU2le();
                _reserved = m_io.ReadU2le();
                _auxSequenceDataBlocks = new List<AuxSequenceDataBlock>((int) (NumberOfSequences));
                for (var i = 0; i < NumberOfSequences; i++)
                {
                    _auxSequenceDataBlocks.Add(new AuxSequenceDataBlock(m_io, this, m_root));
                }
            }
            private ushort _numberOfSequences;
            private ushort _reserved;
            private List<AuxSequenceDataBlock> _auxSequenceDataBlocks;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public ushort NumberOfSequences { get { return _numberOfSequences; } }
            public ushort Reserved { get { return _reserved; } }
            public List<AuxSequenceDataBlock> AuxSequenceDataBlocks { get { return _auxSequenceDataBlocks; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class SequenceData : KaitaiStruct
        {
            public static SequenceData FromFile(string fileName)
            {
                return new SequenceData(new KaitaiStream(fileName));
            }


            public enum EMessageFormat
            {
                Raw = 0,
                Mp3 = 1,
                Flac = 2,
            }
            public SequenceData(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numberOfBlocks = m_io.ReadU2le();
                _messageFormat = ((EMessageFormat) m_io.ReadU1());
                _reserved = m_io.ReadU1();
                _sequenceBlocks = new List<KaitaiStruct>((int) (NumberOfBlocks));
                for (var i = 0; i < NumberOfBlocks; i++)
                {
                    switch (MessageFormat) {
                    case EMessageFormat.Raw: {
                        _sequenceBlocks.Add(new RawSequenceDataBlock(m_io, this, m_root));
                        break;
                    }
                    case EMessageFormat.Mp3: {
                        _sequenceBlocks.Add(new Mp3SequenceDataBlock(m_io, this, m_root));
                        break;
                    }
                    case EMessageFormat.Flac: {
                        _sequenceBlocks.Add(new FlacSequenceDataBlock(m_io, this, m_root));
                        break;
                    }
                    }
                }
            }
            private ushort _numberOfBlocks;
            private EMessageFormat _messageFormat;
            private byte _reserved;
            private List<KaitaiStruct> _sequenceBlocks;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public ushort NumberOfBlocks { get { return _numberOfBlocks; } }
            public EMessageFormat MessageFormat { get { return _messageFormat; } }
            public byte Reserved { get { return _reserved; } }
            public List<KaitaiStruct> SequenceBlocks { get { return _sequenceBlocks; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class String : KaitaiStruct
        {
            public static String FromFile(string fileName)
            {
                return new String(new KaitaiStream(fileName));
            }

            public String(KaitaiStream p__io, KaitaiStruct p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _count = m_io.ReadU4le();
                _content = System.Text.Encoding.GetEncoding("UTF-8").GetString(m_io.ReadBytes(Count));
            }
            private uint _count;
            private string _content;
            private WebxiStream m_root;
            private KaitaiStruct m_parent;
            public uint Count { get { return _count; } }
            public string Content { get { return _content; } }
            public WebxiStream M_Root { get { return m_root; } }
            public KaitaiStruct M_Parent { get { return m_parent; } }
        }
        public partial class PackageBlock : KaitaiStruct
        {
            public static PackageBlock FromFile(string fileName)
            {
                return new PackageBlock(new KaitaiStream(fileName));
            }

            public PackageBlock(KaitaiStream p__io, WebxiStream.Package p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _packageId = m_io.ReadU2le();
                _dataLength = m_io.ReadU2le();
                _data = new List<byte>((int) (DataLength));
                for (var i = 0; i < DataLength; i++)
                {
                    _data.Add(m_io.ReadU1());
                }
            }
            private ushort _packageId;
            private ushort _dataLength;
            private List<byte> _data;
            private WebxiStream m_root;
            private WebxiStream.Package m_parent;
            public ushort PackageId { get { return _packageId; } }
            public ushort DataLength { get { return _dataLength; } }
            public List<byte> Data { get { return _data; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.Package M_Parent { get { return m_parent; } }
        }
        public partial class Debug : KaitaiStruct
        {
            public static Debug FromFile(string fileName)
            {
                return new Debug(new KaitaiStream(fileName));
            }

            public Debug(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _message = new String(m_io, this, m_root);
            }
            private String _message;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public String Message { get { return _message; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class TimeFamily : KaitaiStruct
        {
            public static TimeFamily FromFile(string fileName)
            {
                return new TimeFamily(new KaitaiStream(fileName));
            }

            public TimeFamily(KaitaiStream p__io, KaitaiStruct p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _k = m_io.ReadU1();
                _l = m_io.ReadU1();
                _m = m_io.ReadU1();
                _n = m_io.ReadU1();
            }
            private byte _k;
            private byte _l;
            private byte _m;
            private byte _n;
            private WebxiStream m_root;
            private KaitaiStruct m_parent;
            public byte K { get { return _k; } }
            public byte L { get { return _l; } }
            public byte M { get { return _m; } }
            public byte N { get { return _n; } }
            public WebxiStream M_Root { get { return m_root; } }
            public KaitaiStruct M_Parent { get { return m_parent; } }
        }
        public partial class Status : KaitaiStruct
        {
            public static Status FromFile(string fileName)
            {
                return new Status(new KaitaiStream(fileName));
            }


            public enum EChannelType
            {
                Todo = 0,
            }

            public enum EStatusType
            {
                Todo1 = 0,
            }
            public Status(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _channelType = ((EChannelType) m_io.ReadU2le());
                _channelId = m_io.ReadU2le();
                _statusType = ((EStatusType) m_io.ReadU2le());
                _reserved = m_io.ReadU2le();
                _value1 = m_io.ReadS4le();
                _value2 = m_io.ReadS4le();
                _str = new String(m_io, this, m_root);
            }
            private EChannelType _channelType;
            private ushort _channelId;
            private EStatusType _statusType;
            private ushort _reserved;
            private int _value1;
            private int _value2;
            private String _str;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public EChannelType ChannelType { get { return _channelType; } }
            public ushort ChannelId { get { return _channelId; } }
            public EStatusType StatusType { get { return _statusType; } }
            public ushort Reserved { get { return _reserved; } }
            public int Value1 { get { return _value1; } }
            public int Value2 { get { return _value2; } }
            public String Str { get { return _str; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class QualityBlock : KaitaiStruct
        {
            public static QualityBlock FromFile(string fileName)
            {
                return new QualityBlock(new KaitaiStream(fileName));
            }

            public QualityBlock(KaitaiStream p__io, WebxiStream.DataQuality p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _qualityId = m_io.ReadU2le();
                _validity = m_io.ReadU2le();
                _reserved = m_io.ReadU4le();
            }
            private ushort _qualityId;
            private ushort _validity;
            private uint _reserved;
            private WebxiStream m_root;
            private WebxiStream.DataQuality m_parent;
            public ushort QualityId { get { return _qualityId; } }
            public ushort Validity { get { return _validity; } }
            public uint Reserved { get { return _reserved; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.DataQuality M_Parent { get { return m_parent; } }
        }
        public partial class Sync : KaitaiStruct
        {
            public static Sync FromFile(string fileName)
            {
                return new Sync(new KaitaiStream(fileName));
            }

            public Sync(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _syncId = m_io.ReadU4le();
            }
            private uint _syncId;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public uint SyncId { get { return _syncId; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class Header : KaitaiStruct
        {
            public static Header FromFile(string fileName)
            {
                return new Header(new KaitaiStream(fileName));
            }


            public enum EMessageType
            {
                ESequenceData = 1,
                EDataQuality = 2,
                EState = 3,
                EStatus = 4,
                ETrigger = 5,
                ENode = 6,
                ESync = 7,
                EDebug = 9,
                EPackage = 10,
                EAuxSequenceData = 11,
            }
            public Header(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _magic = m_io.ReadBytes(2);
                if (!((KaitaiStream.ByteArrayCompare(Magic, new byte[] { 66, 75 }) == 0)))
                {
                    throw new ValidationNotEqualError(new byte[] { 66, 75 }, Magic, M_Io, "/types/header/seq/0");
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
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public byte[] Magic { get { return _magic; } }
            public ushort HeaderLength { get { return _headerLength; } }
            public EMessageType MessageType { get { return _messageType; } }
            public ushort ContentVersion { get { return _contentVersion; } }
            public uint Reserved2 { get { return _reserved2; } }
            public ulong Time { get { return _time; } }
            public uint ContentLength { get { return _contentLength; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class Node : KaitaiStruct
        {
            public static Node FromFile(string fileName)
            {
                return new Node(new KaitaiStream(fileName));
            }

            public Node(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _nChanges = m_io.ReadU2le();
                _reserved = m_io.ReadU2le();
                _changes = new List<NodeChange>((int) (NChanges));
                for (var i = 0; i < NChanges; i++)
                {
                    _changes.Add(new NodeChange(m_io, this, m_root));
                }
            }
            private ushort _nChanges;
            private ushort _reserved;
            private List<NodeChange> _changes;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public ushort NChanges { get { return _nChanges; } }
            public ushort Reserved { get { return _reserved; } }
            public List<NodeChange> Changes { get { return _changes; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        public partial class Value : KaitaiStruct
        {
            public static Value FromFile(string fileName)
            {
                return new Value(new KaitaiStream(fileName));
            }

            public Value(KaitaiStream p__io, WebxiStream.AuxValue p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                f_calcValue = false;
                _read();
            }
            private void _read()
            {
                _value1 = m_io.ReadU1();
                _value2 = m_io.ReadU1();
                _value3 = m_io.ReadS1();
                _value4 = m_io.ReadS1();
            }
            private bool f_calcValue;
            private int _calcValue;
            public int CalcValue
            {
                get
                {
                    if (f_calcValue)
                        return _calcValue;
                    _calcValue = (int) (((Value1 + (Value2 << 8)) + (Value3 << 16)));
                    f_calcValue = true;
                    return _calcValue;
                }
            }
            private byte _value1;
            private byte _value2;
            private sbyte _value3;
            private sbyte _value4;
            private WebxiStream m_root;
            private WebxiStream.AuxValue m_parent;
            public byte Value1 { get { return _value1; } }
            public byte Value2 { get { return _value2; } }
            public sbyte Value3 { get { return _value3; } }
            public sbyte Value4 { get { return _value4; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.AuxValue M_Parent { get { return m_parent; } }
        }
        public partial class Mp3SequenceDataBlock : KaitaiStruct
        {
            public static Mp3SequenceDataBlock FromFile(string fileName)
            {
                return new Mp3SequenceDataBlock(new KaitaiStream(fileName));
            }

            public Mp3SequenceDataBlock(KaitaiStream p__io, WebxiStream.SequenceData p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _numberOfSequences = m_io.ReadU2le();
                _sequenceIds = new List<ushort>((int) (NumberOfSequences));
                for (var i = 0; i < NumberOfSequences; i++)
                {
                    _sequenceIds.Add(m_io.ReadU2le());
                }
                _frameLength = m_io.ReadU4le();
                _frame = new List<byte>((int) (FrameLength));
                for (var i = 0; i < FrameLength; i++)
                {
                    _frame.Add(m_io.ReadU1());
                }
            }
            private ushort _numberOfSequences;
            private List<ushort> _sequenceIds;
            private uint _frameLength;
            private List<byte> _frame;
            private WebxiStream m_root;
            private WebxiStream.SequenceData m_parent;
            public ushort NumberOfSequences { get { return _numberOfSequences; } }
            public List<ushort> SequenceIds { get { return _sequenceIds; } }
            public uint FrameLength { get { return _frameLength; } }
            public List<byte> Frame { get { return _frame; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.SequenceData M_Parent { get { return m_parent; } }
        }
        public partial class RawSequenceDataBlock : KaitaiStruct
        {
            public static RawSequenceDataBlock FromFile(string fileName)
            {
                return new RawSequenceDataBlock(new KaitaiStream(fileName));
            }

            public RawSequenceDataBlock(KaitaiStream p__io, WebxiStream.SequenceData p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _sequenceId = m_io.ReadU2le();
                _valueLength = m_io.ReadU4le();
                _values = new List<byte>((int) (ValueLength));
                for (var i = 0; i < ValueLength; i++)
                {
                    _values.Add(m_io.ReadU1());
                }
            }
            private ushort _sequenceId;
            private uint _valueLength;
            private List<byte> _values;
            private WebxiStream m_root;
            private WebxiStream.SequenceData m_parent;
            public ushort SequenceId { get { return _sequenceId; } }
            public uint ValueLength { get { return _valueLength; } }
            public List<byte> Values { get { return _values; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream.SequenceData M_Parent { get { return m_parent; } }
        }
        public partial class Trigger : KaitaiStruct
        {
            public static Trigger FromFile(string fileName)
            {
                return new Trigger(new KaitaiStream(fileName));
            }


            public enum ETriggerType
            {
                Unkown = 0,
                Level = 1,
                Start = 2,
            }
            public Trigger(KaitaiStream p__io, WebxiStream p__parent = null, WebxiStream p__root = null) : base(p__io)
            {
                m_parent = p__parent;
                m_root = p__root;
                _read();
            }
            private void _read()
            {
                _sequenceId = m_io.ReadU2le();
                _triggerType = ((ETriggerType) m_io.ReadU2le());
            }
            private ushort _sequenceId;
            private ETriggerType _triggerType;
            private WebxiStream m_root;
            private WebxiStream m_parent;
            public ushort SequenceId { get { return _sequenceId; } }
            public ETriggerType TriggerType { get { return _triggerType; } }
            public WebxiStream M_Root { get { return m_root; } }
            public WebxiStream M_Parent { get { return m_parent; } }
        }
        private Header _header;
        private object _content;
        private WebxiStream m_root;
        private KaitaiStruct m_parent;
        private byte[] __raw_content;
        public Header header { get { return _header; } }
        public object Content { get { return _content; } }
        public WebxiStream M_Root { get { return m_root; } }
        public KaitaiStruct M_Parent { get { return m_parent; } }
        public byte[] M_RawContent { get { return __raw_content; } }
    }
}
