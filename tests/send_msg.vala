using org;
using freedesktop;
using Telepathy;


int main(string[] args) {

	Elm.init(args);
	stdout.printf("Etalk started!\n");
		
	/* create a glib mainloop */
    GLib.MainLoop gmain = new GLib.MainLoop( null, false );

    /* integrate glib mainloop into ecore mainloop */
    if ( Ecore.MainLoop.glib_integrate() )
    {
        message( "glib mainloop integration successfully completed" );
    }
    else
    {
        warning( "could not integrate glib mainloop. did you compile glib mainloop support into ecore?" );
    }

	playground();

	/* ENTER MAIN LOOP */
    Elm.run();
    Elm.shutdown();
    
    return 0;

}


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

