-- this can use Lua5.1
--

local options = {}

for i = 1, #arg do
  if arg[i]:sub(1, 1) == "-" then
    options[arg[i]:sub(2)] = true
  end
end

-- local t = os.execute("odin build src -out:spawn_rune.bin -o:speed -reloc-mode:static")
local t = os.execute("odin build src -out:2fa.bin && echo 'OK'")
