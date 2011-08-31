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
				sessions.remove(path);
				this.session_removed(path);
		}
		
		//returns null if not exists , otherwise the contact reference if exists
		public unowned ChannelMessages? get_session(string path) {
			return sessions.lookup(path);
		}
		
		public List<unowned ChannelMessages> get_sessions() {
				return sessions.get_values();
		}
		
		public void show_sessions(ListSessionUI sui) {
				logger.debug("SessionManager", "UI requested to show sessions...");
				HashTableIter<string,ChannelMessages> it = HashTableIter<string,ChannelMessages>(sessions);
				unowned string? key;
				unowned ChannelMessages? val;
				while(it.next(out key, out val)) {
					logger.debug("SessionManager", "sending session to UI: "+key);
					sui.add_elem_to_ui(val);
				}
			
		}
		
		public signal void session_added(string path);
		public signal void session_removed(string path);

	}


}
