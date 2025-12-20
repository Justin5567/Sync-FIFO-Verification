`timescale 1ns/1ps

module fifo_sync_tb;

    // 參數定義
    parameter int DEPTH = 8;
    parameter int WIDTH = 32;

    // 訊號定義
    logic clk;
    logic rst_n;
    logic cs;
    logic wr_en;
    logic rd_en;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out;
    logic empty;
    logic full;

    // 實例化被測模組 (DUT)
    fifo_sync #(
        .FIFO_DEPTH(DEPTH),
        .FIFO_WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .cs(cs),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // 時鐘生成 (100MHz)
    always #5 clk = ~clk;

    // 測試流程
    initial begin
        // 初始化
        clk = 0;
        rst_n = 0;
        cs = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // 1. 重置系統
        $display("--- 測試開始：重置系統 ---");
        #20 rst_n = 1;
        cs = 1;
        #10;

        // 2. 寫入資料直到全滿
        $display("--- 測試：連續寫入直到 Full ---");
        for (int i = 0; i < DEPTH; i++) begin
            @(posedge clk);
            if (!full) begin
                wr_en = 1;
                data_in = i + 100; // 寫入 100, 101...
                $display("[Write] Data: %d, Full: %b", data_in, full);
            end
        end
        
        @(posedge clk);
        wr_en = 0;
        #5;
        $display("Final Full Status: %b (預期為 1)", full);

        // 3. 讀取資料直到全空
        $display("--- 測試：連續讀取直到 Empty (注意 Standard Mode 延遲一拍) ---");
        for (int i = 0; i < DEPTH; i++) begin
            @(posedge clk);
            if (!empty) begin
                rd_en = 1;
            end
            // 由於是標準模式，資料在下一拍出現，所以我們在下一拍觀察
            // @(posedge clk);
            $display("[Read Request] Data Out: %d, Empty: %b", data_out, empty);
        end

        @(posedge clk);
        rd_en = 0;
        #5;
        $display("Final Empty Status: %b (預期為 1)", empty);

        // 4. 同時讀寫測試
        $display("--- 測試：同時讀寫 ---");
        @(posedge clk);
        wr_en = 1; data_in = 32'hAAAA;
        rd_en = 1;
        @(posedge clk);
        wr_en = 0; rd_en = 0;
        
        #100;
        $display("測試完成");
        $finish;
    end

    // 產生波形檔 (供 GTKWave 使用)
    initial begin
        $dumpfile("fifo_test.vcd");
        $dumpvars(0, fifo_sync_tb);
    end

endmodule