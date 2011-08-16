using GLib;

namespace Telepathy {

	[DBus (name = "org.freedesktop.Telepathy.AccountManager", timeout = 120000)]
	public interface AccountManager : GLib.Object {
		
		[DBus (name = "ValidAccounts")]
		public abstract GLib.ObjectPath[] valid_accounts { owned get; }
		
		[DBus (name = "AccountRemoved")]
		public signal void account_removed(GLib.ObjectPath Account);

		[DBus (name = "AccountValidityChanged")]
		public signal void account_validity_changed(GLib.ObjectPath Account, bool Valid);

		[DBus (name = "CreateAccount")]
		public abstract GLib.ObjectPath create_account(string Connection_Manager, string Protocol, string Display_Name, GLib.HashTable<string, GLib.Variant> Parameters, GLib.HashTable<string, GLib.Variant> Properties) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Account", timeout = 120000)]
	public interface Account : GLib.Object {

		[DBus (name = "Interfaces")]
		public abstract string[] interfaces { owned get; }

		[DBus (name = "DisplayName")]
		public abstract string display_name { owned get; set;}

		[DBus (name = "Icon")]
		public abstract string icon { owned get; set;}

		[DBus (name = "Valid")]
		public abstract bool valid { owned get;}

		[DBus (name = "Enabled")]
		public abstract bool enabled { owned get; set;}

		[DBus (name = "Nickname")]
		public abstract string nickname { owned get; set;}

		[DBus (name = "Service")]
		public abstract string service { owned get; set;}
		
		[DBus (name = "Parameters")]
		public abstract GLib.HashTable<string,Variant> parameters { owned get; }
		
		[DBus (name = "AutomaticPresence")]
		public abstract Simple_Presence automatic_presence {owned get; set;}

		[DBus (name = "ConnectAutomatically")]
		public abstract bool connect_automatically {owned get; set;}

		[DBus (name = "Connection")]
		public abstract GLib.ObjectPath connection { owned get; }

		[DBus (name = "ConnectionStatus")]
		public abstract uint connection_status { owned get; }

		[DBus (name = "CurrentPresence")]
		public abstract Simple_Presence current_presence {owned get; set;}
		
		[DBus (name = "RequestedPresence")]
		public abstract Simple_Presence requested_presence {owned get; set;}

		[DBus (name = "NormalizedName")]
		public abstract string normalized_name { owned get; }

		[DBus (name = "Remove")]
		public abstract void remove() throws DBusError, IOError;

		[DBus (name = "Removed")]
		public signal void removed();

		[DBus (name = "AccountPropertyChanged")]
		public signal void account_property_changed(GLib.HashTable<string, GLib.Variant> Properties);

		[DBus (name = "UpdateParameters")]
		public abstract string[] update_parameters(GLib.HashTable<string, GLib.Variant> Set, string[] Unset) throws DBusError, IOError;

		[DBus (name = "Reconnect")]
		public abstract void reconnect() throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.ChannelDispatcher", timeout = 120000)]
	public interface ChannelDispatcher : GLib.Object {

		[DBus (name = "CreateChannel")]
		public abstract GLib.ObjectPath create_channel(GLib.ObjectPath Account, GLib.HashTable<string, GLib.Variant> Requested_Properties, int64 User_Action_Time, string Preferred_Handler) throws DBusError, IOError;

		[DBus (name = "EnsureChannel")]
		public abstract GLib.ObjectPath ensure_channel(GLib.ObjectPath Account, GLib.HashTable<string, GLib.Variant> Requested_Properties, int64 User_Action_Time, string Preferred_Handler) throws DBusError, IOError;

		[DBus (name = "CreateChannelWithHints")]
		public abstract GLib.ObjectPath create_channel_with_hints(GLib.ObjectPath Account, GLib.HashTable<string, GLib.Variant> Requested_Properties, int64 User_Action_Time, string Preferred_Handler, GLib.HashTable<string, GLib.Variant> Hints) throws DBusError, IOError;

