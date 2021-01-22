# uvm_set_report_macros.svh
A Simple program to demonstrate the capabilities of uvm_set_report macros !

# Example 1

1) Inside the test in start_of_simulation phase,add the below line. This set_verbosity_level sets specific verbosity to that component.
  ````systemverilog  
    this.set_report_verbosity_level(UVM_DEBUG); 
  ````  
    // If we want to set component specific verbosity, we can use set_verbosity_level
    
    // Note, component specific verbosity takes precedence over global verbosity.
    
# Example 2

1) If we want to set a verbosity to a component and all its descendants, we can use set_report_verbosity_level_hier macro.
````systemverilog
 uvm_top.set_report_verbosity_level_hier(UVM_DEBUG); // From test
 ````
// Add the above line in start_of_simulation phase inside the test.

# Example 3
1) If you want to set verbosity for Particular Message ID, we can use set_report_id_verbosity or if we want for its descendents use set_report_id_verbosity_hier.

// Inside test_build phase

// Add this line after env is built
````systemverilog
 env.set_report_id_verbosity ("test_env", UVM_HIGH); 
````
# Example 4
1) Finally we can set both severity and ID specific verbosity using set_report_severity_id_verbosity or set_report_severity_id_verbosity_hier for descendents.
// Inside test build_phase after env is built, add the below line.
````systemverilog
 env.set_report_severity_id_verbosity_hier (UVM_INFO ,"test_env", UVM_HIGH); 

// or

  env.set_report_severity_id_verbosity (UVM_INFO ,"test_env", UVM_HIGH);
````
