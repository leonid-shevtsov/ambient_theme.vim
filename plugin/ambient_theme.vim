"
" This plugin requires OS X
"
if has('mac')
  if exists("g:loaded_AmbientTheme") || &cp
    finish
  endif
  let g:loaded_AmbientTheme = 1

  if !exists("g:AmbientLightThreshold")
    let g:AmbientLightThreshold = 1000000
  end

  let g:AmbientLightSensor = expand("<sfile>:p:h:h")."/bin/light_sensor"
  let g:AmbientLightFalloff = 0.95

  autocmd CursorHold * call SetAmbientTheme()
  function! SetAmbientTheme()
    call feedkeys("f\e")
    let g:AmbientLightSensorValue=str2nr(split(system(g:AmbientLightSensor)," ")[0])
    if exists("g:AmbientLightAverage")
      let g:AmbientLightAverage=(g:AmbientLightAverage*g:AmbientLightFalloff+g:AmbientLightSensorValue)/(1.0+g:AmbientLightFalloff)
    else
      let g:AmbientLightAverage=g:AmbientLightSensorValue
    end

    if g:AmbientLightAverage > g:AmbientLightThreshold
      set background=light
    else
      set background=dark
    end
  endfunction 
end
