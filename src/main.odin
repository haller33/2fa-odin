package twofa

import "core:fmt"
import libc "core:c"

import lua51 "vendor:lua/5.1"


import c "core:c"
import n "core:math/linalg/hlsl"
import mem "core:mem"
import os "core:os"

import rl "vendor:raylib"


SHOW_LEAK :: true
TEST_MODE :: false
INTERFACE_RAYLIB :: false
DEBUG_PATH :: true
DEBUG_INTERFACE_WORD :: false

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


main_source :: proc(StateL: ^lua51.State) {


  windown_dim :: n.int2{400, 100}

  when INTERFACE_RAYLIB {

    rl.InitWindow(windown_dim.x, windown_dim.y, "Spawn Rune")
    rl.SetTargetFPS(60)
  }

  keyfor: rl.KeyboardKey
  keyfor = rl.GetKeyPressed()


  // os.execvp("/usr/bin/caja &", params)

  when INTERFACE_RAYLIB {

    is_running :: true

    // fmt.println(keyfor)

    rl.BeginDrawing()

    pause: bool = false

    when TEST_MODE {
      fmt.println("test")
    }

    runner_simbol: string = ""

    for is_running && rl.WindowShouldClose() == false {

      // rl.DrawText("Hello World!", 10, 10, 20, rl.DARKGRAY)
      /*scores: cstring = strings.clone_to_cstring(
            fmt.tprintf("hello world",  context.temp_allocator,
        )*/

      // rl.DrawText(string(windown_dim.x), 0, 0, 20, rl.DARKGRAY)
      // rl.DrawText(string(windown_dim.y), 0, 10, 20, rl.DARKGRAY)

      /// handle game play velocity
      keyfor = rl.GetKeyPressed()
      if keyfor == rl.KeyboardKey.ENTER {

      } else if (keyfor >= rl.KeyboardKey.A) && (keyfor <= rl.KeyboardKey.Z) {


      } else if keyfor == rl.KeyboardKey.BACKSPACE {

      } else if keyfor == rl.KeyboardKey.SPACE {

      } else if keyfor == rl.KeyboardKey.PERIOD {

      } else if (keyfor == rl.KeyboardKey.MINUS) ||
         (keyfor == rl.KeyboardKey.KP_SUBTRACT) {

      } else if keyfor == rl.KeyboardKey.TAB {

      }

      // Begin drawing
      rl.ClearBackground(rl.WHITE)

      rl.DrawText("2FA", 100, 100, 20, rl.DARKGRAY)


      rl.EndDrawing()
    }
  }

  ret_str_gen: cstring = twofa_gen(StateL, TOKEN_AUTH_2FASTEST)
  fmt.println("RET 2FA :: ", ret_str_gen)

}


main_scheduler :: proc() {

  StateL: ^lua51.State = lua51.L_newstate()

  lua51.L_openlibs(StateL)
  load_lua_library(StateL, LUA_LIBRARY_OTP)

  main_source(StateL)

  lua51.close(StateL)
}


main :: proc() {

  when SHOW_LEAK {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)
  }

  when !TEST_MODE {
    main_scheduler()
  } else {
    testing()
  }

  when SHOW_LEAK {
    fmt.println("LEAKS")
    for _, leak in track.allocation_map {
      fmt.printf("%v leaked %v bytes\n", leak.location, leak.size)
    }
    for bad_free in track.bad_free_array {
      fmt.printf(
        "%v allocation %p was freed badly\n",
        bad_free.location,
        bad_free.memory,
      )
    }
  }
  return
}


main_init_begin_lua :: proc() {


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
