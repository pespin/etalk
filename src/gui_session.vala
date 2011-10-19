public class SessionUI : Page {

		private Et.ChannelMessages channel;
		
		private unowned Elm.Win? win;
		
		private Elm.Scroller sc;
		private Elm.Box vbox_in;
		
		private ChatText[] gui_container;

		private LabelBox path;
		private FrameBox fr_general;
		
		private Elm.Box hbox_bottom;
		private Elm.Entry text;
		private Elm.Button bt_send;

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
		this.win = win;
		
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
		
		naviframe_next = new Elm.Button(ui.pager);
		naviframe_next.text_set("Close");
		naviframe_next.size_hint_weight_set(1.0, 1.0);
		naviframe_next.size_hint_align_set(-1.0, -1.0);
		naviframe_next.smart_callback_add("clicked", () => {
				channel.close();
				this.close();
			} );

		
		//HERE STARTS ALL THE OPTIONS LIST:
		
		fr_general = new FrameBox(win, vbox_in, "Conversation");
		fr_general.show();
		
		
		var bubble = new ChatText(win, this.fr_general.box);
		bubble.content_set("path (debug)", channel.path);
		bubble.show();
		gui_container += (owned) bubble;
		
		append_pending_messages(); 
		
		hbox_bottom = new Elm.Box(win);
		hbox_bottom.horizontal_set(true);
		hbox_bottom.size_hint_weight_set(1.0, 0.0);
        hbox_bottom.size_hint_align_set(-1.0, 0.0);
		vbox_in.pack_end(hbox_bottom);
		hbox_bottom.show();
		
		text = new Elm.Entry(win);
		text.size_hint_align_set(-1.0, 0.0);
        text.size_hint_weight_set(1.0, 0.0);
        text.single_line_set(true);
		text.scrollable_set(true);
		text.entry_set("");
		hbox_bottom.pack_end(text);
		text.show();
		text.smart_callback_add("activated", cb_bt_send_clicked);
		
		bt_send = new Elm.Button(win);
		bt_send.text_set("Send");
		bt_send.size_hint_weight_set( 0.0, 0.0 );
		bt_send.size_hint_align_set( -1.0, -1.0 );
		hbox_bottom.pack_end(bt_send);
		bt_send.show();
		bt_send.smart_callback_add( "clicked", cb_bt_send_clicked );
		
		

		return vbox;
	}
	
	
	public void append_pending_messages() {
	
		HashTable<string, Variant>[,] messages = channel.get_pending_messages();
		for(int i = 0; i< messages.length[0]; i++) {
			string? sender = (string) messages[i,0].lookup("message-sender-id");
			string? content = (string) messages[i,1].lookup("content");
			if(sender==null || content==null) {
				logger.error("SessionUI", "sender or content is NULL!");
			} else{
				var bubble = new ChatText(win, this.fr_general.box);
				bubble.content_set(sender, content);
				bubble.show();
				gui_container += (owned) bubble;
			}
		}
		
	}
	
	/* callbacks */
	
	void cb_bt_send_clicked() {
		channel.send_message(this.text.entry_get());
		this.text.entry_set("");
	}
	
	/* signals */
	
	public void sig_new_message(GLib.HashTable<string, Variant>[] message) {
		string? sender = (string) message[0].lookup("message-sender-id");
		string? content = (string) message[1].lookup("content");
		if(sender==null || content==null)
			logger.error("SessionUI", "sender or content is NULL!");
		else {
			logger.debug("SessionUI", sender+": "+content+"\n");
			var bubble = new ChatText(win, this.fr_general.box);
			bubble.content_set(sender, content);
			bubble.show();
			gui_container += (owned) bubble;
		}
	}


}


private class ChatText : GLib.Object {
	private unowned Elm.Win? win;
	private unowned Elm.Box? parent;
	private Elm.Bubble bubble; 
	private Elm.Anchorblock label;
	
	public ChatText(Elm.Win? win, Elm.Box? parent) {
		this.win = win;
		this.parent = parent;
	}
	
	
	public void content_set(string speaker, string message) {
		
		
		bubble = new Elm.Bubble(this.win);
		bubble.size_hint_weight_set( 1.0, 1.0 );
		bubble.size_hint_align_set( -1.0, -1.0 );
		bubble.text_set(speaker);
		parent.pack_end(bubble);
		
		label = new Elm.Anchorblock(this.win);
		label.text_set(message);
		label.size_hint_weight_set( 1.0, 1.0 );
		label.size_hint_align_set( -1.0, -1.0 );
		bubble.content_set(label);
		
	}
	
	
	public void show() {
		label.show();
		bubble.show();
	}
	
}
