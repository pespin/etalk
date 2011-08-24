//FIXME: C generated code fails if I add Telepathy.Client here as a Interface...
[DBus (name = "org.freedesktop.Telepathy.Client")]
public class DBusClient : GLib.Object {
	
	private string[] _interfaces;
	
	[DBus (name = "Interfaces")]
	public string[] interfaces { 
			owned get {
				logger.debug("Client", "Interfaces property requested.");
				return _interfaces;
			}
		 }
		 
	public DBusClient(string[] interfaces) {
		_interfaces = interfaces;	
	}
									
}	


[DBus (name = "org.freedesktop.Telepathy.Client.Interface.Requests")]
public class DBusClientInterfaceRequests : GLib.Object, Telepathy.ClientInterfaceRequests {
	
	[DBus (name = "AddRequest")]
	public void add_request(GLib.ObjectPath request, GLib.HashTable<string, GLib.Variant> properties) throws DBusError, IOError {
		logger.debug("DBusClientInterfaceRequests", "AddRequest() called for path "+request.to_string());
	
		properties.@foreach( (key, val) => {
				logger.debug("DBusClientInterfaceRequests", "\t{ key: "+key+", value:  "+val.print(true)+" }");
		});
	
	}

	[DBus (name = "RemoveRequest")]
	public void remove_request(GLib.ObjectPath request, string error, string message) throws DBusError, IOError {
		logger.debug("DBusClientInterfaceRequests", "RemoveRequest() called for path "+request.to_string());
	}
							
}

[DBus (name = "org.freedesktop.Telepathy.Client.Handler")]
public class DBusClientHandler : GLib.Object, Telepathy.ClientHandler {
	
	private bool _bypass_approval;
	[DBus (name = "BypassApproval")]
	public bool bypass_approval { 
			get {
				logger.debug("ClientHandler",  "BypassApproval property requested");
				return _bypass_approval;
			}
	}
	
	private HashTable<string, Variant> _capabilities;
	[DBus (name = "Capabilities")]
	public HashTable<string, Variant> capabilities { 
			owned get {
				logger.debug("ClientHandler", "Capabilities property requested.");
				return _capabilities;
			}
	}
	
	private GLib.ObjectPath[] _handled_channels;
	[DBus (name = "HandledChannels")]
	public GLib.ObjectPath[] handled_channels { 
			owned get {
				logger.debug("ClientHandler", "HandledChannels property requested.");
				return _handled_channels;
			}
		 }
		 
	public DBusClientHandler() {
		_bypass_approval = true;
		_capabilities = new HashTable<string,Variant>(str_hash, str_equal);
		_handled_channels = new GLib.ObjectPath[0];
	}
	
	public void handle_channels(GLib.ObjectPath account, GLib.ObjectPath connection, 
										Telepathy.ChannelInfo[] channels, GLib.ObjectPath[] requests_satisfied, 
										uint64 user_action_time, GLib.HashTable<string, GLib.Variant> handler_info) 
										throws DBusError, IOError {
										
										
		logger.debug("ClientHandler", "account: " + account.to_string() + " \tconnection: " + connection.to_string());
					
		foreach(var chan in channels) {
			logger.debug("ClientHandler", "channel: "+chan.path.to_string());
		}
		foreach(var req in requests_satisfied) {
			logger.debug("ClientHandler", "requests_satisfied: "+req.to_string());
		}
		
		throw new DBusError.FAILED("not implemented!");
	}
		
}


namespace Et {

	public abstract class Client : GLib.Object {
		public DBusClient client { public get; protected set; }
		
		public Client(string[] interfaces) {
			client = new DBusClient(interfaces);
		}
		
		protected void register() {
			try {
				SESCONN.register_object(ETALK_CLIENT_AGENT_PATH, client);
			} catch ( IOError err ) {	
				logger.error("Client", "Could not create Client with path "+ETALK_CLIENT_AGENT_PATH+" and connection manager "+ETALK_CLIENT_SERVICE_NAME+" --> "+err.message);
				return;
			}
			
		}
			
		
	}

	public class ClientHandler : Et.Client {
	
		
		public DBusClientHandler client_handler { public get; protected set; }	
		public DBusClientInterfaceRequests requests { public get; protected set; }
		
		public ClientHandler() {
			
			string[] interfaces = {};
			interfaces += "org.freedesktop.Telepathy.Client.Handler";
			base(interfaces);

			requests = new DBusClientInterfaceRequests();
			client_handler = new DBusClientHandler();
		}
		
		
		public new void register() {
			try {
				SESCONN.register_object(ETALK_CLIENT_AGENT_PATH, requests);
				SESCONN.register_object(ETALK_CLIENT_AGENT_PATH, client_handler);
			} catch ( IOError err ) {
				logger.error("ClientHandler", "Could not create ClientHandler with path "+ETALK_CLIENT_AGENT_PATH+" and connection manager "+ETALK_CLIENT_SERVICE_NAME+" --> "+err.message);
				return;
			}
			
			base.register();
			
		}

	}

}

