/*
 * 
 * Global variables:
 *
 */
public GLib.MainLoop gmain;
public Et.Logger logger;
public Et.SettingsManager SETM;
public Et.AccountManager ACM;
public Et.SessionManager SM;
public Et.ContactManager CM;
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
	SETTINGS_MAIN,
	LIST_ACCOUNT,
	SETTINGS_ACCOUNT,
	NEW_ACCOUNT,
	SESSION,
	LIST_SESSION
}

namespace Et {
	public enum LogLevel {
			SILENT,
			ERROR,
			WARNING,
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

		public void warning(string area, string message) {
			if(this.level >= LogLevel.WARNING)
				stderr.printf("WARN[%s]: %s\n", area, message);
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

	public class SettingsManager : GLib.Object {
		
		private GLib.KeyFile keyfile;
		
		private string filename;
		private const string group_name = "etalk";
		
		public bool show_offline_contacts { get; set; default=false; }
		public bool set_offline_on_close { get; set; default=true; }
		
		public SettingsManager() {
			keyfile=null;
			string? configpath = Environment.get_variable("XDG_CONFIG_HOME");
			if(configpath==null) {
				logger.error("SettingsManager", "XDG_CONFIG_HOME and HOME env var are not defined! Using default settings");
				return;
			}
			var path = GLib.Path.build_filename(configpath, Config.PACKAGE);

			GLib.DirUtils.create_with_parents(path, (int)Posix.S_IRUSR|Posix.S_IWUSR|Posix.S_IXUSR|Posix.S_IRGRP|Posix.S_IXGRP|Posix.S_IROTH|Posix.S_IXOTH);
			
			filename = GLib.Path.build_filename(path, Config.PACKAGE+".conf");
			
			logger.info("SettingsManager", "Loading settings from file "+filename);
			keyfile = new GLib.KeyFile();
			try {
				keyfile.load_from_file(filename, GLib.KeyFileFlags.NONE);
			} catch ( Error err ) {
				logger.error("SettingsManager", "Could not load settings file: "+err.message);
				return;
			}
			
			try {
				show_offline_contacts = keyfile.get_boolean(group_name, "show_offline_contacts");
			} catch (Error err) {
				logger.error("SettingsManager", "Could not load option \"show_offline_contacts\": "+err.message);	
			}
			
			try {
				set_offline_on_close = keyfile.get_boolean(group_name, "set_offline_on_close");
			} catch (Error err) {
				logger.error("SettingsManager", "Could not load option \"show_offline_contacts\": "+err.message);	
			}
			
		}
	
	
		~SettingsManager() {
				
			this.save_current_settings();
			
		}
	
		
		public void save_current_settings()  {
				logger.info("SettingsManager", "Saving current settings to "+filename);
				if(keyfile==null) {
					logger.error("SettingsManager", "Not saving current settings because KeyFile is null!");
					return;
				}
				
				keyfile.set_boolean(group_name, "show_offline_contacts", show_offline_contacts);
				keyfile.set_boolean(group_name, "set_offline_on_close", set_offline_on_close);
				
				var str = keyfile.to_data (null);
                
                try {
                        FileUtils.set_contents (filename, str, str.length);
                } catch (FileError err) {
                        logger.error("SettingsManager", "Error trying to write changes to config file: "+err.message);
                }
		}
	
	
	}
	
	
}
