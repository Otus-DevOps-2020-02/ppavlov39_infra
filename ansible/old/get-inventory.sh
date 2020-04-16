#!/bin/bash

while [ -n "$1" ]; do
case "$1" in
--list) echo "{
    "_meta": {
        "hostvars": {
            "appserver": {
                "ansible_host": "34.90.58.172"
            }, 
            "dbserver": {
                "ansible_host": "34.91.21.203"
            }
        }
    }, 
    "all": {
        "children": [
            "app", 
            "db", 
            "ungrouped"
        ]
    }, 
    "app": {
        "hosts": [
            "appserver"
        ]
    }, 
    "db": {
        "hosts": [
            "dbserver"
        ]
    }
}
" ;;
--host) host="$2" 
if [ "$host" = "appserver" ]
then 
echo "{
    "_meta": {
        "hostvars": {
            "appserver": {
                "ansible_host": "34.90.58.172"
            } 
        }
    }, 
    "app": {
        "hosts": [
            "appserver"
        ]
    }
}
"
fi 
if [ "$host" = "dbserver" ]
then
echo "{
    "_meta": {
        "hostvars": {
            "dbserver": {
                "ansible_host": "34.91.21.203"
            } 
        }
    }, 
    "db": {
        "hosts": [
            "dbserver"
        ]
    }
}
"
fi ;;

esac 
shift
done
exit 0