		[DBus (name = "EnsureChannelWithHints")]
		public abstract GLib.ObjectPath ensure_channel_with_hints(GLib.ObjectPath Account, GLib.HashTable<string, GLib.Variant> Requested_Properties, int64 User_Action_Time, string Preferred_Handler, GLib.HashTable<string, GLib.Variant> Hints) throws DBusError, IOError;

		//[DBus (name = "DelegateChannels")]
		//public abstract void delegate_channels(GLib.ObjectPath[] Channels, int64 User_Action_Time, string Preferred_Handler, out GLib.ObjectPath[] Delegated, out GLib.HashTable<GLib.ObjectPath, ChannelDispatcherNotDelegatedStruct> Not_Delegated) throws DBusError, IOError;

		[DBus (name = "PresentChannel")]
		public abstract void present_channel(GLib.ObjectPath Channel, int64 User_Action_Time) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.Type.Call.DRAFT", timeout = 120000)]
	public interface ChannelTypeCallDRAFT : GLib.Object {

		[DBus (name = "SetRinging")]
		public abstract void set_ringing() throws DBusError, IOError;

		[DBus (name = "Accept")]
		public abstract void accept() throws DBusError, IOError;

		[DBus (name = "Hangup")]
		public abstract void hangup(uint Reason, string Detailed_Hangup_Reason, string Message) throws DBusError, IOError;

		[DBus (name = "AddContent")]
		public abstract GLib.ObjectPath add_content(string Content_Name, uint Content_Type) throws DBusError, IOError;

		[DBus (name = "ContentAdded")]
		public signal void content_added(GLib.ObjectPath Content);

		[DBus (name = "ContentRemoved")]
		public signal void content_removed(GLib.ObjectPath Content);

		//[DBus (name = "CallStateChanged")]
		//public signal void call_state_changed(uint Call_State, uint Call_Flags, ChannelTypeCallDRAFTCallStateReasonStruct Call_State_Reason, GLib.HashTable<string, GLib.Variant> Call_State_Details);

		[DBus (name = "CallMembersChanged")]
		public signal void call_members_changed(GLib.HashTable<uint, uint> Flags_Changed, uint[] Removed);
	}

	[DBus (name = "org.freedesktop.Telepathy.Client.Handler", timeout = 120000)]
	public interface ClientHandler : GLib.Object {

		//[DBus (name = "HandleChannels")]
		//public abstract void handle_channels(GLib.ObjectPath Account, GLib.ObjectPath Connection, ClientHandlerChannelStruct[] Channels, GLib.ObjectPath[] Requests_Satisfied, uint64 User_Action_Time, GLib.HashTable<string, GLib.Variant> Handler_Info) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Addressing.DRAFT", timeout = 120000)]
	public interface ConnectionInterfaceAddressingDRAFT : GLib.Object {

		[DBus (name = "GetContactsByVCardField")]
		public abstract GLib.HashTable<uint, GLib.HashTable<string, GLib.Variant>> get_contacts_by_v_card_field(string Field, string[] Addresses, string[] Interfaces) throws DBusError, IOError;

		[DBus (name = "GetContactsByURI")]
		public abstract GLib.HashTable<uint, GLib.HashTable<string, GLib.Variant>> get_contacts_by_u_r_i(string[] URIs, string[] Interfaces) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Debug", timeout = 120000)]
	public interface Debug : GLib.Object {

		//[DBus (name = "GetMessages")]
		//public abstract DebugMessageStruct[] get_messages() throws DBusError, IOError;

		[DBus (name = "NewDebugMessage")]
		public signal void new_debug_message(double time, string domain, uint level, string message_);
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.Interface.MediaSignalling", timeout = 120000)]
	public interface ChannelInterfaceMediaSignalling : GLib.Object {

		//[DBus (name = "GetSessionHandlers")]
		//public abstract ChannelInterfaceMediaSignallingSessionHandlerStruct[] get_session_handlers() throws DBusError, IOError;

