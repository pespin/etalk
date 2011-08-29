public class SettingsMainUI : Page {
		
		private EntryBox name;

		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		private Elm.Box hbox;
		private Elm.Box hbox_top;
		private Elm.Label header;
		private Elm.Frame fr;
		private Elm.Button bt_back;
		
		
	public override PageID get_page_id() {
		return PageID.SETTINGS_MAIN;
	}
	
	public override string? get_page_title() {
			return "General Settings"; 
	}
	
	public async override void refresh_content() {
	}
	
	
	public unowned Elm.Object create(Elm.Win win) {
		
		//add vbox
		vbox = new Elm.Box(win);
		vbox.size_hint_weight_set(1.0, 1.0);
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
		hbox_top.horizontal_set(true);	
		hbox_top.size_hint_weight_set( 1.0, 0.0 );
		hbox_top.size_hint_align_set( -1.0, 0.0 );
		fr.content_set(hbox_top);
		hbox_top.show();
		
		bt_back = new Elm.Button(win);
		bt_back.text_set("Back");
		bt_back.size_hint_weight_set(1.0, 1.0);
		bt_back.size_hint_align_set(-1.0, -1.0);
		hbox_top.pack_end(bt_back);
		bt_back.show();
		bt_back.smart_callback_add( "clicked", this.close );
		
		// add a label
		header = new Elm.Label(win);
		header.text_set("Settings");
		header.size_hint_weight_set(1.0, 1.0);
		header.size_hint_align_set(-1.0, -1.0);
		hbox_top.pack_end(header);
		header.show();
		
		sc = new Elm.Scroller(win);
		sc.size_hint_weight_set(1.0, 1.0);
		sc.size_hint_align_set(-1.0, -1.0);
		sc.bounce_set(false, true);
		vbox.pack_end(sc);
		sc.show();
		
		vbox_in = new Elm.Box(win);
		vbox_in.size_hint_align_set(-1.0, -1.0);
		vbox_in.size_hint_weight_set(1.0, 1.0);
		sc.content_set(vbox_in);
		vbox_in.show();
		
		// NAME:
		name = new EntryBox(win, vbox_in, "Account Name", "blabla");
		name.show();
		
		/*name.val.smart_callback_add("changed", () => {
							account.dbus.display_name = name.val_get();
													});

		nickname = new EntryBox(win, fr_general.box, "Nickname", account.dbus.nickname);
		nickname.show();
		
		nickname.val.smart_callback_add("changed", () => {
							account.dbus.nickname = nickname.val_get();
													});
													
		tg_valid = new Elm.Toggle(win);
		tg_valid.text_set("Valid:");
		tg_valid.states_labels_set("Yes", "No");
		tg_valid.state_set(account.dbus.valid);
		tg_valid.disabled_set(true);
		tg_valid.size_hint_align_set(-1.0, 0.0);
		fr_general.box.pack_end(tg_valid);
		tg_valid.show();
		
		tg_enabled = new Elm.Toggle(win);
		tg_enabled.text_set("Enabled:");
		tg_enabled.states_labels_set("Yes", "No");
		tg_enabled.state_set(account.dbus.enabled);
		tg_enabled.size_hint_align_set(-1.0, 0.0);
		fr_general.box.pack_end(tg_enabled);
		tg_enabled.show();
		
		
		tg_enabled.smart_callback_add("changed", () => {
							if(tg_enabled.state_get()==true)
								account.enable();
							else
								account.disable();
														});

		
		cstatus = new LabelBox(win, fr_general.box, "Connection status",
					((Telepathy.ConnectionStatus) account.dbus.connection_status).to_string());
		cstatus.show();
		
		
		service = new EntryBox(win, fr_general.box, "Service", account.dbus.service);
		service.show();
		
		service.val.smart_callback_add("changed", () => {
							account.dbus.service = service.val_get();
													});

		*/

		return vbox;
	}
	



}

