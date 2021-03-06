
# `.scripts/`, specs, and impls

Specification-less automations live in the `.scripts/` folder.

Specifications live in the `Specs` folder, which should not be linked into the
host system. The associated implementations live in the `Impls` folder, the
contents of which should be linked to `.scripts/` in the host system.

This means that all implementations are always available on the host-system.
The specific implementation to use is chosen by providing an alias in the
`.zrc/impls` file.

As a side-effect, automations, that depend on specified utilities, can be made
dependent on a specific version.





# OLD STUFF I CAN'T BE BOTHERED WITH RIGHT NOW

### How I Roll

For the most part this repository only contains configuration files, there are
a few considerations though.

```
.zrc/                   contains zsh specific startup settings
.zrc/aliases            zsh aliases
.zrc/prompt             zsh prompt
.zrc/zshrc              sets autocomplete and sources resources

.scripts/               contains all my custom commands
.scripts/functions      shell function definitions, these are sourced by .zrc/zshrc

.env/                   things to make available in $PATH or other environment vars

.i3/                    i3 wm specific scripts, temp files
```



# The .scripts/ Commands

My custom commands and utilites are grouped into "families" of similar/related
semantics. These commands may depend on each other. If they do, they say it in
their doc comment at the start.

Commands that are only related to the families may still be listed under them.

**This list only includes *my* commands, not things that are only in .scripts/
because of $PATH reasons!**

### Assorted

```
cycle                   repeat command until it is successful
basenameFiles           apply basename to all files on stdin
dirnameFiles            apply dirname to all files on stdin
dmenuSelectFile         dmenu select file
filterIncludeExclude    filter lines against include and exclude regex patterns
prependItemsWith        prepend every line with string
random                  produce random numbers in a UNIX safe way
suspend.sh              sleep n; systemctl suspend;
toLower                 convert string to lowercase
toUpper                 convert string to uppercase
wacom-mapping.sh        map to monitors
wacom-toggle_touch.sh   toggle touch
sortR                   randomly sort the standard input (like sort -R but slower)
isInt                   shell predicate for identifying integer arguments
```

### ln* -- hard link files creatively

```
linkFromTo              REMOVE
ln_opts                 handle options in the ln* commands
lnd                     link directory trees
lnp                     link with mkdir -p
lns                     link from stdin
```

### fd* -- opend files using fd searches

```
fdPlay                  playback files with mpv
fdShow                  show files with sxiv
mpvPlay                 playback playlist with mpv
```
