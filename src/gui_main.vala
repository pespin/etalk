public class MainUI : Page {
		
		private unowned Elm.Win win;

		public unowned Elm.List? li;
		private unowned Elm.Box? hbox1;
		private unowned Elm.Button? bt_settings;
		private unowned Elm.Button? bt_accounts;
		private unowned Elm.Button? bt_sessions;

		public HashTable<string,ListItemHandlerContact> elem_ui_list; 
		
		public MainUI() {
				base();
				elem_ui_list = new HashTable<string,ListItemHandlerContact>(str_hash, str_equal);
		}
		

	public unowned Elm.Object create(Elm.Win win) {
		
		this.win = win;
		
		//add vbox
		vbox = Elm.Box.add(win);
		vbox.size_hint_weight_set( 1.0, 1.0 );
		vbox.show();

		//add list
		li = Elm.List.add(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		vbox.pack_end(li);
		li.show();
	
		//add button hbox1
		hbox1 = Elm.Box.add(win);
		hbox1.horizontal_set(true);	
		hbox1.size_hint_weight_set( 1.0, 0.0 );
		hbox1.size_hint_align_set( -1.0, 0.0 );
		vbox.pack_end(hbox1);
		hbox1.show();

		bt_settings = Elm.Button.add(win);
		bt_settings.text_set("Settings");
		bt_settings.size_hint_weight_set( 1.0, 1.0 );
		bt_settings.size_hint_align_set( -1.0, -1.0 );
		hbox1.pack_end(bt_settings);
		bt_settings.show();
		bt_settings.smart_callback_add( "clicked", cb_bt_settings_clicked );
	
		bt_accounts = Elm.Button.add(win);
		bt_accounts.text_set("Accounts");
		bt_accounts.size_hint_weight_set( 1.0, 1.0 );
		bt_accounts.size_hint_align_set( -1.0, -1.0 );
		hbox1.pack_end(bt_accounts);
		bt_accounts.show();
		bt_accounts.smart_callback_add( "clicked", cb_bt_accounts_clicked );
	
		bt_sessions = Elm.Button.add(win);
		bt_sessions.text_set("Sessions");
		bt_sessions.size_hint_weight_set( 1.0, 1.0 );
		bt_sessions.size_hint_align_set( -1.0, -1.0 );
		hbox1.pack_end(bt_sessions);
		bt_sessions.show();
		bt_sessions.smart_callback_add( "clicked", cb_bt_sessions_clicked );
		
		SETM.notify["show-offline-contacts"].connect((s, p) => {
									this.populate_list();
		});
	
		return vbox;
	}
	
	public void add_elem_to_ui(Et.Contact contact) {
		
		if(elem_ui_list.lookup(contact.get_unique_key())==null && 
			(SETM.show_offline_contacts || contact.is_online()) ) {
			
			logger.debug("MainUI", "Adding element " + contact.id + " [" + contact.handle.to_string() + "] to ui-list");
			var opener = new ListItemHandlerContact(win, contact);
			opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
			elem_ui_list.insert(contact.get_unique_key(), (owned) opener);
		
		}
	}

	public void remove_elem_from_ui(string key) {

		logger.debug("MainUI", "Removing elem " + key + " from ui-list");

		elem_ui_list.remove(key);
	}
	
	public void refresh_list() {
		this.li.go();
	}
	
	
	public void populate_list() {
		//li.clear();
		elem_ui_list = new HashTable<string,ListItemHandlerContact>(str_hash, str_equal);
		ACM.show_contacts();
	}

	private void cb_bt_settings_clicked() {
		logger.debug("MainUI", "Accounts button pressed.");
		
		var settingsui = new SettingsMainUI();
		settingsui.create(ui.win);
		ui.push_page(settingsui);
		
	}


	private void cb_bt_accounts_clicked() {
		logger.debug("MainUI", "Accounts button pressed.");
		
		var accounts_list = new ListAccountUI();
		accounts_list.create(ui.win);
		ui.push_page(accounts_list);
		
	}
	
	private void cb_bt_sessions_clicked() {
		logger.debug("MainUI", "Sessions button pressed.");

		ui.push_page(ui.sui);
		
	}
	

	public override PageID get_page_id() {
		return PageID.MAIN;
	}
	
	public override unowned Elm.Button? get_button_next() { return null; }
	
	public override string? get_page_title() {
		return "Contact List"; 
	}
	
	public async override void refresh_content() {

		HashTableIter<string,ListItemHandlerContact> it = HashTableIter<string,ListItemHandlerContact>(elem_ui_list);
		
		unowned string? key;
		unowned ListItemHandlerContact? handler;
		while(it.next(out key, out handler)) {
			handler.refresh_content();
		}
		
		li.go();
		
	}

}


public class ListItemHandlerContact : ListItemHandler {
	
	public Et.Contact contact;
	
	
	public ListItemHandlerContact(Elm.Win win, Et.Contact contact) {
		base(win);
		this.contact = contact;
		
		//contact.notify["presence"].connect(sig_presence_changed); 
		contact.notify.connect(sig_property_changed);
		//this.icon = gen_icon(rdevice.icon+"-"+(rdevice.online ? "online" : "offline") );
	}
	
	
	public new void go () { 
		logger.debug("ListItemHandlerContact", "pressed... HANDLE=" + this.contact.handle.to_string() + "\t ID="+this.contact.id); 
		base.go(); 
	}
	
	public override void refresh_content() {
		/*item.label_set(format_item_label(rdevice));
		icon = gen_icon(rdevice.online ? "online" : "offline" );
		item.icon_set(icon);*/
	}
	
	public override string format_item_label() {
		return "[" + contact.presence.status + "] " + contact.alias;
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
	protected override void open_elem_page() {
		
		//if true, this means probably that contact.ref_count==0
		if(this.contact==null) { 
			logger.error("ListItemHandlerContact", "contact is null!!!");
			return;
		}
		
		logger.debug("ListItemHandlerContact", "Opening win for contact "+contact.id+"...");
		if(ui.sui.show_session_ui(this.contact)==false)
			this.contact.start_conversation.begin();

	}
	
	private void sig_property_changed(ParamSpec p) {
		
		switch(p.name) {
			
			case "presence":
				presence_changed();
				break;
			
			case "alias":
				item.label_set(this.format_item_label());
				break;
		
			default:
				logger.warning("ListItemHandlerContact", "property "+p.name+" changed but no action was done");
				break;
		}
		
	}
	
	
	private void presence_changed() {
		logger.debug("ListItemHandlerContact", "sig_presence_changed() called");
		item.label_set(this.format_item_label());
		if(SETM.show_offline_contacts==false && contact.is_online()==false) {
			ui.mui.remove_elem_from_ui(contact.get_unique_key());
			ui.mui.refresh_list(); //FIXME: necessary?
		} else {
			item.label_set(this.format_item_label());
		}
	}
	
}
