"
" This plugin requires OS X
"
if exists("g:loaded_AmbientTheme") || &cp
  finish
endif
let g:loaded_AmbientTheme = 1

if !exists("g:AmbientLightThreshold")
  let g:AmbientLightThreshold = 1000000
end

let g:AmbientLightSensor = expand("<sfile>:p:h:h")."/bin/light_sensor"

if has('mac')
  autocmd CursorHold * call SetAmbientTheme()
  function! SetAmbientTheme()
    call feedkeys("f\e")
    let g:LightSensorValue=str2nr(split(system(g:AmbientLightSensor)," ")[0])
    if g:LightSensorValue > g:AmbientLightThreshold
      set background=light
    else
      set background=dark
    end
  endfunction 
end
