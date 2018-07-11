onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x1
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x2
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x3
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x4
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x5
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x6
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x7
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x8
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x9
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/x10
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/b
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/y
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/a1
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/a2
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/a3
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/a4
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/a
add wave -noupdate -radix decimal /perceptron_tb/test_perceptron/tmp
add wave -noupdate /perceptron_tb/clk
add wave -noupdate /perceptron_tb/end_sim
add wave -noupdate -radix decimal /perceptron_tb/w1_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26358 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 94
configure wave -valuecolwidth 68
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {144528 ps}
