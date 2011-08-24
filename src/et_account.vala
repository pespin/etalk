namespace Et {

	public class Account : GLib.Object {
		
		private Telepathy.Account account;

		public Telepathy.Account dbus { get { return account; } }
		
		
		public string path {get; private set;}
		
		
		/* we have to parse it. Connection manager is always of type "/org/freedesktop/Telepathy/Account/cm/proto/acct"
		 * see http://telepathy.freedesktop.org/spec/Account.html for more info */
		public string connection_manager { get; private set; }
		public Connection? connection { get; private set; default=null; }
		
		public Account(string path) {
			
			this.path = path;
			
			var parts = this.path.split("/");
			this.connection_manager = Telepathy.CONNECTION_MANAGER_BUS_NAME + "." + parts[5];
		
			try {
				account = Bus.get_proxy_sync (BusType.SESSION, Telepathy.ACCOUNT_MANAGER_BUS_NAME, path);
			} catch ( IOError err ) {	
				logger.error("Account", "Could not create Account with path "+path+": "+err.message);
			}

			logger.debug("Account", "connection_manager = "+this.connection_manager);
			
			
			//autoconnect if the account is configured this way:
			if(this.dbus.enabled) {
				logger.debug("Account", "autoconnecting "+path);
				this.dbus.requested_presence = this.dbus.automatic_presence;
			}
			
			
			this.open_connection(this.account.connection);
			
			this.dbus.account_property_changed.connect(this.sig_account_property_changed);

		}
		
		public void enable() {
			this.dbus.enabled = true;
			this.dbus.requested_presence = this.dbus.automatic_presence;
		}
		
		public void disable() {
			this.dbus.enabled = false;
		}
		
		
		private void open_connection(GLib.ObjectPath conn) {
			this.connection = new Connection(conn, this.connection_manager);
			this.connection.init();
		}
		
		private void close_connection() {
			logger.debug("Account",  "closing connection");
			this.connection.invalidate();
		}
		
		
		

		/* TODO: connect to signals propertychanged */
		
		
		private void sig_account_property_changed(GLib.HashTable<string, GLib.Variant> properties) {
			
			properties.@foreach( (key, val) => {
				logger.debug("Account", "\t{ key: "+key+", value:  "+val.print(true)+" }");
			});
			
			unowned Variant? e = properties.lookup("Enabled");
			unowned Variant? cs = properties.lookup("ConnectionStatus");
			unowned Variant? c = properties.lookup("Connection");
			
			if( c!=null && c.get_string()!="/" && cs!=null &&  cs.get_uint32()==Telepathy.ConnectionStatus.CONNECTED && this.connection.is_valid==false) {
					this.open_connection((GLib.ObjectPath) c.get_string());
			}
			
			if(e!=null && e.get_boolean()==true && this.connection!=null) {
				this.connection.init();
			}
			
			//account disabled, remove connection:
			if((e!=null && e.get_boolean()==false) || (c!=null && c.get_string()=="/")	) {
				this.close_connection();
			}
			
			
		}

	}


}
