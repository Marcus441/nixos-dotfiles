local M = {}

local saved = nil

local function monocle()
  return hl.get_config("general.layout") == "monocle"
end

local function profile()
  return {
    gaps_in = hl.get_config("general.gaps_in"),
    gaps_out = hl.get_config("general.gaps_out"),
    border_size = hl.get_config("general.border_size"),
    animations = hl.get_config("animations.enabled"),
  }
end

local function announce(name)
  hl.dispatch(hl.dsp.event("layout," .. name))
end

function M.set(name)
  return function()
    if name == "monocle" then
      if not monocle() then
        saved = profile()
      end
      hl.config({
        general = { layout = "monocle", gaps_in = 0, gaps_out = 0, border_size = 0 },
        animations = { enabled = false },
      })
    else
      local p = saved or profile()
      saved = nil
      hl.config({
        general = {
          layout = name,
          gaps_in = p.gaps_in,
          gaps_out = p.gaps_out,
          border_size = p.border_size,
        },
        animations = { enabled = p.animations },
      })
    end
    announce(name)
  end
end

function M.toggle()
  M.set(monocle() and "dwindle" or "monocle")()
end

function M.focus(dir)
  return function()
    if not monocle() then
      hl.dispatch(hl.dsp.focus({ direction = dir }))
    elseif dir == "l" then
      hl.dispatch(hl.dsp.focus({ workspace = "m-1" }))
    elseif dir == "r" then
      hl.dispatch(hl.dsp.focus({ workspace = "m+1" }))
    elseif dir == "u" then
      hl.dispatch(hl.dsp.layout("cycleprev"))
    else
      hl.dispatch(hl.dsp.layout("cyclenext"))
    end
  end
end

function M.cycle_next()
  if monocle() then
    hl.dispatch(hl.dsp.layout("cyclenext"))
  else
    hl.dispatch(hl.dsp.window.cycle_next())
  end
end

return M
