namespace Et {

	errordomain ConnectionError {
		NO_HANDLES
	}

	public class Connection : GLib.Object {
		private static const string DOMAIN = "Connection";		
		
		private Telepathy.Connection connection;
		private Telepathy.ConnectionInterfaceRequests? _dbus_requests;
		private Telepathy.ConnectionInterfaceContacts? _dbus_contacts;
		private Telepathy.ConnectionInterfaceSimplePresence? _dbus_presence;

		public Telepathy.Connection dbus { get { return connection; } }
		public Telepathy.ConnectionInterfaceRequests? dbus_request { get { return _dbus_requests; } }
		public Telepathy.ConnectionInterfaceContacts? dbus_contacts { get { return _dbus_contacts; } }
		public Telepathy.ConnectionInterfaceSimplePresence? dbus_presence { get { return _dbus_presence; } }
		
		
		public string path {get; private set;}
		public string connection_manager {get; private set;}
		public bool is_valid {get; private set; default=false;}
		
		
		private HashTable<string,Channel> channels;

		
		public Connection(string path, string connection_manager) {
			
			this.path = path;
			this.connection_manager = connection_manager;
			
			logger.info(DOMAIN, "Creating new connection with path="+path+" and connection_manager="+connection_manager);
		}

		public void init() {
			if(path=="/") {
				logger.error(DOMAIN, "Incorrect path \"/\"");
				return;
			}
			
			channels = new HashTable<string,Channel>(str_hash, str_equal);	
		
			try {
				connection = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {	
				logger.error(DOMAIN, "Could not create Connection with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this.connection = null;
				return;
			}
			
			try {
				_dbus_requests = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				_dbus_requests.new_channels.connect(sig_new_channels);
				_dbus_requests.channel_closed.connect(sig_channel_closed);
			} catch ( IOError err ) {	
				logger.error(DOMAIN, "Could not create ConnectionInterfaceRequests with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this._dbus_requests = null;
				return;
			}
			
			try {
				_dbus_contacts = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {	
				logger.error(DOMAIN, "Could not create ConnectionInterfaceContacts with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this._dbus_contacts = null;
				return;
			}
			
			try {
				_dbus_presence = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				_dbus_presence.presences_changed.connect(sig_presences_changed);
			} catch ( IOError err ) {	
				logger.error(DOMAIN, "Could not create ConnectionInterfaceSimplePresence with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this._dbus_presence = null;
				return;
			}
			
			this.ensure_channel_contact_list();
			this.update_channels();
			this.update_contacts();
			
			this.is_valid=true;

		}

		~Connection() {

			logger.debug(DOMAIN, "Destructor for "+this.path+" called");
			if(this.is_valid) this.invalidate();
		}


		public void invalidate() {
			if(this.is_valid==false) return;
			this.is_valid=false;
			_dbus_requests.new_channels.disconnect(sig_new_channels);
			_dbus_requests.channel_closed.disconnect(sig_channel_closed);
			_dbus_presence.presences_changed.disconnect(sig_presences_changed);
			this.remove_contacts();
			this.remove_channels();
		}

		public void create_contacts(uint[] handles) {
			
				//foreach(var handle in handles) { stderr.printf("Handle: %u\n", handle); }
			
				string[] interfaces = {};
				interfaces += "org.freedesktop.Telepathy.Connection";
				interfaces += "org.freedesktop.Telepathy.Connection.Interface.SimplePresence";
				interfaces += "org.freedesktop.Telepathy.Connection.Interface.Aliasing";
			
				HashTable<uint, HashTable<string, Variant> > hash_info_all;
					
				try {
					hash_info_all = this._dbus_contacts.get_contact_attributes(handles, interfaces, true);
				} catch (Error err) {
					logger.error(DOMAIN, "get_contact_attributes() error on Contacts interface: "+err.message);
					return;
				}
				
				CM.add_contacts(this, handles, hash_info_all);
		}
		
		public void ensure_channel(HashTable<string, GLib.Variant> params, out GLib.ObjectPath channel, out HashTable<string, GLib.Variant> properties) {
			
			if(this.is_valid==false) {
				logger.error(DOMAIN, "ensure_channel() called in non valid connection");
				return;
			}
			
			bool yours;
			try { //TODO: make it async:
				_dbus_requests.ensure_channel(params, out yours, out channel, out properties);
			} catch (Error err) {
				logger.error(DOMAIN, "ensure_channel(): "+err.message);
			} 
		}
		
		
		public GLib.ObjectPath ensure_channel_contact_list() {
		
			HashTable<string, GLib.Variant> params = new HashTable<string, GLib.Variant>(null, null);
			params.insert(Telepathy.PROP_CHANNEL_CHANNEL_TYPE, Telepathy.IFACE_CHANNEL_TYPE_CONTACT_LIST);
			params.insert(Telepathy.PROP_CHANNEL_TARGET_HANDLE_TYPE, Telepathy.TpHandleType.LIST);
			//params.insert(PROP_CHANNEL_TARGET_ID, "stored");
			params.insert(Telepathy.PROP_CHANNEL_TARGET_ID, "subscribe");
			bool yours;
			GLib.ObjectPath channel;
			HashTable<string, GLib.Variant> properties;	
			
			this.ensure_channel(params, out channel, out properties);
			return channel; 
			
		}
		
		public GLib.ObjectPath ensure_channel_text(string id) {
		
			HashTable<string, GLib.Variant> params = new HashTable<string, GLib.Variant>(null, null);
			params.insert(Telepathy.PROP_CHANNEL_CHANNEL_TYPE, Telepathy.IFACE_CHANNEL_TYPE_TEXT);
			params.insert(Telepathy.PROP_CHANNEL_TARGET_HANDLE_TYPE, Telepathy.TpHandleType.CONTACT);
			params.insert(Telepathy.PROP_CHANNEL_TARGET_ID, id);
			bool yours;
			GLib.ObjectPath channel;
			HashTable<string, GLib.Variant> properties;	
			
			this.ensure_channel(params, out channel, out properties);
			return channel; 
			
		}
		
		
		public async void update_contacts() {
			logger.debug(DOMAIN, "Updating contacts info (connection.path="+path+")...");
			if(channels!=null) {
				
				HashTableIter<string,Channel> it = HashTableIter<string,Channel>(channels);
				unowned string? path;
				unowned Channel? chan;
				while(it.next(out path, out chan)) {
					assert(chan!=null);
					assert(chan.path!=null);
					update_contacts_channel(chan);
				}
	
					
			} else {
				logger.error(DOMAIN ,"Updating contacts info error: No Contacts interface on connection "+path);
			}
		}
		
		private void update_contacts_channel(Channel chan) {
			uint[]? handless = chan.get_contact_handles();
			if(handless==null)
				logger.error(DOMAIN, "update_contacts_channel("+chan.path+"): handless == NULL!!!");
			else
				this.create_contacts(handless);
		}
		
		
		public async void remove_contacts() {
			logger.debug(DOMAIN, "Removing contacts (connection.path="+path+")...");
			if(channels!=null) {
				
				HashTableIter<string,Channel> it = HashTableIter<string,Channel>(channels);
				unowned string? path;
				unowned Channel? chan;
				bool correct;
				while(it.next(out path, out chan)) {
					assert(chan!=null);
					assert(chan.path!=null);
					
					try {
						remove_contacts_channel(chan);
					} catch (ConnectionError err) {
						/* If we can't assure, all contacts from this conn have been erased from contact manager 
						 * just erase them all in a dirty way ;) 
						 */
						logger.error(DOMAIN, err.message);
						 CM.remove_all_contacts(this.path);
						 return;
					}
				}	
					
			} else {
				logger.error(DOMAIN, "Removing contacts info error: No Contacts interface on connection"+path);
			}	
		}
		
		/* Sometimes when you try to get handles from a channel the property can be null/empty:
		 * - The channel does not have this property
		 * - The connection from this channel has been closed
		 * If we couldn't get correct information from handles property, throw an exception to indicate it:
		 * */
		private void remove_contacts_channel(Channel chan) throws ConnectionError {
			uint[]? handless = chan.get_contact_handles();
			if(handless==null) {
				throw new ConnectionError.NO_HANDLES ("remove_contacts_channel("+chan.path+"): handless == NULL!!!");
			} else
				CM.remove_contacts(this, handless);
		}
		
		
		public async void update_channels() {
			
			foreach(Telepathy.ChannelInfo chinfo in this.dbus_request.channels) {
				
				var ret = channels.lookup(chinfo.path);
				if(ret!=null) continue;
				logger.debug(DOMAIN,  "update_channels(): adding channel "+chinfo.path.to_string()+" to hash table");
				Channel ch = Channel.new_from_type(chinfo.path, this.connection_manager, this, (string) chinfo.properties.lookup("org.freedesktop.Telepathy.Channel.ChannelType"));
				if(ch==null) 
					logger.warning(DOMAIN,  "unknown type for channel "+chinfo.path.to_string()+". new_from_type() returned NULL");
				else
					channels.insert(ch.path, (owned) ch);
				
				
			}
		}
		
		public void remove_channels() {
			logger.debug(DOMAIN, "Removing channels (connection.path="+path+")...");
			channels = null;
		}


		/* SIGNALS */
		
		private void sig_new_channels(Telepathy.ChannelInfo[] channel_list) {
			/*Each dictionary MUST contain the keys org.freedesktop.Telepathy.Channel.ChannelType, org.freedesktop.Telepathy.Channel.TargetHandleType, org.freedesktop.Telepathy.Channel.TargetHandle, org.freedesktop.Telepathy.Channel.TargetID and org.freedesktop.Telepathy.Channel.Requested. 
			 * */
				foreach(var ch_info in channel_list) {
					logger.debug(DOMAIN, "Signal sig_new_channels: new channel "+ch_info.path.to_string()+" created");
					string ch_type = (string) ch_info.properties.lookup("org.freedesktop.Telepathy.Channel.ChannelType");
					Channel? ch = Channel.new_from_type(ch_info.path, this.connection_manager, this, ch_type);
					if(ch==null) {
						logger.error(DOMAIN,  "unknown type for channel "+ch_info.path.to_string()+". new_from_type() returned NULL");
					} else {
						channels.insert(ch_info.path, (owned) ch);
						this.update_contacts_channel(channels.lookup(ch_info.path));
					}
				}
		}
		
		private void sig_channel_closed(GLib.ObjectPath chremoved) {
			logger.debug(DOMAIN, "Signal sig_channel_closed: "+chremoved.to_string());
			if(this.is_valid==false) return;
			unowned Channel? ch = this.channels.lookup(chremoved);
			if(ch==null) return;
			bool is_session = ch.is_session();
			this.channels.remove(chremoved);
			if(is_session) SM.remove_session(chremoved);
		}
		
		
		private void sig_presences_changed(HashTable<uint,Telepathy.Simple_Presence?> presence) {
			logger.debug(DOMAIN, "Signal sig_presence_changed");
			
			presence.@foreach( (key, val) => {
					logger.debug(DOMAIN, "\t"+key.to_string()+" -> "+((Telepathy.ConnectionPresenceType) val.type).to_string() );
				});
		
			CM.presences_changed(this, presence);	
		}

	}


}
