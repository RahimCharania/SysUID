#!/bin/bash

echo \

echo "Hello, $USER. whose account do you want to check?"

echo \

echo -n "Enter client USERID and press [ENTER]: "
read name

echo \

sudo $(which mam-list-accounts) -u $name>tmp[$name]
sudo $(which mam-list-funds) -u $name -h > tmp2[$name]
sudo $(which /usr/lpp/mmfs/bin/mmlsquota) -u $name scratch>tmp3[$name]


if grep -q "open" tmp[$name]
then
        echo "Active ACI Account: YES ($name)  "

echo \

echo "Client name: `ldapsearch -x -b dc=psu,dc=edu -h ldap.psu.edu uid=$name -LLL|grep displ|sed -e 's#.*: \(\)#\1#'`  (`ldapsearch -x -b dc=psu,dc=edu -h ldap.psu.edu uid=$name -LLL|grep eduPersonPrimaryAffiliation|sed -e 's#.*: \(\)#\1#'`)"

echo \

        echo "Account has access to: `id $name -Gn`"
else
        echo "No, $name does not have an active ACI account"
fi

echo \

if grep -q "@" tmp[$name]
then
        echo "Allocation summary:"
        cat tmp[$name]| awk '{print $1 "  >>  " $3}'| sed 1,2d|sed '/open/d'
        echo \

        echo "COMPUTE BALANCE (in hours) for $name:"
        cat tmp2[$name]| awk '{print $2 "  >>  " $5}'| sed 1,2d|sed '/open/d'
        echo \

else
        echo "User $name does not have access to priority allocations"
fi

echo "Space used: `cat tmp3[$name]|awk '{print "Scratch-> KB=" $3 "; Files=" $9 "; Inode limit=" $11}'| sed 1,2d`"

echo \



rm -rf tmp[$name]
rm -rf tmp2[$name]
rm -rf tmp3[$name]

