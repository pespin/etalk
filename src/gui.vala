

public class EtalkUI {
	
		public Elm.Win win;
		
		public Elm.Naviframe pager;
			
		private Elm.Bg	bg;
		public MainUI  mui;
		public ListSessionUI sui;
		public List<Page> page_stack;
		
		
		public EtalkUI() {
				page_stack = new List<Page>();
		}
		

	public void create() {
		
			win = new Elm.Win( null, "main_win", Elm.WinType.BASIC );
			win.title_set( "etalk" );
			win.smart_callback_add( "delete,request", Elm.exit );
			
			bg = new Elm.Bg(win);
			bg.size_hint_weight_set( 1.0, 1.0 );
			bg.show();
			win.resize_object_add(bg);
			
			win.resize( DISPLAY_WIDTH, DISPLAY_HEIGHT );
			
			pager = new Elm.Naviframe( win );
			win.resize_object_add( pager );
			pager.size_hint_weight_set( 1.0, 1.0 );
			pager.content_preserve_on_pop_set(true);
			pager.show();
			
			mui = new MainUI();
			sui = new ListSessionUI();
			unowned Elm.Object page;
			page = mui.create(win);
			win.title_set("Etalk - "+mui.get_page_title());
			pager.item_push(mui.get_page_title(), null, null, page, null);

			sui.create(win);
			
			win.show();
	
	}
	
	public void pop_page(Page page) {
		//stderr.printf("pop_page() started!\n");
		//if( obj == pager.content_top_get() ) { //this segfaults...
			pager.item_pop();
			page_stack.remove(page);
			
			string? last_title = get_last_title();
			if(last_title != null)
				win.title_set("Etalk - "+last_title);
			else
				win.title_set("Etalk - "+mui.get_page_title());
		//}
		//stderr.printf("pop_page() finished!\n");
	}


	public void push_page(owned Page obj) {
		
		obj.naviframe_back = new Elm.Button(ui.pager);
		obj.naviframe_back.text_set("Back");
		obj.naviframe_back.size_hint_weight_set(1.0, 1.0);
		obj.naviframe_back.size_hint_align_set(-1.0, -1.0);
		obj.naviframe_back.smart_callback_add("clicked", obj.close);
		
		unowned Elm.Object? page = obj.get_page();
		if(page!=null) {
			
			string title = obj.get_page_title();
			if(title!=null)
				win.title_set("Etalk - "+title);
				
			pager.item_push(title, obj.naviframe_back, null, page, null);
		
		} else 
			logger.error("EtalkUI", "push_page(): pager.content_push(NULL)!!!");
		
		page_stack.prepend((owned) obj);
	}
	
	
	public void refresh_page_with_id(PageID id) {
		
		//first handle special cases: main and sessions UI are there,
		// even if they are not in the stack
		switch(id) {
			case PageID.LIST_SESSION:
				ui.sui.refresh_content();
				break;
			
			case PageID.MAIN:
				ui.sui.refresh_content();
				break;
			
			default:
				List<Page> l = get_page_by_id(id);
				foreach(var p in l) {
					p.refresh_content();
				}
				break;
		}
	}
	
	private List<Page> get_page_by_id(PageID id) {
		
		unowned List<Page> l = page_stack;
		List<Page> ret = new List<Page>();
		
		while(l!=null) {
			//stderr.printf("iterating over page: "+l.data.get_page_id()+"\n");
			if( id == l.data.get_page_id() )
				ret.prepend(l.data);
			l = l.next;
		} 
		
		return ret;
	}
	
	private string? get_last_title() {
		
		string title;
		unowned List<Page> l = page_stack;
		
		while(l!=null) {
			title = l.data.get_page_title();
			if(title!=null) return title;
			l = l.next;
		} 
		
		return null;
		
	}

}

/* PAGE: all UIs inherit from this, and is used by EtalkUI */
public abstract class Page : Object {
	
	protected Elm.Box vbox;
	public Elm.Button naviframe_back;
	
	public Page() {
		vbox = null;
	}
	
	public unowned Elm.Object? get_page() {
		return vbox;
	}
	
	public void close() {
		ui.pop_page(this);
	}
	
	public async abstract void refresh_content();
	
	public abstract PageID get_page_id();
	
	public abstract string? get_page_title();
	
}


	/* PIN DIALOG */
public class DialogUI : Object {	
	
	Elm.Win inwin;
	Elm.Box vbox;
	Elm.Box vbox_in;
	Elm.Anchorblock lb;
	Elm.Button bt_ok;
	Elm.Scroller sc;
	
