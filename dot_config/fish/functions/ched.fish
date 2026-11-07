function ched --wraps='chezmoi edit' --wraps='chezmoi edit -v' --description 'alias ched=chezmoi edit -v'
    chezmoi edit -v $argv
end
