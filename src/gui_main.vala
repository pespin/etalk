


public class MainUI : Page {
	
		public Elm.Label header;
		public Elm.List li;
		
		private unowned Elm.Win win;
			
		private Elm.Box hbox;
		private Elm.Frame fr;
		private Elm.Box hbox1;
		//private Elm.Button bt_start;
		//private Elm.Button bt_stop;
		private Elm.Button bt_accounts;

		public HashTable<uint,ListItemHandlerContact> elem_ui_list; 
		
		public MainUI() {
				base();
				elem_ui_list = new HashTable<uint,ListItemHandlerContact>(direct_hash, direct_equal);
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
		
		// add a label
		header = new Elm.Label(win);
		header.text_set("Contacts");
		fr.content_set(header);
		header.show();

		//add list
		li = new Elm.List(win);
		li.scale_set(1.0);
		li.size_hint_weight_set(1.0, 1.0);
		li.size_hint_align_set(-1.0, -1.0);
		vbox.pack_end(li);
		//li.smart_callback_add( "clicked", cb_device_list_selected );
		li.show();
	
		//add button hbox1
		hbox1 = new Elm.Box(win);
		hbox1.horizontal_set(true);	
		hbox1.size_hint_weight_set( 1.0, 0.0 );
		hbox1.size_hint_align_set( -1.0, 0.0 );
		vbox.pack_end(hbox1);
		hbox1.show();
		/*
		//add buttons to hbox1
		bt_start = new Elm.Button(win);
		bt_start.text_set("Start Discovery");
		bt_start.size_hint_weight_set( 1.0, 1.0 );
		bt_start.size_hint_align_set( -1.0, -1.0 );
		//bt_start.smart_callback_add( "clicked", cb_bt_start_clicked );
		
		
		bt_stop = new Elm.Button(win);
		bt_stop.text_set("Stop Discovery");
		bt_stop.size_hint_weight_set( 1.0, 1.0 );
		bt_stop.size_hint_align_set( -1.0, -1.0 );
		//bt_stop.smart_callback_add( "clicked", cb_bt_stop_clicked );
		hbox1.pack_end(bt_stop);
		bt_stop.show(); */
	
	
		bt_accounts = new Elm.Button(win);
		bt_accounts.text_set("Accounts");
		bt_accounts.size_hint_weight_set( 1.0, 1.0 );
		bt_accounts.size_hint_align_set( -1.0, -1.0 );
		hbox1.pack_end(bt_accounts);
		bt_accounts.show();
		bt_accounts.smart_callback_add( "clicked", cb_bt_accounts_clicked );
	
		return vbox;
	}
	
	public void add_elem_to_ui(Et.Contact contact) {
		
		
		logger.debug("MainUI", "Adding element " + contact.id + " [" + contact.handle.to_string() + "] to ui-list");
		
		//Little hack to not hang the UI while adding lots of stuff... :P
		Ecore.MainLoop.iterate();
		
		var opener = new ListItemHandlerContact(win, contact);
		opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
		elem_ui_list.insert(contact.handle, (owned) opener);
		this.li.go();
	}

	public void remove_elem_from_ui(uint handle) {

		logger.debug("MainUI", "Removing elem " + handle.to_string() + " from ui-list");
		//Little hack to not hang the UI while removing lots of stuff... :P
		Ecore.MainLoop.iterate();
		elem_ui_list.remove(handle);
		this.li.go();
	}
	
	
	private void cb_bt_accounts_clicked() {
		logger.debug("MainUI", "Accounts button pressed.");
		
		var accounts_list = new ListAccountUI();
		accounts_list.create(ui.win);
		ui.push_page(accounts_list);
		
	}
	

	public override PageID get_page_id() {
		return PageID.MAIN;
	}
	
	public override string? get_page_title() {
		return "Etalk - settings"; 
	}
	
	public async override void refresh_content() {

		HashTableIter<uint,ListItemHandlerContact> it = HashTableIter<uint,ListItemHandlerContact>(elem_ui_list);
		
		unowned uint? handle;
		unowned ListItemHandlerContact? handler;
		while(it.next(out handle, out handler)) {
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
		return "[" + contact.handle.to_string() + "] " + contact.id;
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
		
		//if true, this means probably that contact.ref_count==0
		if(this.contact==null) { 
			logger.error("ListItemHandlerContact", "contact is null!!!");
			return;
		}
		
		logger.debug("ListItemHandlerContact", "Opening win for contact "+contact.id+"...");
		
		/*BluezRemoteDeviceUI device_ui = new BluezRemoteDeviceUI(rdevice);
		device_ui.create(ui.win);
		ui.push_page(device_ui);*/

	}
	
}
