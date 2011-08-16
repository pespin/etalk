/* Generated by vala-dbus-binding-tool 0.3.3. Do not modify! */
/* Generated with: vala-dbus-binding-tool -v -v -v --gdbus --no-synced --directory=. --strip-namespace=tp */
using GLib;

namespace org {

	namespace freedesktop {

		namespace Telepathy {

			namespace Call {

				namespace Stream {

					[DBus (name = "org.freedesktop.Telepathy.Call.Stream.DRAFT", timeout = 120000)]
					public interface DRAFT : GLib.Object {

						[DBus (name = "SetSending")]
						public abstract void set_sending(bool Send) throws DBusError, IOError;

						[DBus (name = "RequestReceiving")]
						public abstract void request_receiving(uint Contact, bool Receive) throws DBusError, IOError;

						[DBus (name = "RemoteMembersChanged")]
						public signal void remote_members_changed(GLib.HashTable<uint, uint> Updates, uint[] Removed);

						[DBus (name = "LocalSendingStateChanged")]
						public signal void local_sending_state_changed(uint State);
					}
				}
			}
		}
	}
}
