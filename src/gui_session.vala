public class SessionUI : Page {

		private Et.ChannelMessages channel;
		
		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		
		private LabelBox[] gui_container;

		private LabelBox path;
		private FrameBox fr_general;

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
	
	public unowned Elm.Object create(Elm.Win win) {
		
		vbox = new Elm.Box(win);
		vbox.size_hint_weight_set( 1.0, 1.0 );
		
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
		
		HashTable<string, Variant>[,] messages = channel.dbus_ext.pending_messages;
		for(int i = 0; i< messages.length[0]; i++) {
			string? sender = (string) messages[i,0].lookup("message-sender-id");
			string? content = (string) messages[i,1].lookup("content");
			if(sender==null || content==null) {
				logger.error("SessionUI", "sender or content is NULL!");
			} else{
				var text = new LabelBox(win, fr_general.box, sender, content);
				text.show();
				gui_container += (owned) text;
			}
		}

		return vbox;
	}
	
	public void sig_new_message(GLib.HashTable<string, Variant>[] message) {
		string? sender = (string) message[0].lookup("message-sender-id");
		string? content = (string) message[1].lookup("content");
		if(sender==null || content==null)
			logger.error("SessionUI", "sender or content is NULL!");
		else {
			logger.debug("SessionUI", sender+": "+content+"\n");
			var text = new LabelBox(ui.win, fr_general.box, sender, content);
			text.show();
			gui_container += (owned) text;
		}
	}


}
