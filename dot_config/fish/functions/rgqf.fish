function rgqf --wraps='rg --line --column' --wraps='rg --line-number --column' --description 'alias rgqf rg --line-number --column'
  rg --line-number --column $argv
        
end
