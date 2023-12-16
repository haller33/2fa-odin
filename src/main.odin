package twofa

import libc "core:c"
import "core:fmt"
import lua51 "vendor:lua/5.1"


main :: proc() {


  StateL := lua51.L_newstate()

  lua51.L_openlibs(StateL)

  ret: lua51.Status = lua51.L_loadfile(StateL, "./src/otp_lib.lua")

  if !(ret == lua51.Status.OK) {
    lua51.L_error(StateL, "lua LoadFile Failed\n")
  }


  fmt.println("In Odin, calling Lua\n")

  int_ret: libc.int = lua51.pcall(StateL, 0, 0, 0)
  if !(int_ret == 0) {
    fmt.println(StateL)
    lua51.L_error(StateL, "lua pcall() Failed\n")
  }

  fmt.println(StateL)

  string_fun_call: cstring = "twofa_hash_gen"
  lua51.getglobal(StateL, string_fun_call)

  string_test: cstring = "2FASTEST"
  lua51.pushstring(StateL, string_test)


  int_ret = lua51.pcall(StateL, 1, 1, 0)
  if !(int_ret == 0) {
    fmt.println(StateL)
    lua51.L_error(StateL, "lua pcall() Failed\n")
  }


  ret_fun_lua_call: cstring = lua51.tostring(StateL, 1)

  fmt.println("LUA RETURN :: ", ret_fun_lua_call)


  fmt.println("Back in Odin again\n")
  lua51.close(StateL)

  return

}


main_begin :: proc() {

  fmt.println("hello world!")

  return
}
