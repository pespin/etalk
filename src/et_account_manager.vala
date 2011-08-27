namespace Et {

	public class AccountManager : GLib.Object {

		private Telepathy.AccountManager acm;

		public Telepathy.AccountManager dbus {get { return acm; } }
		
		public HashTable<string,Account> accounts;
		
		public AccountManager() {
			
			accounts = new HashTable<string,Account>(str_hash, str_equal);
		
			try {
				acm = Bus.get_proxy_sync (BusType.SESSION, Telepathy.ACCOUNT_MANAGER_BUS_NAME, Telepathy.ACCOUNT_MANAGER_OBJECT_PATH, DBusProxyFlags.DO_NOT_LOAD_PROPERTIES);
				acm.account_removed.connect(sig_account_removed);
				acm.account_validity_changed.connect(sig_account_validity_changed);
			} catch ( IOError err ) {	
				logger.error("AccountManager", "Could not create AccountManager with path "+Telepathy.ACCOUNT_MANAGER_OBJECT_PATH+": "+err.message);
			}
			
		}
		
		
		public void update_accounts() {
			foreach(var acc_path in acm.valid_accounts) {
				logger.debug("AccountManager", "Account "+acc_path.to_string()+" requested");
				Account acc = new Account(acc_path);
				accounts.insert(acc_path, (owned) acc);
			}
			
		}
		
		
		public void show_accounts(ListAccountUI laui) {
				
				HashTableIter<string,Account> it = HashTableIter<string,Account>(accounts);
				unowned string? path;
				unowned Account? acc;
				while(it.next(out path, out acc)) {
					laui.add_elem_to_ui(acc);
				}
			
		}
		
		
		public void sig_account_removed(GLib.ObjectPath acc_path) {
			logger.debug("AccountManager",  "sig_account_removed ("+acc_path.to_string()+")");
			accounts.remove(acc_path);
			ui.refresh_page_with_id(PageID.LIST_ACCOUNT);
			
		}

		public void sig_account_validity_changed(GLib.ObjectPath acc_path, bool valid) {
			logger.debug("AccountManager", "sig_account_validity_changed (valid = "+valid.to_string()+") ("+acc_path.to_string()+")");			
			if(accounts.lookup(acc_path)==null) {
				Account acc = new Account(acc_path);
				accounts.insert(acc_path, (owned) acc);
			}
			
			ui.refresh_page_with_id(PageID.LIST_ACCOUNT);
		}
		
	}


}
