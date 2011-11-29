public class ListAccountUI : Page {
		
		private unowned Elm.Win win;

		private Elm.GenlistItemClass itc;
		private unowned Elm.Genlist? li;
		private unowned Elm.Box? hbox1;
		private unowned Elm.Button? bt_new;

		public HashTable<string,ListItemHandlerAccount> elem_ui_list; 
		
		public ListAccountUI() {
			base();
			elem_ui_list = new HashTable<string,ListItemHandlerAccount>(str_hash, str_equal);
	
			itc.item_style = "default";
			itc.func.label_get = genlist_get_label;
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

		bt_new = Elm.Button.add(win);
		bt_new.text_set("New Account");
		bt_new.size_hint_weight_set(1.0, 1.0);
		bt_new.size_hint_align_set(-1.0, -1.0);
		hbox1.pack_end(bt_new);
		bt_new.show();
		bt_new.smart_callback_add( "clicked", cb_bt_new_clicked);
	
		this.populate_list();
		
		ACM.account_updated.connect(add_elem_to_ui);
		ACM.account_removed.connect(remove_elem_from_ui);
	
		return vbox;
	}
	
	
	private void populate_list() {
			li.clear();
			elem_ui_list = new HashTable<string,ListItemHandlerAccount>(str_hash, str_equal);
			List<weak Et.Account> list = ACM.get_accounts();
			foreach(var elem in list) {
				add_elem_to_ui(elem);
			}
	}
	
	public void add_elem_to_ui(Et.Account account) {
		
		
		logger.debug("ListAccountUI", "Adding element " + account.path + " to ui-list");
		
		//Little hack to not hang the UI while adding lots of stuff... :P
		Ecore.MainLoop.iterate();
		
		var opener = new ListItemHandlerAccount(win, account);
		//opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
		opener.item = li.item_append(ref itc, opener, null, Elm.GenlistItemFlags.NONE, opener.go);
				
		elem_ui_list.insert(account.path, (owned) opener);
	}

	public void remove_elem_from_ui(string path) {

		logger.debug("ListAccountUI", "Removing elem " + path + " from ui-list");
		//Little hack to not hang the UI while removing lots of stuff... :P
		Ecore.MainLoop.iterate();
		unowned ListItemHandlerAccount? elem = elem_ui_list.lookup(path);
		if(elem!=null) {
			elem.item.del();
			elem_ui_list.remove(path);
		}

	}
	

	public override PageID get_page_id() {
		return PageID.LIST_ACCOUNT;
	}
	
	public override string? get_page_title() {
		return "Accounts List"; 
	}
	
	public override unowned Elm.Button? get_button_next() { return null; }
	
	public async override void refresh_content() {
			
		//this.populate_list();
		
	}
	
	/* CALLBACKS */
	
	
	private void cb_bt_new_clicked() {
		logger.debug("ListAccountUI", "New Account button pressed.");
		
		var accui = new NewAccountUI();
		accui.create(ui.win);
		ui.push_page(accui);
		
	}
	
	/* Genlist stuff */

	private static string genlist_get_label(void *data, Elm.Object obj, string part ) {
		logger.debug("AccountUI", "HEY!!!! LABEL CALLED!");
		ListItemHandlerAccount handler = (ListItemHandlerAccount) data;
		return handler.format_item_label();
	}


	private static unowned Elm.Object? genlist_get_content(void *data, Elm.Object obj, string part ) {
		logger.debug("AccountUI", "content function called!");
		ListItemHandlerAccount handler = (ListItemHandlerAccount) data;
		return null;
	}

	private static bool genlist_get_state(void *data, Elm.Object obj, string part ) {
		//logger.debug("AccountUI", "state function called!");
		return false;
	}

	private static void genlist_del_item(void *data, Elm.Object obj ) {
		logger.debug("AccountUI", "DELETE function called!");
	}
	
	
}



public class ListItemHandlerAccount : ListItemHandler {
	
	public Et.Account account;
	
	
	public ListItemHandlerAccount(Elm.Win win, Et.Account account) {
		base(win);
		this.account = account;
	}
	
	
	public new void go () { 
		logger.debug("ListItemHandlerAccount", "pressed... path=" + this.account.path); 
		base.go(); 
	}
	
	public override string format_item_label() {
		return "[" + account.dbus.display_name + "]";
	}

	protected override void open_elem_page() {
		
		//if true, this means probably that account.ref_count==0
		if(this.account==null) { 
			logger.error("ListItemHandlerAccount", "account is null!!!");
			return;
		}
		
		logger.debug("ListItemHandlerAccount", "Opening win for account "+account.path+"...");
		
		var accui = new SettingsAccountUI(account);
		accui.create(ui.win);
		ui.push_page(accui);

	}
}
