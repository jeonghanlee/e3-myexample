#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : Jeong Han Lee
# email   : jeonghan.lee@gmail.com
# Date    : Saturday, January 12 01:27:46 CET 2019
# version : 0.0.1
#
## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS


ifneq ($(strip $(SEQUENCER_DEP_VERSION)),)
sequencer_VERSION=$(SEQUENCER_DEP_VERSION)
endif



## Exclude linux-ppc64e6500
EXCLUDE_ARCHS = linux-ppc64e6500


APP:=myexampleApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

TEMPLATES += $(wildcard $(APPDB)/*.db)


SOURCES += $(APPSRC)/dbSubExample.c
SOURCES += $(APPSRC)/myexampleHello.c
SOURCES += $(APPSRC)/initTrace.c
SOURCES += $(APPSRC)/devXxxSoft.c

SOURCES += $(APPSRC)/sncExample.stt


DBDS += $(APPSRC)/xxxSupport.dbd
DBDS += $(APPSRC)/dbSubExample.dbd
DBDS += $(APPSRC)/myexampleHello.dbd
DBDS += $(APPSRC)/initTrace.dbd
DBDS += $(APPSRC)/sncExample.dbd

#


## xxxRecord.dbd Local Codes 
DBDINC_SUFF = c
DBDINC_PATH = $(APPSRC)
DBDINC_SRCS = $(DBDINC_PATH)/xxxRecord.$(DBDINC_SUFF)

## xxxRecord.dbd Generic Codes : BEGIN
DBDINC_DBDS = $(subst .$(DBDINC_SUFF),.dbd,   $(DBDINC_SRCS:$(DBDINC_PATH)/%=%))
DBDINC_HDRS = $(subst .$(DBDINC_SUFF),.h,     $(DBDINC_SRCS:$(DBDINC_PATH)/%=%))
DBDINC_DEPS = $(subst .$(DBDINC_SUFF),$(DEP), $(DBDINC_SRCS:$(DBDINC_PATH)/%=%))

HEADERS += $(DBDINC_HDRS)
SOURCES += $(DBDINC_SRCS)

$(DBDINC_DEPS): $(DBDINC_HDRS)

.dbd.h:
	$(DBTORECORDTYPEH)  $(USR_DBDFLAGS) -o $@ $<

.PHONY: $(DBDINC_DEPS) .dbd.h
## Record.dbd Generic codes : END


SCRIPTS += $(wildcard ../iocsh/*.iocsh)


USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)

db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)

vlibs:

.PHONY: vlibs



