# Load ~/.bash_*
# ~/.bash_extra can be used for settings you don’t want to commit
for file in ~/.{bash_exports,bash_path,bash_aliases,bash_functions,bash_prompt,bash_functions,bash_extra}; do
    [ -r "$file" ] && source "$file"
done
unset file