		//[DBus (name = "NewSessionHandler")]
		//public signal void new_session_handler(GLib.ObjectPath Session_Handler, unknown Session_Type);
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Cellular", timeout = 120000)]
	public interface ConnectionInterfaceCellular : GLib.Object {

		[DBus (name = "IMSIChanged")]
		public signal void i_m_s_i_changed(string IMSI);
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.MailNotification", timeout = 120000)]
	public interface ConnectionInterfaceMailNotification : GLib.Object {

		[DBus (name = "MailsReceived")]
		public signal void mails_received(GLib.HashTable<string, GLib.Variant>[] Mails);

		[DBus (name = "UnreadMailsChanged")]
		public signal void unread_mails_changed(uint Count, GLib.HashTable<string, GLib.Variant>[] Mails_Added, string[] Mails_Removed);

		//[DBus (name = "RequestInboxURL")]
		//public abstract ConnectionInterfaceMailNotificationURLStruct request_inbox_u_r_l() throws DBusError, IOError;

		//[DBus (name = "RequestMailURL")]
		//public abstract ConnectionInterfaceMailNotificationURLStruct2 request_mail_u_r_l(string ID, GLib.Variant URL_Data) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.ContactCapabilities", timeout = 120000)]
	public interface ConnectionInterfaceContactCapabilities : GLib.Object {

		//[DBus (name = "UpdateCapabilities")]
		//public abstract void update_capabilities(ConnectionInterfaceContactCapabilitiesHandlerCapabilityStruct[] Handler_Capabilities) throws DBusError, IOError;

		//[DBus (name = "GetContactCapabilities")]
		//public abstract GLib.HashTable<uint, ConnectionInterfaceContactCapabilitiesContactCapabilityStruct[]> get_contact_capabilities(uint[] Handles) throws DBusError, IOError;

		//[DBus (name = "ContactCapabilitiesChanged")]
		//public signal void contact_capabilities_changed(GLib.HashTable<uint, ConnectionInterfaceContactCapabilitiesCapStruct[]> caps);
	}

	[DBus (name = "org.freedesktop.Telepathy.Protocol.Interface.Presence", timeout = 120000)]
	public interface ProtocolInterfacePresence : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Client.Approver", timeout = 120000)]
	public interface ClientApprover : GLib.Object {

		//[DBus (name = "AddDispatchOperation")]
		//public abstract void add_dispatch_operation(ClientApproverChannelStruct[] Channels, GLib.ObjectPath DispatchOperation, GLib.HashTable<string, GLib.Variant> Properties) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Client.Handler.FUTURE", timeout = 120000)]
	public interface ClientHandlerFUTURE : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Capabilities", timeout = 120000)]
	public interface ConnectionInterfaceCapabilities : GLib.Object {

		//[DBus (name = "AdvertiseCapabilities")]
		//public abstract ConnectionInterfaceCapabilitiesSelfCapabilityStruct[] advertise_capabilities(ConnectionInterfaceCapabilitiesAddStruct[] Add, string[] Remove) throws DBusError, IOError;

		//[DBus (name = "CapabilitiesChanged")]
		//public signal void capabilities_changed(ConnectionInterfaceCapabilitiesCapStruct[] Caps);

		//[DBus (name = "GetCapabilities")]
		//public abstract ConnectionInterfaceCapabilitiesContactCapabilityStruct[] get_capabilities(uint[] Handles) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Account.Interface.ExternalPasswordStorage.DRAFT", timeout = 120000)]
	public interface AccountInterfaceExternalPasswordStorageDRAFT : GLib.Object {

		[DBus (name = "ForgetPassword")]
		public abstract void forget_password() throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.ChannelRequest", timeout = 120000)]
	public interface ChannelRequest : GLib.Object {

		[DBus (name = "Proceed")]
		public abstract void proceed() throws DBusError, IOError;

		[DBus (name = "Cancel")]
		public abstract void cancel() throws DBusError, IOError;

