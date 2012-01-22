namespace Et {

	public class AccountManager : GLib.Object {
		private static const string DOMAIN = "AccountManager";

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
				logger.error(DOMAIN, "Could not create AccountManager with path "+Telepathy.ACCOUNT_MANAGER_OBJECT_PATH+": "+err.message);
			}
			
		}
		
		
		public void stop() {
			if(SETM.set_offline_on_close)
				simple_presence_set_all(Telepathy.ConnectionPresenceType.OFFLINE, "Client exited.");
		}

		public void simple_presence_set_all(Telepathy.ConnectionPresenceType ptype, string? status_message=null, string? status=null) {

			logger.debug(DOMAIN, "Setting all accounts presence to "+ptype.to_string());

			HashTableIter<string,Account> it = HashTableIter<string,Account>(accounts);
				unowned string? path;
				unowned Account? acc;
				while(it.next(out path, out acc)) {
					acc.simple_presence_set(ptype, status_message, status);
				}
		}


		public void update_accounts() {
			foreach(var acc_path in acm.valid_accounts) {
				logger.debug(DOMAIN, "Account "+acc_path.to_string()+" requested");
				Account acc = new Account(acc_path);
				accounts.insert(acc_path, (owned) acc);
			}
			
		}


		public List<weak Account> get_accounts() {
				return accounts.get_values();
		}
		
		
		public void fetch_contacts() {
				HashTableIter<string,Account> it = HashTableIter<string,Account>(accounts);
				unowned string? path;
				unowned Account? acc;
				while(it.next(out path, out acc)) {
					if(acc==null || acc.connection.is_valid==false) continue;
					acc.connection.update_contacts();
				}
			
		}
		
		
		private void sig_account_removed(GLib.ObjectPath acc_path) {
			logger.debug(DOMAIN,  "sig_account_removed ("+acc_path.to_string()+")");
			accounts.remove(acc_path);
			this.account_removed(acc_path.to_string());
		}

		private void sig_account_validity_changed(GLib.ObjectPath acc_path, bool valid) {
			logger.debug(DOMAIN, "sig_account_validity_changed (valid = "+valid.to_string()+") ("+acc_path.to_string()+")");			
			if(accounts.lookup(acc_path)==null) {
				Account acc = new Account(acc_path);
				accounts.insert(acc_path, (owned) acc);
			}
			
			this.account_updated(accounts.lookup(acc_path));
			
		}
		
		public signal void account_updated(Account c);
		public signal void account_removed(string key);
		
	}


}
