package twofa

import "core:fmt"
import libc "core:c"
import lua51 "vendor:lua/5.4"


main :: proc() {


  StateL := lua51.L_newstate()

  lua51.L_openlibs(StateL)

  ret: lua51.Status = lua51.L_loadfile(StateL, "./src/test.lua")

  if !(ret == lua51.Status.OK) {
    lua51.L_error(StateL, "lua LoadFile Failed\n")
  }


  fmt.println("In Odin, calling Lua\n")

  int_ret: libc.int = lua51.pcall(StateL, 0, 0, 0, 0)
  if !(int_ret == 0) {
    fmt.println(StateL)
    lua51.L_error(StateL, "lua pcall() Failed\n")
  }

  fmt.println(StateL)

  fmt.println("Back in Odin again\n")

  return

}


main_begin :: proc() {

  fmt.println("hello world!")

  return
}
