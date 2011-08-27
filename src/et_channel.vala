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

		public Telepathy.ChannelInterfaceMessages dbus_ext { public get; private set; }

		public ChannelMessages(string path, string connection_manager, Connection connection) {
	
			base(path,connection_manager, connection);

			logger.info("ChannelMessages", "Creating new channel with path="+path+" and connection_manager="+connection_manager);

			try {
				dbus_ext = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				dbus_ext.message_sent.connect(sig_message_sent);
				dbus_ext.message_received.connect(sig_message_received);
				dbus_ext.pending_messages_removed.connect(sig_pending_messages_removed);
			} catch ( IOError err ) {
				logger.error("ChannelMessages",  "Could not create ChannelMessages with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
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

		}

		private void sig_pending_messages_removed(uint[] message_ids) {
			logger.debug("ChannelMessages", "sig_pending_messages_removed");

			foreach(uint id in message_ids) {
				logger.debug("ChannelMessages", "pending_message_removed: id="+id.to_string());
			}

		}

	}

}
