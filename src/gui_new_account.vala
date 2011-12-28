public class NewAccountUI : Page {
		
		private FrameBox fr_general;
		
		private EntryBox display_name;
		private EntryBox cmanager;
		private EntryBox protocol;
		private EntryBox account;
		private EntryBox server;
		private EntryBox port;
		private EntryBox password;
		private unowned Elm.Check? encryption;
		private unowned Elm.Check? registerr;
			
		private unowned Elm.Scroller? sc;
		private unowned Elm.Box? vbox_in;
		private unowned Elm.Box? hbox;

		private unowned Elm.Button? bt_ok;
		
	public NewAccountUI() {
		base();
	}

	
	public override string? get_page_title() {
			return "New Account"; 
	}
	
	public override unowned Elm.Button? get_button_next() { return null; }

	
	public unowned Elm.Object create(Elm.Win win) {
		
		//add vbox
		vbox = Elm.Box.add(win);
		vbox.size_hint_weight_set(1.0, 1.0);
		
		sc = Elm.Scroller.add(win);
		sc.size_hint_weight_set(1.0, 1.0);
		sc.size_hint_align_set(-1.0, -1.0);
		sc.bounce_set(false, true);
		vbox.pack_end(sc);
		sc.show();
		
		vbox_in = Elm.Box.add(win);
		vbox_in.size_hint_align_set(-1.0, -1.0);
		vbox_in.size_hint_weight_set(1.0, 1.0);
		sc.content_set(vbox_in);
		vbox_in.show();
		
		//HERE STARTS ALL THE OPTIONS LIST:
		
		fr_general = new FrameBox(win, vbox_in, "General settings");
		fr_general.show();	
		
		display_name = new EntryBox(win, fr_general.box, "Display Name", "Account name");
		display_name.show();
		
		cmanager = new EntryBox(win, fr_general.box, "Connection Manager", "gabble");
		cmanager.show();
		
		protocol = new EntryBox(win, fr_general.box, "Protocol", "jabber");
		protocol.show();
		
		
		
		account = new EntryBox(win, fr_general.box, "Account", "foo@jabber.org");
		account.show();
		
		server = new EntryBox(win, fr_general.box, "Server", "jabber.org");
		server.show();
		
		port = new EntryBox(win, fr_general.box, "Port", "5222");
		port.show();
		
		password = new EntryBox(win, fr_general.box, "Password", "1234");
		password.show();
		
		encryption = Elm.Check.add(win);
		encryption.style_set("toggle");
		encryption.text_set("Encryption:");
		encryption.part_text_set("on", "Yes");
		encryption.part_text_set("off", "No");
		encryption.state_set(false);
		encryption.size_hint_align_set(-1.0, 0.0);
		fr_general.box.pack_end(encryption);
		encryption.show();
		
		registerr = Elm.Check.add(win);
		registerr.style_set("toggle");
		registerr.text_set("Register:");
		registerr.part_text_set("on", "Yes");
		registerr.part_text_set("off", "No");
		registerr.state_set(false);
		registerr.size_hint_align_set(-1.0, 0.0);
		fr_general.box.pack_end(registerr);
		registerr.show();
		
		//BOTTOM:
		
		hbox = Elm.Box.add(win);
		hbox.horizontal_set(true);
		hbox.size_hint_weight_set(1.0, 0.0);
		hbox.size_hint_align_set(-1.0, 0.0);
		vbox.pack_end(hbox);
		hbox.show();
		
		bt_ok = Elm.Button.add(win);
		bt_ok.text_set("Create");
		bt_ok.size_hint_weight_set(1.0, 1.0);
		bt_ok.size_hint_align_set(-1.0, -1.0);
		hbox.pack_end(bt_ok);
		bt_ok.show();
		bt_ok.smart_callback_add( "clicked", this.cb_create_account );

		return vbox;
	}
	
	
	
	private void cb_create_account() {
		var parameters = new GLib.HashTable<string, Variant>(str_hash, str_equal);
		var properties = new GLib.HashTable<string, Variant>(str_hash, str_equal);
		
		parameters.insert("account", new Variant.string(account.val_get()));
		parameters.insert("server", new Variant.string(server.val_get()));
		parameters.insert("port", new Variant.uint32((uint) int.parse(port.val_get())));
		parameters.insert("password", new Variant.string(password.val_get()));
		parameters.insert("require-encryption", new Variant.boolean(encryption.state_get()));
		parameters.insert("register", new Variant.boolean(registerr.state_get()));
		
		try {
			ACM.dbus.create_account(cmanager.val_get(), protocol.val_get(), display_name.val_get(), parameters, properties);
		} catch (Error err) {
			logger.error("NewAccountUI", "CreateAccount() failed: "+err.message);
		}
		this.close();
	}
	



}
