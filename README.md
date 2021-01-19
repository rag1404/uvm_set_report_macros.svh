# uvm_set_report_macros.svh
A Simple program to demonstrate the capabilities of uvm_set_report macros !

# Example 1
1) Inside the test in start_of_simulation phase,add the below line. This set_verbosity_level sets specific verbosity to that component.
    this.set_report_verbosity_level(UVM_DEBUG); 
    // If we want to set component specific verbosity, we can use set_verbosity_level
    // Note, component specific verbosity takes precedence over global verbosity.
    
# Example 2
1) If we want to set a verbosity to a component and all its descendants, we can use set_report_verbosity_level_hier macro.
// uvm_top.set_report_verbosity_level_hier(UVM_DEBUG); // From test
// Add the above line in start_of_simulation phase inside the test.

