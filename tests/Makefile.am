MAINTAINERCLEANFILES = Makefile.in

VALAFLAGS = @ETALK_PACKAGES@ @ETALK_VALAFLAGS@

noinst_PROGRAMS = $(TEST_PROGS)

progs_ldadd = $(DEPS_LIBS)

TP_GDBUS = 	telepathy_gdbus_interfaces.vala telepathy_gdbus_aux.vala

INCLUDES = -I$(top_srcdir) @ETALK_CFLAGS@

#
# contacts_info
#
TEST_PROGS = contactsinfo
contactsinfo_SOURCES = contacts_info.vala $(TP_GDBUS)
contactsinfo_LDADD = $(progs_ldadd) @ETALK_LIBS@
EXTRA_DIST = $(contactsinfo_VALASOURCES)


