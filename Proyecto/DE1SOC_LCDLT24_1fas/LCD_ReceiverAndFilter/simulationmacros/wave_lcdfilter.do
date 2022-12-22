onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_filter_tb/uFilter/CLK
add wave -noupdate /lcd_filter_tb/uFilter/RESET_L
add wave -noupdate -divider ENTRADA/SALIDA
add wave -noupdate -color Coral /lcd_filter_tb/uFilter/OP_FILTER
add wave -noupdate -color Gold /lcd_filter_tb/uFilter/RX
add wave -noupdate -color Coral /lcd_filter_tb/uFilter/SPEED
add wave -noupdate -color Blue /lcd_filter_tb/uFilter/FILTER_DONE
add wave -noupdate -color {Steel Blue} /lcd_filter_tb/uFilter/RX_BIT
add wave -noupdate -divider {SENIALES DE CONTROL}
add wave -noupdate /lcd_filter_tb/uFilter/EP
add wave -noupdate /lcd_filter_tb/uFilter/ES
add wave -noupdate /lcd_filter_tb/uFilter/Init
add wave -noupdate -color {Spring Green} /lcd_filter_tb/uFilter/LD_WaitingCicles
add wave -noupdate /lcd_filter_tb/uFilter/DEC_Cicles
add wave -noupdate -color {Spring Green} /lcd_filter_tb/uFilter/Waiting_End
add wave -noupdate /lcd_filter_tb/uFilter/DEC_Reading
add wave -noupdate -color {Spring Green} /lcd_filter_tb/uFilter/END_Reading
add wave -noupdate /lcd_filter_tb/uFilter/IS_0
add wave -noupdate -color {Spring Green} /lcd_filter_tb/uFilter/INC_1
add wave -noupdate /lcd_filter_tb/uFilter/INC_0
add wave -noupdate -color {Spring Green} /lcd_filter_tb/uFilter/Output_1
add wave -noupdate /lcd_filter_tb/uFilter/Output_0
add wave -noupdate /lcd_filter_tb/uFilter/WaitingCicles
add wave -noupdate /lcd_filter_tb/uFilter/Abs0
add wave -noupdate /lcd_filter_tb/uFilter/Abs1
add wave -noupdate /lcd_filter_tb/uFilter/q_cicles
add wave -noupdate /lcd_filter_tb/uFilter/q_reading
add wave -noupdate /lcd_filter_tb/uFilter/aux_cont1
add wave -noupdate /lcd_filter_tb/uFilter/aux_cont0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {527261 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 88
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {1050 ns}
