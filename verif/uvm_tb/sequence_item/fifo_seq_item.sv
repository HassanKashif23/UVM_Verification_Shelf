//===========FIFO Sequence item==========//

class fifo_seq_item  extends uvm_sequence_item;

// Data members
rand bit [7:0] rd_data;
rand bit [7:0] wr_data;
rand bit       rd_en;
rand bit       wr_en;
rand bit       rst;
rand bit       full;
rand bit       empty;
fifo_config    cfg;

// Constructor
function new(string name = "fifo_seq_item");
    super.new(name);
endfunction

`uvm_object_utils_begin(fifo_seq_item)
    `uvm_field_int(wr_data, UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(rd_en, UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(wr_en, UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(full, UVM_ALL_ON)
    `uvm_field_int(empty, UVM_ALL_ON)
    `uvm_field_int(rd_data, UVM_ALL_ON|UVM_NOCOMPARE)
`uvm_object_utils_end

//=======create a copy of the sequence item========//
function fifo_seq_item clone();
    fifo_seq_item item;
    $cast(item, super.clone());
    return item;
endfunction

//=========Display function to print the sequence item========//

virtual function void display_item(string name);
    string msg;

    msg = $sformatf(" \n This is being displayed from %s: \n", name);
    msg = {msg, $sformatf("==================================================\n")};
    msg = {msg, $sformatf("Write Data : %0h \n", wr_data)};
    msg = {msg, $sformatf("Read Enable : %0b \n", rd_en)};
    msg = {msg, $sformatf("Write Enable : %0b \n", wr_en)};
    msg = {msg, $sformatf("Full : %0b \n", full)};
    msg = {msg, $sformatf("Empty : %0b \n", empty)};
    msg = {msg, $sformatf("Read Data : %0h \n", rd_data)};
    msg = {msg, $sformatf("==================================================\n")};
    `uvm_info(name, msg, UVM_MEDIUM)
endfunction

endclass 