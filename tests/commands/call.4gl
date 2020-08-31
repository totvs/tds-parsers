main 

  call fgl_winmessage()

  call fgl_winmessage("p1")




  call fgl_winmessage("p1","p2", "p3")
  call fgl_winmessage(1,2,    3)

end main

function f1() 

  call fgl_winmessage() returning var1

  call fgl_winmessage() returning var1 , var2

call fgl_winmessage() returning var1,var2,var3

end function

function f2() 

  call fgl_winmessage() returning var1[ind1]

end function

function f3() 

  call fgl_winmessage() returning rec1.var1

  call fgl_winmessage() returning rec1.*

end function

