namespace Et {

	public abstract class Channel : GLib.Object {
		private static const string DOMAIN = "Channel";		
		
		protected Telepathy.Channel channel;

		public Telepathy.Channel dbus { get { return channel; } }
		
		public string path {get; private set;}
		public string connection_manager {get; private set;}
		public unowned Connection connection {get; private set;}
		
		public Channel(string path, string connection_manager, Connection connection) {
			assert(path!=null);
			this.path = path;
			this.connection_manager = connection_manager;
			this.connection = connection;
			
			//logger.info(DOMAIN, "Creating new channel with path="+path+" and connection_manager="+connection_manager);
		
			try {
				channel = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {	
				logger.error(DOMAIN,  "Could not create Channel with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}
		}
		
		//returns Members in Group channels
		public abstract uint[] get_contact_handles();
		
		public abstract bool is_session();
		
		
		public static Channel? new_from_type(string path, string connection_manager, Connection connection, string type) {
			
			/*TODO: parse and return depending on type */
			logger.debug(DOMAIN, "new_from_type: type="+type);
			switch(type) {
				case Telepathy.IFACE_CHANNEL_TYPE_CONTACT_LIST:
					return new ChannelGroup(path, connection_manager, connection) as Channel;
				case Telepathy.IFACE_CHANNEL_TYPE_TEXT:
					return new ChannelMessages(path, connection_manager, connection) as Channel;
				default:
					return null;
			}
			
		}

		public bool started_by_local_handle() {
			return (this.dbus.initiator_handle == this.connection.dbus.self_handle);
		}

		/* TODO: connect to signals */

	}



	public class ChannelGroup : Channel {
		private static const string DOMAIN = "ChannelGroup";
	
		private Telepathy.ChannelInterfaceGroup channelext;

		public Telepathy.ChannelInterfaceGroup dbus_ext { get { return channelext; } }
	
		
		public ChannelGroup(string path, string connection_manager, Connection connection) {
				
			base(path,connection_manager, connection);
			
			logger.info(DOMAIN, "Creating new channel with path="+path+" and connection_manager="+connection_manager);
		
			try {
				channelext = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				channelext.members_changed.connect(sig_members_changed);
			} catch ( IOError err ) {	
				logger.error(DOMAIN,  "Could not create ChannelGroup with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}
			
		}
		
		
		public override uint[] get_contact_handles() {
			return this.channelext.members;
		}
		
		public override bool is_session() {
			return false;
		}
			
		public void sig_members_changed(string message, uint[] added, uint[] removed, uint[] local_pending, uint[] remote_pending, uint actor, uint reason) {
					
			logger.debug(DOMAIN, "sig_members_changed");
			
			foreach(uint add in added) logger.debug(DOMAIN, "\tAdded: "+add.to_string());
			connection.create_contacts(added);
			foreach(uint rm in removed) logger.debug(DOMAIN, "\tRemoved: "+rm.to_string()+" (NOT IMPLEMENTED, TO DO)");
			//TODO: remove contacts
		}
	}

	public class ChannelMessages : Channel {
		private static const string DOMAIN = "ChannelMessages";

		public Telepathy.ChannelInterfaceMessages dbus_ext_messages { public get; private set; }
		public Telepathy.ChannelTypeText dbus_ext_text { public get; private set; }

		public ChannelMessages(string path, string connection_manager, Connection connection) {
	
			base(path,connection_manager, connection);

			logger.info(DOMAIN, "Creating new channel with path="+path+" and connection_manager="+connection_manager);

			try {
				dbus_ext_messages = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				dbus_ext_messages.message_sent.connect(sig_message_sent);
				dbus_ext_messages.message_received.connect(sig_message_received);
				dbus_ext_messages.pending_messages_removed.connect(sig_pending_messages_removed);
			} catch ( IOError err ) {
				logger.error(DOMAIN,  "Could not create ChannelMessages [InterfaceMessages] with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}

			try {
				dbus_ext_text = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {
				logger.error(DOMAIN,  "Could not create ChannelMessages [TypeText] with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}
			
			SM.add_session(this);

		}
		
		~ChannelMessages() {
			SM.remove_session(this.path);
		}


		public override uint[] get_contact_handles() {
			return new uint[0];
		}

		public override bool is_session() {
			return true;
		}
		
		public HashTable<string, Variant>[,] get_pending_messages() {
			HashTable<string, Variant>[,] messages = dbus_ext_messages.pending_messages;
			uint[] container = {};
			for(int i = 0; i< messages.length[0]; i++) {
				uint? id = (uint) messages[i,0].lookup("pending-message-id");	
				if(id!=null) container += id;
			}
			
			//this.ack_messages(container); //this is now done in UI
			return messages;
			
		}
		
		public void send_message(string message) {
			
			logger.debug(DOMAIN, "message to be sent: "+message);
			
			var msg = new HashTable<string, Variant>[2];
			msg[0] = new HashTable<string, Variant>(str_hash, str_equal);
			msg[1] = new HashTable<string, Variant>(str_hash, str_equal);
			
			msg[0].insert("message-type", 0); // = Channel_Text_Message_Type_Normal
			
			msg[1].insert("alternative", "main");
			msg[1].insert("content-type", "text/plain");
			msg[1].insert("content", message);
			try {
				var token = this.dbus_ext_messages.send_message(msg, 0);
				logger.debug(DOMAIN, "Messge sent, token = "+token);
			} catch( Error err ) {
				logger.error(DOMAIN,  "send_message() failed -> "+err.message);
			}
		}
		
		public void close() {
			try {
				this.dbus.close();
			} catch ( Error err ) {
				logger.error(DOMAIN,  "close() failed -> "+err.message);
			}
		}

		public void ack_messages(uint[] ids) {
			logger.debug(DOMAIN, "Sending ACK for messages:");
			foreach(var id in ids) logger.debug(DOMAIN, "\t "+id.to_string());
			try {
				dbus_ext_text.ack_pending_messages(ids);
			} catch ( Error err ) {
				logger.error(DOMAIN,  "ack_pending_messages() failed -> "+err.message);
			}			
			
		}

		private void sig_message_sent(GLib.HashTable<string, Variant>[] content, uint flags, string message_token) {
		
			logger.debug(DOMAIN, "sig_message_sent: flags="+flags.to_string()+" message_token="+message_token);

			foreach(var part in content) {
				part.@foreach( (key, val) => {
					logger.debug(DOMAIN, "\t{ key: "+key+", value:  "+val.print(true)+" }");
				});
				logger.debug(DOMAIN, "---");
			}
			
			this.new_message(content);

		}
		
	
		private void sig_message_received(GLib.HashTable<string, Variant>[] content) {
			logger.debug(DOMAIN, "sig_message_received");

			foreach(var part in content) {
				part.@foreach( (key, val) => {
					logger.debug(DOMAIN, "\t{ key: "+key+", value:  "+val.print(true)+" }");
				});
				logger.debug(DOMAIN, "---");
			}
			this.new_message(content);
			
			/*uint? id = (uint) content[0].lookup("pending-message-id");
			if(id!=null) { //this is now done in UI
				uint[] container = new uint[1];
				container[0] = id;
				this.ack_messages(container);
			} */
		}

		private void sig_pending_messages_removed(uint[] message_ids) {
			logger.debug(DOMAIN, "sig_pending_messages_removed");

			foreach(uint id in message_ids) {
				logger.debug(DOMAIN, "pending_message_removed: id="+id.to_string());
			}

		}
		
		public signal void new_message(GLib.HashTable<string, Variant>[] message);

	}

}
