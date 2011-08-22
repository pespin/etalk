

async void etalk_init() {
	
		/* INITIALIZE GLOBALS */
	
		ACM = new Et.AccountManager();
	
		/*foreach(var acc_path in ACM.accounts.get_keys()) {
		
			stderr.printf("init: %s\n", acc_path);
			
		} */
	
}


void bus_session_name_error() {
	logger.error("DBus", "Could not acquire session bus name\n");
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
    
    /* start logger */
	logger = new Et.Logger();
    
#if _FSO_
    /* Get CPU resource if fso is running */
    try {
			logger.info("FSO", "Requesting \"CPU\" resource to org.freesmartphone.ousaged...\n");
			fso = Bus.get_proxy_sync (BusType.SYSTEM, "org.freesmartphone.ousaged", "/org/freesmartphone/Usage");
			fso.request_resource("CPU");
		} catch (IOError e) {
			logger.error("FSO", "Could not get access to org.freesmartphone.ousaged: "+e.message);
		}
#endif

   Bus.own_name (BusType.SESSION, ETALK_CLIENT_SERVICE_NAME, BusNameOwnerFlags.NONE,
			  on_bus_session_acquired,
			  () => logger.info("DBus", "Session Bus name acquired"),
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
		logger.info("FSO", "Releasing \"CPU\" resource...\n");
		fso.release_resource("CPU");
	} catch (IOError e) {
		logger.error("FSO", "Could not get access to org.freesmartphone.ousaged: "+e.message);
	}
#endif   
    
    return 0;

}

