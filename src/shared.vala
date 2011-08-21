/*
 * 
 * Global variables:
 *
 */
public GLib.MainLoop gmain;
public Et.AccountManager ACM;
//public Telepathy.ConnectionManager CNM;
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
/*const string ETALK_BLUEZ_AGENT_IFACE = "org.bluez.Agent";
const string ETALK_OBEX_AGENT_PATH = "/org/etalk/openobex/agent";
const string ETALK_OBEX_AGENT_IFACE = "org.openobex.Agent";
*/
extern const string IMAGESDIR;


//Pager:
const string PAGE_SID_SETTINGS	= "settings";
const string PAGE_SID_MAIN		= "main";
/*const string PAGE_SID_KNOWN		= "known"; */





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
