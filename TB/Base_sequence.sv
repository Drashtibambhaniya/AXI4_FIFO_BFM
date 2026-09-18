class base_sequence extends uvm_sequence #(fifo_packet);

  `uvm_object_utils(base_sequence)

  function new(string name = "base_sequence");
    super.new(name);
  endfunction

  task body();

    fifo_packet req;

    req = fifo_packet::type_id::create("req");

    start_item(req);

    req.is_write = 1;
    req.txn_id   = 4'h1;
    req.addr     = 32'h0000_1000;
    req.len      = 4'h0;
    req.size     = 3'h3;
    req.burst    = 2'b01;
    req.lock     = 2'b00;
    req.cache    = 2'b00;
    req.prot     = 3'b000;
    req.strobe   = 4'hF;
    req.data     = 1024'h1234;

    finish_item(req);

  endtask

endclass
