# Simple Makefile for FIFO UVM Test

# Paths - UPDATED FOR YOUR SETUP
PROJECT_HOME := /home/hassan-ul-haq/UVM/UVM_Verification_Shelf
UVM_HOME := $(PROJECT_HOME)/uvm-1.2

# Source directories - UPDATED FOR YOUR SETUP
DESIGN_DIR := $(PROJECT_HOME)/design
UVM_TB_DIR := $(PROJECT_HOME)/verif/uvm_tb
VLIB_DIR := $(PROJECT_HOME)/verif/vlib

# Source files - UPDATED FOR YOUR FILENAMES
DUT_SRC := $(DESIGN_DIR)/FIFO.sv
INTF_SRC := $(UVM_TB_DIR)/interface/fifo_intf.sv  # ← ADDED THIS LINE
PKG_SRC := $(UVM_TB_DIR)/package/package.sv
TOP_SRC := $(VLIB_DIR)/fifo_tb.sv

# Test name
TEST_NAME ?= simple_test
USR_OPT ?=

# QuestaSim commands
compile:
	vlib work
	vlog -sv +incdir+$(UVM_HOME)/src \
	      +incdir+$(UVM_TB_DIR) \
	      +incdir+$(UVM_TB_DIR)/interface \
	$(UVM_HOME)/src/uvm_pkg.sv \
	$(DUT_SRC) $(INTF_SRC) $(PKG_SRC) $(TOP_SRC) -l compile.log  # ← ADDED $(INTF_SRC)

run:
	vsim -c -sv_lib /home/hassan-ul-haq/UVM/UVM_Verification_Shelf/uvm-1.2/lib/uvm_dpi -do "run -all; quit" fifo_tb +UVM_TESTNAME=$(TEST_NAME) $(USR_OPT) -l $(TEST_NAME).log

# Combined compile and run
all: compile run

clean:
	rm -rf work compile.log *.log transcript vsim.wlf

help:
	@echo "Usage:"
	@echo "  make all      - Compile and run simulation"
	@echo "  make compile  - Compile only"
	@echo "  make run      - Run simulation"
	@echo "  make clean    - Clean generated files"
