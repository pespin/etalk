namespace Et {


	public class SessionManager : GLib.Object {
		
		
		private HashTable<string,ChannelMessages> sessions;
		
		public SessionManager() {
			logger.info("SessionManager", "Creating new SessionManager");
			sessions = new HashTable<string,ChannelMessages>(str_hash, str_equal);
		}

		
		public void add_session(owned ChannelMessages session) {
				sessions.insert(session.path, (owned) session);
				ui.refresh_page_with_id(PageID.LIST_SESSION);
		}

		public void remove_session(string path) {
				sessions.remove(path);
				ui.refresh_page_with_id(PageID.LIST_SESSION);
		}
		
		//returns null if not exists , otherwise the contact reference if exists
		public unowned ChannelMessages? has_session(string path) {
			return sessions.lookup(path);
		}
		
		public List<unowned ChannelMessages> get_sessions() {
				return sessions.get_values();
		}
		
		public void show_sessions(ListSessionUI sui) {
				
				HashTableIter<string,ChannelMessages> it = HashTableIter<string,ChannelMessages>(sessions);
				unowned string? key;
				unowned ChannelMessages? val;
				while(it.next(out key, out val)) {
					sui.add_elem_to_ui(val);
				}
			
		}

	}


}
