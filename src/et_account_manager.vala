namespace Et {

	public class AccountManager : GLib.Object {

		private Telepathy.AccountManager acm;

		public Telepathy.AccountManager dbus {get { return acm; } }
		
		public HashTable<string,Account> accounts;
		
		public AccountManager() {
			
			accounts = new HashTable<string,Account>(str_hash, str_equal);
		
			try {
				acm = Bus.get_proxy_sync (BusType.SESSION, Telepathy.ACCOUNT_MANAGER_BUS_NAME, Telepathy.ACCOUNT_MANAGER_OBJECT_PATH);
				acm.account_removed.connect(sig_account_removed);
				acm.account_validity_changed.connect(sig_account_validity_changed);
			} catch ( IOError err ) {	
				stderr.printf("AccountManager(): Could not create AccountManager with path %s: %s\n", Telepathy.ACCOUNT_MANAGER_OBJECT_PATH, err.message);
			}
			
			//fill the accounts hash table
			this.update_accounts();
			
		}
		
		
		public void update_accounts() {
			foreach(var acc_path in acm.valid_accounts) {
				stderr.printf("AccountManager: Account %s requested\n", acc_path);
				Account acc = new Account(acc_path);
				accounts.insert(acc_path, (owned) acc);
			}
			
		}
		
		
		public void show_accounts(ListAccountUI laui) {
		
				foreach(var acc in accounts.get_values()) {
						laui.add_elem_to_ui(acc);
				}
			
		}
		
		
		public void sig_account_removed(GLib.ObjectPath acc_path) {
			stderr.printf("AccountManager: sig_account_removed (%s)\n", acc_path);
			accounts.remove(acc_path);
			ui.refresh_page_with_id(PageID.LIST_ACCOUNT);
			
		}

		public void sig_account_validity_changed(GLib.ObjectPath acc_path, bool valid) {
			stderr.printf("AccountManager: sig_account_validity_changed (valid = %s) (%s)\n", valid.to_string(), acc_path);			
			if(accounts.lookup(acc_path)==null) {
				Account acc = new Account(acc_path);
				accounts.insert(acc_path, (owned) acc);
			}
			
			ui.refresh_page_with_id(PageID.LIST_ACCOUNT);
		}
		
	}


}
