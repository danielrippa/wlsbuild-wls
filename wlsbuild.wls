
  { run } = dependency wsh.Process
  { text-as-lines } = dependency primitive.Text
  { with-extension, file-exists, last-modified-as-ms, absolute-path, build-path } = dependency wsh.FileSystem
  { outln } = dependency wsh.IO
  { trim } = dependency native.String
  { fail } = dependency wsh.Script

  wlsc = (wls-filepath) ->

    outln wls-filepath

    { output, errorlevel, error } = run "wlsc #wls-filepath"

    fail error, errorlevel \
      if errorlevel isnt 0

  #

  { output, errorlevel } = run "dir /b /a-d *.wls"

  if errorlevel is 0

    current-folder = absolute-path '.'

    for wls-filename in text-as-lines output

      continue \
        if (trim wls-filename) is ''

      wls-filepath = build-path current-folder, wls-filename

      wsf-filepath = wls-filepath `with-extension` 'wsf'

      if file-exists wsf-filepath

        wls-modified = last-modified-as-ms wls-filepath
        wsf-modified = last-modified-as-ms wsf-filepath

        if wls-modified > wsf-modified

          wlsc wls-filepath

      else

        wlsc wls-filepath
