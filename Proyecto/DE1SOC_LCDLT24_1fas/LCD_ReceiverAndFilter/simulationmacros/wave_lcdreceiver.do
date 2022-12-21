onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lcd_receiver_tb/uReceiver/CLK
add wave -noupdate -color Gray90 /lcd_receiver_tb/uReceiver/RESET_L
add wave -noupdate -divider ENTRADA/SALIDA
add wave -noupdate -color Orange /lcd_receiver_tb/uReceiver/RX
add wave -noupdate -color {Orange Red} /lcd_receiver_tb/uReceiver/FILTER_DONE
add wave -noupdate -color Orange /lcd_receiver_tb/uReceiver/RX_BIT
add wave -noupdate -color {Orange Red} /lcd_receiver_tb/uReceiver/DONE
add wave -noupdate -color Blue /lcd_receiver_tb/uReceiver/OP_FILTER
add wave -noupdate -color {Medium Slate Blue} /lcd_receiver_tb/uReceiver/COMAND_READY
add wave -noupdate -color Blue /lcd_receiver_tb/uReceiver/COMANDO
add wave -noupdate -divider {SENIALES DE CONTROL}
add wave -noupdate /lcd_receiver_tb/uReceiver/EP
add wave -noupdate /lcd_receiver_tb/uReceiver/ES
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/Init
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/LD_Start
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/StartBit
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/DEC_Cdwn
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/FIN_Cdwn
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/Q_Cdwn
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/Shift
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/aux_Comando
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/Sum
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/InputK
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/Odd
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/ParityBit
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/LD_Parity
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/ParityCheck
add wave -noupdate -color Green /lcd_receiver_tb/uReceiver/LD_Stop
add wave -noupdate -color {Medium Spring Green} /lcd_receiver_tb/uReceiver/StopBit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26431 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 264
configure wave -valuecolwidth 64
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
WaveRestoreZoom {0 ps} {420 ns}
