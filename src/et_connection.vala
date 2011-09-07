namespace Et {


	public class Connection : GLib.Object {
		
		private Telepathy.Connection connection;
		private Telepathy.ConnectionInterfaceRequests? _dbus_requests;
		private Telepathy.ConnectionInterfaceContacts? _dbus_contacts;

		public Telepathy.Connection dbus { get { return connection; } }
		public Telepathy.ConnectionInterfaceRequests? dbus_request { get { return _dbus_requests; } }
		public Telepathy.ConnectionInterfaceContacts? dbus_contacts { get { return _dbus_contacts; } }
		
		public string path {get; private set;}
		public string connection_manager {get; private set;}
		public bool is_valid {get; private set; default=false;}
		
		
		private HashTable<string,Channel> channels;
		private HashTable<uint,Contact> contacts;
		
		public Connection(string path, string connection_manager) {
			
			this.path = path;
			this.connection_manager = connection_manager;
			
			logger.info("Connection", "Creating new connection with path="+path+" and connection_manager="+connection_manager);
		}

		public void init() {
			if(path=="/") {
				logger.error("Connection", "Incorrect path \"/\"");
				return;
			}
			
			channels = new HashTable<string,Channel>(str_hash, str_equal);
			contacts = new HashTable<uint,Contact>(direct_hash, direct_equal);
			
		
			try {
				connection = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {	
				logger.error("Connection", "Could not create Connection with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this.connection = null;
				return;
			}
			
			try {
				_dbus_requests = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				_dbus_requests.new_channels.connect(sig_new_channels);
				_dbus_requests.channel_closed.connect(sig_channel_closed);
			} catch ( IOError err ) {	
				logger.error("Connection", "Could not create ConnectionInterfaceRequests with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this._dbus_requests = null;
				return;
			}
			
			try {
				_dbus_contacts = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {	
				logger.error("Connection", "Could not create ConnectionInterfaceContacts with path="+path+" and connection_manager="+connection_manager+" --> "+err.message);
				this._dbus_contacts = null;
				return;
			}
			
			this.ensure_channel_contact_list();
			this.update_channels();
			this.update_contacts();
			
			this.is_valid=true;

		}

		~Connection() {

			logger.debug("Connection", "Destructor for "+this.path+" called");
			if(this.is_valid) this.invalidate();
		}


		public void invalidate() {
			if(this.is_valid==false) return;
			this.is_valid=false;
			_dbus_requests.new_channels.disconnect(sig_new_channels);
			this.remove_contacts();
			this.remove_channels();
		}
		
		private void add_contact(owned Contact c) {
				this.contacts.insert(c.handle, (owned) c);
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
					logger.error("Connection", "get_contact_attributes() error on Contacts interface: "+err.message);
					return;
				}
				
				foreach(var handle in handles) {
					
					unowned HashTable<string,Variant> hash_info_one = hash_info_all.lookup(handle);
					unowned Contact c = this.get_contact(handle);
					
					if(hash_info_one==null) continue;
					
					c.update_properties(hash_info_one);
					ui.mui.add_elem_to_ui(c);
				}
				ui.mui.refresh_list();
		}

		public void remove_contacts_subset(uint[] handles) {
			foreach(var handle in handles) {
					unowned Contact? contact = contacts.lookup(handle);
					if(contact!=null) {
						contacts.remove(handle);
						ui.mui.remove_elem_from_ui(contact.get_unique_key());
					}
			}
			ui.mui.refresh_list();
		}
		
		//returns null if not exists , otherwise the contact reference if exists
		public unowned Contact? has_contact(uint handle) {
			return contacts.lookup(handle);
		}
		
		
		//if not exists, creates a new one and returns its reference
		public unowned Contact? get_contact(uint handle) {
			unowned Contact? c = this.has_contact(handle);
			
			if(c!=null) return c;
			
			Contact cnew = new Contact(handle, this);	
			contacts.insert(handle, (owned) cnew);
			return contacts.lookup(handle);
			
		}
		
		
		public void ensure_channel(HashTable<string, GLib.Variant> params, out GLib.ObjectPath channel, out HashTable<string, GLib.Variant> properties) {
			
			if(this.is_valid==false) {
				logger.error("Connection", "ensure_channel() called in non valid connection");
				return;
			}
			
			bool yours;
			try { //TODO: make it async:
				_dbus_requests.ensure_channel(params, out yours, out channel, out properties);
			} catch (Error err) {
				logger.error("Connection", "ensure_channel(): "+err.message);
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
			logger.debug("Connection", "Updating contacts info (connection.path="+path+")...");
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
				logger.error("Connection" ,"Updating contacts info error: No Contacts interface on connection "+path);
			}
		}
		
		private void update_contacts_channel(Channel chan) {
			uint[]? handless = chan.get_contact_handles();
			if(handless==null)
				logger.error("Connection", "update_contacts_channel("+chan.path+"): handless == NULL!!!");
			else
				this.create_contacts(handless);
		}
		
		
		public async void remove_contacts() {
			logger.debug("Connection", "Removing contacts (connection.path="+path+")...");
			if(channels!=null) {
				
				HashTableIter<string,Channel> it = HashTableIter<string,Channel>(channels);
				unowned string? path;
				unowned Channel? chan;
				while(it.next(out path, out chan)) {
					assert(chan!=null);
					assert(chan.path!=null);
					remove_contacts_channel(chan);
				}	
					
			} else {
				logger.error("Connection", "Removing contacts info error: No Contacts interface on connection"+path);
			}	
		}
		
		private void remove_contacts_channel(Channel chan) {
			uint[]? handless = chan.get_contact_handles();
			if(handless==null)
				logger.error("Connection", "remove_contacts_channel("+chan.path+"): handless == NULL!!!");
			else
				this.remove_contacts_subset(handless);
			
		}
		
		
		public async void update_channels() {
			
			foreach(Telepathy.ChannelInfo chinfo in this.dbus_request.channels) {
				
				var ret = channels.lookup(chinfo.path);
				if(ret!=null) continue;
				logger.debug("Connection",  "update_channels(): adding channel "+chinfo.path.to_string()+" to hash table");
				Channel ch = Channel.new_from_type(chinfo.path, this.connection_manager, this, (string) chinfo.properties.lookup("org.freedesktop.Telepathy.Channel.ChannelType"));
				if(ch==null) 
					logger.error("Connection",  "unknown type for channel "+chinfo.path.to_string()+". new_from_type() returned NULL");
				else
					channels.insert(ch.path, (owned) ch);
				
				
			}
		}
		
		public void remove_channels() {
			logger.debug("Connection", "Removing channels (connection.path="+path+")...");
			channels = null;
		}


		/* TODO: connect to signals */


		/* SIGNALS */
		
		private void sig_new_channels(Telepathy.ChannelInfo[] channel_list) {
			/*Each dictionary MUST contain the keys org.freedesktop.Telepathy.Channel.ChannelType, org.freedesktop.Telepathy.Channel.TargetHandleType, org.freedesktop.Telepathy.Channel.TargetHandle, org.freedesktop.Telepathy.Channel.TargetID and org.freedesktop.Telepathy.Channel.Requested. 
			 * */
				foreach(var ch_info in channel_list) {
					logger.debug("Connection", "Signal sig_new_channels: new channel "+ch_info.path.to_string()+" created");
					string ch_type = (string) ch_info.properties.lookup("org.freedesktop.Telepathy.Channel.ChannelType");
					Channel? ch = Channel.new_from_type(ch_info.path, this.connection_manager, this, ch_type);
					if(ch==null) {
						logger.error("Connection",  "unknown type for channel "+ch_info.path.to_string()+". new_from_type() returned NULL");
					} else {
						channels.insert(ch_info.path, (owned) ch);
						this.update_contacts_channel(channels.lookup(ch_info.path));
					}
				}
		}
		
		private void sig_channel_closed(GLib.ObjectPath chremoved) {
			logger.debug("Connection", "Signal sig_channel_closed: "+chremoved.to_string());
			if(this.is_valid==true) this.channels.remove(chremoved);
			SM.remove_session(chremoved);
		}		


	}


}
