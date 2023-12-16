package twofa

import libc "core:c"
import "core:fmt"
import lua51 "vendor:lua/5.1"

TOKEN_AUTH_2FASTEST :: "2FASTEST"

LUA_LIBRARY_OTP :: "./src/otp_lib.lua"


load_lua_library :: proc(StateL: ^lua51.State, path_lua_entry: cstring) {

  ret: lua51.Status = lua51.L_loadfile(StateL, path_lua_entry)

  if !(ret == lua51.Status.OK) {
    lua51.L_error(StateL, "lua LoadFile Failed\n")
  }

  int_ret := lua51.pcall(StateL, 0, 0, 0)
  if !(int_ret == 0) {
    fmt.println(StateL)
    lua51.L_error(StateL, "lua pcall() Failed\n")
  }


}

twofa_gen :: proc(
  StateL: ^lua51.State,
  digest_keygen: cstring,
) -> (
  ret_fun_lua_call: cstring,
) {

  string_fun_call: cstring = "twofa_hash_gen"
  lua51.getglobal(StateL, string_fun_call)

  string_test: cstring = digest_keygen
  lua51.pushstring(StateL, string_test)


  int_ret: libc.int = lua51.pcall(StateL, 1, 1, 0)
  if !(int_ret == 0) {
    fmt.println(StateL)
    lua51.L_error(StateL, "lua pcall() Failed\n")
  }

  ret_fun_lua_call = lua51.tostring(StateL, 1)

  return ret_fun_lua_call
}


main :: proc() {


  StateL: ^lua51.State = lua51.L_newstate()
  lua51.L_openlibs(StateL)

  load_lua_library(StateL, LUA_LIBRARY_OTP)


  ret_str_gen: cstring = twofa_gen(StateL, TOKEN_AUTH_2FASTEST)
  fmt.println("RET 2FA :: ", ret_str_gen)


  lua51.close(StateL)
  return
}


first_lua_library_test :: proc() {


  StateL := lua51.L_newstate()

  lua51.L_openlibs(StateL)

  ret: lua51.Status = lua51.L_loadfile(StateL, "./src/otp_lib.lua")

  if !(ret == lua51.Status.OK) {
    lua51.L_error(StateL, "lua LoadFile Failed\n")
  }


  fmt.println("In Odin, calling Lua\n")

  int_ret := lua51.pcall(StateL, 0, 0, 0)
  if !(int_ret == 0) {
    fmt.println(StateL)
    lua51.L_error(StateL, "lua pcall() Failed\n")
  }

  fmt.println(StateL)

  string_fun_call: cstring = "twofa_hash_gen"
  lua51.getglobal(StateL, string_fun_call)

  string_test: cstring = "2FASTEST"
  lua51.pushstring(StateL, string_test)


  int_ret_two := lua51.pcall(StateL, 1, 1, 0)
  if !(int_ret_two == 0) {
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
