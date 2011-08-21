/*
 * 
 * Global variables:
 *
 */
public GLib.MainLoop gmain;
public Et.AccountManager ACM;
//public Telepathy.ConnectionManager CNM;
public Et.ClientHandler CH;
public EtalkUI ui;

DBusConnection SESCONN;

public Evas.Coord DISPLAY_WIDTH = 320;
public Evas.Coord DISPLAY_HEIGHT = 400;


#if _FSO_   
public FSOusaged fso;
#endif


/*
 * 
 * CONSTANTS/DEFINES:
 *
 */
 
const string ETALK_CLIENT_SERVICE_NAME = "org.freedesktop.Telepathy.Client.Etalk";
const string ETALK_CLIENT_AGENT_PATH = "/org/freedesktop/Telepathy/Client/Etalk";
const string TELEPATHY_CLIENT_INTERFACE = "org.freedesktop.Telepathy.Client";

extern const string IMAGESDIR;


public enum PageID {
	MAIN,
	LIST_ACCOUNT,
	SETTINGS_ACCOUNT,
	NEW_ACCOUNT
}




/*
 * 
 * MISC FUNCS
 * 
 * 
 */

public string[]? get_dbus_array(Variant? bar) {
	//stdout.printf("CREATING GLIST FROM DBUS...\n"); 
	if(bar==null || bar.is_container()==false) return null;
	
	string[] list;

	size_t max = bar.n_children();
	list = new string[max];
	
	for(size_t i=0; i<max; i++) {
		var item = (string) bar.get_child_value(i);
				list[i] = item;
				stdout.printf("ListAdded: %s;\n",(string) item);
	}
	
	return list;
	
}


public string? variant_to_string(Variant? v) {
	if(v!=null && ( v.is_of_type(VariantType.OBJECT_PATH) || v.is_of_type(VariantType.STRING) || v.is_of_type(VariantType.SIGNATURE)) )
		return v.print(true);
	return null;
	
}
