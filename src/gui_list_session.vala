public class ListSessionUI : Page {
	
		private unowned Elm.Win win;
	
		public Elm.List li;
		
		public HashTable<string,ListItemHandlerSession> elem_ui_list; 

		
		public ListSessionUI() {
				base();
				elem_ui_list = new HashTable<string,ListItemHandlerSession>(str_hash, str_equal);
		}
		

	public unowned Elm.Object create(Elm.Win win) {
		
		this.win = win;
		
		//add vbox
		vbox = new Elm.Box(win);
		vbox.size_hint_weight_set( 1.0, 1.0 );
		//vbox.show();

		//add list
		li = new Elm.List(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		vbox.pack_end(li);
		li.show();
	
		this.populate_list();
		
		SM.session_added.connect(sig_session_added);
		SM.session_removed.connect(sig_session_removed);
	
		return vbox;
	}
	
	
	private void populate_list() {
			elem_ui_list = new HashTable<string,ListItemHandlerSession>(str_hash, str_equal);
			SM.show_sessions(this);
	}
	
	public void add_elem_to_ui(Et.ChannelMessages elem) {
		
		
		logger.debug("ListSessionUI", "Adding element " + elem.path + " to ui-list");
		
		//Little hack to not hang the UI while adding lots of stuff... :P
		Ecore.MainLoop.iterate();
		
		var opener = new ListItemHandlerSession(win, elem);
		opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
		elem_ui_list.insert(elem.path, (owned) opener);
		this.li.go();
	}

	public void remove_elem_from_ui(string path) {

		logger.debug("ListSessionUI", "Removing elem " + path + " from ui-list");
		//Little hack to not hang the UI while removing lots of stuff... :P
		Ecore.MainLoop.iterate();
		elem_ui_list.remove(path);
		this.li.go();
	}
	
	
	private void sig_session_added(string path) {
		unowned Et.ChannelMessages? session = SM.get_session(path);
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

	public override PageID get_page_id() {
		return PageID.LIST_SESSION;
	}
	
	public override string? get_page_title() {
		return "Sessions List"; 
	}
	
	public async override void refresh_content() {
		logger.debug("ListSessionUI", "refresh_content() called");			
		this.populate_list();
		
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
		//this.icon = gen_icon(rdevice.icon+"-"+(rdevice.online ? "online" : "offline") );
	}
	
	
	public new void go () { 
		logger.debug("ListItemHandlerSession", "pressed... path=" + this.elem.path); 
		base.go(); 
	}
	
	public override void refresh_content() {
		/*item.label_set(format_item_label(rdevice));
		icon = gen_icon(rdevice.online ? "online" : "offline" );
		item.icon_set(icon);*/
	}
	
	public override string format_item_label() {
		return "[" + elem.dbus.target_handle.to_string() + "] "+elem.dbus.target_id;
	}
	/*
	private static Elm.Icon gen_icon(string name) {
		
		var ic = new Elm.Icon(win);
		ic.file_set(Path.build_filename(IMAGESDIR,name+".png"));
		ic.scale_set(true, true);
		ic.fill_outside_set(true);
		ic.show();
		return ic;
	}
*/
	protected override void open_rdevice_page() {
		
		//if true, this means probably that elem.ref_count==0
		if(this.elem==null) { 
			logger.error("ListItemHandlerSession", "elem is null!!!");
			return;
		}
		
		logger.debug("ListItemHandlerSession", "Opening win for elem "+elem.path+"...");

		ui.push_page(gui);

	}
}