		[DBus (name = "Failed")]
		public signal void failed(string Error, string Message);

		[DBus (name = "Succeeded")]
		public signal void succeeded();

		[DBus (name = "SucceededWithChannel")]
		public signal void succeeded_with_channel(GLib.ObjectPath Connection, GLib.HashTable<string, GLib.Variant> Connection_Properties, GLib.ObjectPath Channel, GLib.HashTable<string, GLib.Variant> Channel_Properties);
	}

	[DBus (name = "org.freedesktop.Telepathy.Account.Interface.Hidden.DRAFT1", timeout = 120000)]
	public interface AccountInterfaceHiddenDRAFT1 : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Anonymity", timeout = 120000)]
	public interface ConnectionInterfaceAnonymity : GLib.Object {

		[DBus (name = "AnonymityModesChanged")]
		public signal void anonymity_modes_changed(uint Modes);
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.FUTURE", timeout = 120000)]
	public interface ChannelFUTURE : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Client", timeout = 120000)]
	public interface Client : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Account.Interface.Storage", timeout = 120000)]
	public interface AccountInterfaceStorage : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Contacts", timeout = 120000)]
	public interface ConnectionInterfaceContacts : GLib.Object {

		[DBus (name = "GetContactAttributes")]
		public abstract GLib.HashTable<uint, GLib.HashTable<string, GLib.Variant>> get_contact_attributes(uint[] Handles, string[] Interfaces, bool Hold) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.ChannelDispatchOperation", timeout = 120000)]
	public interface ChannelDispatchOperation : GLib.Object {

		[DBus (name = "ChannelLost")]
		public signal void channel_lost(GLib.ObjectPath Channel, string Error, string Message);

		[DBus (name = "HandleWith")]
		public abstract void handle_with(string Handler) throws DBusError, IOError;

		[DBus (name = "Claim")]
		public abstract void claim() throws DBusError, IOError;

		[DBus (name = "HandleWithTime")]
		public abstract void handle_with_time(string Handler, int64 UserActionTime) throws DBusError, IOError;

		[DBus (name = "Finished")]
		public signal void finished();
	}

	[DBus (name = "org.freedesktop.Telepathy.Properties", timeout = 120000)]
	public interface Properties : GLib.Object {

		//[DBus (name = "GetProperties")]
		//public abstract PropertiesValueStruct[] get_properties(uint[] Properties) throws DBusError, IOError;

		//[DBus (name = "ListProperties")]
		//public abstract PropertiesAvailablePropertyStruct[] list_properties() throws DBusError, IOError;

		//[DBus (name = "PropertiesChanged")]
		//public signal void properties_changed(PropertiesPropertyStruct[] Properties);

		//[DBus (name = "PropertyFlagsChanged")]
		//public signal void property_flags_changed(PropertiesPropertyStruct2[] Properties);

		//[DBus (name = "SetProperties")]
		//public abstract void set_properties(PropertyStruct[] Properties) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Client.Observer", timeout = 120000)]
	public interface ClientObserver : GLib.Object {

		//[DBus (name = "ObserveChannels")]
		//public abstract void observe_channels(GLib.ObjectPath Account, GLib.ObjectPath Connection, ClientObserverChannelStruct[] Channels, GLib.ObjectPath Dispatch_Operation, GLib.ObjectPath[] Requests_Satisfied, GLib.HashTable<string, GLib.Variant> Observer_Info) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.ChannelDispatcher.Interface.OperationList", timeout = 120000)]
	public interface ChannelDispatcherInterfaceOperationList : GLib.Object {

		[DBus (name = "NewDispatchOperation")]
		public signal void new_dispatch_operation(GLib.ObjectPath Dispatch_Operation, GLib.HashTable<string, GLib.Variant> Properties);

		[DBus (name = "DispatchOperationFinished")]
		public signal void dispatch_operation_finished(GLib.ObjectPath Dispatch_Operation);
	}

