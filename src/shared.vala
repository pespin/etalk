/*
 * 
 * Global variables:
 *
 */
public GLib.MainLoop gmain;
public Et.Logger logger;
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

namespace Et {
	public enum LogLevel {
			SILENT,
			ERROR,
			INFO,
			DEBUG
	}


	public class Logger : GLib.Object {
		public LogLevel level { get; set; default=LogLevel.DEBUG; }
		
		
		public Logger() {
			string? loglevel = Environment.get_variable("ET_LOG_LEVEL");
			if(loglevel!=null) {
				uint ulevel = int.parse(loglevel);
				if( LogLevel.SILENT <= ulevel <= LogLevel.DEBUG )
					this.level = (LogLevel) ulevel;
			}
			
		}

		public void error(string area, string message) {
			if(this.level >= LogLevel.ERROR)
				stderr.printf("ERROR[%s]: %s\n", area, message);
		}
		
		public void info(string area, string message) {
			if(this.level >= LogLevel.INFO)
				stderr.printf("INFO[%s]: %s\n", area, message);
		}
		
		public void debug(string area, string message) {
			if(this.level >= LogLevel.DEBUG)
				stderr.printf("DEBUG[%s]: %s\n", area, message);
		}
	}
}
