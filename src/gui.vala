

public class EtalkUI {
	
		public Elm.Win win;
		
		public unowned Elm.Naviframe? pager;

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
			
			unowned Elm.Bg? bg = Elm.Bg.add(win);
			bg.size_hint_weight_set( 1.0, 1.0 );
			bg.show();
			win.resize_object_add(bg);
			
			win.resize( DISPLAY_WIDTH, DISPLAY_HEIGHT );
			
			pager = Elm.Naviframe.add( win );
			win.resize_object_add( pager );
			pager.size_hint_weight_set( 1.0, 1.0 );
			pager.content_preserve_on_pop_set(true);
			pager.show();
			
			mui = new MainUI();
			sui = new ListSessionUI();
			unowned Elm.Object page;
			page = mui.create(win);
			win.title_set("Etalk - "+mui.get_page_title());
			unowned Elm.NaviframeItem? nitem;
			nitem = pager.item_push(mui.get_page_title(), null, null, page, null);
			nitem.data_set(mui);
			sui.create(win);
			
			win.show();
	
	}
	
	public void pop_page(Page page) {
		//stderr.printf("pop_page(%s) started!\n", page.get_page_title());
		//if( obj == pager.content_top_get() ) { //this segfaults...
			pager.item_pop();
			page_stack.remove(page);

			Page top_page = (Page) pager.top_item_get().data_get();
			win.title_set("Etalk - "+top_page.get_page_title());
			top_page.on_appear();
		//}
		//stderr.printf("pop_page() finished!\n");
	}


	public void push_page(owned Page obj) {
		
		unowned Elm.Object? page = obj.get_page();
		if(page!=null) {
			
			string title = obj.get_page_title();
			if(title!=null)
				win.title_set("Etalk - "+title);
			unowned Elm.NaviframeItem? nitem;
			nitem = pager.item_push(title, obj.get_button_back(), obj.get_button_next(), page, null);
			nitem.data_set(obj);
			obj.on_appear();
		
		} else 
			logger.error("EtalkUI", "push_page(): pager.content_push(NULL)!!!");
		
		page_stack.prepend((owned) obj);
	}

}

/* PAGE: all UIs inherit from this, and is used by EtalkUI */
public abstract class Page : Object {
	
	protected unowned Elm.Box? vbox;
	public unowned Elm.Button? naviframe_back;
	public unowned Elm.Button? naviframe_next;
	public Page() {
		vbox = null;
		naviframe_back = null;
		naviframe_next = null;
	}
	
	~Page() {
		logger.debug("Page", "Page destructor called");
	}
	
	public unowned Elm.Object? get_page() {
		return vbox;
	}
	
	public void close() {
		ui.pop_page(this);
	}
	
	public abstract string? get_page_title();
	
	public unowned Elm.Button? get_button_back(){
		
		naviframe_back = Elm.Button.add(ui.pager);
		naviframe_back.text_set("Back");
		naviframe_back.size_hint_weight_set(1.0, 1.0);
		naviframe_back.size_hint_align_set(-1.0, -1.0);
		naviframe_back.smart_callback_add("clicked", this.close);
		return naviframe_back;
	}
	public abstract unowned Elm.Button? get_button_next();

	//This method is called by the pager on the page which is on top (is ivisible to the user therefore).
	public abstract void on_appear();
	
}


	/* PIN DIALOG */
public class DialogUI : Object {	
	
	public void create(string text) {
		this.ref(); //let it be unless someone presses the kill button
		
		unowned Elm.Win? inwin;
		unowned Elm.Box? vbox;
		unowned Elm.Box? vbox_in;
		unowned Elm.Anchorblock? lb;
		unowned Elm.Button? bt_ok;
		unowned Elm.Scroller? sc;
		
		inwin = ui.win.inwin_add();
		inwin.show();
		
		vbox = Elm.Box.add(ui.win);
		inwin.inwin_content_set(vbox);
		vbox.show();
		
		sc = Elm.Scroller.add(ui.win);
		sc.size_hint_weight_set(1.0, 1.0);
		sc.size_hint_align_set(-1.0, -1.0);
		sc.bounce_set(false, true);
		vbox.pack_end(sc);
		sc.show();
		
		vbox_in = Elm.Box.add(ui.win);
		vbox_in.size_hint_align_set(-1.0, -1.0);
		vbox_in.size_hint_weight_set(1.0, 1.0);
		sc.content_set(vbox_in);
		vbox_in.show();
		
		// add a label
		lb = Elm.Anchorblock.add(ui.win);
		lb.text_set(text);
		lb.size_hint_weight_set(1.0, 1.0);
		lb.size_hint_align_set(-1.0, -1.0);
		vbox_in.pack_end(lb);
		lb.show();
		
		bt_ok = Elm.Button.add(ui.win);
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
	
	private unowned Elm.Label? lb;
	private unowned Elm.Label? val;
	private unowned Elm.Box? box;
	
	public LabelBox(Elm.Win win, Elm.Box parent, string label, string Value) {
		
		box = Elm.Box.add(win);
		box.horizontal_set(true);
		box.size_hint_align_set(0.0, 0.0);	
		parent.pack_end(box);
		
		lb = Elm.Label.add(win);
		lb.text_set("<b>"+label+":</b>");
		box.pack_end(lb);
		
		val = Elm.Label.add(win);
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
	
	private unowned Elm.Label? lb;
	public unowned Elm.Entry? val;
	private unowned Elm.Frame? fr;
	private unowned Elm.Box? box;
	
	public EntryBox(Elm.Win win, Elm.Box parent, string label, string Value) {
		
		box = Elm.Box.add(win);
		box.horizontal_set(true);
		box.size_hint_weight_set(1.0, 0.0);
        box.size_hint_align_set(-1.0, 0.0);
		parent.pack_end(box);
		
		lb = Elm.Label.add(win);
		lb.text_set("<b>"+label+":</b>");
		box.pack_end(lb);
		
		fr = Elm.Frame.add(win);
        fr.size_hint_align_set(-1.0, 0.0);
        fr.size_hint_weight_set(1.0, 0.0);
        fr.style_set("outdent_top");
        box.pack_end(fr);
		
		val = Elm.Entry.add(win);
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
	
	public unowned Elm.Frame? fr;
	public unowned Elm.Box? box;
	
	public FrameBox(Elm.Win win, Elm.Box parent, string label) {
		
		fr = Elm.Frame.add(win);
		fr.text_set(label);
        fr.size_hint_align_set(-1.0, 0.0);
        fr.size_hint_weight_set(1.0, 0.0);
        parent.pack_end(fr);
		
		box = Elm.Box.add(win);
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
	
	public unowned Elm.GenlistItem? item;
	//public unowned Elm.Icon? icon;
	public static unowned Elm.Win win;
	
	
	public ListItemHandler(Elm.Win win) {
		this.win = win;
	}
	
	public void refresh_content() {
		this.item.update();
	}
	
	
	public void go () { 
		this.item.selected_set(false);
		open_elem_page();
	}
	
	public abstract string format_item_label();

	protected abstract void open_elem_page();
	
}