	[DBus (name = "org.freedesktop.Telepathy.Account.Interface.Addressing", timeout = 120000)]
	public interface AccountInterfaceAddressing : GLib.Object {

		[DBus (name = "SetURISchemeAssociation")]
		public abstract void set_u_r_i_scheme_association(string URI_Scheme, bool Association) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Requests", timeout = 120000)]
	public interface ConnectionInterfaceRequests : GLib.Object {
		
		[DBus (name = "Channels")]
		public abstract ChannelInfo[] channels { owned get; private set;}

		[DBus (name = "CreateChannel")]
		public abstract void create_channel(GLib.HashTable<string, GLib.Variant> Request, out GLib.ObjectPath Channel, out GLib.HashTable<string, GLib.Variant> Properties) throws DBusError, IOError;

		[DBus (name = "EnsureChannel")]
		public abstract void ensure_channel(GLib.HashTable<string, GLib.Variant> Request, out bool Yours, out GLib.ObjectPath Channel, out GLib.HashTable<string, GLib.Variant> Properties) throws DBusError, IOError;

		[DBus (name = "NewChannels")]
		public signal void new_channels(ChannelInfo[] channel_List);

		[DBus (name = "ChannelClosed")]
		public signal void channel_closed(GLib.ObjectPath Removed);
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel", timeout = 120000)]
	public interface Channel : GLib.Object {

		//THIS PRPERTY IS NOT WORKING ON tp-gabble atm:
		[DBus (name = "ChannelType")]
		public abstract string channel_type_ { owned get; private set;}

		[DBus (name = "Close")]
		public abstract void close() throws DBusError, IOError;

		[DBus (name = "Closed")]
		public signal void closed();

		[DBus (name = "GetChannelType")]
		public abstract string get_channel_type() throws DBusError, IOError;

		[DBus (name = "GetHandle")]
		public abstract void get_handle(out uint Target_Handle_Type, out uint Target_Handle) throws DBusError, IOError;

		[DBus (name = "GetInterfaces")]
		public abstract string[] get_interfaces() throws DBusError, IOError;
	}


	[DBus (name = "org.freedesktop.Telepathy.Channel.Interface.Group")]
	public interface ChannelInterfaceGroup : GLib.Object {
		[DBus (name = "Members")]
		public abstract uint[] members {owned get;}

		[DBus (name = "MembersChanged")]
		public signal void members_changed(string message, uint[] added, uint[] removed, uint[] local_pending, uint[] remote_pending, uint actor, uint reason);
	}
	
	
	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.ContactInfo", timeout = 120000)]
	public interface ConnectionInterfaceContactInfo : GLib.Object {

		[DBus (name = "RequestContactInfo")]
		public abstract ContactInfo[] request_contact_info(uint handle) throws IOError;
		
		[DBus (name = "GetContactInfo")]
		public abstract GLib.HashTable<uint, ContactInfo?> get_contact_info(uint[] contacts) throws IOError;
		//RequestContactInfo( u:Contact ) -> ( a(sasas):Contact_Info )
		//RefreshContactInfo( au:Contacts ) -> ()
		//GetContactInfo( au:Contacts ) -> ( a{ua(sasas)}:ContactInfo )
		//ContactInfoChanged( u:none, a(sasas):none )

	}


	/*[DBus (name = "org.freedesktop.Telepathy.Channel.Type.StreamTube", timeout = 120000)]
	public interface ChannelTypeStreamTube : GLib.Object {

		[DBus (name = "Offer")]
		public abstract void offer(uint address_type, GLib.Variant address, uint access_control, GLib.HashTable<string, GLib.Variant> parameters) throws DBusError, IOError;

		[DBus (name = "Accept")]
		public abstract GLib.Variant accept(uint address_type, uint access_control, GLib.Variant access_control_param) throws DBusError, IOError;

		[DBus (name = "NewRemoteConnection")]
		public signal void new_remote_connection(uint Handle, GLib.Variant Connection_Param, uint Connection_ID);

		[DBus (name = "NewLocalConnection")]
		public signal void new_local_connection(uint Connection_ID);

		[DBus (name = "ConnectionClosed")]
		public signal void connection_closed(uint Connection_ID, string Error, string Message);
	}*/

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.ContactGroups", timeout = 120000)]
	public interface ConnectionInterfaceContactGroups : GLib.Object {

