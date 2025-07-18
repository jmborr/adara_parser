#
# *** Simple ADARA Parser ***
# 
# SNS ADARA SYSTEM
# 
# This repository contains the software for the next-generation Data
# Aquisition System (DAS) at the Spallation Neutron Source (SNS) at
# Oak Ridge National Laboratory (ORNL) -- "ADARA".
# 
# ADARA stands for "Accelerating Data Acquisition, Reduction, and
# Analysis" and is a collaborative project between the SNS and ORNL's
# Computing and Computational Sciences Directorate (CCSD) to develop
# "next-generation" software and hardware components for SNS data
# acquisition. The goal of ADARA is to provide real time (streaming) data
# acquisition and data analysis system(s) for SNS that will ultimately
# provide the researchers using the SNS beam lines with effectively
# instant access to their reduced experimental data both during, and
# after, data collection.
# 
# The main ADARA software infrastructure contains the following key
# software components:
# 
#    * "Stream Management Service (SMS)" for collecting and collating
#    neutron pulse and event data from detector system preprocessors, as
#    well as Process Variables (PVs) from the beamline Slow Controls and
#    Sample Environment subsystems, and producing a hybrid streaming
#    network protocol that combines these data along with run-time
#    experiment/run meta-data;
# 
#    * "Streaming Translation Client (STC)" receives the live data
#    stream from the SMS and applies it to produce live NeXus Event
#    files, available immediately upon completion of a given
#    experimental run, for reduction and analysis;
# 
#    * ""PVStreamer"" service collects the values and status of
#    Slow Controls and Sample Environment Process Variables
#    (PVs) and delivers them to the SMS for inclusion in the
#    hybrid network protocol stream;
# 
#    * "Post-Processing and Reduction" service is notified
#    when the STC completes the generation of the NeXus
#    Event file, and proceeds to apply pre-defined data
#    post-processing and reduction operations, customizable
#    on a per-beamline basis, and then archives and catalogs
#    the resulting data files.
# 
# There is also an ADARA Test Harness for building and testing various
# ADARA software components, using historical SNS experiment data. This
# Test Harness can be used for Manual Testing as well as regular
# Integration Testing via the Jenkins Test and Build system.
# 
# Copyright (c) 2015, UT-Battelle LLC
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 

PROG = adara-parser

CXX = g++

CXXFLAGS = -Wall -Wextra -Werror -Winit-self -Wpointer-arith \
		-Wcast-align -Woverloaded-virtual -Wno-missing-field-initializers \
        -Wunused-but-set-variable -Wunused-but-set-parameter

CXXLINK = $(CXX) $(CXXFLAGS) -o $@

CPPFLAGS = -Iinclude

LDADD = -lboost_program_options

BUILDDIR = _build
SRCDIR = src
INCDIR = include
SOURCES = $(wildcard $(SRCDIR)/*.cc)
OBJECTS = $(patsubst $(SRCDIR)/%.cc,$(BUILDDIR)/%.o,$(SOURCES))

# Google Test setup
GTEST_DIR = $(BUILDDIR)/googletest
GTEST_REPO = https://github.com/google/googletest.git
GTEST_LIB = $(GTEST_DIR)/build/lib/libgtest.a
GTEST_INC = $(GTEST_DIR)/googletest/include

# Test sources
UNIT_TEST_SOURCES = $(wildcard tests/unit/*.cc)
UNIT_TEST_OBJECTS = $(patsubst tests/unit/%.cc,$(BUILDDIR)/unit_%.o,$(UNIT_TEST_SOURCES))
UNIT_TEST_BIN = $(BUILDDIR)/unit_tests

# Download and build Google Test if not present
$(GTEST_LIB):
	@if [ ! -d $(GTEST_DIR) ]; then \
	  git clone --depth 1 $(GTEST_REPO) $(GTEST_DIR); \
	fi
	cd $(GTEST_DIR) && cmake -S googletest -B build && cmake --build build --target gtest

# Build unit test objects
$(BUILDDIR)/unit_%.o: tests/unit/%.cc | $(BUILDDIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -I$(GTEST_INC) -c $< -o $@

# Build unit test binary
$(UNIT_TEST_BIN): $(UNIT_TEST_OBJECTS) $(OBJECTS) $(GTEST_LIB)
	$(CXX) $(CXXFLAGS) -I$(GTEST_INC) $^ -lpthread -o $@

all: $(BUILDDIR) $(BUILDDIR)/$(PROG)

$(BUILDDIR):
	@mkdir -p $(BUILDDIR)

$(BUILDDIR)/$(PROG): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDADD)

$(BUILDDIR)/%.o: $(SRCDIR)/%.cc | $(BUILDDIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# Run unit tests
.PHONY: test

test: $(UNIT_TEST_BIN)
	./$(UNIT_TEST_BIN)

clean:
	rm -rf $(BUILDDIR)
