public class SessionUI : Page {

		private Et.ChannelMessages channel;
		
		Elm.Object[] gui_container;
		private Elm.Frame fr;
		private Elm.Label header;
		private LabelBox path;
		private FrameBox fr_general;	
		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		private Elm.Box hbox;
		private Elm.Box hbox_top;
		private Elm.Box hbox2;

		private Elm.Button bt_back;
		
	public SessionUI(Et.ChannelMessages channel) {
		base();
		this.channel = channel;
		channel.new_message.connect(sig_new_message);
	}
		
		
	public override PageID get_page_id() {
		return PageID.SESSION;
	}
	
	public override string? get_page_title() {
		return "Session"; 
	}
	
	public async override void refresh_content() {
	
	}
	
	public void sig_new_message(GLib.HashTable<string, Variant>[] message) {
		string? sender = (string) message[0].lookup("message-sender-id");
		string? content = (string) message[1].lookup("content");
		if(sender==null || content==null)
			logger.error("SessionUI", "sender or content is NULL!");
		logger.debug("SessionUI", sender+": "+content+"\n");
		
	}
	
	
	public unowned Elm.Object create(Elm.Win win) {
		
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
		header.text_set("Sessions");
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
		
		
		//HERE STARTS ALL THE OPTIONS LIST:
		
		fr_general = new FrameBox(win, vbox_in, "Conversation");
		fr_general.show();
		
		
		path = new LabelBox(win, fr_general.box, "path", channel.path);
		path.show();
		
		//BOTTOM:
		
		hbox2 = new Elm.Box(win);
		hbox2.horizontal_set(true);
		hbox2.size_hint_weight_set(1.0, 0.0);
		hbox2.size_hint_align_set(-1.0, 0.0);
		vbox.pack_end(hbox2);
		hbox2.show();

		return vbox;
	}
	



}