		[DBus (name = "GroupsChanged")]
		public signal void groups_changed(uint[] Contact, string[] Added, string[] Removed);

		[DBus (name = "GroupsCreated")]
		public signal void groups_created(string[] Names);

		[DBus (name = "GroupRenamed")]
		public signal void group_renamed(string Old_Name, string New_Name);

		[DBus (name = "GroupsRemoved")]
		public signal void groups_removed(string[] Names);

		[DBus (name = "SetContactGroups")]
		public abstract void set_contact_groups(uint Contact, string[] Groups) throws DBusError, IOError;

		[DBus (name = "SetGroupMembers")]
		public abstract void set_group_members(string Group, uint[] Members) throws DBusError, IOError;

		[DBus (name = "AddToGroup")]
		public abstract void add_to_group(string Group, uint[] Members) throws DBusError, IOError;

		[DBus (name = "RemoveFromGroup")]
		public abstract void remove_from_group(string Group, uint[] Members) throws DBusError, IOError;

		[DBus (name = "RemoveGroup")]
		public abstract void remove_group(string Group) throws DBusError, IOError;

		[DBus (name = "RenameGroup")]
		public abstract void rename_group(string Old_Name, string New_Name) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection", timeout = 120000)]
	public interface Connection : GLib.Object {
		
		[DBus (name = "Interfaces")]
		public abstract string[] interfaces_ { owned get; }
		
				[DBus (name = "Status")]
		public abstract uint status { owned get; }

		[DBus (name = "Connect")]
		public abstract void connect() throws DBusError, IOError;

		[DBus (name = "Disconnect")]
		public abstract void disconnect() throws DBusError, IOError;

		[DBus (name = "GetInterfaces")]
		public abstract string[] get_interfaces() throws DBusError, IOError;

		[DBus (name = "GetProtocol")]
		public abstract string get_protocol() throws DBusError, IOError;

		[DBus (name = "SelfHandleChanged")]
		public signal void self_handle_changed(uint Self_Handle);

		[DBus (name = "GetSelfHandle")]
		public abstract uint get_self_handle() throws DBusError, IOError;

		//[DBus (name = "GetStatus")]
		//public abstract uint get_status() throws DBusError, IOError;

		[DBus (name = "HoldHandles")]
		public abstract void hold_handles(uint Handle_Type, uint[] Handles) throws DBusError, IOError;

		[DBus (name = "InspectHandles")]
		public abstract string[] inspect_handles(uint Handle_Type, uint[] Handles) throws DBusError, IOError;

		//[DBus (name = "ListChannels")]
		//public abstract ConnectionChannelInfoStruct[] list_channels() throws DBusError, IOError;

		[DBus (name = "NewChannel")]
		public signal void new_channel(GLib.ObjectPath Object_Path, string Channel_Type, uint Handle_Type, uint Handle, bool Suppress_Handler);

		[DBus (name = "ReleaseHandles")]
		public abstract void release_handles(uint Handle_Type, uint[] Handles) throws DBusError, IOError;

		[DBus (name = "RequestChannel")]
		public abstract GLib.ObjectPath request_channel(string Type, uint Handle_Type, uint Handle, bool Suppress_Handler) throws DBusError, IOError;

		[DBus (name = "RequestHandles")]
		public abstract uint[] request_handles(uint Handle_Type, string[] Identifiers) throws DBusError, IOError;

		[DBus (name = "ConnectionError")]
		public signal void connection_error(string Error, GLib.HashTable<string, GLib.Variant> Details);

		[DBus (name = "StatusChanged")]
		public signal void status_changed(uint Status, uint Reason);

		[DBus (name = "AddClientInterest")]
		public abstract void add_client_interest(string[] Tokens) throws DBusError, IOError;

