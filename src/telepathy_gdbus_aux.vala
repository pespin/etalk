

namespace Telepathy {
	
	/* DEFINES */
	
	public const string ACCOUNT_MANAGER_BUS_NAME = "org.freedesktop.Telepathy.AccountManager";
	public const string ACCOUNT_MANAGER_OBJECT_PATH = "/org/freedesktop/Telepathy/AccountManager";
	
	public const string CONNECTION_MANAGER_BUS_NAME = "org.freedesktop.Telepathy.ConnectionManager";
	
	public const string IFACE_CONNECTION_INTERFACE_CONTACTS = "org.freedesktop.Telepathy.Connection.Interface.Contacts";
	
	
	public const string	IFACE_CHANNEL_TYPE_CONTACT_LIST = "org.freedesktop.Telepathy.Channel.Type.ContactList";
	public const string IFACE_CHANNEL_TYPE_CONTACT_SEARCH = "org.freedesktop.Telepathy.Channel.Type.ContactSearch";
	public const string IFACE_CHANNEL_TYPE_DBUS_TUBE = "org.freedesktop.Telepathy.Channel.Type.DBusTube";
	public const string IFACE_CHANNEL_TYPE_FILE_TRANSFER = "org.freedesktop.Telepathy.Channel.Type.FileTransfer";
	public const string IFACE_CHANNEL_TYPE_ROOM_LIST = "org.freedesktop.Telepathy.Channel.Type.RoomList";
	public const string IFACE_CHANNEL_TYPE_SERVER_AUTHENTICATION = "org.freedesktop.Telepathy.Channel.Type.ServerAuthentication";
	public const string IFACE_CHANNEL_TYPE_SERVER_TLS_CONNECTION = "org.freedesktop.Telepathy.Channel.Type.ServerTLSConnection";
	public const string IFACE_CHANNEL_TYPE_STREAMED_MEDIA = "org.freedesktop.Telepathy.Channel.Type.StreamedMedia";
	public const string IFACE_CHANNEL_TYPE_STREAM_TUBE = "org.freedesktop.Telepathy.Channel.Type.StreamTube";
 	public const string IFACE_CHANNEL_TYPE_TEXT = "org.freedesktop.Telepathy.Channel.Type.Text";
	public const string IFACE_CHANNEL_TYPE_TUBES = "org.freedesktop.Telepathy.Channel.Type.Tubes";


