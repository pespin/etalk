namespace Et {

	public class ContactManager : GLib.Object {
		
		public HashTable<string,Contact> hash;
		
		public ContactManager() {
			
			hash = new HashTable<string,Contact>(str_hash, str_equal);
			
		}
		
		
		public void add_contacts(Connection conn, uint[] handles, HashTable<uint, HashTable<string, Variant> > properties) {
			foreach(var handle in handles) {
					
					unowned HashTable<string,Variant> hash_info_one = properties.lookup(handle);
					unowned Contact c = this.get_contact(conn, handle);
					
					if(hash_info_one==null) continue;
					
					c.update_properties(hash_info_one);
					//ui.mui.add_elem_to_ui(c);
					this.contact_added(c);
				}
			
		}
		
		
		public void remove_all_contacts(string conn_path) {
				HashTableIter<string,Contact> it = HashTableIter<string,Contact>(hash);
				unowned string? key;
				unowned Contact? c;
				string[] key_container = { };
				while(it.next(out key, out c)) {
					if(key.has_prefix(conn_path)) {
						key_container+=key;
					 }
				}
				
				foreach(var k in key_container) {
					ui.mui.remove_elem_from_ui(k);
					hash.remove(k);
				}

		}
		
		public void remove_contacts(Connection conn, uint[] handles) {
			foreach(var handle in handles) {
					remove_contact(conn, handle);
			}
		}		
				//returns null if not exists , otherwise the contact reference if exists
		public unowned Contact? has_contact(Connection conn, uint handle) {
			return hash.lookup(Contact.get_unique_key_ext(conn, handle));
		}
		
		
		//if not exists, creates a new one and returns its reference
		public unowned Contact? get_contact(Connection conn, uint handle) {
			unowned Contact? c = this.has_contact(conn, handle);
			
			if(c!=null) return c;
			
			Contact cnew = new Contact(conn, handle);	
			this.add_contact(cnew);
			return hash.lookup(cnew.get_unique_key());
			
		}
		public void presences_changed(Connection conn, HashTable<uint,Telepathy.Simple_Presence?> presence) {
			
			HashTableIter<uint,Telepathy.Simple_Presence?> it = HashTableIter<uint,Telepathy.Simple_Presence?>(presence);
				unowned uint handle;
				unowned Telepathy.Simple_Presence? pres;
				while(it.next(out handle, out pres)) {
					if(pres==null) continue;
					unowned Contact? c = this.get_contact(conn, handle);
					if(c==null) continue;
					if(c.is_online()==false) { //if contact has become online...
						c.presence = pres;
						ui.mui.add_elem_to_ui(c);
					} else {
						c.presence = pres;
					}
					//TODO: if contact was created, update its properties?
				}
		}
		
		private void add_contact(owned Contact c) {
				this.hash.insert(c.get_unique_key(), (owned) c);
		}
		
		private void remove_contact(Connection conn, uint handle) {
			string key = Contact.get_unique_key_ext(conn,handle);
			unowned Contact? contact = hash.lookup(key);
					if(contact!=null) hash.remove(key);
					this.contact_removed(key);
		}
		
		
		public signal void contact_added(Contact c);
		public signal void contact_removed(string key);

	}


}