		[DBus (name = "RemoveClientInterest")]
		public abstract void remove_client_interest(string[] Tokens) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.ConnectionManager.Interface.AccountStorage.DRAFT", timeout = 120000)]
	public interface ConnectionManagerInterfaceAccountStorageDRAFT : GLib.Object {

		[DBus (name = "ForgetCredentials")]
		public abstract void forget_credentials(string Account_Id) throws DBusError, IOError;

		[DBus (name = "RemoveAccount")]
		public abstract void remove_account(string Account_Id) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Avatars", timeout = 120000)]
	public interface ConnectionInterfaceAvatars : GLib.Object {

		//[DBus (name = "AvatarUpdated")]
		//public signal void avatar_updated(uint Contact, unknown New_Avatar_Token);

		//[DBus (name = "AvatarRetrieved")]
		//public signal void avatar_retrieved(uint Contact, unknown Token, uint8[] Avatar, string Type);

		[DBus (name = "GetAvatarRequirements")]
		public abstract void get_avatar_requirements(out string[] MIME_Types, out uint Min_Width, out uint Min_Height, out uint Max_Width, out uint Max_Height, out uint Max_Bytes) throws DBusError, IOError;

		[DBus (name = "GetAvatarTokens")]
		public abstract string[] get_avatar_tokens(uint[] Contacts) throws DBusError, IOError;

		[DBus (name = "GetKnownAvatarTokens")]
		public abstract GLib.HashTable<uint, string> get_known_avatar_tokens(uint[] Contacts) throws DBusError, IOError;

		[DBus (name = "RequestAvatar")]
		public abstract void request_avatar(uint Contact, out uint8[] Data, out string MIME_Type) throws DBusError, IOError;

		[DBus (name = "RequestAvatars")]
		public abstract void request_avatars(uint[] Contacts) throws DBusError, IOError;

		[DBus (name = "SetAvatar")]
		public abstract string set_avatar(uint8[] Avatar, string MIME_Type) throws DBusError, IOError;

		[DBus (name = "ClearAvatar")]
		public abstract void clear_avatar() throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.FUTURE", timeout = 120000)]
	public interface ConnectionFUTURE : GLib.Object {

		[DBus (name = "EnsureSidecar")]
		public abstract void ensure_sidecar(string Main_Interface, out GLib.ObjectPath Path, out GLib.HashTable<string, GLib.Variant> Properties) throws DBusError, IOError;
	}

	/*[DBus (name = "org.freedesktop.Telepathy.Channel.Type.DBusTube", timeout = 120000)]
	public interface ChannelTypeDBusTube : GLib.Object {

		[DBus (name = "Offer")]
		public abstract string offer(GLib.HashTable<string, GLib.Variant> parameters, uint access_control) throws DBusError, IOError;

		[DBus (name = "Accept")]
		public abstract string accept(uint access_control) throws DBusError, IOError;

		[DBus (name = "DBusNamesChanged")]
		public signal void d_bus_names_changed(GLib.HashTable<uint, string> Added, uint[] Removed);
	}*/

	[DBus (name = "org.freedesktop.Telepathy.Protocol", timeout = 120000)]
	public interface Protocol : GLib.Object {

		[DBus (name = "IdentifyAccount")]
		public abstract string identify_account(GLib.HashTable<string, GLib.Variant> Parameters) throws DBusError, IOError;

		[DBus (name = "NormalizeContact")]
		public abstract string normalize_contact(string Contact_ID) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.Type.RoomList", timeout = 120000)]
	public interface ChannelTypeRoomList : GLib.Object {

		[DBus (name = "GetListingRooms")]
		public abstract bool get_listing_rooms() throws DBusError, IOError;

		//[DBus (name = "GotRooms")]
		//public signal void got_rooms(ChannelTypeRoomListRoomStruct[] Rooms);

		[DBus (name = "ListRooms")]
		public abstract void list_rooms() throws DBusError, IOError;