	public const string PROP_CHANNEL_CHANNEL_TYPE = "org.freedesktop.Telepathy.Channel.ChannelType";
	public const string PROP_CHANNEL_DISPATCHER_INTERFACES = "org.freedesktop.Telepathy.ChannelDispatcher.Interfaces";
    public const string PROP_CHANNEL_DISPATCHER_INTERFACE_OPERATION_LIST_DISPATCH_OPERATIONS = "org.freedesktop.Telepathy.ChannelDispatcher.Interface.OperationList.DispatchOperations";
    public const string PROP_CHANNEL_DISPATCHER_SUPPORTS_REQUEST_HINTS = "org.freedesktop.Telepathy.ChannelDispatcher.SupportsRequestHints";
    public const string PROP_CHANNEL_DISPATCH_OPERATION_ACCOUNT = "org.freedesktop.Telepathy.ChannelDispatchOperation.Account";
    public const string PROP_CHANNEL_DISPATCH_OPERATION_CHANNELS = "org.freedesktop.Telepathy.ChannelDispatchOperation.Channels";
    public const string PROP_CHANNEL_DISPATCH_OPERATION_CONNECTION = "org.freedesktop.Telepathy.ChannelDispatchOperation.Connection";
    public const string PROP_CHANNEL_DISPATCH_OPERATION_INTERFACES = "org.freedesktop.Telepathy.ChannelDispatchOperation.Interfaces";
    public const string PROP_CHANNEL_DISPATCH_OPERATION_POSSIBLE_HANDLERS = "org.freedesktop.Telepathy.ChannelDispatchOperation.PossibleHandlers";
    public const string PROP_CHANNEL_INITIATOR_HANDLE = "org.freedesktop.Telepathy.Channel.InitiatorHandle";
    public const string PROP_CHANNEL_INITIATOR_ID = "org.freedesktop.Telepathy.Channel.InitiatorID";
    public const string PROP_CHANNEL_INTERFACES = "org.freedesktop.Telepathy.Channel.Interfaces";
    public const string PROP_CHANNEL_INTERFACE_ANONYMITY_ANONYMITY_MANDATORY = "org.freedesktop.Telepathy.Channel.Interface.Anonymity.AnonymityMandatory";
    public const string PROP_CHANNEL_INTERFACE_ANONYMITY_ANONYMITY_MODES = "org.freedesktop.Telepathy.Channel.Interface.Anonymity.AnonymityModes";
    public const string PROP_CHANNEL_INTERFACE_ANONYMITY_ANONYMOUS_ID = "org.freedesktop.Telepathy.Channel.Interface.Anonymity.AnonymousID";
    public const string PROP_CHANNEL_INTERFACE_CHAT_STATE_CHAT_STATES = "org.freedesktop.Telepathy.Channel.Interface.ChatState.ChatStates";
    public const string PROP_CHANNEL_INTERFACE_CONFERENCE_CHANNELS = "org.freedesktop.Telepathy.Channel.Interface.Conference.Channels";
    public const string PROP_CHANNEL_INTERFACE_CONFERENCE_INITIAL_CHANNELS = "org.freedesktop.Telepathy.Channel.Interface.Conference.InitialChannels";
    public const string PROP_CHANNEL_INTERFACE_CONFERENCE_INITIAL_INVITEE_HANDLES = "org.freedesktop.Telepathy.Channel.Interface.Conference.InitialInviteeHandles";
    public const string PROP_CHANNEL_INTERFACE_CONFERENCE_INITIAL_INVITEE_IDS = "org.freedesktop.Telepathy.Channel.Interface.Conference.InitialInviteeIDs";
    public const string PROP_CHANNEL_INTERFACE_CONFERENCE_INVITATION_MESSAGE = "org.freedesktop.Telepathy.Channel.Interface.Conference.InvitationMessage";
    public const string PROP_CHANNEL_INTERFACE_CONFERENCE_ORIGINAL_CHANNELS = "org.freedesktop.Telepathy.Channel.Interface.Conference.OriginalChannels";
    public const string PROP_CHANNEL_INTERFACE_DTMF_CURRENTLY_SENDING_TONES = "org.freedesktop.Telepathy.Channel.Interface.DTMF.CurrentlySendingTones";
    public const string PROP_CHANNEL_INTERFACE_DTMF_DEFERRED_TONES = "org.freedesktop.Telepathy.Channel.Interface.DTMF.DeferredTones";
    public const string PROP_CHANNEL_INTERFACE_DTMF_INITIAL_TONES = "org.freedesktop.Telepathy.Channel.Interface.DTMF.InitialTones";
    public const string PROP_CHANNEL_INTERFACE_GROUP_GROUP_FLAGS = "org.freedesktop.Telepathy.Channel.Interface.Group.GroupFlags";
    public const string PROP_CHANNEL_INTERFACE_GROUP_HANDLE_OWNERS = "org.freedesktop.Telepathy.Channel.Interface.Group.HandleOwners";
    public const string PROP_CHANNEL_INTERFACE_GROUP_LOCAL_PENDING_MEMBERS = "org.freedesktop.Telepathy.Channel.Interface.Group.LocalPendingMembers";
    public const string PROP_CHANNEL_INTERFACE_GROUP_MEMBERS = "org.freedesktop.Telepathy.Channel.Interface.Group.Members";
    public const string PROP_CHANNEL_INTERFACE_GROUP_REMOTE_PENDING_MEMBERS = "org.freedesktop.Telepathy.Channel.Interface.Group.RemotePendingMembers";
    public const string PROP_CHANNEL_INTERFACE_GROUP_SELF_HANDLE = "org.freedesktop.Telepathy.Channel.Interface.Group.SelfHandle";
    public const string PROP_CHANNEL_INTERFACE_MESSAGES_DELIVERY_REPORTING_SUPPORT = "org.freedesktop.Telepathy.Channel.Interface.Messages.DeliveryReportingSupport";
    public const string PROP_CHANNEL_INTERFACE_MESSAGES_MESSAGE_PART_SUPPORT_FLAGS = "org.freedesktop.Telepathy.Channel.Interface.Messages.MessagePartSupportFlags";
    public const string PROP_CHANNEL_INTERFACE_MESSAGES_MESSAGE_TYPES = "org.freedesktop.Telepathy.Channel.Interface.Messages.MessageTypes";
    public const string PROP_CHANNEL_INTERFACE_MESSAGES_PENDING_MESSAGES = "org.freedesktop.Telepathy.Channel.Interface.Messages.PendingMessages";
    public const string PROP_CHANNEL_INTERFACE_MESSAGES_SUPPORTED_CONTENT_TYPES = "org.freedesktop.Telepathy.Channel.Interface.Messages.SupportedContentTypes";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_AUTHORIZATION_IDENTITY = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.AuthorizationIdentity";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_AVAILABLE_MECHANISMS = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.AvailableMechanisms";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_CAN_TRY_AGAIN = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.CanTryAgain";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_DEFAULT_REALM = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.DefaultRealm";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_DEFAULT_USERNAME = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.DefaultUsername";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_HAS_INITIAL_DATA = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.HasInitialData";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_MAY_SAVE_RESPONSE = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.MaySaveResponse";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_SASL_ERROR = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.SASLError";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_SASL_ERROR_DETAILS = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.SASLErrorDetails";
    public const string PROP_CHANNEL_INTERFACE_SASL_AUTHENTICATION_SASL_STATUS = "org.freedesktop.Telepathy.Channel.Interface.SASLAuthentication.SASLStatus";
    public const string PROP_CHANNEL_INTERFACE_SECURABLE_ENCRYPTED = "org.freedesktop.Telepathy.Channel.Interface.Securable.Encrypted";
    public const string PROP_CHANNEL_INTERFACE_SECURABLE_VERIFIED = "org.freedesktop.Telepathy.Channel.Interface.Securable.Verified";
    public const string PROP_CHANNEL_INTERFACE_SERVICE_POINT_CURRENT_SERVICE_POINT = "org.freedesktop.Telepathy.Channel.Interface.ServicePoint.CurrentServicePoint";
    public const string PROP_CHANNEL_INTERFACE_SERVICE_POINT_INITIAL_SERVICE_POINT = "org.freedesktop.Telepathy.Channel.Interface.ServicePoint.InitialServicePoint";
    public const string PROP_CHANNEL_INTERFACE_SMS_FLASH = "org.freedesktop.Telepathy.Channel.Interface.SMS.Flash";
    public const string PROP_CHANNEL_INTERFACE_SMS_SMS_CHANNEL = "org.freedesktop.Telepathy.Channel.Interface.SMS.SMSChannel";
    public const string PROP_CHANNEL_INTERFACE_TUBE_PARAMETERS = "org.freedesktop.Telepathy.Channel.Interface.Tube.Parameters";
    public const string PROP_CHANNEL_INTERFACE_TUBE_STATE = "org.freedesktop.Telepathy.Channel.Interface.Tube.State";
    public const string PROP_CHANNEL_REQUESTED = "org.freedesktop.Telepathy.Channel.Requested";
    public const string PROP_CHANNEL_REQUEST_ACCOUNT = "org.freedesktop.Telepathy.ChannelRequest.Account";
    public const string PROP_CHANNEL_REQUEST_HINTS = "org.freedesktop.Telepathy.ChannelRequest.Hints";
    public const string PROP_CHANNEL_REQUEST_INTERFACES = "org.freedesktop.Telepathy.ChannelRequest.Interfaces";
    public const string PROP_CHANNEL_REQUEST_PREFERRED_HANDLER = "org.freedesktop.Telepathy.ChannelRequest.PreferredHandler";
    public const string PROP_CHANNEL_REQUEST_REQUESTS = "org.freedesktop.Telepathy.ChannelRequest.Requests";
    public const string PROP_CHANNEL_REQUEST_USER_ACTION_TIME = "org.freedesktop.Telepathy.ChannelRequest.UserActionTime";
    public const string PROP_CHANNEL_TARGET_HANDLE = "org.freedesktop.Telepathy.Channel.TargetHandle";
    public const string PROP_CHANNEL_TARGET_HANDLE_TYPE = "org.freedesktop.Telepathy.Channel.TargetHandleType";
    public const string PROP_CHANNEL_TARGET_ID = "org.freedesktop.Telepathy.Channel.TargetID";
    public const string PROP_CHANNEL_TYPE_CONTACT_SEARCH_AVAILABLE_SEARCH_KEYS = "org.freedesktop.Telepathy.Channel.Type.ContactSearch.AvailableSearchKeys";
    public const string PROP_CHANNEL_TYPE_CONTACT_SEARCH_LIMIT = "org.freedesktop.Telepathy.Channel.Type.ContactSearch.Limit";
    public const string PROP_CHANNEL_TYPE_CONTACT_SEARCH_SEARCH_STATE = "org.freedesktop.Telepathy.Channel.Type.ContactSearch.SearchState";
    public const string PROP_CHANNEL_TYPE_CONTACT_SEARCH_SERVER = "org.freedesktop.Telepathy.Channel.Type.ContactSearch.Server";
    public const string PROP_CHANNEL_TYPE_DBUS_TUBE_DBUS_NAMES = "org.freedesktop.Telepathy.Channel.Type.DBusTube.DBusNames";
    public const string PROP_CHANNEL_TYPE_DBUS_TUBE_SERVICE_NAME = "org.freedesktop.Telepathy.Channel.Type.DBusTube.ServiceName";
    public const string PROP_CHANNEL_TYPE_DBUS_TUBE_SUPPORTED_ACCESS_CONTROLS = "org.freedesktop.Telepathy.Channel.Type.DBusTube.SupportedAccessControls";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_AVAILABLE_SOCKET_TYPES = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.AvailableSocketTypes";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_CONTENT_HASH = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.ContentHash";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_CONTENT_HASH_TYPE = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.ContentHashType";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_CONTENT_TYPE = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.ContentType";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_DATE = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.Date";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_DESCRIPTION = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.Description";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_FILENAME = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.Filename";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_INITIAL_OFFSET = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.InitialOffset";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_SIZE = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.Size";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_STATE = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.State";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_TRANSFERRED_BYTES = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.TransferredBytes";
    public const string PROP_CHANNEL_TYPE_FILE_TRANSFER_URI = "org.freedesktop.Telepathy.Channel.Type.FileTransfer.URI";
    public const string PROP_CHANNEL_TYPE_ROOM_LIST_SERVER = "org.freedesktop.Telepathy.Channel.Type.RoomList.Server";
    public const string PROP_CHANNEL_TYPE_SERVER_AUTHENTICATION_AUTHENTICATION_METHOD = "org.freedesktop.Telepathy.Channel.Type.ServerAuthentication.AuthenticationMethod";
    public const string PROP_CHANNEL_TYPE_SERVER_TLS_CONNECTION_HOSTNAME = "org.freedesktop.Telepathy.Channel.Type.ServerTLSConnection.Hostname";
    public const string PROP_CHANNEL_TYPE_SERVER_TLS_CONNECTION_REFERENCE_IDENTITIES = "org.freedesktop.Telepathy.Channel.Type.ServerTLSConnection.ReferenceIdentities";
    public const string PROP_CHANNEL_TYPE_SERVER_TLS_CONNECTION_SERVER_CERTIFICATE = "org.freedesktop.Telepathy.Channel.Type.ServerTLSConnection.ServerCertificate";
    public const string PROP_CHANNEL_TYPE_STREAMED_MEDIA_IMMUTABLE_STREAMS = "org.freedesktop.Telepathy.Channel.Type.StreamedMedia.ImmutableStreams";
    public const string PROP_CHANNEL_TYPE_STREAMED_MEDIA_INITIAL_AUDIO = "org.freedesktop.Telepathy.Channel.Type.StreamedMedia.InitialAudio";
    public const string PROP_CHANNEL_TYPE_STREAMED_MEDIA_INITIAL_VIDEO = "org.freedesktop.Telepathy.Channel.Type.StreamedMedia.InitialVideo";
    public const string PROP_CHANNEL_TYPE_STREAM_TUBE_SERVICE = "org.freedesktop.Telepathy.Channel.Type.StreamTube.Service";
    public const string PROP_CHANNEL_TYPE_STREAM_TUBE_SUPPORTED_SOCKET_TYPES = "org.freedesktop.Telepathy.Channel.Type.StreamTube.SupportedSocketTypes";


