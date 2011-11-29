namespace Et {


	public class SessionManager : GLib.Object {
		
		
		private HashTable<string,ChannelMessages> sessions;
		
		public SessionManager() {
			logger.info("SessionManager", "Creating new SessionManager");
			sessions = new HashTable<string,ChannelMessages>(str_hash, str_equal);
		}

		
		public void add_session(ChannelMessages session) {
				logger.debug("SessionManager", "Adding session "+session.path+" to list of sessions");
				sessions.insert(session.path, session);
				this.session_added(session.path);
		}

		public void remove_session(string path) {
				logger.debug("SessionManager", "Removing session "+path+" from list of sessions");
				sessions.remove(path);
				this.session_removed(path);
		}
		
		//returns null if not exists , otherwise the contact reference if exists
		public unowned ChannelMessages? get_session_by_path(string path) {
			return sessions.lookup(path);
		}
		
		
		public List<weak ChannelMessages> get_sessions() {
				logger.debug("SessionManager", "UI requested to show sessions...");
				
				return sessions.get_values();
		}
		
		public signal void session_added(string path);
		public signal void session_removed(string path);

	}


}
