public class SettingsMainUI : Page {


		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		
		private Elm.Toggle tg_offline;

		private Elm.Box hbox_presence;
		private Elm.Label lb_presence;
		private Elm.Hoversel presence;
		private CbPresenceTypeAll[] hoversel_container;
		
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

		tg_offline = new Elm.Toggle(win);
		tg_offline.text_set("Offline Contacts:");
		tg_offline.states_labels_set("Show", "Hide");
		tg_offline.state_set(SETM.show_offline_contacts);
		tg_offline.size_hint_align_set(-1.0, 0.0);
		vbox_in.pack_end(tg_offline);
		tg_offline.show();
		tg_offline.smart_callback_add("changed", () => { 
							SETM.show_offline_contacts = tg_offline.state_get();
							});


		hbox_presence = new Elm.Box(win);
		hbox_presence.horizontal_set(true);
		hbox_presence.size_hint_align_set(0.0, 0.0);
		vbox_in.pack_end(hbox_presence);
		hbox_presence.show();

		lb_presence = new Elm.Label(win);
		lb_presence.text_set("<b>Presence:</b>");
		hbox_presence.pack_end(lb_presence);
		lb_presence.show();

		presence = new Elm.Hoversel(win);
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