   public const string TOKEN_CONNECTION_CONTACT_ID = "org.freedesktop.Telepathy.Connection/contact-id";
   public const string TOKEN_CONNECTION_INTERFACE_ALIASING_ALIAS = "org.freedesktop.Telepathy.Connection.Interface.Aliasing/alias";
   public const string TOKEN_CONNECTION_INTERFACE_AVATARS_TOKEN = "org.freedesktop.Telepathy.Connection.Interface.Avatars/token";
   public const string TOKEN_CONNECTION_INTERFACE_CAPABILITIES_CAPS = "org.freedesktop.Telepathy.Connection.Interface.Capabilities/caps";
   public const string TOKEN_CONNECTION_INTERFACE_CLIENT_TYPES_CLIENT_TYPES = "org.freedesktop.Telepathy.Connection.Interface.ClientTypes/client-types";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_BLOCKING_BLOCKED = "org.freedesktop.Telepathy.Connection.Interface.ContactBlocking/blocked";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_CAPABILITIES_CAPABILITIES = "org.freedesktop.Telepathy.Connection.Interface.ContactCapabilities/capabilities";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_GROUPS_GROUPS = "org.freedesktop.Telepathy.Connection.Interface.ContactGroups/groups";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_INFO_INFO = "org.freedesktop.Telepathy.Connection.Interface.ContactInfo/info";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_LIST_PUBLISH = "org.freedesktop.Telepathy.Connection.Interface.ContactList/publish";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_LIST_PUBLISH_REQUEST = "org.freedesktop.Telepathy.Connection.Interface.ContactList/publish-request";
   public const string TOKEN_CONNECTION_INTERFACE_CONTACT_LIST_SUBSCRIBE = "org.freedesktop.Telepathy.Connection.Interface.ContactList/subscribe";
   public const string TOKEN_CONNECTION_INTERFACE_LOCATION_LOCATION = "org.freedesktop.Telepathy.Connection.Interface.Location/location";
   public const string TOKEN_CONNECTION_INTERFACE_SIMPLE_PRESENCE_PRESENCE = "org.freedesktop.Telepathy.Connection.Interface.SimplePresence/presence";


