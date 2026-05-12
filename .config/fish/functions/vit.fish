function vit --description 'Vim tiny with no config'
    if command -q vim.tiny
        vim.tiny -u NONE $argv
    else
        vim -u NONE $argv
    end
end
