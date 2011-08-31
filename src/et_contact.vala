namespace Et {


	public class Contact : GLib.Object {
		
		public unowned Connection connection {get; private set;}
		
		public uint handle {get; private set;}
		public string id {get; private set; default="unknown";}
		public string alias {get; private set; default="unknown";}
		public Telepathy.Simple_Presence presence {get; private set;}
		
		public Contact(uint handle, Connection connection) {
			this.handle = handle;
			this.connection = connection;
			
			
			this.presence = Telepathy.Simple_Presence();
			presence.type = Telepathy.ConnectionPresenceType.UNSET;
			presence.status="";
			presence.status_message="";
		
			logger.debug("Contact", "Creating new contact with handle="+handle.to_string()+" and connection.path="+connection.path);
		
		}
		
		
		public void update_properties(HashTable<string, Variant> properties) {
			
			/*
			stderr.printf("Contact: update_properties():\n");
			
			properties.@foreach( (key, val) => {
				stderr.printf("\t{ key: %s, value:  %s }\n", key, val.print(true));
			});
			*/
			
			this.id = (string) properties.lookup(Telepathy.TOKEN_CONNECTION_CONTACT_ID);
			this.alias = (string) properties.lookup(Telepathy.TOKEN_CONNECTION_INTERFACE_ALIASING_ALIAS);
			
			Variant v = properties.lookup(Telepathy.TOKEN_CONNECTION_INTERFACE_SIMPLE_PRESENCE_PRESENCE);
			if(v!=null) {
				VariantIter iter = v.iterator();
				presence.type = (uint) iter.next_value();
				presence.status = (string) iter.next_value();
				presence.status_message = (string) iter.next_value();
			}
		}

		public async void start_conversation() {
				this.connection.ensure_channel_text(this.id);
		}

		/*  debugging purpouses */
		public string to_string() {
			Telepathy.ConnectionPresenceType cp = (Telepathy.ConnectionPresenceType) 	presence.type;
			return "[#"+handle.to_string()+"]["+cp.to_string() +"]["+presence.status+"] "+alias+" ("+id+")";
		}

	}


}
