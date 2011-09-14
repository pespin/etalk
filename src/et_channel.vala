namespace Et {

	public abstract class Channel : GLib.Object {
		
		
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
			
			//logger.info("Channel", "Creating new channel with path="+path+" and connection_manager="+connection_manager);
		
			try {
				channel = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {	
				logger.error("Channel",  "Could not create Channel with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}
		}
		
		//returns Members in Group channels
		public abstract uint[] get_contact_handles();
		
		
		
		public static Channel? new_from_type(string path, string connection_manager, Connection connection, string type) {
			
			/*TODO: parse and return depending on type */
			logger.debug("Channel", "new_from_type: type="+type);
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
	
		private Telepathy.ChannelInterfaceGroup channelext;

		public Telepathy.ChannelInterfaceGroup dbus_ext { get { return channelext; } }
	
		
		public ChannelGroup(string path, string connection_manager, Connection connection) {
				
			base(path,connection_manager, connection);
			
			logger.info("ChannelGroup", "Creating new channel with path="+path+" and connection_manager="+connection_manager);
		
			try {
				channelext = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				channelext.members_changed.connect(sig_members_changed);
			} catch ( IOError err ) {	
				logger.error("ChannelGroup",  "Could not create ChannelGroup with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}
			
		}
		
		
		public override uint[] get_contact_handles() {
			return this.channelext.members;
		}
			
		public void sig_members_changed(string message, uint[] added, uint[] removed, uint[] local_pending, uint[] remote_pending, uint actor, uint reason) {
					
			logger.debug("ChannelGroup", "sig_members_changed");
			
			foreach(uint add in added) logger.debug("ChannelGroup", "\tAdded: "+add.to_string());
			connection.create_contacts(added);
			foreach(uint rm in removed) logger.debug("ChannelGroup", "\tRemoved: "+rm.to_string()+" (NOT IMPLEMENTED, TO DO)");
			//TODO: remove contacts
		}
	}

	public class ChannelMessages : Channel {

		public Telepathy.ChannelInterfaceMessages dbus_ext_messages { public get; private set; }
		public Telepathy.ChannelTypeText dbus_ext_text { public get; private set; }

		public ChannelMessages(string path, string connection_manager, Connection connection) {
	
			base(path,connection_manager, connection);

			logger.info("ChannelMessages", "Creating new channel with path="+path+" and connection_manager="+connection_manager);

			try {
				dbus_ext_messages = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				dbus_ext_messages.message_sent.connect(sig_message_sent);
				dbus_ext_messages.message_received.connect(sig_message_received);
				dbus_ext_messages.pending_messages_removed.connect(sig_pending_messages_removed);
			} catch ( IOError err ) {
				logger.error("ChannelMessages",  "Could not create ChannelMessages [InterfaceMessages] with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}

			try {
				dbus_ext_text = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
			} catch ( IOError err ) {
				logger.error("ChannelMessages",  "Could not create ChannelMessages [TypeText] with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
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
		
		public HashTable<string, Variant>[,] get_pending_messages() {
			HashTable<string, Variant>[,] messages = dbus_ext_messages.pending_messages;
			uint[] container = {};
			for(int i = 0; i< messages.length[0]; i++) {
				uint? id = (uint) messages[i,0].lookup("pending-message-id");	
				if(id!=null) container += id;
			}
			
			this.ack_messages(container);
			return messages;
			
		}
		
		private void ack_messages(uint[] ids) {
			logger.debug("ChannelMessages", "Sending ACK for messages:");
			foreach(var id in ids) logger.debug("ChannelMessages", "\t "+id.to_string());
			try {
				dbus_ext_text.ack_pending_messages(ids);
			} catch ( Error err ) {
				logger.error("ChannelMessages",  "ack_pending_messages() failed -> "+err.message);
			}			
			
		}

		private void sig_message_sent(GLib.HashTable<string, Variant>[] content, uint flags, string message_token) {
		
			logger.debug("ChannelMessages", "sig_message_sent: flags="+flags.to_string()+" message_token="+message_token);

			foreach(var part in content) {
				part.@foreach( (key, val) => {
					logger.debug("ChannelMessages", "\t{ key: "+key+", value:  "+val.print(true)+" }");
				});
				logger.debug("ChannelMessages", "---");
			}

		}
		
	
		private void sig_message_received(GLib.HashTable<string, Variant>[] content) {
			logger.debug("ChannelMessages", "sig_message_received");

			foreach(var part in content) {
				part.@foreach( (key, val) => {
					logger.debug("ChannelMessages", "\t{ key: "+key+", value:  "+val.print(true)+" }");
				});
				logger.debug("ChannelMessages", "---");
			}
			this.new_message(content);
			
			uint? id = (uint) content[0].lookup("pending-message-id");
			if(id!=null) {
				uint[] container = new uint[1];
				container[0] = id;
				this.ack_messages(container);
			}
		}

		private void sig_pending_messages_removed(uint[] message_ids) {
			logger.debug("ChannelMessages", "sig_pending_messages_removed");

			foreach(uint id in message_ids) {
				logger.debug("ChannelMessages", "pending_message_removed: id="+id.to_string());
			}

		}
		
		public signal void new_message(GLib.HashTable<string, Variant>[] message);

	}

}
