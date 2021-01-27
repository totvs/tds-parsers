#include "protheus.ch"

user function hello1() 
  conout("hello")

user function hello2()
  local x := time()

  conout("hello 2")
  conout (x)

return
  
