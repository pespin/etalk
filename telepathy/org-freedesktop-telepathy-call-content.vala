/* Generated by vala-dbus-binding-tool 0.3.3. Do not modify! */
/* Generated with: vala-dbus-binding-tool -v -v -v --gdbus --no-synced --directory=. --strip-namespace=tp */
using GLib;

namespace org {

	namespace freedesktop {

		namespace Telepathy {

			namespace Call {

				namespace Content {

					[DBus (name = "org.freedesktop.Telepathy.Call.Content.DRAFT", timeout = 120000)]
					public interface DRAFT : GLib.Object {

						[DBus (name = "Remove")]
						public abstract void remove(uint Reason, string Detailed_Removal_Reason, string Message) throws DBusError, IOError;

						[DBus (name = "Removed")]
						public signal void removed();

						[DBus (name = "StreamsAdded")]
						public signal void streams_added(GLib.ObjectPath[] Streams);

						[DBus (name = "StreamsRemoved")]
						public signal void streams_removed(GLib.ObjectPath[] Streams);
					}
				}
			}
		}
	}
}
