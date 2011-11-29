public class SettingsMainUI : Page {


		private unowned Elm.Scroller? sc;
		private unowned Elm.Box? vbox_in;
		
		private unowned Elm.Toggle? tg_offline;
		private unowned Elm.Toggle? tg_disconnect;

		private unowned Elm.Box? hbox_presence;
		private unowned Elm.Label? lb_presence;
		private unowned Elm.Hoversel? presence;
		private CbPresenceTypeAll[] hoversel_container;

	
	public override string? get_page_title() {
			return "General Settings"; 
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

		tg_offline = Elm.Toggle.add(win);
		tg_offline.text_set("Offline Contacts:");
		tg_offline.states_labels_set("Show", "Hide");
		tg_offline.state_set(SETM.show_offline_contacts);
		tg_offline.size_hint_align_set(-1.0, 0.0);
		vbox_in.pack_end(tg_offline);
		tg_offline.show();
		tg_offline.smart_callback_add("changed", () => { 
							SETM.show_offline_contacts = tg_offline.state_get();
							});
							
		tg_disconnect = Elm.Toggle.add(win);
		tg_disconnect.text_set("Become offline when closing:");
		tg_disconnect.states_labels_set("Yes", "No");
		tg_disconnect.state_set(SETM.set_offline_on_close);
		tg_disconnect.size_hint_align_set(-1.0, 0.0);
		vbox_in.pack_end(tg_disconnect);
		tg_disconnect.show();
		tg_disconnect.smart_callback_add("changed", () => { 
							SETM.set_offline_on_close = tg_disconnect.state_get();
							});


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
		presence.text_set("Choose Presence");
		presence.show();


		hoversel_container = { };
		int i = 0;
		foreach(var ptype in Telepathy.ConnectionPresenceType.get_usable()) {
			var cbdata = new CbPresenceTypeAll(ptype);
			hoversel_container += (owned) cbdata;
			presence.item_add(hoversel_container[i].ptype.to_string(), null, Elm.IconType.NONE, hoversel_container[i].apply_presence);
			i++;
		}


		return vbox;
	}

}

/* This object is needed to avoid delete of data when passed to hoversel callback */
private class CbPresenceTypeAll : GLib.Object {

	public Telepathy.ConnectionPresenceType ptype;

	public CbPresenceTypeAll(Telepathy.ConnectionPresenceType ptype) {
		this.ptype=ptype;
	}

	public void apply_presence() {
			logger.debug("CbPresenceTypeAll", "presence set to "+this.ptype.to_string()+" for all accounts");
			ACM.simple_presence_set_all(ptype);
	}
}