	/* ENUMS */
	
	public enum ConnectionPresenceType {
		UNSET,
		OFFLINE,
		AVAILABLE,
		AWAY,
		EXTENDED_AWAY,
		HIDDEN,
		BUSY,
		UNKNOWN,
		ERROR;
		
		public static ConnectionPresenceType[] get_usable() {
			return { AVAILABLE, BUSY, AWAY, HIDDEN, OFFLINE };
		}
		
		public string to_string() {
			switch (this) {
				case UNSET:
					return "unset";

				case OFFLINE:
					return "offline";

				case AVAILABLE:
					return "available";
				
				case AWAY:
				case EXTENDED_AWAY:
					return "away";

				case HIDDEN:
					return "hidden";

				case BUSY:
					return "busy";	
					
				case UNKNOWN:
					return "unknown";
					
				case ERROR:
					return "error";
								
				default:
					assert_not_reached();
			}
			
		}
	}
	
	public enum ConnectionStatus {
		CONNECTED,
		CONNECTING,
		DISCONNECTED;
		
		public string to_string() {
			switch (this) {
				case CONNECTED:
					return "Connected";

				case CONNECTING:
					return "Connecting";

				case DISCONNECTED:
					return "Disconnected";

				default:
					assert_not_reached();
			}
		}
	}

	public enum TpHandleType {
		NONE,
		CONTACT,
		ROOM,
		LIST,
		GROUP
	}


	/* STRUCTS */
	
	/* used in Channels property in ConnectionInterfaceRequests */
	public struct ChannelInfo {
		GLib.ObjectPath path;
		GLib.HashTable<string, Variant> properties;
	}
	
	public struct ContactInfo {
		string field_name;
		string[] parameters;
		string[] field_value;	
	}
	
	
	/* Used in ConnectionInterfaceMessages */
	public struct Message {
		GLib.HashTable<string, Variant>[] parts;	
	}



	public struct Simple_Presence {
		uint type; /* = enum ConnectionPresenceType */
		string status;
		string status_message; 	
	}
	
	

}


