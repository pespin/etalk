public class SettingsMainUI : Page {
		
		private EntryBox name;

		private Elm.Scroller sc;
		private Elm.Box vbox_in;

		
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
		
		name = new EntryBox(win, vbox_in, "Account Name", "blabla");
		name.show();
		

		return vbox;
	}
	



}

