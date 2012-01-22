public class SettingsAccountUI : Page {
		private static const string DOMAIN = "SettingsAccountUI";

		private Et.Account account;
		
		private CbPresenceType[] hoversel_container;
		
		private unowned Elm.Scroller? sc;
		private unowned Elm.Box? vbox_in;
		
		private EntryBox name;
		private EntryBox nickname;
		private LabelBox cstatus;
		private EntryBox service;
		private unowned Elm.Check? tg_valid;
		private unowned Elm.Check? tg_enabled;
		private unowned Elm.Box? hbox_presence;
		private unowned Elm.Label? lb_presence;
		private unowned Elm.Hoversel? presence;
		private unowned Elm.Button? bt_rm;

		
	public SettingsAccountUI(Et.Account account) {
		base();
		this.account = account;
	}

	
	public override unowned Elm.Button? get_button_next() { return null; }
	
	public override string? get_page_title() {
			return "Account settings"; 
	}

	public override void on_appear() {
			logger.debug(DOMAIN, "page is visible!");
	}
	
	
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
		
		// NAME:
		name = new EntryBox(win, vbox_in, "Account Name", account.dbus.display_name);
		name.show();
		
		name.val.smart_callback_add("changed", () => {
							account.dbus.display_name = name.val_get();
													});

		nickname = new EntryBox(win, vbox_in, "Nickname", account.dbus.nickname);
		nickname.show();
		
		nickname.val.smart_callback_add("changed", () => {
							account.dbus.nickname = nickname.val_get();
													});
													
		tg_valid = Elm.Check.add(win);
		tg_valid.style_set("toggle");
		tg_valid.text_set("Valid:");
		tg_valid.part_text_set("on", "Yes");
		tg_valid.part_text_set("off", "No");
		tg_valid.state_set(account.dbus.valid);
		tg_valid.disabled_set(true);
		tg_valid.size_hint_align_set(-1.0, 0.0);
		vbox_in.pack_end(tg_valid);
		tg_valid.show();
		
		tg_enabled = Elm.Check.add(win);
		tg_enabled.style_set("toggle");
		tg_enabled.text_set("Enabled:");
		tg_enabled.part_text_set("on", "Yes");
		tg_enabled.part_text_set("off", "No");
		tg_enabled.state_set(account.dbus.enabled);
		tg_enabled.size_hint_align_set(-1.0, 0.0);
		vbox_in.pack_end(tg_enabled);
		tg_enabled.show();
		
		
		tg_enabled.smart_callback_add("changed", () => {
							if(tg_enabled.state_get()==true)
								account.enable();
							else
								account.disable();
														});

		
		cstatus = new LabelBox(win, vbox_in, "Connection status", account.connection_status);
		cstatus.show();
		
		
		hbox_presence = Elm.Box.add(win);
		hbox_presence.horizontal_set(true);	
		hbox_presence.size_hint_align_set(0.0, 0.0);	
		vbox_in.pack_end(hbox_presence);
		hbox_presence.show();		
		
		lb_presence = Elm.Label.add(win);
		lb_presence.text_set("<b>Presence:</b>");
		hbox_presence.pack_end(lb_presence);
		lb_presence.show();
		
		presence = Elm.Hoversel.add(win);
		presence.hover_parent_set(win);
		presence.size_hint_align_set(1.0, 0.0);
		hbox_presence.pack_end(presence);
		presence.text_set(account.current_connection_presence);
		presence.show();
		
		
		hoversel_container = { };
		int i = 0;
		foreach(var ptype in Telepathy.ConnectionPresenceType.get_usable()) {
			var cbdata = new CbPresenceType(this.account, ptype);
			hoversel_container += (owned) cbdata;
			presence.item_add(hoversel_container[i].ptype.to_string(), null, Elm.IconType.NONE, hoversel_container[i].apply_presence);
			i++;
		}
		
		
		service = new EntryBox(win, vbox_in, "Service", account.dbus.service);
		service.show();
		
		service.val.smart_callback_add("changed", () => {
							account.dbus.service = service.val_get();
													});
		//RM BUTTON:
		bt_rm = Elm.Button.add(win);
		bt_rm.text_set("Remove Account");
		bt_rm.size_hint_weight_set(0, 0);
		bt_rm.size_hint_align_set(-1.0, -1.0);
		vbox_in.pack_end(bt_rm);
		bt_rm.show();
		
		bt_rm.smart_callback_add( "clicked", () => {
											account.dbus.remove();
											this.close();
											} );

		account.account_updated.connect(content_refresh);

		return vbox;
	}
	
	private void content_refresh() {
		name.val_set(account.dbus.display_name);
		nickname.val_set(account.dbus.nickname);
		tg_valid.state_set(account.dbus.valid);
		tg_enabled.state_set(account.dbus.enabled);
		cstatus.val_set(account.connection_status);
		presence.text_set(account.current_connection_presence);
		service.val_set(account.dbus.service);
	}
	
}

/* This object is needed to avoid delete of data when passed to hoversel callback */
private class CbPresenceType : GLib.Object {
	
	public Telepathy.ConnectionPresenceType ptype;
	private unowned Et.Account account;
	
	public CbPresenceType(Et.Account account, Telepathy.ConnectionPresenceType ptype) {
		this.account = account;
		this.ptype=ptype;
	}
	
	public void apply_presence() {
			logger.debug("CbPresenceType", "presence set to "+this.ptype.to_string());
			account.simple_presence_set(ptype);
	}
}

