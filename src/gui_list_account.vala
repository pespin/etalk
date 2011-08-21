public class ListAccountUI : Page {
	
		public Elm.Label header;
		public Elm.List li;
		
		private unowned Elm.Win win;
			
		private Elm.Box hbox;
		private Elm.Box hbox_top;
		private Elm.Frame fr;
		private Elm.Box hbox1;
		private Elm.Button bt_back;
		private Elm.Button bt_new;

		public HashTable<string,ListItemHandlerAccount> elem_ui_list; 
		
		public ListAccountUI() {
				base();
				elem_ui_list = new HashTable<string,ListItemHandlerAccount>(str_hash, str_equal);
		}
		

	public unowned Elm.Object create(Elm.Win win) {
		
		this.win = win;
		
		//add vbox
		vbox = new Elm.Box(win);
		vbox.size_hint_weight_set( 1.0, 1.0 );
		vbox.show();
		
		//add button hbox
		hbox = new Elm.Box(win);
		hbox.horizontal_set(true);	
		hbox.size_hint_weight_set( 1.0, 0.0 );
		hbox.size_hint_align_set( -1.0, 0.0 );
		vbox.pack_end(hbox);
		hbox.show();
		
		// add a frame
		fr = new Elm.Frame(win);
		fr.style_set("outdent_top");
		fr.size_hint_weight_set(0.0, 0.0);
		fr.size_hint_align_set(0.0, -1.0);
		hbox.pack_end(fr);
		fr.show();
		
		hbox_top = new Elm.Box(win);
		hbox.horizontal_set(true);	
		hbox.size_hint_weight_set( 1.0, 0.0 );
		hbox.size_hint_align_set( -1.0, 0.0 );
		fr.content_set(hbox_top);
		hbox.show();
		
		bt_back = new Elm.Button(win);
		bt_back.text_set("Back");
		bt_back.size_hint_weight_set(1.0, 1.0);
		bt_back.size_hint_align_set(-1.0, -1.0);
		hbox_top.pack_end(bt_back);
		bt_back.show();
		bt_back.smart_callback_add( "clicked", this.close );
		
		// add a label
		header = new Elm.Label(win);
		header.text_set("Accounts");
		header.size_hint_weight_set(1.0, 1.0);
		header.size_hint_align_set(-1.0, -1.0);
		hbox_top.pack_end(header);
		header.show();

		//add list
		li = new Elm.List(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		vbox.pack_end(li);;
		li.show();
	
		//add button hbox1
		hbox1 = new Elm.Box(win);
		hbox1.horizontal_set(true);	
		hbox1.size_hint_weight_set( 1.0, 0.0 );
		hbox1.size_hint_align_set( -1.0, 0.0 );
		vbox.pack_end(hbox1);
		hbox1.show();

		bt_new = new Elm.Button(win);
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
		
		
		message("Adding element " + account.path + " to ui-list");
		
		//Little hack to not hang the UI while adding lots of stuff... :P
		Ecore.MainLoop.iterate();
		
		var opener = new ListItemHandlerAccount(win, account);
		opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
		elem_ui_list.insert(account.path, (owned) opener);
		this.li.go();
	}

	public void remove_elem_from_ui(string path) {

		message("Removing elem " + path + " from ui-list\n");
		//Little hack to not hang the UI while removing lots of stuff... :P
		Ecore.MainLoop.iterate();
		elem_ui_list.remove(path);
		this.li.go();
	}
	

	public override PageID get_page_id() {
		return PageID.LIST_ACCOUNT;
	}
	
	public override string? get_page_title() {
		return "Etalk - Accounts List"; 
	}
	
	public async override void refresh_content() {
			
		this.populate_list();
		
	}
	
	
	
	
	private void cb_bt_new_clicked() {
		stdout.printf("New Account button pressed.\n");
		
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
		stderr.printf ("GUI: pressed... path=" + this.account.path + "\n"); 
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
	protected override void open_rdevice_page() {
		
		//if true, this means probably that account.ref_count==0
		if(this.account==null) { 
			warning("account is null!!!\n");
			return;
		}
		
		message("Opening win for account "+account.path+"...\n");
		
		var accui = new SettingsAccountUI(account);
		accui.create(ui.win);
		ui.push_page(accui);

	}
}
