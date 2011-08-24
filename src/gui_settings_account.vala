public class SettingsAccountUI : Page {
	
		Elm.Object[] gui_container;

		private Et.Account account;
		
		private FrameBox fr_general;
		
		private EntryBox name;
		private EntryBox nickname;
		private LabelBox cstatus;
		private EntryBox service;
		private EntryBox pairable_timeout;
			
		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		private Elm.Box hbox;
		private Elm.Toggle tg_valid;
		private Elm.Toggle tg_enabled;
		private Elm.Button bt_k;
		
		private Elm.Button bt_close;
		
	public SettingsAccountUI(Et.Account account) {
		base();
		this.account = account;
	}
		
		
	public override PageID get_page_id() {
		return PageID.SETTINGS_ACCOUNT;
	}
	
	public override string? get_page_title() {
			return "Emtooth - Account settings"; 
	}
	
	public async override void refresh_content() {
		name.val_set(account.dbus.display_name);
		nickname.val_set(account.dbus.nickname);
		tg_valid.state_set(account.dbus.valid);
		tg_enabled.state_set(account.dbus.enabled);
		cstatus.val_set(((Telepathy.ConnectionStatus) account.dbus.connection_status).to_string());
		service.val_set(account.dbus.service);
	}
	
	
	public unowned Elm.Object create(Elm.Win win) {
		
		//add vbox
		vbox = new Elm.Box(win);
		vbox.size_hint_weight_set(1.0, 1.0);
		vbox.show();
		
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
		
		//HERE STARTS ALL THE OPTIONS LIST:
		
		fr_general = new FrameBox(win, vbox_in, "General settings");
		fr_general.show();
		
		//ADDRESS	
		//address = new LabelBox(win, fr_general.box, "Address", ADAPTER.addr);
		//address.show();
		
		// NAME:
		name = new EntryBox(win, fr_general.box, "Account Name", account.dbus.display_name);
		name.show();
		
		name.val.smart_callback_add("changed", () => {
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

		/*
		
		discoverable_timeout = new EntryBox(win, fr_disc.box, "Discoverable timeout", ADAPTER.discoverable_timeout.to_string());
		discoverable_timeout.show();
		
		discoverable_timeout.val.smart_callback_add("changed", () => {Variant val = (uint) int.parse(discoverable_timeout.val_get());
									ADAPTER.set_property_("DiscoverableTimeout", val); });
	
		
		// PAIRABLE TOGGLE + TIMEOUT:
		
		fr_pair = new FrameBox(win, vbox_in, "Pairing settings");
		fr_pair.show();
		
		tg_pair = new Elm.Toggle(win);
		tg_pair.text_set("Pairable:");
		tg_pair.states_labels_set("On", "Off");
		tg_pair.state_set(ADAPTER.pairable);
		tg_pair.size_hint_align_set(-1.0, 0.0);
		fr_pair.box.pack_end(tg_pair);
		tg_pair.show();
		
		tg_pair.smart_callback_add("changed", () => {Variant val = tg_pair.state_get();
									ADAPTER.set_property_("Pairable", val); });
		
		//endl
		
		pairable_timeout = new EntryBox(win, fr_pair.box, "Pairable timeout", ADAPTER.pairable_timeout.to_string());
		pairable_timeout.show();
		
		discoverable_timeout.val.smart_callback_add("changed", () => {Variant val = (uint) int.parse(pairable_timeout.val_get());
												ADAPTER.set_property_("PairableTimeout", val); });
		
		
		
		//DEVICES BUTTON:
		bt_k = new Elm.Button(win);
		bt_k.text_set("Show Devices");
		bt_k.size_hint_weight_set(0, 0);
		bt_k.size_hint_align_set(-1.0, -1.0);
		vbox_in.pack_end(bt_k);
		bt_k.show();
		
		bt_k.smart_callback_add( "clicked", () => {
												KnownUI known_ui = new KnownUI();
												known_ui.create(ui.win);
												ui.push_page(known_ui);
											} );
		
		*/
		//BOTTOM:
		
		gui_container += (owned) hbox;
		hbox = new Elm.Box(win);
		hbox.horizontal_set(true);
		hbox.size_hint_weight_set(1.0, 0.0);
		hbox.size_hint_align_set(-1.0, 0.0);
		vbox.pack_end(hbox);
		hbox.show();
		
		bt_close = new Elm.Button(win);
		bt_close.text_set("Close");
		bt_close.size_hint_weight_set(1.0, 1.0);
		bt_close.size_hint_align_set(-1.0, -1.0);
		hbox.pack_end(bt_close);
		bt_close.show();
		bt_close.smart_callback_add( "clicked", this.close );

		return vbox;
	}
	



}

