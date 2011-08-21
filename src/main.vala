

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


void bus_session_name_error() {
	stderr.printf ("Could not acquire session bus name\n");
	Elm.shutdown();
	Process.exit(0);
}

void on_bus_session_acquired (DBusConnection conn) {
	
	SESCONN = conn;
	CH = new Et.ClientHandler();
	CH.register();
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
    /* Get CPU resource if fso is running */
    try {
			stderr.printf ("Requesting \"CPU\" resource to org.freesmartphone.ousaged...\n");
			fso = Bus.get_proxy_sync (BusType.SYSTEM, "org.freesmartphone.ousaged", "/org/freesmartphone/Usage");
			fso.request_resource("CPU");
		} catch (IOError e) {
			stderr.printf ("ERR: Could not get access to org.freesmartphone.ousaged: %s\n", e.message);
		}
#endif

   Bus.own_name (BusType.SESSION, ETALK_CLIENT_SERVICE_NAME, BusNameOwnerFlags.NONE,
			  on_bus_session_acquired,
			  () => stderr.printf ("Session Bus name acquired\n"),
			  bus_session_name_error);


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

