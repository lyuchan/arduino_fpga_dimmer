# AC Dimmer
## 緣起
因為我想複製某個演唱會的燈光效果，但需要巨量的鎢絲燈，但因為鎢絲燈泡是交流電，因此需要的調光策略比較不一樣XD

但因為我對arduino計時器比較不熟悉，且因為需要48CH，因此我選擇使用arduino接收DMX協議，通過SPI來跟FPGA溝通，因為FPGA的特性，讓我可以寫一個驅動模組，然後瘋狂複製XDDDD