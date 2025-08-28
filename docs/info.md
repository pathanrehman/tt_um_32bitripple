<!---
This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.
You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

# 32-bit Ripple Carry Adder

A hardware implementation of a **32-bit ripple carry adder** designed for educational purposes and arithmetic operations. This project demonstrates fundamental digital design concepts including full adder circuits, carry propagation, and modular Verilog design.

## How it works

The 32-bit ripple carry adder is built using a **cascade of 32 full adder modules**, where each full adder handles one bit position of the addition operation.

### Architecture Overview

**Full Adder Module**: Each 1-bit full adder implements:
- **Sum output**: `sum = a ⊕ b ⊕ cin` (XOR logic)
- **Carry output**: `cout = (a & b) | (b & cin) | (cin & a)` (majority logic)

**Carry Propagation**: The carry output from bit position `i` connects to the carry input of bit position `i+1`, creating a ripple effect from LSB to MSB.

**Modular Design**: Uses Verilog `generate` statements to create 32 identical full adder instances, making the design scalable and maintainable.

### I/O Interface

Due to Tiny Tapeout's limited I/O pins, this implementation provides an 8-bit interface:
- **Operand A**: Input through `ui[7:0]` pins
- **Operand B**: Input through `uio[7:0]` pins (configured as inputs)
- **Sum Output**: Lower 8 bits output through `uo[7:0]` pins
- **Carry Output**: Available on `uio[7]` when configured as output

The internal 32-bit adder can be extended by zero-padding the 8-bit inputs or by using multiple clock cycles to load larger operands.

### Key Features

- **Combinational Logic**: Pure combinational design with predictable propagation delay
- **Educational Value**: Clear demonstration of carry propagation and modular design
- **Synthesizable**: Compatible with FPGA and ASIC synthesis tools
- **Scalable Architecture**: Easy to modify for different bit widths

## How to test

### Basic Functionality Test

1. **Setup**: Connect power and clock to the Tiny Tapeout demo board
2. **Input Configuration**:
   - Set operand A using input switches `ui[7:0]`
   - Set operand B using bidirectional pins `uio[7:0]` (ensure they're configured as inputs)
3. **Observe Results**:
   - Read sum output from `uo[7:0]` pins
   - Check carry output on `uio[7]` if configured as output

### Test Cases

**Test Case 1 - Basic Addition**:
- Input A: `00001111` (15 decimal)
- Input B: `00000001` (1 decimal)
- Expected Sum: `00010000` (16 decimal)
- Expected Carry: 0

**Test Case 2 - Carry Generation**:
- Input A: `11111111` (255 decimal)
- Input B: `00000001` (1 decimal)
- Expected Sum: `00000000` (0 decimal)
- Expected Carry: 1

**Test Case 3 - Maximum Values**:
- Input A: `11111111` (255 decimal)
- Input B: `11111111` (255 decimal)
- Expected Sum: `11111110` (510 decimal, lower 8 bits)
- Expected Carry: 1

### Verification Methods

**Simulation Testing**:
```
// Example testbench stimulus
a = 8'h0F; b = 8'h01; #10; // Test basic addition
a = 8'hFF; b = 8'h01; #10; // Test carry generation
a = 8'hAA; b = 8'h55; #10; // Test alternating patterns
```

**Hardware Testing**:
- Use logic analyzer to capture timing relationships
- Verify propagation delay from inputs to outputs
- Test with various input patterns to ensure correctness

**Automated Testing**:
- Create comprehensive test vectors covering edge cases
- Implement self-checking testbench with expected results
- Use assertion-based verification for critical properties

## External hardware

**No external hardware required** - this project is completely self-contained within the Tiny Tapeout tile.

### Optional Testing Equipment

**For enhanced testing and verification**:
- **Logic Analyzer**: To observe timing relationships and propagation delays
- **Pattern Generator**: For automated input stimulus generation
- **Oscilloscope**: To measure propagation delay characteristics
- **LED Array**: For visual output display (connect to `uo[7:0]`)
- **DIP Switches**: For manual input control (connect to `ui[7:0]` and `uio[7:0]`)

### Demo Board Compatibility

This design is fully compatible with the **Tiny Tapeout demo board** and requires only:
- Standard power supply (1.8V digital)
- Clock input (though the adder itself is combinational)
- No special I/O voltage levels or external references

### Future Enhancements

**Potential external hardware for extended functionality**:
- **Serial Interface Module**: For loading 32-bit operands via UART
- **Display Module**: 7-segment or LCD display for showing full 32-bit results
- **Memory Module**: External RAM for storing multiple operands and results
- **Microcontroller Interface**: For automated testing and control

The modular design allows easy integration with external systems while maintaining the core educational value of demonstrating ripple carry addition principles.
