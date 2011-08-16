namespace Et {

	public class AccountManager : GLib.Object {

		private Telepathy.AccountManager acm;

		public Telepathy.AccountManager dbus {get { return acm; } }
		
		public HashTable<string,Account> accounts;
		
		public AccountManager() {
			
			accounts = new HashTable<string,Account>(str_hash, str_equal);
		
			try {
				acm = Bus.get_proxy_sync (BusType.SESSION, Telepathy.ACCOUNT_MANAGER_BUS_NAME, Telepathy.ACCOUNT_MANAGER_OBJECT_PATH);
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


		/* TODO: connect to signals remove and validitychanged */

	}


}
