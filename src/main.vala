

async void etalk_init() {
	
		/* INITIALIZE GLOBALS */
	
		ACM = new Et.AccountManager();
	
		foreach(var acc_path in ACM.accounts.get_keys()) {
		
			stderr.printf("init: %s\n", acc_path);
			
		}
	
		/*ACM.accounts.@foreach( (acc_path, acc) => {
		
			stderr.printf("init: Requesting info on account %s ...\n", acc_path);

			if(!acc.connection.is_valid || acc.connection.dbus.status!=Telepathy.ConnectionStatus.CONNECTED) {
				stderr.printf("\tThis connection is not connected, jumping to next connection...\n");
				return;
			}
			//stderr.printf("connection has status=%u\n", acc.connection.dbus.status);
			stderr.printf("\tEnsuring contact list channel %s ...\n", acc.connection.ensure_channel_contact_list());
			*/
			/*
			acc.connection.channels.@foreach( (path, channel) => {
				
				stderr.printf("\tChannel: %s\n", path);
			
			} ); */
			
			
			/*acc.connection.contacts.@foreach( (handle, contact) => {
				
				stderr.printf("\tContact: %s\n", contact.to_string());
					
			
			
			} );*/
		
		
		//} );
	
	
}


void on_bus_session_acquired (DBusConnection conn) {
	
	SESCONN = conn;
	/*
	try {
		//conn.register_object (ETALK_OBEX_AGENT_PATH, new ObexAgent ());
		stderr.printf ("service org.etalk on session bus created correctly\n");
	} catch (IOError e) {
		stderr.printf ("Could not create service org.etalk on session bus: %s\n", e.message);
	}*/

}


int main(string[] args) {

	Elm.init(args);
	stdout.printf("Etalk started!\n");
		
	/* create a glib mainloop */
    gmain = new GLib.MainLoop( null, false );

    /* integrate glib mainloop into ecore mainloop */
    if ( Ecore.MainLoop.glib_integrate() )
    {
        message( "glib mainloop integration successfully completed" );
    }
    else
    {
        warning( "could not integrate glib mainloop. did you compile glib mainloop support into ecore?" );
    }
    
    
#if _FSO_
    /* Get Bluetooth resource if fso is running */
    try {
			stderr.printf ("Requesting \"CPU\" resource to org.freesmartphone.ousaged...\n");
			fso = Bus.get_proxy_sync (BusType.SYSTEM, "org.freesmartphone.ousaged", "/org/freesmartphone/Usage");
			fso.request_resource("CPU");
		} catch (IOError e) {
			stderr.printf ("ERR: Could not get access to org.freesmartphone.ousaged: %s\n", e.message);
		}
#endif

   Bus.own_name (BusType.SESSION, ETALK_SERVICE_NAME, BusNameOwnerFlags.NONE,
			  on_bus_session_acquired,
			  () => stderr.printf ("Session Bus name acquired\n"),
			  () => stderr.printf ("Could not acquire session bus name\n"));


	/* Start ui */
	ui = new EtalkUI();
	ui.create();

	etalk_init();

	/* ENTER MAIN LOOP */
    Elm.run();
    Elm.shutdown();
    
    
#if _FSO_    
	try {
		stderr.printf ("Releasing \"CPU\" resource...\n");
		fso.release_resource("CPU");
	} catch (IOError e) {
		stderr.printf ("Could not get access to org.freesmartphone.ousaged: %s\n", e.message);
	}
#endif   
    
    return 0;

}

