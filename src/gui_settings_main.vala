public class SettingsMainUI : Page {


		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		
		private Elm.Toggle tg_offline;

		
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

		return vbox;
	}
	



}

