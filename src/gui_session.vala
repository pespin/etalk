public class SessionUI : Page {

		private Et.ChannelMessages channel;
		
		private unowned Elm.Win? win;
		
		//private ChatText[] gui_container;

		//private LabelBox path;
		//private FrameBox fr_general;
		
		private Elm.Box hbox_bottom;
		private Elm.Entry text;
		private Elm.Button bt_send;
		
		private Elm.Genlist genlist;
		private Elm.GenlistItemClass itc;
		
		private HashTable<string, ChatText> messages;

	public SessionUI(Et.ChannelMessages channel) {
		base();
		this.channel = channel;
		
		messages = new HashTable<string,ChatText>(str_hash, str_equal);
		
		
		//itc.item_style = "default";
		itc.item_style = "icon_top_text_bottom";
		itc.func.label_get = genlist_get_label;
        itc.func.content_get = genlist_get_content;
        itc.func.state_get = genlist_get_state;
        itc.func.del = genlist_del_item;
		
		
		
		
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
		
		
		naviframe_next = new Elm.Button(ui.pager);
		naviframe_next.text_set("Close");
		naviframe_next.size_hint_weight_set(1.0, 1.0);
		naviframe_next.size_hint_align_set(-1.0, -1.0);
		naviframe_next.smart_callback_add("clicked", () => {
				channel.close();
				this.close();
			} );
		
		genlist = new Elm.Genlist(win);
		genlist.scale_set(1.0);
		genlist.size_hint_weight_set(1.0, 1.0);
		genlist.size_hint_align_set(-1.0, -1.0);
		genlist.no_select_mode_set(true);
		vbox.pack_end(genlist);
		genlist.show();
		append_pending_messages();
		
		hbox_bottom = new Elm.Box(win);
		hbox_bottom.horizontal_set(true);
		hbox_bottom.size_hint_weight_set(1.0, 0.0);
        hbox_bottom.size_hint_align_set(-1.0, 0.0);
		vbox.pack_end(hbox_bottom);
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
			string? key = (string) messages[i,0].lookup("message-token");
			string? content = (string) messages[i,1].lookup("content");
			if(sender==null || content==null || key==null) {
				logger.error("SessionUI", "sender,key or content is NULL!");
			} else{
				var bubble = new ChatText(win, this, key);
				bubble.content_set(sender, content);
				unowned Elm.GenlistItem it = genlist.item_append(ref itc, (void*) bubble, null, Elm.GenlistItemFlags.NONE, onSelectedItem);
				this.messages.insert(key, (owned) bubble);
				it.bring_in();
			}
		}
		
	}
	
	
	/* Genlist stuff */

	private static string genlist_get_label( Elm.Object obj, string part ) {
		logger.debug("SessionUI", "HEY!!!! LABEL CALLED!");
		ChatText t = (ChatText) obj;
		return t.get_label();
	}


	private static Elm.Object? genlist_get_content( Elm.Object obj, string part ) {
		logger.debug("SessionUI", "content function called!");
		ChatText t = (ChatText) obj;
		return t.get_content();
	}

	private static bool genlist_get_state( Elm.Object obj, string part ) {
		logger.debug("SessionUI", "state function called!");
		return false;
	}

	private static void genlist_del_item( Elm.Object obj ) {
		logger.debug("SessionUI", "DELETE function called!");
	}
	
	public void onSelectedItem( Evas.Object obj, void* event_info)
    {
       logger.debug("SessionUI", "HEY!!!! ITEM SELECTED!");
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
		string? key = (string) message[0].lookup("message-token");
		if(sender==null || content==null || key==null)
			logger.error("SessionUI", "sender, token or content is NULL!");
		else {
			logger.debug("SessionUI", sender+": "+content+"\n");
			var bubble = new ChatText(win, this, key);
			bubble.content_set(sender, content);
			unowned Elm.GenlistItem it = genlist.item_append(ref itc, (void*) bubble, null, Elm.GenlistItemFlags.NONE, onSelectedItem);
			messages.insert(key, (owned) bubble);
			it.bring_in();
		}
	}


}


private class ChatText : GLib.Object {
	private unowned Elm.Win? win;
	private Elm.Bubble bubble;
	private Elm.Anchorblock label;
	
	public unowned SessionUI ui {get; private set;}
	public string key {get; private set;}
	private string speaker;
	private string message;
	
	public ChatText(Elm.Win win, SessionUI ui, string key) {
		this.win = win;
		this.ui = ui;
		this.key = key;
	}
	
	
	public void content_set(string speaker, string message) {
		
		this.speaker = speaker;
		this.message = message;
		bubble = null;
		bubble = new Elm.Bubble(win);
		bubble.size_hint_weight_set( 1.0, 1.0 );
		bubble.size_hint_align_set( -1.0, -1.0 );
		bubble.text_set(speaker);
		
		label = null;
		label = new Elm.Anchorblock(win);
		label.text_set(message);
		label.size_hint_weight_set( 1.0, 1.0 );
		label.size_hint_align_set( -1.0, -1.0 );
		label.show();
		bubble.content_set(label);
		
	}
	
	public string? get_label() {
		return "";
	}
	
	public Elm.Object? get_content() {
		
		bubble = new Elm.Bubble(win);
		bubble.size_hint_weight_set( 1.0, 1.0 );
		bubble.size_hint_align_set( -1.0, -1.0 );
		bubble.text_set(speaker);
		
		label = new Elm.Anchorblock(win);
		label.text_set(message);
		label.size_hint_weight_set( 1.0, 1.0 );
		label.size_hint_align_set( -1.0, -1.0 );
		label.show();
		bubble.content_set(label);
		
		return (owned) bubble;
	}
	

	
}
