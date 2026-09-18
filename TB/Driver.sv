class fifo_driver extends uvm_driver #(fifo_packet);

  `uvm_component_utils(fifo_driver)

  virtual cpu_if vif;

  localparam bit [7:0] SOP = 8'b1010_1010;
  localparam bit [7:0] EOP = 8'b0101_0011;

  function new(string name = "fifo_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual cpu_if)::get(this, "", "cpu_vif", vif))
      `uvm_fatal("DRV", "virtual cpu_if was not found in uvm_config_db")
  endfunction

  task run_phase(uvm_phase phase);

    fifo_packet req;

    vif.wr_en   <= 1'b0;
    vif.wr_data <= '0;
    vif.rd_en   <= 1'b0;
    vif.rd_data <= '0;

    wait (vif.rst == 1'b0);
    @(posedge vif.clk);

    forever begin

      seq_item_port.get_next_item(req);

      `uvm_info("FIFO_DRV", $sformatf("Driving packet: WRITE=%0d ID=%0h ADDR=%08h LEN=%0d SIZE=%0d", req.is_write, req.txn_id, req.addr, req.len, req.size), UVM_MEDIUM)
       
      drive_packet(req);
      seq_item_port.item_done();

    end

  endtask

  task drive_packet(fifo_packet req);

    bit [127:0] fifo_data_words[$];

    if (req.is_write)
      build_write_packet_words(req, fifo_data_words);
    else
      build_read_packet_words(req, fifo_data_words);

    `uvm_info("FIFO_DRV",
              $sformatf("Number of FIFO words = %0d", fifo_data_words.size()),
              UVM_HIGH)

    foreach (fifo_data_words[i]) begin

      @(posedge vif.clk);

      while (vif.full) begin
        `uvm_info("FIFO_DRV", "Write FIFO is FULL", UVM_HIGH)
        @(posedge vif.clk);
      end

      vif.wr_data <= fifo_data_words[i];
      vif.wr_en   <= 1'b1;

      `uvm_info("FIFO_DRV",
                $sformatf("FIFO WRITE[%0d] = %032h", i, fifo_data_words[i]),
                UVM_HIGH)

      //@(posedge vif.clk);
      @(posedge vif.clk);

      vif.wr_en   <= 1'b0;
      vif.wr_data <= '0;

    end

  endtask

  //building header
  function bit [63:0] build_header(fifo_packet req);
    return {
      SOP,
      req.txn_id,
      req.addr,
      req.len,
      req.size,
      req.burst,
      req.lock,
      req.cache,
      req.prot,
      req.strobe
    };
  endfunction

  // grouping packet bits into fifo words. 
.
  function void group_bits_into_fifo_words(
      bit packet_bits[$],
       bit [127:0] fifo_data_words[$]
  );
    int bit_index;
    bit_index = 0;

    while (bit_index < packet_bits.size()) begin

      bit [127:0] fifo_word = '0;

      for (int i = 0; i < 128; i++) begin
        if ((bit_index + i) < packet_bits.size())
          fifo_word[127-i] = packet_bits[bit_index+i];
      end

      fifo_data_words.push_back(fifo_word);
      bit_index += 128;

    end
  endfunction


  task build_read_packet_words(
      fifo_packet req,
      ref bit [127:0] fifo_data_words[$]
  );

    bit [63:0] header;
    bit packet_bits[$];

    header = build_header(req);
    packet_bits.delete();

    for (int i = 63; i >= 0; i--)
      packet_bits.push_back(header[i]);

    //data fixed to 0
    for (int i = 0; i < 8; i++)
      packet_bits.push_back(1'b0);

    for (int i = 7; i >= 0; i--)
      packet_bits.push_back(EOP[i]);

    group_bits_into_fifo_words(packet_bits, fifo_data_words);

  endtask

  //write packet
  task build_write_packet_words(
      fifo_packet req,
      ref bit [127:0] fifo_data_words[$]
  );

    bit [63:0] header;
    bit packet_bits[$];
    int payload_bits;

    payload_bits = (1 << req.size) * req.len;

    if (payload_bits > 1024) begin
      `uvm_error("FIFO_DRV",
                 $sformatf("Payload size %0d exceeds 1024 bits", payload_bits))
   
      return;
    end

    if (payload_bits == 0)
      `uvm_warning("FIFO_DRV",
                   "Write packet has zero payload bits (LEN=0)  no data will be sent")

    header = build_header(req);
    packet_bits.delete();

    for (int i = 63; i >= 0; i--)
      packet_bits.push_back(header[i]);

    for (int i = payload_bits - 1; i >= 0; i--)
      packet_bits.push_back(req.data[i]);

    for (int i = 7; i >= 0; i--)
      packet_bits.push_back(EOP[i]);

    group_bits_into_fifo_words(packet_bits, fifo_data_words);

  endtask

endclass
