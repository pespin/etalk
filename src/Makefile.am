AUTOMAKE_OPTIONS     = 1.4 foreign
MAINTAINERCLEANFILES = Makefile.in

INCLUDES = -I$(top_srcdir) @ETALK_CFLAGS@
AM_CPPFLAGS = "-DIMAGESDIR=\"$(datadir)/etalk/images\""

bin_PROGRAMS      = etalk

etalk_SOURCES = \
	main.vala \
	shared.vala \
	et_account_manager.vala \
	et_account.vala \
	et_channel.vala \
	et_clients.vala \
	et_connection.vala \
	et_contact.vala \
	fso.vala \
	gui.vala \
	gui_list_account.vala \
	gui_main.vala \
	gui_settings_account.vala \
	telepathy_gdbus_interfaces.vala \
	telepathy_gdbus_aux.vala



etalk_LDADD = @ETALK_LIBS@
etalk_CFLAGS =
VALAFLAGS = @ETALK_PACKAGES@ @ETALK_VALAFLAGS@
 