	public void create(string text) {
		this.ref(); //let it be unless someone presses the kill button
		
		inwin = ui.win.inwin_add();
		inwin.show();
		
		vbox = new Elm.Box(ui.win);
		inwin.inwin_content_set(vbox);
		vbox.show();
		
		sc = new Elm.Scroller(ui.win);
		sc.size_hint_weight_set(1.0, 1.0);
		sc.size_hint_align_set(-1.0, -1.0);
		sc.bounce_set(false, true);
		vbox.pack_end(sc);
		sc.show();
		
		vbox_in = new Elm.Box(ui.win);
		vbox_in.size_hint_align_set(-1.0, -1.0);
		vbox_in.size_hint_weight_set(1.0, 1.0);
		sc.content_set(vbox_in);
		vbox_in.show();
		
		// add a label
		lb = new Elm.Anchorblock(ui.win);
		lb.text_set(text);
		lb.size_hint_weight_set(1.0, 1.0);
		lb.size_hint_align_set(-1.0, -1.0);
		vbox_in.pack_end(lb);
		lb.show();
		
		bt_ok = new Elm.Button(ui.win);
		bt_ok.text_set("Ok");
		bt_ok.size_hint_align_set(-1.0, -1.0);
		bt_ok.size_hint_weight_set(1.0, 0.0);
		vbox_in.pack_end(bt_ok);
		bt_ok.show();
		bt_ok.smart_callback_add("clicked", () => { this.close(); } );
		
			
	}
	
	public void close() {
		logger.debug("DialogUI", "Closing Dialog window");
		//win.del();
		this.unref();
	}
}

	

public class LabelBox {
	
	private Elm.Label lb;
	private Elm.Label val;
	private Elm.Box box;
	
	public LabelBox(Elm.Win win, Elm.Box parent, string label, string Value) {
		
		box = new Elm.Box(win);
		box.horizontal_set(true);
		box.size_hint_align_set(0.0, 0.0);	
		parent.pack_end(box);
		
		lb = new Elm.Label(win);
		lb.text_set("<b>"+label+":</b>");
		box.pack_end(lb);
		
		val = new Elm.Label(win);
		val.text_set(Value);
		box.pack_end(val);
		
	}
	
	public void show() {
		box.show();
		lb.show();
		val.show();
	}
	
	public string val_get() {
		return this.val.text_get();
	}
	public void val_set(string Value) {
		this.val.text_set(Value);
	}
	
}

public class EntryBox {
	
	private Elm.Label lb;
	public Elm.Entry val;
	private Elm.Frame fr;
	private Elm.Box box;
	
	public EntryBox(Elm.Win win, Elm.Box parent, string label, string Value) {
		
		box = new Elm.Box(win);
		box.horizontal_set(true);
		box.size_hint_weight_set(1.0, 0.0);
        box.size_hint_align_set(-1.0, 0.0);
		parent.pack_end(box);
		
		lb = new Elm.Label(win);
		lb.text_set("<b>"+label+":</b>");
		box.pack_end(lb);
		
		fr = new Elm.Frame(win);
        fr.size_hint_align_set(-1.0, 0.0);
        fr.size_hint_weight_set(1.0, 0.0);
        fr.style_set("outdent_top");
        box.pack_end(fr);
		
		val = new Elm.Entry(win);
		val.size_hint_align_set(-1.0, 0.0);
        val.size_hint_weight_set(1.0, 0.0);
        val.single_line_set(true);
		val.entry_set(Value);
		fr.content_set(val);
		
	}
	
	public void show() {
		box.show();
		lb.show();
		fr.show();
		val.show();
	}
	
	public string val_get() {
		return this.val.entry_get();
	}
	public void val_set(string Value) {
		this.val.entry_set(Value);
	}
	
}



public class FrameBox {
	
	public Elm.Frame fr;
	public Elm.Box box;
	
	public FrameBox(Elm.Win win, Elm.Box parent, string label) {
		
		fr = new Elm.Frame(win);
		fr.text_set(label);
        fr.size_hint_align_set(-1.0, 0.0);
        fr.size_hint_weight_set(1.0, 0.0);
        parent.pack_end(fr);
		
		box = new Elm.Box(win);
		box.size_hint_weight_set(1.0, 0.0);
        box.size_hint_align_set(-1.0, 0.0);
		fr.content_set(box);
		
	}
	
	public void show() {
		box.show();
		fr.show();
	}
	
}


public abstract class ListItemHandler : Object {
	
	public Elm.ListItem item;
	public Elm.Icon icon;
	public static unowned Elm.Win win;
	
	
	public ListItemHandler(Elm.Win win) {
		this.win = win;
	}
	
	
	public void go () { 
		this.item.selected_set(false);
		open_rdevice_page(); 
	}
	
	public abstract void refresh_content();
		/*item.label_set(format_item_label(rdevice));
		icon = gen_icon(rdevice.online ? "online" : "offline" );
		item.icon_set(icon);*/
	
	public abstract string format_item_label();
	/*
	private static Elm.Icon gen_icon(string name) {
		
		var ic = new Elm.Icon(win);
		ic.file_set(Path.build_filename(IMAGESDIR,name+".png"));
		ic.scale_set(true, true);
		ic.fill_outside_set(true);
		ic.show();
		return ic;
	}
*/
	protected abstract void open_rdevice_page();
	
}