		[DBus (name = "StopListing")]
		public abstract void stop_listing() throws DBusError, IOError;

		[DBus (name = "ListingRooms")]
		public signal void listing_rooms(bool Listing);
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.Interface.CredentialsStorage.DRAFT", timeout = 120000)]
	public interface ChannelInterfaceCredentialsStorageDRAFT : GLib.Object {

		[DBus (name = "StoreCredentials")]
		public abstract void store_credentials(bool Store) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.Type.ContactList", timeout = 120000)]
	public interface ChannelTypeContactList : GLib.Object {
	}

	[DBus (name = "org.freedesktop.Telepathy.Channel.Interface.ServicePoint", timeout = 120000)]
	public interface ChannelInterfaceServicePoint : GLib.Object {

		//[DBus (name = "ServicePointChanged")]
		//public signal void service_point_changed(ChannelInterfaceServicePointServicePointStruct Service_Point);
	}

	[DBus (name = "org.freedesktop.Telepathy.ChannelHandler", timeout = 120000)]
	public interface ChannelHandler : GLib.Object {

		[DBus (name = "HandleChannel")]
		public abstract void handle_channel(string Bus_Name, GLib.ObjectPath Connection, string Channel_Type, GLib.ObjectPath Channel, uint Handle_Type, uint Handle) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Protocol.Interface.Addressing.DRAFT", timeout = 120000)]
	public interface ProtocolInterfaceAddressingDRAFT : GLib.Object {

		[DBus (name = "NormalizeVCardAddress")]
		public abstract string normalize_v_card_address(string VCard_Field, string VCard_Address) throws DBusError, IOError;

		[DBus (name = "NormalizeURI")]
		public abstract string normalize_u_r_i(string URI) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.ConnectionManager", timeout = 120000)]
	public interface ConnectionManager : GLib.Object {

		//[DBus (name = "GetParameters")]
		//public abstract ConnectionManagerParameterStruct[] get_parameters(string Protocol) throws DBusError, IOError;

		[DBus (name = "ListProtocols")]
		public abstract string[] list_protocols() throws DBusError, IOError;

		[DBus (name = "NewConnection")]
		public signal void new_connection(string Bus_Name, GLib.ObjectPath Object_Path, string Protocol);

		[DBus (name = "RequestConnection")]
		public abstract void request_connection(string Protocol, GLib.HashTable<string, GLib.Variant> Parameters, out string Bus_Name, out GLib.ObjectPath Object_Path) throws DBusError, IOError;
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.CommunicationPolicy.DRAFT", timeout = 120000)]
	public interface ConnectionInterfaceCommunicationPolicyDRAFT : GLib.Object {

		//[DBus (name = "SetPolicy")]
		//public abstract void set_policy(string Channel_Type, ConnectionInterfaceCommunicationPolicyDRAFTPolicyStruct Policy) throws DBusError, IOError;

		//[DBus (name = "PolicyChanged")]
		//public signal void policy_changed(GLib.HashTable<string, ConnectionInterfaceCommunicationPolicyDRAFTChangedPolicyStruct> Changed_Policies);
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.ServicePoint", timeout = 120000)]
	public interface ConnectionInterfaceServicePoint : GLib.Object {

		//[DBus (name = "ServicePointsChanged")]
		//public signal void service_points_changed(ConnectionInterfaceServicePointServicePointStruct[] Service_Points);
	}

	[DBus (name = "org.freedesktop.Telepathy.Connection.Interface.Resources.DRAFT", timeout = 120000)]
	public interface ConnectionInterfaceResourcesDRAFT : GLib.Object {

		[DBus (name = "GetResources")]
		public abstract GLib.HashTable<uint, GLib.HashTable<string, GLib.HashTable<string, GLib.Variant>>> get_resources(uint[] Contacts) throws DBusError, IOError;

		//[DBus (name = "ResourcesUpdated")]
		//public signal void resources_updated(uint Contact, unknown Resources);
	}
}
