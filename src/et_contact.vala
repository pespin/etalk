namespace Et {


	public class Contact : GLib.Object {
		private static const string DOMAIN = "Contact";
		
		public unowned Connection connection {get; private set;}
		
		public uint handle {get; private set;}
		public string id {get; private set; default="unknown";}
		public string alias {get; private set; default="unknown";}
		public Telepathy.Simple_Presence presence {get; set;}
		
		public Contact(Connection connection, uint handle) {
			this.handle = handle;
			this.connection = connection;
			
			
			this.presence = Telepathy.Simple_Presence();
			presence.type = Telepathy.ConnectionPresenceType.UNSET;
			presence.status="";
			presence.status_message="";
		
			logger.debug(DOMAIN, "Creating new contact with handle="+handle.to_string()+" and connection.path="+connection.path);
		
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
				presence = (Telepathy.Simple_Presence) v;
			}
		}

		public async void start_conversation() {
				this.connection.ensure_channel_text(this.id);
		}
		
		public string get_unique_key() {
				assert(this.connection.path!=null);
				return this.connection.path+this.handle.to_string();
		}
		
		public static string get_unique_key_ext(Connection conn, uint handle) {
			assert(conn.path!=null);
			return conn.path+handle.to_string();
		}
		
		public bool is_online() {
			Telepathy.ConnectionPresenceType p = (Telepathy.ConnectionPresenceType) this.presence.type;
			return (Telepathy.ConnectionPresenceType.AVAILABLE <= p <= Telepathy.ConnectionPresenceType.BUSY);
			
		}

		/*  debugging purpouses */
		public string to_string() {
			Telepathy.ConnectionPresenceType cp = (Telepathy.ConnectionPresenceType) 	presence.type;
			return "[#"+handle.to_string()+"]["+cp.to_string() +"]["+presence.status+"] "+alias+" ("+id+")";
		}

	}


}