/*
public const string PROP_CHANNEL_CHANNEL_TYPE = "org.freedesktop.Telepathy.Channel.ChannelType";
public const string PROP_CHANNEL_TARGET_HANDLE_TYPE = "org.freedesktop.Telepathy.Channel.TargetHandleType";
public const string PROP_CHANNEL_TARGET_ID = "org.freedesktop.Telepathy.Channel.TargetID";
public const string IFACE_CHANNEL_TYPE_CONTACT_LIST = "org.freedesktop.Telepathy.Channel.Type.ContactList";
public const uint TP_HANDLE_TYPE_LIST = 3;

public async void playground() {
	AccountManager acm;
	try {
		acm = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.Telepathy.AccountManager", "/org/freedesktop/Telepathy/AccountManager");

		foreach(var acco in acm.valid_accounts) {
			stderr.printf("account:-->"+acco.to_string()+"\n");
			
			Account acc = null;
			
			try {
				acc = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.Telepathy.AccountManager", acco);
				
				stderr.printf("\tname: %s\t\tconnection: %s\n", acc.display_name, acc.connection);
				
			} catch (IOError errr) {
				stderr.printf("ERR: Could not get account with path %s: %s\n", acco.to_string(), errr.message);
			}
			
			var presence = Simple_Presence();
			presence.type = ConnectionPresenceType.AWAY;
			presence.status="";
			presence.status_message="";
			acc.requested_presence = presence;
			
			
			Connection conn = null;
			
			try {
				conn = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.Telepathy.ConnectionManager.gabble", acc.connection);
			
			} catch (IOError errk) {
				stderr.printf("ERR: Could not get connection with path %s: %s\n", acc.connection.to_string(), errk.message);
			}
			
			if(acc.connection.to_string()=="/") continue;
			
			foreach(var iface in conn.interfaces_) {
				stderr.printf("\t\tconn.interface: %s\n", iface);
			}
			
			
			
			ConnectionInterfaceRequests cir = null;
			
			try {	
				cir = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.Telepathy.ConnectionManager.gabble", acc.connection.to_string());
			} catch (IOError erq) {
				stderr.printf("ERR: Could not get ConnectionInterfaceRequests with path %s: %s\n", acc.connection.to_string(), erq.message);
				continue;
			}
			
			HashTable<string, GLib.Variant> params = new HashTable<string, GLib.Variant>(null, null);
			params.insert(PROP_CHANNEL_CHANNEL_TYPE, IFACE_CHANNEL_TYPE_CONTACT_LIST);
			params.insert(PROP_CHANNEL_TARGET_HANDLE_TYPE, TP_HANDLE_TYPE_LIST);
			//params.insert(PROP_CHANNEL_TARGET_ID, "stored");
			params.insert(PROP_CHANNEL_TARGET_ID, "subscribe");
			bool yours;
			GLib.ObjectPath channel;
			HashTable<string, GLib.Variant> properties;
			
			try {
				cir.ensure_channel(params, out yours, out channel, out properties);
			} catch (Error erp) {
				stderr.printf("ERR: EnsureChannel(): %s\n", erp.message);
				continue;
			} 
			
			stderr.printf("\t\t\tchannel: %s\n", channel);
			
			ChannelInterfaceGroup chg = null;
			try {	
				chg = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.Telepathy.ConnectionManager.gabble", channel);
			} catch (IOError era) {
				stderr.printf("ERR: Could not get ChannelGroup with path %s: %s\n", channel, era.message);
				continue;
			}
			
			//here we use chg.members:
			ConnectionInterfaceContactInfo ci = null;
			try {	
				ci = Bus.get_proxy_sync (BusType.SESSION, "org.freedesktop.Telepathy.ConnectionManager.gabble", acc.connection.to_string());
			} catch (IOError erd) {
				stderr.printf("ERR: Could not get ContactInfo with path %s: %s\n", acc.connection.to_string(), erd.message);
				continue;
			}
			
			foreach(var member in chg.members) {
					stderr.printf("\t\t\t\tmember: %u\n", member);
					
					ContactInfo[] cc = null;
					try { 
						cc = ci.request_contact_info(member);
					}  catch (IOError ek) {
						stderr.printf("ERR: RequestContactInfo(): %s\n", ek.message);
						continue;
					}
					foreach (var contact_info in cc) {
						stderr.printf("\t\t\t\t\tinfo: %s\n", contact_info.field_name);
						foreach	(var val in contact_info.field_value) {
								stderr.printf("\t\t\t\t\t\tvalue: %s\n", val);
						}
					}
			}
			
		}	

	} catch (IOError err) {
		stderr.printf("ERR: Could not get acm with path %s: %s\n", "/org/freedesktop/Telepathy/AccountManager", err.message);
	}

}
*/
/*
public async void playground2() {
	DBusDaemon bus_daemon;
	try {
		bus_daemon = DBusDaemon.dup();
	} catch (GLib.Error eone) {
		stderr.printf ("ERR: TelepathyGLib.dup(): %s\n", eone.message);	
	}
	AccountManager acm;
	
	try {
		acm = AccountManager.dup();
	} catch (GLib.Error etwo) {
		stderr.printf ("ERR: AccountManager.dup(): %s\n", etwo.message);	
	}
	try {
		yield acm.prepare_async(null);
	} catch (GLib.Error ethree) {
		stderr.printf ("ERR: AccountManager.prepare_async(): %s\n", ethree.message);
	}
	
	
	List<weak Account> accounts = acm.get_valid_accounts();
	
	foreach (var acc in accounts) {
		stderr.printf(acc.get_protocol()+"-->"+acc.get_display_name()+"\n");
		
		if(!acc.is_enabled()) {
			stderr.printf("This account is not enabled!\n");
			continue;
		}
		
		yield acc.request_presence_async(ConnectionPresenceType.HIDDEN, null, null);
		
		Connection conn = acc.get_connection();
		
		stderr.printf("\tprotocol: %s\n", conn.get_protocol_name ());
		//foreach(string iface in conn.interfaces) {
		//	stderr.printf("\t\t"+iface+"\n");
		//}



		GLib.HashTable<string, GLib.Value?> params = new GLib.HashTable<string, GLib.Value?>(null, null);
		params.insert(PROP_CHANNEL_CHANNEL_TYPE, IFACE_CHANNEL_TYPE_CONTACT_LIST);
		GLib.Value value = GLib.Value(typeof(int));
		value.set_int(HandleType.LIST);
		params.insert(PROP_CHANNEL_TARGET_HANDLE_TYPE,value);
		params.insert(PROP_CHANNEL_TARGET_ID, "stored");
		HandleChannelsContext context = null;
		AccountChannelRequest request = new AccountChannelRequest(acc, params, -1);
							
		request.ensure_and_handle_channel_async.begin(null, (obj, result) =>{
			Channel ch = request.ensure_and_handle_channel_async.end(result, out context);
			
			ch.prepare_async.begin(null, (obj, result) => {
				ch.prepare_async.end(result);
				stdout.printf("Channel name: %s\n", ch.get_identifier());
				Intset contacts = ch.group_get_members();
				stdout.printf("Contact count: %d\n", (int)contacts.size());
								
				contacts.@foreach( (i, user_data) => {
					stdout.printf("Element index: %d data: %s\n", (int)i, (string)user_data);
				}, null);						
									
			});
		});




	}
}*/
