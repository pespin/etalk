/* Generated by vala-dbus-binding-tool 0.3.3. Do not modify! */
/* Generated with: vala-dbus-binding-tool -v -v -v --gdbus --no-synced --directory=. --strip-namespace=tp */
using GLib;

namespace org {

	namespace freedesktop {

		namespace Telepathy {

			namespace Call {

				namespace Content {

					namespace Interface {

						namespace VideoControl {

							[DBus (name = "org.freedesktop.Telepathy.Call.Content.Interface.VideoControl.DRAFT", timeout = 120000)]
							public interface DRAFT : GLib.Object {

								[DBus (name = "KeyFrameRequested")]
								public signal void key_frame_requested();

								[DBus (name = "VideoResolutionChanged")]
								public signal void video_resolution_changed(DRAFTNewResolutionStruct NewResolution);

								[DBus (name = "BitrateChanged")]
								public signal void bitrate_changed(uint NewBitrate);

								[DBus (name = "FramerateChanged")]
								public signal void framerate_changed(uint NewFramerate);

								[DBus (name = "MTUChanged")]
								public signal void m_t_u_changed(uint NewMTU);
							}
						}
					}
				}
			}
		}
	}
}
