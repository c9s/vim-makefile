
" vimana record format:
" {
"          version => 0.2,    # record spec version
"          generated_by => 'Vimana-' . $Vimana::VERSION,
"          install_type => 'auto',    # auto , make , rake ... etc
"          package => $self->package_name,
"          files => \@e,
"  }
fun! s:mkmd5(file)
  if executable('md5')
    return system('cat ' . a:file . ' | md5')
  else
    return ""
  endif
endf
let files = readfile('.record')
let package_name = remove(files,0)
let script_version      = remove(files,0)
let record = { 'version' : 0.3 , 'generated_by': 'Vim-Makefile' , 'script_version': script_version , 'install_type' : 'makefile' , 'package' : package_name , 'files': [  ] }
for file in files 
  let md5 = s:mkmd5(file)
  cal add( record.files , {  'checksum': md5 , 'file': file  } )
endfor
redir => output
silent echon record
redir END
let content = join(split(output,"\n"),'')
let record_file = expand('~/.vim/record/' . package_name )
cal writefile( [content] , record_file )
cal delete('.record')
echo "Done"
