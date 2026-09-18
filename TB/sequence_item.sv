class fifo_packet extends uvm_sequence_item;

  rand bit is_write;
  rand bit [3:0] txn_id;
  rand bit [31:0] addr;
  rand bit [3:0] len;
  rand bit [2:0] size;
  rand bit [1:0] burst;
  rand bit [1:0] lock;
  rand bit [1:0] cache;
  rand bit [2:0] prot;
  rand bit [3:0] strobe;
  rand bit [1023:0] data;

  `uvm_object_utils_begin(fifo_packet)
    `uvm_field_int(is_write, UVM_ALL_ON)
    `uvm_field_int(txn_id,   UVM_ALL_ON)
    `uvm_field_int(addr,     UVM_ALL_ON)
    `uvm_field_int(len,      UVM_ALL_ON)
    `uvm_field_int(size,     UVM_ALL_ON)
    `uvm_field_int(burst,    UVM_ALL_ON)
    `uvm_field_int(lock,     UVM_ALL_ON)
    `uvm_field_int(cache,    UVM_ALL_ON)
    `uvm_field_int(prot,     UVM_ALL_ON)
    `uvm_field_int(strobe,   UVM_ALL_ON)
    `uvm_field_int(data,     UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "fifo_packet");
    super.new(name);
  endfunction

endclass
