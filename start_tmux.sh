# Simple, convenient way of starting and restoring tmux sessions
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# I source this function as part of my .bashrc or .zshrc (actually I do 'source .zsh_library.sh')
# I normally also run 'start_tmux' at the end of my .bashrc or .zshrc in all my servers
#
# Usage:
#   start_tmux # instead of just 'tmux'
#
# Notes:
#   It attaches to existing orphan tmux sessions upon exiting current tmux session

function start_tmux()
{
  test -z ${TMUX} || return                                          # fail if already in a TMUX session
  [[ $- == *i* ]] || return                                          # only for interactive shells
  while true; do
    while read l; do                                                 # search for unused sessions
      local  ID=$( echo $l | cut -f1 -d: )
      local NUM=$( echo $l | cut -f2 -d: )
      test "$NUM" == "0" && break;
      ID=""
    done < <( tmux ls -F "#{session_id}:#{session_attached}" 2>/dev/null )
    if [[ "$ID" != "" ]]; then                                       # use unused sessions, if they exist
      tmux attach -t $( echo $ID | sed 's=\$==' )
      local ID=""
    else
      tmux
      break
    fi
  done
}

# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA

# comment this line if you do not want to automatically start tmux
start_tmux
