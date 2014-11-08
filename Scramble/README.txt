# Jiajie Dang
# djjkobe@gmail.com
=========================

My approach for the assignment
1.creat a 32-bit instruction
(1) randomly select a number between 0-8
(2) select the corresponding opcodes for the instruction
(3) creat the rest 26-bits according to the different opcodes and their format
# now we have the 32-bit instruction

2.copy the instruction in both "display" buffer and "answer" buffer

3.print the assembly lanaguage according to the 32-bit instruction
(1) first print the opcode(using the convert-table to convert number into string) 
(2) print the rest according to the opcodes(using the register-table to find the corresponding registers)

4.Insert asterisks into random positions in "display" buffer

5.print the string(32-bit instruction with asterisks)which was into "display" buffer

6. prompt the user to to input their guess(when the user input the required number of guess, the system automatically going on and the 
user do not need to push"enter"
for example: if there are for asterisks in the instruction, when user input four-bit guess, the system automatically continue.

7. check if the user's input is short than the requirement, print the words to let user to input again

8. check if the user's input is "*",print the string in the "answer" and go to 1

9. if the user's input is ".", exit the game

10. else check the user's input and calculate the scores, and print it out. then go to 1.
(1) I store the bits with asterisks as a string 
(2) store the user's input bits as a string 
(3) compare the two strings bit by bit, and get the score
