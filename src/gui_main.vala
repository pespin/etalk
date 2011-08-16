


public class MainUI : Page {
	
		public Elm.Label header;
		public Elm.List li;
		
		private unowned Elm.Win win;
			
		private Elm.Box hbox;
		private Elm.Frame fr;
		private Elm.Box hbox1;
		private Elm.Button bt_start;
		private Elm.Button bt_stop;
		private Elm.Button bt;

		public HashTable<uint,ListItemHandler> elem_ui_list; 
		
		public MainUI() {
				//super();
				elem_ui_list = new HashTable<uint,ListItemHandler>(direct_hash, direct_equal);
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
		header.text_set("Discovering Devices...");
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
		bt_stop.show();
	
	
		bt = new Elm.Button(win);
		bt.text_set("Settings");
		bt.size_hint_weight_set( 1.0, 1.0 );
		bt.size_hint_align_set( -1.0, -1.0 );
		hbox1.pack_end(bt);
		bt.show();
		bt.smart_callback_add( "clicked", cb_bt_settings_clicked );
	
		return vbox;
	}
	
	public void add_elem_to_ui(Et.Contact contact) {
		
		
		message("Adding element " + contact.id + " [" + contact.handle.to_string() + "] to ui-list");
		
		//Little hack to not hang the UI while adding lots of stuff... :P
		Ecore.MainLoop.iterate();
		
		var opener = new ListItemHandler(win, contact);
		opener.item = this.li.append(opener.format_item_label(), null, null, opener.go);
		elem_ui_list.insert(contact.handle, (owned) opener);
		this.li.go();
	}
	/*
	public void remove_rdevice_from_ui(string path) {

		message("Removing rdevice " + path + " from ui-list\n");
		rdevices_ui_list.remove(path);
		this.li.go();
	}*/
	
	
	private void cb_bt_settings_clicked() {
		stdout.printf("Settings button pressed.\n");
		
		/*SettingsUI settings_ui = new SettingsUI();
		settings_ui.create(ui.win);
		ui.push_page(settings_ui); */
	}
	

	public override string get_page_sid() {
		return PAGE_SID_MAIN; 
	}
	
	public override string? get_page_title() {
		return "Etalk - settings"; 
	}
	
	public async override void refresh_content() {
			//stderr.printf("NOT IMPLEMENTED: refresh_content() on MainUI\n");
			
			
		HashTableIter<uint,ListItemHandler> it = HashTableIter<uint,ListItemHandler>(elem_ui_list);
		
		unowned uint? handle;
		unowned ListItemHandler? handler;
		while(it.next(out handle, out handler)) {
			handler.refresh_content();
		}
		
		li.go();
		
	}

}
