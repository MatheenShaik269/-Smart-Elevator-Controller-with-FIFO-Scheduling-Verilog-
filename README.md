# 🛗 Smart Elevator Controller with FIFO Scheduling (Verilog)

## 📌 Project Overview

This project implements a **Smart Elevator Controller integrated with a FIFO-based request scheduler** using Verilog.
It enhances a traditional FSM-based elevator by introducing **request queuing**, enabling efficient handling of multiple floor requests.

The design simulates real-world elevator behavior including:

* 🏢 Multi-floor navigation (0–15 floors)
* 📥 FIFO-based request handling
* ⚡ Power failure handling (Electricity / Generator)
* ⚖️ Overweight detection with alarm
* 🚨 Emergency stop handling
* 🚪 Automatic door control with timer
* 💡 Fan & light control inside elevator

The system ensures **ordered, safe, and efficient servicing of multiple requests**.

---

## ⚙️ Key Features

* ✅ FIFO-based request scheduling (handles multiple requests)
* 🔄 Sequential request processing (no request loss)
* 🚪 Door open/close control with timing
* ⚖️ Overweight detection (Alarm if weight ≥ 500)
* 🚨 Emergency stop functionality
* ⚡ Power failure handling with generator backup
* 💡 Fan and light control
* 🔄 Handles incorrect user inputs (Up/Down mismatch)
* 🧪 Fully verified with extensive testbench (22 test cases)

---

## 🧠 System Architecture

```
User Requests → FIFO → Elevator FSM → Outputs
```

### Modules Used:

1. **FIFO (`fifo_sync`)**

   * Stores incoming floor requests
   * Prevents request loss
   * Provides `data_valid` for safe read

2. **Elevator FSM (`elevator`)**

   * Controls movement, doors, safety
   * Implements real-world elevator logic

3. **Top Module (`elevator_top`)**

   * Integrates FIFO + FSM
   * Manages request scheduling

---

## 📥 FIFO Design Details

* Type: Synchronous FIFO
* Depth: 8
* Data Width: 4-bit (floor number)

### Features:

* ✔ Write when `request_valid = 1`
* ✔ Read only when elevator is idle
* ✔ Uses `data_valid` to avoid repeated reads
* ✔ Full & Empty flag support

---

## 🔁 Request Scheduling Logic

* New requests are stored in FIFO
* Elevator reads request only when:

  * It is in **IDLE state**
  * FIFO is **not empty**
  * No request is currently being processed

### Request Pending Mechanism:

* Prevents multiple reads of the same request
* Ensures **one request is completed before next starts**

---

## 🧠 FSM States

| State               | Description                   |
| ------------------- | ----------------------------- |
| `electricity_check` | Waiting for power restoration |
| `idle`              | Elevator waiting              |
| `move_up`           | Moving upward                 |
| `move_down`         | Moving downward               |
| `door_open`         | Door open                     |
| `weight_check`      | Checking overload             |
| `alarm`             | Overweight condition          |
| `door_close`        | Door closing                  |
| `emergency_stop`    | Emergency halt                |

FSM implementation is defined in the elevator module

---

## ⚡ Power Handling

* If **electricity = 0** and **generator = 0**
  → System enters `electricity_check`

### Behavior:

* Elevator pauses safely
* Resumes previous state when power returns

---

## ⚖️ Overweight Handling

* Condition:

```
weight ≥ 500
```

### Behavior:

* Elevator stops movement
* Alarm is triggered
* Returns to normal after weight reduces

---

## 🚨 Emergency Handling

* Trigger:

```
e_stop = 1
```

### Behavior:

* Immediate stop
* Door opens for safety
* Transitions to safe state

---

## 🚪 Door Control Logic

* Door opens when elevator reaches target floor
* Timer-based control (~10 clock cycles)
* Automatically closes after timeout

---

## 🎯 Target Floor Logic

* Target floor is updated only when:

  * FIFO provides valid data
  * Current request is completed

* Ensures:

  * No skipping of requests
  * Ordered execution

---

## 📂 Project Structure

```text
elevator-fifo-controller/
│
├── fifo_sync.v              # FIFO module
├── elevator.v               # FSM-based elevator logic
├── elevator_top.v           # Integration (FIFO + FSM)
├── elevator_top_tb.v        # Testbench
├── README.md
├── simulation_log.txt
└── images/
    └── waveform.png
```

---

## 🧪 Testbench Description

The testbench verifies **22 real-world scenarios** including:

### ✔ Core Tests

1. Idle with electricity
2. No power condition
3. Generator backup
4. Door operation at same floor
5. Upward movement
6. Downward movement

### ✔ Advanced Tests

7. Multiple requests (FIFO behavior)
8. Sequential requests
9. Simultaneous requests
10. Conflicting inputs (Up & Down)
11. Rapid floor changes
12. Inside & outside requests

### ✔ Safety Tests

13. Overweight condition
14. Recovery after weight reduction
15. Emergency stop during movement
16. Emergency stop at idle

### ✔ Stress Tests

17. Multiple FIFO entries
18. Continuous request injection
19. Edge case combinations
20. High load request handling
21. Mixed inside/outside requests
22. Random request patterns

---

## 🖥️ Simulation Output

### 🔹 Console Output Includes:

* Current state
* Current floor
* Target floor
* Movement direction
* Door status
* Alarm & emergency signals

---

## 🔧 Design Highlights

* 🧠 FSM-based control logic
* 📥 FIFO-based scheduling
* 🔄 Clean separation of modules
* 🎯 Deterministic request handling

### Priority Handling:

```
Emergency > Power Failure > Overweight > Normal Operation
```

---

## 🚀 How to Run

### Using  Vivado:

1. Compile files:

```bash
 fifo_sync.v elevator.v elevator_top.v elevator_top_tb.v
```

2. Simulate:

```bash
sim elevator_top_tb
run -all
```

3. Observe:

* Waveforms
* Console output logs

---

## 🛠️ Tools Used

* Verilog HDL
* Xilinx Vivado 

---

## 📜 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**SHAIK ABDUL MATHEEN**

---

## 📌 Acknowledgement

This project demonstrates **advanced RTL design concepts** including:

* FSM Design
* FIFO-Based Scheduling
* Real-World System Modeling
* Hardware Verification using Testbench

It is a strong example of **industry-level digital design thinking**.
