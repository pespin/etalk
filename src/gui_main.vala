public class MainUI : Page {
		
		private unowned Elm.Win win;

		private unowned Elm.Genlist? li;
		private Elm.GenlistItemClass itc;
		
		private unowned Elm.Box? hbox1;
		private unowned Elm.Button? bt_settings;
		private unowned Elm.Button? bt_accounts;
		private unowned Elm.Button? bt_sessions;

		public HashTable<string,ListItemHandlerContact> elem_ui_list; 
		
		public MainUI() {
			base();
			elem_ui_list = new HashTable<string,ListItemHandlerContact>(str_hash, str_equal);

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
		vbox.show();

		//add list
		li = Elm.Genlist.add(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		li.no_select_mode_set(false);
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
		
		CM.contact_added.connect(add_elem_to_ui);
		CM.contact_removed.connect(remove_elem_from_ui);
		
		return vbox;
	}
	
	public void add_elem_to_ui(Et.Contact contact) {
		
		//TODO: have to look into this, the logic doesn't seem right: (storing+showing content)
		if(elem_ui_list.lookup(contact.get_unique_key())==null && 
			(SETM.show_offline_contacts || contact.is_online()) ) {
			
			logger.debug("MainUI", "Adding element " + contact.id + " [" + contact.handle.to_string() + "] to ui-list");
			var opener = new ListItemHandlerContact(win, this, contact);
			opener.item = li.item_sorted_insert(ref itc, opener, null, Elm.GenlistItemFlags.NONE, genlist_compare, opener.go);
				
			elem_ui_list.insert(contact.get_unique_key(), (owned) opener);
		
		}
	}

	public void remove_elem_from_ui(string key) {

		logger.debug("MainUI", "Removing elem " + key + " from ui-list");
		
		unowned ListItemHandlerContact? elem = elem_ui_list.lookup(key);
		if(elem!=null) {
			elem.item.del();
			elem_ui_list.remove(key);
		}
	}
	
	
	public void populate_list() {
		li.clear();
		elem_ui_list = new HashTable<string,ListItemHandlerContact>(str_hash, str_equal);
		ACM.fetch_contacts();
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

	
	public override unowned Elm.Button? get_button_next() { return null; }
	
	public override string? get_page_title() {
		return "Contact List"; 
	}
	
	
		/* Genlist stuff */

	private static string genlist_get_text(void *data, Elm.Object obj, string part ) {
		logger.debug("MainUI", "HEY!!!! LABEL CALLED!");
		ListItemHandlerContact handler = (ListItemHandlerContact) data;
		return handler.format_item_label();
	}


	private static unowned Elm.Object? genlist_get_content(void *data, Elm.Object obj, string part ) {
		logger.debug("MainUI", "content function called!");
		ListItemHandlerContact handler = (ListItemHandlerContact) data;
		return null;
	}

	private static bool genlist_get_state(void *data, Elm.Object obj, string part ) {
		//logger.debug("MainUI", "state function called!");
		return false;
	}

	private static void genlist_del_item(void *data, Elm.Object obj ) {
		logger.debug("MainUI", "DELETE function called!");
	}

	private static int genlist_compare(void* data1, void* data2) {
		ListItemHandlerContact handler1 = (ListItemHandlerContact) data1;
		ListItemHandlerContact handler2 = (ListItemHandlerContact) data2;
		//logger.debug("MainUI", handler1.contact.alias + " < " + handler2.contact.alias + " ? " + handler1.contact.alias.ascii_casecmp(handler2.contact.alias).to_string());
		return handler1.contact.alias.ascii_casecmp(handler2.contact.alias);
	}

}


public class ListItemHandlerContact : ListItemHandler {
	
	public MainUI mainui;
	public Et.Contact contact;
	
	public ListItemHandlerContact(Elm.Win win, MainUI mainui, Et.Contact contact) {
		base(win);
		this.mainui = mainui;
		this.contact = contact;
		
		contact.notify.connect(sig_property_changed);
	}
	
	
	public new void go () { 
		logger.debug("ListItemHandlerContact", "pressed... HANDLE=" + this.contact.handle.to_string() + "\t ID="+this.contact.id); 
		base.go(); 
	}
	
	public override string format_item_label() {
		return "[" + contact.presence.status + "] " + contact.alias;
	}

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
				this.refresh_content();
				break;
		
			default:
				logger.warning("ListItemHandlerContact", "property "+p.name+" changed but no action was done");
				break;
		}
		
	}
	
	
	private void presence_changed() {
		logger.debug("ListItemHandlerContact", "sig_presence_changed() called");
		//item.label_set(this.format_item_label());
		if(SETM.show_offline_contacts==false && contact.is_online()==false) {
			ui.mui.remove_elem_from_ui(contact.get_unique_key());
			//ui.mui.refresh_list(); //FIXME: necessary?
		} else {
			this.refresh_content();
		}
	}
	
}
