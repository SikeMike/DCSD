onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/CLK
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/RESET_L
add wave -noupdate -divider -height 23 LCD_RECEIVER
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/RX
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/FILTER_DONE
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/RX_BIT
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/DONE
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/OP_FILTER
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/COMAND_READY
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/COMANDO
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/EP
add wave -noupdate /lcd_receiverandfilter_tb/uReceiver/ES
add wave -noupdate -divider -height 23 LCD_FILTER
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/OP_FILTER
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/RX
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/SPEED
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/FILTER_DONE
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/RX_BIT
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/EP
add wave -noupdate /lcd_receiverandfilter_tb/uFilter/ES
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2540643 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 330
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {21 us}
