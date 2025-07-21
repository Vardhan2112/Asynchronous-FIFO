# Asynchronous FIFO Design

This repo contains verilog code for an asynchronous FIFO.


## Introduction

- FIFO stands for "First-In, First-Out." It is a type of data structure or buffer in which the first data element added (the "first in") is the first one to be removed (the "first out"). This structure is commonly used in scenarios where order of operations is important.
- Async FIFO, or Asynchronous FIFO, is a FIFO buffer where the read and write operations are controlled by independent clock domains. This means that the writing process and the reading process are driven by different clocks, which are not synchronized. Async FIFOs are used to safely transfer data between these asynchronous clock domains.
- Async FIFOs are used in various applications where data needs to be transferred between two parts of a system that operate on different clock frequencies. Some common use cases include:

    - Interfacing between different clock domains: For example, transferring data between a high-speed processing unit and a slower peripheral.
    - Communication between different modules: In a system-on-chip (SoC) where different modules might operate at different clock rates.
    - Buffering data: To handle variations in data flow rates between producer and consumer components in digital systems.
    - Bridging clock domains: In FPGA designs and other digital circuits where subsystems run at different clock speeds
 
#### Operations
In an asynchronous FIFO, the read and write operations are managed by separate clock domains. The write pointer always points to the next word to be written. On a FIFO-write operation, the memory location pointed to by the write pointer is written, and then the write pointer is incremented to point to the next location to be written. Similarly, the read pointer always points to the current FIFO word to be read. On reset, both pointers are set to zero. When the first data word is written to the FIFO, the write pointer increments, the empty flag is cleared, and the read pointer, which is still addressing the contents of the first FIFO memory word, immediately drives that first valid word onto the FIFO data output port to be read by the receiver logic. The FIFO is empty when the read and write pointers are both equal, and it is full when the write pointer has wrapped around and caught up to the read pointer.

#### Full, empty and wrapping condition
The conditions for the FIFO to be full or empty are as follows:

- **Empty Condition**: The FIFO is empty when the read and write pointers are both equal. This condition happens when both pointers are reset to zero during a reset operation, or when the read pointer catches up to the write pointer, having read the last word from the FIFO.

- **Full Condition**: The FIFO is full when the write pointer has wrapped around and caught up to the read pointer. This means that the write pointer has incremented past the final FIFO address and has wrapped around to the beginning of the FIFO memory buffer.

To distinguish between the full and empty conditions when the pointers are equal, an extra bit is added to each pointer. This extra bit helps in identifying whether the pointers have wrapped around:

- **Wrapping Around Condition**: When the write pointer increments past the final FIFO address, it will increment the unused Most Significant Bit (MSB) while setting the rest of the bits back to zero. The same is done with the read pointer. If the MSBs of the two pointers are different, it means that the write pointer has wrapped one more time than the read pointer. If the MSBs of the two pointers are the same, it means that both pointers have wrapped the same number of times.

This design technique helps in accurately determining the full and empty conditions of the FIFO.

#### Gray code counter

Gray code counters are used in FIFO design because they only allow one bit to change for each clock transition. This characteristic eliminates the problem associated with trying to synchronize multiple changing signals on the same clock edge, which is crucial for reliable operation in asynchronous systems.


## Results

The asynchronous FIFO design was tested using a testbench. The following key results were observed:-

1. **Correct Data Storage and Retrieval**: The FIFO correctly stored data when written to and retrieved the exact same data when read from. This was validated across multiple test cases with varying data patterns.
2. **Full and Empty Conditions**: The FIFO accurately indicated full and empty conditions. When the FIFO was full, additional write operations were correctly prevented, and when the FIFO was empty, additional read operations were correctly halted.

## Conclusion

The design and implementation of the asynchronous FIFO were successful, demonstrating reliable data storage and retrieval between asynchronous clock domains. The use of gray code counters ensured proper synchronization, and the module's behavior in full and empty conditions was as expected. The testbench validated the FIFO's functionality across different scenarios, proving the design's correctness and efficiency.

While simulations confirmed the functional aspects of the design, it is important to note that metastability issues cannot be fully tested through simulations alone. Metastability is a physical phenomenon that occurs in actual hardware, and its mitigation relies on proper design techniques like the use of synchronizers and careful consideration of setup and hold times.

Overall, the asynchronous FIFO design is well-suited for applications requiring data transfer between different clock domains, ensuring data integrity and synchronization. Future work could involve implementing the design on actual hardware to observe real-world behavior and further testing under varied clock frequencies and data patterns to ensure robust performance.

## Author
Srivardhan


## References
1. [Sunburst Design: Simulation and Synthesis Techniques for Asynchronous FIFO Design](http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf)
2. [VLSI verify Blog - Asynchronous FIFO](https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/)
