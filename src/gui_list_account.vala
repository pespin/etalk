public class ListAccountUI : Page {
		
		private unowned Elm.Win win;

		public unowned Elm.List? li;
		private unowned Elm.Box? hbox1;
		private unowned Elm.Button? bt_new;

		public HashTable<string,ListItemHandlerAccount> elem_ui_list; 
		
		public ListAccountUI() {
				base();
				elem_ui_list = new HashTable<string,ListItemHandlerAccount>(str_hash, str_equal);
		}
		

	public unowned Elm.Object create(Elm.Win win) {
		
		this.win = win;
		
		//add vbox
		vbox = Elm.Box.add(win);
		vbox.size_hint_weight_set( 1.0, 1.0 );

		//add list
		li = Elm.List.add(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		vbox.pack_end(li);;
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
	
		return vbox;
	}
	
	
	private void populate_list() {
			elem_ui_list = new HashTable<string,ListItemHandlerAccount>(str_hash, str_equal);
			ACM.show_accounts(this);
	}
	
	public void add_elem_to_ui(Et.Account account) {
		
		
		logger.debug("ListAccountUI", "Adding element " + account.path + " to ui-list");
		
		//Little hack to not hang the UI while adding lots of stuff... :P
		Ecore.MainLoop.iterate();
		
		var opener = new ListItemHandlerAccount(win, account);
		opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
		elem_ui_list.insert(account.path, (owned) opener);
		this.li.go();
	}

	public void remove_elem_from_ui(string path) {

		logger.debug("ListAccountUI", "Removing elem " + path + " from ui-list");
		//Little hack to not hang the UI while removing lots of stuff... :P
		Ecore.MainLoop.iterate();
		elem_ui_list.remove(path);
		this.li.go();
	}
	

	public override PageID get_page_id() {
		return PageID.LIST_ACCOUNT;
	}
	
	public override string? get_page_title() {
		return "Accounts List"; 
	}
	
	public override unowned Elm.Button? get_button_next() { return null; }
	
	public async override void refresh_content() {
			
		this.populate_list();
		
	}
	
	
	
	
	private void cb_bt_new_clicked() {
		logger.debug("ListAccountUI", "New Account button pressed.");
		
		var accui = new NewAccountUI();
		accui.create(ui.win);
		ui.push_page(accui);
		
	}
	
	
}



public class ListItemHandlerAccount : ListItemHandler {
	
	public Et.Account account;
	
	
	public ListItemHandlerAccount(Elm.Win win, Et.Account account) {
		base(win);
		this.account = account;
		//this.icon = gen_icon(rdevice.icon+"-"+(rdevice.online ? "online" : "offline") );
	}
	
	
	public new void go () { 
		logger.debug("ListItemHandlerAccount", "pressed... path=" + this.account.path); 
		base.go(); 
	}
	
	public override void refresh_content() {
		/*item.label_set(format_item_label(rdevice));
		icon = gen_icon(rdevice.online ? "online" : "offline" );
		item.icon_set(icon);*/
	}
	
	public override string format_item_label() {
		return "[" + account.dbus.display_name + "]";
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
