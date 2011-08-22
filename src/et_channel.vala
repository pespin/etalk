namespace Et {

	public abstract class Channel : GLib.Object {
		
		
		protected Telepathy.Channel channel;

		public Telepathy.Channel dbus { get { return channel; } }
		
		public string path {get; private set;}
		public string connection_manager {get; private set;}
		public unowned Connection connection {get; private set;}
		
		public Channel(string path, string connection_manager, Connection connection) {
			
			this.path = path;
			this.connection_manager = connection_manager;
			this.connection = connection;
			
			logger.info("Channel", "Creating new channel with path="+path+" and connection_manager="+connection_manager);
		
			try {
				channel = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path);
			} catch ( IOError err ) {	
				logger.error("Channel",  "Could not create Channel with path="+path+" and connection_manager="+connection_manager+" -> "+err.message);
				return;
			}
		}
		
		//returns Members in Group channels
		public abstract uint[] get_contact_handles();
		
		
		
		public static Channel? new_from_type(string path, string connection_manager, Connection connection, string type) {
			
			/*TODO: parse and return depending on type */
			
			return new ChannelGroup(path, connection_manager, connection) as Channel;
			
			
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
				channelext = Bus.get_proxy_sync (BusType.SESSION, connection_manager, path);
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
			foreach(uint rm in removed) logger.debug("ChannelGroup", "\tRemoved: "+rm.to_string());
			//TODO: remove contacts
		}
		
		
		
	
	}

}
