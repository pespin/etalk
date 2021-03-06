public class ListSessionUI : Page {
		private static const string DOMAIN = "ListSessionUI"; 
	
		private unowned Elm.Win win;

		private Elm.GenlistItemClass itc;
		private unowned Elm.Genlist? li;
		
		public HashTable<string,ListItemHandlerSession> elem_ui_list; 

		
		public ListSessionUI() {
			base();
			elem_ui_list = new HashTable<string,ListItemHandlerSession>(str_hash, str_equal);
		
			itc = new Elm.GenlistItemClass();
			itc.item_style = "default";
			itc.func.text_get = genlist_get_text;
			itc.func.content_get = genlist_get_content;
			itc.func.state_get = genlist_get_state;
			itc.func.del = genlist_del_item;
		}
		

	public unowned Elm.Object create(Elm.Win win) {
		
		this.win = win;
		
		//add vbox
		vbox = Elm.Box.add(win);
		vbox.size_hint_weight_set( 1.0, 1.0 );

		//add list
		li = Elm.Genlist.add(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		//li.no_select_mode_set(false);
		vbox.pack_end(li);
		li.show();
	
		this.populate_list();
		
		SM.session_added.connect(sig_session_added);
		SM.session_removed.connect(sig_session_removed);
	
		return vbox;
	}
	
	
	private void populate_list() {
			li.clear();
			elem_ui_list = new HashTable<string,ListItemHandlerSession>(str_hash, str_equal);
			List<weak Et.ChannelMessages> list = SM.get_sessions();
			foreach(var elem in list) {
				add_elem_to_ui(elem);
			}
	}
	
	public void add_elem_to_ui(Et.ChannelMessages elem) {
		
		
		logger.debug(DOMAIN, "Adding element " + elem.path + " to ui-list");
		
		var opener = new ListItemHandlerSession(win, elem);
		opener.item = li.item_sorted_insert(itc, opener, null, Elm.GenlistItemType.NONE, genlist_compare, opener.go);

		elem_ui_list.insert(elem.path, (owned) opener);

	}

	public void remove_elem_from_ui(string path) {

		logger.debug(DOMAIN, "Removing elem " + path + " from ui-list");

		unowned ListItemHandlerSession? elem = elem_ui_list.lookup(path);
		if(elem!=null) {
			elem.item.del();
			elem_ui_list.remove(path);
		}

	}
	
	//returns true if the ui is already available, false if it can't
	public bool show_session_ui(Et.Contact contact) {
		unowned SessionUI? gui = get_session_ui_by_contact(contact);
		if(gui==null) return false;
		ui.push_page(gui);
		return true;
	}
	
	private unowned SessionUI? get_session_ui_by_contact(Et.Contact contact) {
				var it = HashTableIter<string,ListItemHandlerSession>(elem_ui_list);
				unowned string? key;
				unowned ListItemHandlerSession? val;
				while(it.next(out key, out val)) {
					uint thandle = val.elem.dbus.target_handle;
					if(thandle==0) { //unknown, lets compare using id
						if(val.elem.dbus.target_id==contact.id) return val.gui;
					} else if(val.elem.dbus.target_handle==contact.handle) return val.gui;
				}
			
			return null;
		}
	
	
	private void sig_session_added(string path) {
		unowned Et.ChannelMessages? session = SM.get_session_by_path(path);
		if(session==null) return;
		
		this.add_elem_to_ui(session);
		if(session.started_by_local_handle()) {
			unowned ListItemHandlerSession? item = elem_ui_list.lookup(path);
			ui.push_page(item.gui);
		}
	}
	
	private void sig_session_removed(string path) {
		this.remove_elem_from_ui(path);
	}
	
	public override string? get_page_title() {
		return "Sessions List"; 
	}
	
	public override unowned Elm.Button? get_button_next() { return null; }

	public override void on_appear() {
			logger.debug(DOMAIN, "page is visible!");
	}
	
	/* Genlist stuff */

	private static string genlist_get_text(void *data, Elm.Object obj, string part ) {
		logger.debug("SessionUI", "HEY!!!! LABEL CALLED!");
		ListItemHandlerSession handler = (ListItemHandlerSession) data;
		return handler.format_item_label();
	}


	private static unowned Elm.Object? genlist_get_content(void *data, Elm.Object obj, string part ) {
		logger.debug("SessionUI", "content function called!");
		ListItemHandlerSession handler = (ListItemHandlerSession) data;
		return null;
	}

	private static bool genlist_get_state(void *data, Elm.Object obj, string part ) {
		//logger.debug("SessionUI", "state function called!");
		return false;
	}

	private static void genlist_del_item(void *data, Elm.Object obj ) {
		logger.debug("SessionUI", "DELETE function called!");
	}
	
	private static int genlist_compare(void* data1, void* data2) {
		unowned Elm.GenlistItem? it1 = (Elm.GenlistItem?) data1;
        unowned Elm.GenlistItem? it2 = (Elm.GenlistItem?) data2;
		ListItemHandlerSession handler1 = (ListItemHandlerSession) it1.data_get();
		ListItemHandlerSession handler2 = (ListItemHandlerSession) it2.data_get();
		//logger.debug("MainUI", handler1.contact.alias + " < " + handler2.contact.alias + " ? " + handler1.contact.alias.ascii_casecmp(handler2.contact.alias).to_string());
		return handler1.elem.dbus.target_id.ascii_casecmp(handler2.elem.dbus.target_id);
	}


}



public class ListItemHandlerSession : ListItemHandler {
	
	public Et.ChannelMessages elem;
	public SessionUI gui;
	
	public ListItemHandlerSession(Elm.Win win, Et.ChannelMessages elem) {
		base(win);
		this.elem = elem;
		this.gui = new SessionUI(elem);
		gui.create(ui.win);
	}
	
	
	public new void go () { 
		logger.debug("ListItemHandlerSession", "pressed... path=" + this.elem.path); 
		base.go(); 
	}
	
	public override string format_item_label() {
		return "[" + elem.dbus.target_handle.to_string() + "] "+elem.dbus.target_id;
	}
	
	protected override void open_elem_page() {
		
		//if true, this means probably that elem.ref_count==0
		if(this.elem==null) { 
			logger.error("ListItemHandlerSession", "elem is null!!!");
			return;
		}
		
		logger.debug("ListItemHandlerSession", "Opening win for elem "+elem.path+"...");

		ui.push_page(gui);

	}
}
